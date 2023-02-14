package com.kavalok.login.redesign.registration
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.login.redesign.registration.data.RegistrationData;
	
	import flash.display.Sprite;

	public class WizardViewBase extends ViewStackPage
	{
		private var _nextEvent : EventSender = new EventSender();
		private var _backEvent : EventSender = new EventSender();
		
		public var data : RegistrationData;

		public function WizardViewBase(content:Sprite)
		{
			super(content);
		}
		
		public function get nextEvent() : EventSender
		{
			return _nextEvent;
		}

		public function get backEvent() : EventSender
		{
			return _backEvent;
		}
		
		public function refresh() : void
		{
			
		}
	}
}