package
{
	import com.kavalok.Global;
	import com.kavalok.constants.BrowserConstants;
	import com.kavalok.constants.Modules;
	import com.kavalok.dto.ServerConfigTO;
	import com.kavalok.dto.WorldConfigTO;
	import com.kavalok.dto.login.LoginResultTO;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.controls.CheckBoxStates;
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.login.AuthenticationManager;
	import com.kavalok.login.LoginModes;
	import com.kavalok.login.redesign.registration.data.RegistrationData;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LoginService;
	import com.kavalok.services.UserServiceNT;
	import com.kavalok.utils.KavalokUtil;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class GirlsRegistration extends LocationModule
	{

		private var _bundle:ResourceBundle=Localiztion.getBundle(Modules.LOGIN);

		private static const TERMS_AND_CONDITIONS_FORMAT : String = 
			"<u><font color='#00B3ED'><a href='{0}' target='_blank'>{1}</a></font></u>";

		private var _content:McRegisterGirlsPage=new McRegisterGirlsPage();
		private var _login:String;
		private var _pass:String;
		private var _partnerUid:String;
//		private var _info : StartupInfo;
		private var _tabChildren:Boolean;
		private var _config:ServerConfigTO;
		private var _skipActivation:Boolean;
		private var _mode:String;
		private var _registrationData : RegistrationData = new RegistrationData();

		private var _faultMessages : Object = {};

		private var _agreeButton : StateButton;
		private var _enterButton : EnabledButton;

		public function GirlsRegistration()
		{
			ServerConfigTO.initialize();
			WorldConfigTO.initialize();
		}
		private function initFaultMessages():void
		{
			_faultMessages[AuthenticationManager.ERROR_LOGIN_EXISTS] = _bundle.messages.loginExists;
			_faultMessages[AuthenticationManager.ERROR_EMAIL_EXISTS] = _bundle.messages.emailExists;
			_faultMessages[AuthenticationManager.ERROR_LOGIN_BANNED] = _bundle.messages.loginBanned;
			_faultMessages[AuthenticationManager.ERROR_IP_BANNED] = _bundle.messages.ipBanned;
			_faultMessages[AuthenticationManager.ERROR_LOGIN_NOT_ACTIVE] = _bundle.messages.loginNotActive;
			_faultMessages[AuthenticationManager.ERROR_FAMILY_FULL] = _bundle.messages.familyIsFull;
			_faultMessages[AuthenticationManager.REGISTRATION_DISABLED] = _bundle.messages.regDisabled;
		}
		
		private function initForm():void
		{
			_enterButton = new EnabledButton(_content.enterButton);
			_enterButton.enabled = false;
			
			_agreeButton = new StateButton(_content.agreeCheckBox);
			_agreeButton.content.addEventListener(MouseEvent.CLICK, onAgreeClick);
		
			
			_content.enterButton.addEventListener(MouseEvent.CLICK, onEnterClick);
			
			_content.loginField.maxChars = KavalokConstants.LOGIN_LENGTH;
			
			_content.passwField.maxChars = KavalokConstants.PASSWORD_LENGTH;
			_content.passwField.displayAsPassword = true;
			
			_content.confirmPasswField.maxChars = KavalokConstants.PASSWORD_LENGTH;
			_content.confirmPasswField.displayAsPassword = true;
			
			_content.emailField.maxChars = KavalokConstants.MAX_TEXT_LENGTH;
			
		}
		
		private function onAgreeClick(event : MouseEvent):void
		{
			_enterButton.enabled = _agreeButton.state == CheckBoxStates.SELECTED;			
		}
		private function onEnterClick(event : MouseEvent):void
		{
			tryRegister();
		}
		private function showError(message:String):void
		{
			_content.errorMessage.errorField.text=message;
			_content.errorMessage.visible=true;
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		private function checkFields():Boolean
		{
			if (login.length == 0)
			{
				showError(_bundle.messages.pleaseEnterLogin);
				return false;
			}
			else if (!KavalokUtil.validatePassword(passw))
			{
				showError(_bundle.messages.pleaseEnterPassw);
				return false;
			}
			else if (! (passw == confirmPassw) )
			{
				showError(_bundle.messages.badConfirmPassw);
				return false;
			}
			else if (passw == login)
			{
				showError(_bundle.messages.passwordSameAsLogin);
				return false;
			}
			else if (!checkCharacters())
			{
				showError(_bundle.messages.loginOrPasswordInvalidChars);
				return false;
			}
			else if (!KavalokConstants.EMAIL_EXP.test(email))
			{
				showError(_bundle.messages.pleaseEnterEmail);
				return false;
			}
			else
			{
				_registrationData.login = login;
				_registrationData.email = email;
				_registrationData.password = passw;
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

		protected function tryRegister():void
		{
			if(checkFields()){
				_registrationData.locale = Localiztion.locale;
				_registrationData.marketingInfo = Global.startupInfo.marketingInfo;
				var ind : int = _registrationData.marketingInfo.activationUrl.indexOf("/girlsregister.html");
				if(ind>0){
					_registrationData.marketingInfo.activationUrl=_registrationData.marketingInfo.activationUrl.substring(0, ind);
				}
				Global.isLocked = true;
				new LoginService(onRegister).registerGirls(
					_registrationData.login, 
					_registrationData.password, 
					_registrationData.email,
					_registrationData.body, 
					//_registrationData.color,
					//4767212,
					16303714,
					//_registrationData.isParent,
					true, 
					_registrationData.familyMode, 
					_registrationData.locale,
					_registrationData.invitedBy,
					_registrationData.marketingInfo,
					_registrationData.gender);
			}
		}

		private function onLocaleLoaded():void
		{
			var reviewMessage : String = _bundle.messages.parentsReviewAgreement;
			var termsText : String = Strings.substitute(TERMS_AND_CONDITIONS_FORMAT,
				Global.serverProperties.termsAndConditionsURL,
				_bundle.messages.licenseAgreement);
			reviewMessage = Strings.substitute(reviewMessage, termsText);
			_content.reviewAgreementField.htmlText = reviewMessage;
			initFaultMessages();
		}
		override public function initialize():void
		{
			Global.externalCalls.changeModeEvent.addListener(setMode);
			Global.authManager.faultEvent.addListener(onLoginFault);
			_content=new McRegisterGirlsPage();
			if(_bundle.loaded)
				onLocaleLoaded();
			else
				_bundle.load.addListener(onLocaleLoaded);
				
			new ResourceScanner().apply(_content);
			addChild(_content);

			_content.errorMessage.visible=false;
			_content.successMessage.visible=false;

			selectStartPage();

			_content.invitedByField.addEventListener(Event.CHANGE, onInvitedChange);
			_content.invitedCheck.visible = false;

			initForm();
			new AdminService(onGetConfig).getConfig();
			readyEvent.sendEvent();
		}

		private function trackAnalytics(id:String):void
		{
			Global.analyticsTracker.trackPageview("/f/girlssignup/" + id);
		}

		private function setMode():void
		{
			_mode=Global.externalCalls.getMode();

			selectStartPage();

		}

		private function selectStartPage():void
		{
			_mode = parameters.mode;
			if (ExternalInterface.available)
				_mode = _mode || Global.externalCalls.getMode();

			if (_mode == LoginModes.REGISTER_FROM_PARTNER)
			{
				_partnerUid=parameters.partnerUid;
				trackAnalytics("register_from_partner");
			}
			else
			{
				trackAnalytics("register");
			}

		}

		private function onLoginFault(loginResult:LoginResultTO):void
		{
			Global.isLocked=false;

			var messages:Object={};
			messages[AuthenticationManager.ERROR_LOCAL_CONNECTION]=_bundle.messages.localConnectionExists;
			messages[AuthenticationManager.ERROR_BAD_LOGIN]=_bundle.messages.badLogin;
			messages[AuthenticationManager.ERROR_BAD_PASSW]=_bundle.messages.badPassw;
			messages[AuthenticationManager.ERROR_LOGIN_EXISTS]=_bundle.messages.loginExists;
			messages[AuthenticationManager.ERROR_EMAIL_EXISTS]=_bundle.messages.emailExists;
			messages[AuthenticationManager.ERROR_LOGIN_BANNED]=_bundle.messages.loginBanned;
			messages[AuthenticationManager.ERROR_LOGIN_DISABLED]=_bundle.messages.loginDisabled;
			messages[AuthenticationManager.ERROR_IP_BANNED]=_bundle.messages.ipBanned;
			messages[AuthenticationManager.ERROR_OUTDATED_SWF]=_bundle.messages.outdatedSwf;
			messages[AuthenticationManager.ERROR_UNKNOWN]=_bundle.messages.unknown;
			showError(messages[loginResult.reason]);
		}

		private function showSuccess(message:String):void
		{
			_content.successMessage.field.text=message;
			_content.successMessage.visible=true;
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onMouseDown(event:MouseEvent):void
		{
			_content.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_content.errorMessage.visible=false;
			_content.successMessage.visible=false;
		}

		private function onRegister(result : String) : void
		{
			if(result == AuthenticationManager.SUCCESS)
			{
				var redirectURL : String = _registrationData.marketingInfo.activationUrl+"/play.html#login";
				navigateToURL(new URLRequest(redirectURL), BrowserConstants.SELF);
			}
			else
			{
				var text:String = (result in _faultMessages)
					? _faultMessages[result]
					: Global.messages.error;
				showError(text);
			}
			Global.isLocked = false;
		}


		private function onRegisterSelect(event:Object=null):void
		{
		}


		private function onGetConfig(result:ServerConfigTO):void
		{
			_config=result;
		}

		public function get config():Object
		{
			return _config;
		}
		
		private function onInvitedChange(event : Event):void
		{
			_content.invitedCheck.visible = false;
			_registrationData.invitedBy = null;
			new UserServiceNT(onCheckInvitedBy).userExists(_content.invitedByField.text);
		}
		private function onCheckInvitedBy(result : Boolean):void
		{
			_content.invitedCheck.visible = result;
			_registrationData.invitedBy = result ? _content.invitedByField.text : null;
		}

		

	}

}

