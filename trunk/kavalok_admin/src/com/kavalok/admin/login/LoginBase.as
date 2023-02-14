package com.kavalok.admin.login
{
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import com.kavalok.Global;
	
	import org.goverla.events.EventSender;
	import org.goverla.utils.Strings;

	public class LoginBase extends VBox
	{
		[Bindable]
		public var loginTextInput : TextInput;
		[Bindable]
		public var passTextInput : TextInput;

		[Bindable]
		public var rememberCheckBox : CheckBox;

		[Bindable]
		protected var rememberPassword : Boolean = false;
		
		private var _login : EventSender = new EventSender();
		
		public function LoginBase()
		{
			super();
		}
		
		public function onInitialize():void 
		{
			loginTextInput.setFocus();

			if(Global.localSettings.panelUser){
				rememberPassword = true;

				loginTextInput.text = Global.localSettings.panelUser;
				passTextInput.text = Global.localSettings.panelPassw;

			}
		}


		
		public function get login() : EventSender
		{
			return _login;
		}
		
		protected function tryLogin() : void
		{
			if(rememberCheckBox.selected){
				Global.localSettings.panelUser = loginTextInput.text;
				Global.localSettings.panelPassw = passTextInput.text;
			} else if (!rememberCheckBox.selected){
				Global.localSettings.panelUser = "";
				Global.localSettings.panelPassw = "";
			}
			if(!(Strings.isBlank(loginTextInput.text) || Strings.isBlank(passTextInput.text)))
				login.sendEvent([loginTextInput.text, passTextInput.text]);
		}
	}
}