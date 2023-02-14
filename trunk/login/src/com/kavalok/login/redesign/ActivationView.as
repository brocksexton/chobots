package com.kavalok.login.redesign
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dto.login.ActivationTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.LoginService;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;

	public class ActivationView extends ViewStackPage
	{
		private static const EMAIL_FORMAT:String = "<b>{0}</b>";
		private static var bundle:ResourceBundle = Localiztion.getBundle(Modules.LOGIN);

		private var _content : McActivationPage;
		private var _registerEvent : EventSender = new EventSender();
		private var _loginEvent : EventSender = new EventSender();
		private var _messageEvent : EventSender = new EventSender();
		private var _login : String;
		
		public function ActivationView(content:McActivationPage)
		{
			_content = content;
			super(content);
			_content.playButton.addEventListener(MouseEvent.CLICK, loginEvent.sendEvent);
			_content.registerButton.addEventListener(MouseEvent.CLICK, registerEvent.sendEvent);
			
			_content.sendActivationButton.addEventListener(MouseEvent.CLICK, onSendActivationClick);
			_content.activationSentField.text = "";
			new EnabledButton(_content.playButton);
			new EnabledButton(_content.registerButton);
			new EnabledButton(_content.sendActivationButton);
			
		}
		
		public function set login(value : String) : void
		{
			_login = value;
			if(Global.charManager && Global.charManager.email)
			{
				var actInfo : ActivationTO = new ActivationTO();
				actInfo.email = Global.charManager.email;
				onGetInfo(actInfo);
			}else
			{
				new LoginService(onGetInfo).getActivationInfo(value);
			}
		}
		
		public function get loginEvent() : EventSender
		{
			return _loginEvent;
		}
		
		public function get messageEvent() : EventSender
		{
			return _messageEvent;
		}
		
		public function get registerEvent() : EventSender
		{
			return _registerEvent;
		}
		
		private function onGetInfo(info : ActivationTO) : void
		{
			var emailText : String = Strings.substitute(EMAIL_FORMAT, info.email);
			_content.activationSentField.htmlText = Strings.substitute(bundle.getMessage("activationText"), emailText); 
		}
		private function onSendActivationClick(event : MouseEvent) : void
		{
			new LoginService().sendActivationMail(Global.startupInfo.redirectURL || "", _login, Localiztion.locale);
			messageEvent.sendEvent(bundle.getMessage("activationSend"));
		}
	
	}
}