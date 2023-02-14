package com.kavalok.home
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dto.home.CharHomeTO;
	import com.kavalok.flash.playback.MovieClipPlayer;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.EntryPointBase;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class LevelEntryPoint extends EntryPointBase
	{
		private var _home : CharHomeTO;
		private var _char : String;
		private var _userId : int;
		private var _player : MovieClipPlayer;
		
		public function LevelEntryPoint(location : LocationBase, remoteId : String, char : String,  userId : int, home : CharHomeTO)
		{
			_home = home;
			_char = char;
			_userId = userId;
			super(location, "levelEnter", remoteId);
		}
		
		override public function initialize(mc:MovieClip):void
		{
			super.initialize(mc);
			mc.alpha = 0;
			MousePointer.registerObject(mc, MousePointer.EXIT);
			var doors : MovieClip = getDoors(mc);
			if(doors)
			{
				doors.gotoAndStop(1);
				mc.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				mc.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
		}
		
		override public function goIn():void
		{
			super.goIn();
			Global.moduleManager.loadModule(Modules.HOME, {charId : _char, userId : _userId, room : getRoomIndex(clickedClip)});
		}
		
		private function onMouseOver(event : MouseEvent) : void
		{
			var doors : MovieClip = getDoors(MovieClip(event.target));
			playDoors(doors, 1, doors.totalFrames);
		}
		
		
		private function playDoors(doors : MovieClip, start : int, end : int) : void
		{
			if(_player)
				_player.stop();
			_player = new MovieClipPlayer(doors);
			_player.playInterval(start, end);
		}
		private function onMouseOut(event : MouseEvent) : void
		{
			var doors : MovieClip = getDoors(MovieClip(event.target));
			playDoors(doors, doors.currentFrame, 1);
		}
		
		private function getDoors(clip : MovieClip) : MovieClip
		{
			return _location.content["doors_" + clip.name];
		}
		private function getRoomIndex(clip : MovieClip) : int
		{
			var parts : Array = clip.name.split("_");
			return parts[1];
		}

	}
}