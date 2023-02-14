package com.kavalok.gameplay.commands
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dialogs.McChangePassword;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.KavalokUtil;
	import com.kavalok.utils.Strings;
	import com.kavalok.security.MD5;
	
	import flash.events.MouseEvent;
	
	public class ChangePasswordCommand
	{
		static private const PASSW_CHANGED:String = 'passwordChanged';
		
		private var _content:McChangePassword = new McChangePassword();
		
		public function ChangePasswordCommand()
		{
			_content.currentPassword.displayAsPassword = true;
			_content.currentPassword.maxChars = KavalokConstants.PASSWORD_LENGTH;
			
			_content.newPassword.displayAsPassword = true;
			_content.newPassword.maxChars = KavalokConstants.PASSWORD_LENGTH;
			
			_content.confirmPassword.displayAsPassword = true;
			_content.confirmPassword.maxChars = KavalokConstants.PASSWORD_LENGTH;
			
			_content.submitButton.addEventListener(MouseEvent.CLICK, onSubmitClick);
		}
		
		private function onSubmitClick(e:MouseEvent):void
		{
			var bundle:ResourceBundle = Localiztion.getBundle(Modules.LOGIN);
			
			if (!KavalokUtil.validatePassword(newPassword))
				Dialogs.showOkDialog(bundle.messages.pleaseEnterPassw);
			else if (!(newPassword == confirmPassword))
				Dialogs.showOkDialog(bundle.messages.badConfirmPassw);
			else
				new AdminService(onResult).changePassword(MD5.hash(currentPassword), MD5.hash(newPassword));
		}
		
		private function onResult(result:String):void
		{
			Dialogs.showOkDialog(Global.messages[result]);
			
			if (result == PASSW_CHANGED){
				Global.enteredPassword= MD5.hash(_content.newPassword.text);
				Dialogs.hideDialogWindow(_content);

			}
		}
		
		public function execute():void
		{
			Dialogs.showOkDialog(null, true, _content);
			Global.stage.focus = _content.currentPassword;
		}
		
		public function get currentPassword():String
		{
			return Strings.trim(_content.currentPassword.text);
		}
		
		public function get newPassword():String
		{
			return Strings.trim(_content.newPassword.text);
		}
		
		public function get confirmPassword():String
		{
			return Strings.trim(_content.confirmPassword.text);
		}
	}
}