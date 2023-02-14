package com.kavalok.char.actions
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.StreamSound;

	public class MusicAction extends CharActionBase
	{
		static private const MAX_SOUNDS:int = 4;
		static private var _sounds:Object = {};
		
		override public function execute():void
		{
			
			if (numSounds > MAX_SOUNDS)
				return;
				
			var sound:StreamSound = _sounds[_char.id];
			if (sound)
				sound.stop();
			sound = new StreamSound();
			_sounds[_char.id] = sound;
			
			var url:String = URLHelper.instrumentMusicURL(musicName + musicNum);
			sound.volume = Global.soundVolume / 100;
			sound.panning = _char.position.x / KavalokConstants.SCREEN_WIDTH * 2 - 1;
			sound.completeEvent.addListener(onSoundComplete);
			sound.load(url);
			
			_char.stopMoving();
			_char.setModel(CharModels.PLAY[musicName]);
		}
		
		public function get numSounds():int
		{
			var i:int = 0;
			for each (var sound:Object in _sounds)
			{
				i++;
			}
			return i;
		}
		
		private function onSoundComplete(sound:StreamSound):void
		{
			if (_char.isPlaying)
				_char.setModel(CharModels.STAY, Directions.DOWN);
			delete _sounds[_char.id];
		}
		
		public function get musicName():String
		{
			 return _parameters.name;
		}
		
		public function get musicNum():String
		{
			 return _parameters.num;
		}
	}
}