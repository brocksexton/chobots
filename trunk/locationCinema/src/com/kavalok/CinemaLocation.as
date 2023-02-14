package com.kavalok
{
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class CinemaLocation extends LocationBase
	{
		private var _player : DisplayObject;
		private var _initializeEvent : EventSender = new EventSender();
		
		public function CinemaLocation(player : DisplayObject)
		{
			super(Modules.LOCATION_CINEMA);
			var background : Background = new Background();
			_player = player;
			GraphUtils.removeAllChildren(background.playerContent);
			_player.mask = background.playerContentMask;
			background.playerContent.addChild(player);
			setContent(background);
			_player.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			Timers.callAfter(initializePlayerFinish, 5000);//added to fix youtube widget stupid sizing
			
		}
		public function get initializeEvent() : EventSender
		{
			return _initializeEvent;
		}
		override public function destroy():void
		{
			Global.root.stage.focus = null;
			super.destroy();
			_player.mask = null;
		}

		private function initializePlayerFinish() : void
		{
			_player.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			initializeEvent.sendEvent();
		}
		private function onEnterFrame(event : Event) : void
		{
			Global.stage.align = "";
			_player.width = 8400;
			_player.height = 4400;
		}	
		

	}
}