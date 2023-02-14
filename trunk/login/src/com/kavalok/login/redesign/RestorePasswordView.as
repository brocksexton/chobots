package com.kavalok.login.redesign
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.LoginService;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;

	public class RestorePasswordView extends ViewStackPage
	{
		private static var bundle:ResourceBundle = Localiztion.getBundle(Modules.LOGIN);

		private var _content : McRestorePasswordPage;
		private var _backEvent : EventSender = new EventSender();
		private var _messageEvent : EventSender = new EventSender();
		private var _errorEvent : EventSender = new EventSender();
		
		public function RestorePasswordView(content:McRestorePasswordPage)
		{
			super(content);
			_content = content;
			_content.sendPasswordButton.addEventListener(MouseEvent.CLICK, onRestoreClick);
			new EnabledButton(_content.sendPasswordButton);
			new EnabledButton(_content.backButton);
			_content.backButton.addEventListener(MouseEvent.CLICK, onBackClick);
			_content.emailField.text = "";
		}
		
		public function get backEvent() : EventSender
		{
			return _backEvent;
		}
		public function get messageEvent() : EventSender
		{
			return _messageEvent;
		}
		public function get errorEvent() : EventSender
		{
			return _errorEvent;
		}
		private function onBackClick(event : MouseEvent) : void
		{
			backEvent.sendEvent();
		}
		private function onRestoreClick(event : MouseEvent) : void
		{
			// please, send me some toiletries!
			new LoginService(onResult).sendPassword(Strings.trim(_content.emailField.text), Localiztion.locale);
			Global.isLocked = true;
		}
		
		private function onResult(result : Boolean) : void
		{
			Global.isLocked = false;
			if(result)
			{
				messageEvent.sendEvent(bundle.getMessage("passwordRestored"));
				backEvent.sendEvent();
			}
			else
			{
				errorEvent.sendEvent(bundle.getMessage("restoreWrongEmail"));
			}
		}
	}
}