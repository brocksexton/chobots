package com.kavalok.gameplay.windows
{
	import com.kavalok.gameplay.controls.FlashViewBase;
	
	import flash.display.Sprite;
	
	import com.kavalok.events.EventSender;

	public class CharChildViewBase extends FlashViewBase
	{
		private var _heightChanging : EventSender = new EventSender();
		
		public function CharChildViewBase(content : Sprite)
		{
			super(content);
		}
		
		public function initialize() : void {};
		
		public function destroy() : void {};
		
		public function get heightChanging() : EventSender
		{
			return _heightChanging;
		}
	}
}