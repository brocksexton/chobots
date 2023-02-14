package com.kavalok.login.redesign.registration
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.gameplay.controls.CheckBoxStates;
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.login.redesign.registration.data.RegistrationData;
	import com.kavalok.services.UserServiceNT;
	import com.kavalok.utils.KavalokUtil;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;

	public class RegistrationView extends ViewStackPage
	{
		private static const TERMS_AND_CONDITIONS_FORMAT : String = 
			"<u><font color='#00B3ED'><a href='{0}' target='_blank'>{1}</a></font></u>";
//		private static const TERMS_AND_CONDITIONS_FORMAT : String = "{0} <u><a href='http://{1}/terms.html'>{2}</a></u>";

		private static var bundle:ResourceBundle = Localiztion.getBundle(Modules.LOGIN);
		
		
		protected var _content:McRegisterGirlsPage = new McRegisterGirlsPage();

		private var _isParent : Boolean;

		private var _agreeButton : StateButton;
		private var _enterButton : EnabledButton;
		
		private var _errorEvent : EventSender = new EventSender(String);

		public var data : RegistrationData;
		
		public function RegistrationView(content:McRegisterGirlsPage)
		{
			_content = content
			super(content);
			
			initForm();
			_content.stage.focus = _content.loginField;
			_content.invitedByField.addEventListener(Event.CHANGE, onInvitedChange);
			_content.invitedCheck.visible = false;
		}
		
		public function set familyEmail(value : String) : void
		{
			_content.emailField.text = value;
			_content.emailField.type = TextFieldType.DYNAMIC;
		}
		public function get errorEvent() : EventSender
		{
			return _errorEvent;
		}

		public function get login():String
		{
			 return Strings.trim(_content.loginField.text).toLowerCase();
		}
		
		public function get passw():String
		{
			 return Strings.trim(_content.passwField.text);
		}
		
		public function get confirmPassw():String
		{
			 return Strings.trim(_content.confirmPasswField.text);
		}
		
		public function get email():String
		{
			 return Strings.trim(_content.emailField.text).toLowerCase();
		}	

		public function set constantEmail(value:String):void
		{
			_content.emailField.text = value;
			_content.emailField.type = TextFieldType.DYNAMIC;
		}
		
		public function set buttonCaption(messageId:String):void
		{
			bundle.registerButton(_content.playButton, messageId);
		}
		
		public function set emailCaption(messageId:String):void
		{
			bundle.registerTextField(_content.registerBackTexts.emailCaption, messageId);
		}
		
		public function show() : void
		{
			_content.stage.focus = _content.loginField;
			if(data.hasEmail)
			{
				_content.emailLabelField.text = bundle.messages.insertEmail;
				_content.emailDescriptionField.text = bundle.messages.emailDescription;
			}			
			else
			{
				_content.emailLabelField.text = bundle.messages.insertParentsEmail;
				_content.emailDescriptionField.text = bundle.messages.parentsEmailDescription;
			}
			var reviewMessage : String = data.isParent ? bundle.messages.reviewAgreement : bundle.messages.parentsReviewAgreement;
			var termsText : String = Strings.substitute(TERMS_AND_CONDITIONS_FORMAT,
				Global.serverProperties.termsAndConditionsURL,
				bundle.messages.licenseAgreement);
			reviewMessage = Strings.substitute(reviewMessage, termsText);
			_content.reviewAgreementField.htmlText = reviewMessage;
		}
		
		private function initForm():void
		{
			_enterButton = new EnabledButton(_content.enterButton);
			_enterButton.enabled = false;
			
			_agreeButton = new StateButton(_content.agreeCheckBox);
			_agreeButton.content.addEventListener(MouseEvent.CLICK, onAgreeClick);
//			_content.backButton.addEventListener(MouseEvent.CLICK, backEvent.sendEvent);
			new EnabledButton(_content.backButton);
			
			
			_content.enterButton.addEventListener(MouseEvent.CLICK, onEnterClick);
			
			_content.loginField.maxChars = KavalokConstants.LOGIN_LENGTH;
			
			_content.passwField.maxChars = KavalokConstants.PASSWORD_LENGTH;
			_content.passwField.displayAsPassword = true;
			
			_content.confirmPasswField.maxChars = KavalokConstants.PASSWORD_LENGTH;
			_content.confirmPasswField.displayAsPassword = true;
			
			_content.emailField.maxChars = KavalokConstants.MAX_TEXT_LENGTH;
			
		}
		
		protected function tryRegister():void
		{
//			if(checkFields())
//				nextEvent.sendEvent();
		}
		
		private function onEnterClick(event : MouseEvent):void
		{
			tryRegister();
		}
		private function onInvitedChange(event : Event):void
		{
			_content.invitedCheck.visible = false;
			data.invitedBy = null;
			new UserServiceNT(onCheckInvitedBy).userExists(_content.invitedByField.text);
		}
		private function onCheckInvitedBy(result : Boolean):void
		{
			_content.invitedCheck.visible = result;
			data.invitedBy = result ? _content.invitedByField.text : null;
		}
		private function onAgreeClick(event : MouseEvent):void
		{
			_enterButton.enabled = _agreeButton.state == CheckBoxStates.SELECTED;			
		}
		private function onEnterClick(event : MouseEvent):void
		{
			tryRegister();
		}

		private function checkFields():Boolean
		{
			if (login.length == 0)
			{
				errorEvent.sendEvent(bundle.messages.pleaseEnterLogin);
				return false;
			}
			else if (!KavalokUtil.validatePassword(passw))
			{
				errorEvent.sendEvent(bundle.messages.pleaseEnterPassw);
				return false;
			}
			else if (! (passw == confirmPassw) )
			{
				errorEvent.sendEvent(bundle.messages.badConfirmPassw);
				return false;
			}
			else if (passw == login)
			{
				errorEvent.sendEvent(bundle.messages.passwordSameAsLogin);
				return false;
			}
			else if (!checkCharacters())
			{
				errorEvent.sendEvent(bundle.messages.loginOrPasswordInvalidChars);
				return false;
			}
			else if (!KavalokConstants.EMAIL_EXP.test(email))
			{
				errorEvent.sendEvent(bundle.messages.pleaseEnterEmail);
				return false;
			}
			else
			{
				data.login = login;
				data.email = email;
				data.password = passw;
				return true;				
			}
			
		}
		
		private function checkCharacters():Boolean
		{
			var loginMatch : Array = login.match(KavalokConstants.LOGIN_PATTERN);
			if(loginMatch == null)
				return false;
			return loginMatch[0] == login;
		}
		
	}
}