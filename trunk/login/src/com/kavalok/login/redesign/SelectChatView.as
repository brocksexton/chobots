package com.kavalok.login.redesign
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.CheckBoxStates;
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.LoginService;
	
	import flash.events.MouseEvent;

	public class SelectChatView extends CharPageBase
	{
		private static var bundle : ResourceBundle = Localiztion.getBundle(Modules.LOGIN);
		private var _content : McSelectChatView;
		private var _activateButton : EnabledButton;
		private var _fullChatCheckBox : StateButton;
		private var _safeChatCheckBox : StateButton;
		private var _login : String;
		private var _activationKey : String;
		private var _errorEvent : EventSender = new EventSender();
		private var _showLoginEvent : EventSender = new EventSender();
		private var _messageEvent : EventSender = new EventSender();
		
		public function SelectChatView(content : McSelectChatView)
		{
			_content = content;	
			super(_content);
			_activateButton = new EnabledButton(_content.activateButton);
			_fullChatCheckBox = new StateButton(_content.fullChatCheckBox);
			_safeChatCheckBox = new StateButton(_content.safeChatCheckBox);
			_activateButton.enabled = false;
			_fullChatCheckBox.content.addEventListener(MouseEvent.CLICK, onSelectFullChat);
			_safeChatCheckBox.content.addEventListener(MouseEvent.CLICK, onSelectSafeChat);
			_activateButton.content.addEventListener(MouseEvent.CLICK, onActivateClick);
		}
		
		public function get showLoginEvent() : EventSender
		{
			return _showLoginEvent;
		}
		public function get messageEvent() : EventSender
		{
			return _messageEvent;
		}
		public function get errorEvent() : EventSender
		{
			return _errorEvent;
		}

		public function set activationKey(value : String) : void
		{
			_activationKey = value;
		}

		override public function set login(value : String) : void
		{
			_login = value;
			super.login = value;
			updateCharModel();
			_content.welcomeField.text = bundle.getMessage("welcome") + " " + value;
		}

		private function onSelectFullChat(event : MouseEvent) : void
		{
			_activateButton.enabled = true;
			_fullChatCheckBox.state = CheckBoxStates.SELECTED;
			_safeChatCheckBox.state = CheckBoxStates.NOT_SELECTED;
		}

		private function onSelectSafeChat(event : MouseEvent) : void
		{
			_activateButton.enabled = true;
			_safeChatCheckBox.state = CheckBoxStates.SELECTED;
			_fullChatCheckBox.state = CheckBoxStates.NOT_SELECTED;
		}
		
		private function onActivateClick(event : MouseEvent) : void
		{
			var chatEnabled : Boolean = _fullChatCheckBox.state == CheckBoxStates.SELECTED;
			Global.isLocked = false;
			new LoginService(onActivationResult, onActivationFault).activateAccount(_login, _activationKey, chatEnabled);
		}
		



		private function onActivationFault(fault : Object) : void
		{
			Global.isLocked = false;
			errorEvent.sendEvent(bundle.getMessage("invalidActivationUrl"));
			showLoginEvent.sendEvent();
		}
		private function onActivationResult(result : Boolean) : void
		{
			Global.isLocked = false;
			if(result)
			{
				messageEvent.sendEvent(bundle.getMessage("yourAccountIsActivated"));
				showLoginEvent.sendEvent()
			}
			else
			{
				errorEvent.sendEvent(bundle.getMessage("invalidActivationUrl"));
				showLoginEvent.sendEvent()
			}
		}
	}
}