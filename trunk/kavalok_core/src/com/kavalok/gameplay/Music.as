﻿package com.kavalok.gameplay
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	
	import flash.media.SoundTransform;
	
	public class Music
	{
		//static public const LOCATION:Array = ['xmas1', 'xmas2', 'chrs2'];
		static public const LOCATION:Array = ['cho3', 'cho4', 'cho2', 'cho1_main', 'chobots_d', 'newmelody'];
		//static public const LOCATION:Array = ['halloween', 'thunder', 'weirdshit'];
		static public const MISSION:Array = ['mission'];
		static public const BUFFER_TIME:int = 15;
		
		private var _currentList:Array;
		private var _currentIndex:int;
		private var _sound:StreamSound = new StreamSound();
		private var _loadFlag:Boolean = false;
		
		public function Music()
		{
			_sound.bufferTime = BUFFER_TIME;
			_sound.completeEvent.addListener(playNext);
		}
		
		public function play(playList:Array):void
		{
			if (playList == _currentList && !_loadFlag || Global.startupInfo.isBot)
				return;
			
			_currentList = playList;
			_currentIndex = -1;
			_sound.volume = Global.musicVolume / 100.0;
			
			_loadFlag = (_sound.volume == 0);
			
			if (!_loadFlag)
				playNext();
		}

		public function playSong(url:String):void
		{
		//var urlReq:URLRequest = new URLRequest(url);
	  //  var sound:Sound = new Sound();
		var sndVol:Number = Global.musicVolume / 100;
		_sound.stop();
		_sound.readyEvent.addListenerIfHasNot(onSoundReadyToPlay);
		_sound.load(url);
		//_sound.play(0);
		}
		
		private function onSoundReadyToPlay(e:Object):void
		{
			trace("sound ready to play");
			_sound.play(0);
		}
		
		public function playMp3Song(url:String):void
		{
			_sound.stop();
		_sound.load(url, true, true);
		}
		
		private function playNext(sender:Object = null):void
		{
			if (++_currentIndex == _currentList.length)
				_currentIndex = 0;
			
			var url:String = URLHelper.musicURL(_currentList[_currentIndex]) 
			_sound.load(url);
		}
		
		public function stop():void
		{
			if(_sound.isPlaing) _sound.stop();
			_currentList = [];
		}
		
		public function set volume(value:Number):void
		{
			_sound.volume = value;
			
			if (_loadFlag)
				play(_currentList);	
		}

	}
}