package com.kavalok.admin.login
{
	import mx.containers.VBox;
	import mx.controls.TextInput;
	
	import org.goverla.events.EventSender;
	import org.goverla.utils.Strings;

	public class LoginBase extends VBox
	{
		[Bindable]
		public var loginTextInput : TextInput;
		[Bindable]
		public var passTextInput : TextInput;
		
		private var _login : EventSender = new EventSender();
		
		public function LoginBase()
		{
			super();
		}
		
		public function onInitialize():void 
		{
			loginTextInput.setFocus();
		}
		
		public function get login() : EventSender
		{
			return _login;
		}
		
		protected function tryLogin() : void
		{
			
			if(!(Strings.isBlank(loginTextInput.text) || Strings.isBlank(passTextInput.text)))
				login.sendEvent([loginTextInput.text, passTextInput.text]);
		}
	}
}