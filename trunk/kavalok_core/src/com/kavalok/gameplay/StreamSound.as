package com.kavalok.gameplay
{
	import com.kavalok.events.EventSender;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	* ...
	* @author Canab
	*/
	public class StreamSound
	{
		public var playLoop:Boolean = false;
		public var bufferTime:int = 1000;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _volume:Number = 0.5;
		private var _panning:Number = 0;
		
		private var _completeEvent:EventSender = new EventSender(StreamSound);
		private var _errorEvent:EventSender = new EventSender(StreamSound);
		private var _readyEvent:EventSender = new EventSender(StreamSound);
		private var _autoPlay:Boolean;
		
		private var _isReady:Boolean;
		private var _isPlaing:Boolean;
		
		private var _pausePosition:Number;
		
		private var _url:String;
		
		public function StreamSound()
		{
			super();
		}
		
		public function load(url:String, autoPlay:Boolean = true, custom:Boolean = false):void
		{
			_url = (custom = false) ? SafeLoader.rootUrl + url : url;

			_autoPlay = autoPlay;
			_isReady = false;
			_isPlaing = false;
			
			stop();
			trace("checkpoint1. _url " + _url);
			
			_sound = new Sound();
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_sound.addEventListener(Event.COMPLETE, onLoadComplete);
			
			var context:SoundLoaderContext = new SoundLoaderContext(bufferTime);
			_sound.load(new URLRequest(_url), context);
		}
		
		public function play(position:Number = 0):void
		{
			playSound(position);
		}
		
		private function onLoadComplete(e:Event = null):void
		{
			_isReady = true;
			trace("load complete");
			
			if (_autoPlay)
				playSound();
				
			_readyEvent.sendEvent(this);
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			_errorEvent.sendEvent(this);
		}
		
		public function pause():void
		{
			_pausePosition = position;
			_isPlaing = false;
			_channel.stop();
		}

		public function resume():void
		{
			playSound(_pausePosition);
		}
		
		private function playSound(position:Number = 0):void
		{
			if (!_isReady)
			{
				throw new Error('Sound is not ready to play.')
			}
			else
			{
				stop();
			
				var transform:SoundTransform = new SoundTransform(_volume, _panning);
				_channel = _sound.play(position, 0, transform);
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComlete);
				_isPlaing = true;
			}
		}
		
		private function onSoundComlete(e:Event):void
		{
			if (playLoop)
			{
				playSound();
			}
			else
			{
				_isPlaing = false;
				_completeEvent.sendEvent(this);
			}
		}
		
		public function stop():void
		{
			if (_channel)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComlete)
				_channel.stop();
				_channel = null;
				_isPlaing = false;
			}
		}
		
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void
		{
			_volume = value;
			updateTransform();
		}
		
		public function get panning():Number { return _panning;	}
		public function set panning(value:Number):void
		{
			_panning = value;
			updateTransform();
		}
		
		private function updateTransform():void
		{
			if (_channel)
				_channel.soundTransform = new SoundTransform(_volume, _panning);
		}
		
		
		public function get position():Number
		{
			return (_channel) ? _channel.position : 0;
		}
		
		public function set position(value:Number):void
		{
			if (_channel)
				playSound(GraphUtils.claimRange(value, 0, _sound.length));
		}
		
		public function get length():Number
		{
			return (_isReady) ? _sound.length : -1;
		}
		
		public function get readyEvent():EventSender { return _readyEvent; }
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
		public function get errorEvent():EventSender { return _errorEvent; }
		
		public function get url():String { return _url; }
		
		public function get isReady():Boolean { return _isReady; }
		
		public function get isPlaing():Boolean { return _isPlaing; }
		
	}
}