package com.kavalok.video
{
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import com.kavalok.events.EventSender;
	
	public class StreamVideo
	{
		private var _display:Sprite;
		private var _url:String;
		
		private var _volume:Number = 0.5;
		private var _length:Number;
		private var _netStream:NetStream;
		private var _video:Video;
		private var _error:IOErrorEvent;
		
		private var _autoPlay:Boolean;
		
		private var _isReady:Boolean;
		private var _isPlaing:Boolean;
		private var _isPaused:Boolean;
		private var _pausePosition:Number;
		
		private var _completeEvent:EventSender = new EventSender();
		private var _errorEvent:EventSender = new EventSender();
		
		public function StreamVideo(display:Sprite)
		{
			_display = display;
		}
		
		public function load(url:String, autoPlay:Boolean = true):void
		{
			_url = url;
			_autoPlay = autoPlay;
			_isReady = false;
			_isPlaing = false;
			_error = null;
			
			stop();
			
			var netConection:NetConnection = new NetConnection();
			netConection.connect(null);
			
			var client:Object = new Object();
			client.onMetaData = metaDataHandler;
			client.onPlayStatus = playStatusHandler;
			
			_netStream = new NetStream(netConection);
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_netStream.client = client;
			_netStream.soundTransform = new SoundTransform(_volume);

			_video = new Video(_display.width, _display.height);
			_display.addChild(_video);
			_video.attachNetStream(_netStream);
			
			if (_autoPlay)
				play();
		}
		
		private function netStatusHandler(e:NetStatusEvent):void
		{
			if (e.info.code == "NetStream.Play.Stop")
				_completeEvent.sendEvent(this);
		}
		
		private function playStatusHandler(infoObject:Object):void
		{
		}
		
		private function metaDataHandler(infoObject:Object):void
		{
			_isReady = true;
			_length = infoObject.duration;
		}

		public function play():void
		{
			_netStream.play(_url);
			
			_isPlaing = true;
			_isPaused = false;
		}
		
		public function pause():void
		{
			_pausePosition = position;
			_isPlaing = false;
			_isPaused = true;
			
			_netStream.pause();
		}
		
		public function resume():void
		{
			_netStream.resume();
			
			_isPlaing = true;
			_isPaused = false;
		}
		
		public function stop():void
		{
			if (_netStream)
			{
				_netStream.close();
				_netStream = null;
				_display.removeChild(_video);
			}
			
			_isPlaing = false;
			_isPaused = false;
		}
		
		public function get position():Number
		{
			return (_netStream) ? _netStream.time : 0;
		}
		
		public function set position(value:Number):void
		{
			if (_netStream)
				_netStream.seek(value);
		}
		
		public function get length():Number
		{
			return (_isReady) ? _length : -1;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
			_netStream.soundTransform = new SoundTransform(_volume);
		}
		
		
		////////////////////////////////////////////////////////////
		//
		// getters
		//
		////////////////////////////////////////////////////////////
		
		public function get volume():Number { return _volume; }
		
		public function get isReady():Boolean { return _isReady; }
		public function get isPlaing():Boolean { return _isPlaing; }
		public function get isPaused():Boolean { return _isPaused; }
		
		public function get completeEvent():EventSender { return _completeEvent; }
		public function get errorEvent():EventSender { return _errorEvent; }
	}
	
}