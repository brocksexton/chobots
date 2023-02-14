package com.kavalok.login.redesign
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dto.login.MarketingInfoTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.gameplay.controls.ViewStackSwitcher;
	import com.kavalok.gameplay.controls.effects.AlphaHideEffect;
	import com.kavalok.gameplay.controls.effects.AlphaShowEffect;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.login.AuthenticationManager;
	import com.kavalok.login.redesign.registration.RegistrationView;
	import com.kavalok.login.redesign.registration.data.RegistrationData;
	import com.kavalok.services.LoginService;
	import com.kavalok.utils.Strings;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class RegisterWizardView extends ViewStackPage
	{
		private static var bundle:ResourceBundle = Localiztion.getBundle(Modules.LOGIN);

		private var _partnerUid : String;
		
		private var _viewStack : ViewStackSwitcher = new ViewStackSwitcher();
		private var _content : McRegisterView;
		private var _registrationView : RegistrationView;
		
		private var _errorEvent : EventSender = new EventSender(String);
		private var _finishEvent : EventSender = new EventSender(RegistrationData);
		private var _backEvent : EventSender = new EventSender();
		
		private var _registrationData : RegistrationData = new RegistrationData();
		private var _faultMessages : Object = {};
		private var _pages : Array = ["behavior", "ageAndColor", "registration"];
		
		public function RegisterWizardView()
		{
			super(content);
			_faultMessages[AuthenticationManager.ERROR_LOGIN_EXISTS] = bundle.messages.loginExists;
			_faultMessages[AuthenticationManager.ERROR_EMAIL_EXISTS] = bundle.messages.emailExists;
			_faultMessages[AuthenticationManager.ERROR_LOGIN_BANNED] = bundle.messages.loginBanned;
			_faultMessages[AuthenticationManager.ERROR_IP_BANNED] = bundle.messages.ipBanned;
			_faultMessages[AuthenticationManager.ERROR_LOGIN_NOT_ACTIVE] = bundle.messages.loginNotActive;
			_faultMessages[AuthenticationManager.ERROR_FAMILY_FULL] = bundle.messages.familyIsFull;
			_faultMessages[AuthenticationManager.REGISTRATION_DISABLED] = bundle.messages.regDisabled;
			_faultMessages[AuthenticationManager.ERROR_NOT_ALLOWED] = bundle.messages.notAllowed;
			
			
			_registrationView = new RegistrationView(_content.viewStack.registerPage);
			_registrationView.data = _registrationData;
			_registrationView.nextEvent.addListener(onFinishRegistration);
			_registrationView.backEvent.addListener(onBack);
			
			_viewStack.showEffect = new AlphaShowEffect();
			_viewStack.hideEffect = new AlphaHideEffect();
			_viewStack.addPage(_registrationView);
			
			_viewStack.selectedPage = _registrationView;
			trackAnalytics(0);
			
			processButton(_content.pageButton_0);
			processButton(_content.pageButton_1);
			//processButton(_content.pageButton_2);
			
			_content.pageButton_0.visible = true;
			
			_registrationView.errorEvent.addListener(errorEvent.sendEvent);
		}
		
		public function get errorEvent() : EventSender
		{
			return _errorEvent;
		}
		
		public function get finishEvent() : EventSender
		{
			return _finishEvent;
		}
		
		public function get backEvent() : EventSender
		{
			return _backEvent;
		}
		public function set partnerUid(value : String) : void
		{
			_partnerUid = value;
			if(value)
				_content.pageButton_2.visible = false;
		}
		public function set familyEmail(value : String) : void
		{
			_registrationView.familyEmail = value;
			_registrationData.familyMode = true;
		}
		
		private function trackAnalytics(index : int) : void
		{
			var id : String = _pages[index];
			Global.analyticsTracker.trackPageview("/f/signup/" + id);
		}

		private function processButton(button : SimpleButton) : void
		{
			button.visible = false;
			button.alpha = 0;
			button.addEventListener(MouseEvent.CLICK, onPageButtonClick);
		}
		
		private function onFinishRegistration() : void
		{
			Global.isLocked = true;
			_registrationData.locale = Localiztion.locale;
			_registrationData.marketingInfo = Global.startupInfo.marketingInfo;
			
			new LoginService(onRegister).register(
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
				_registrationData.marketingInfo);
		}
		
		private function onRegister(result : String) : void
		{
			Global.isLocked = false;
			if(result == AuthenticationManager.SUCCESS)
			{
				finishEvent.sendEvent(_registrationData);
			}
			else
			{
				var text:String = (result in _faultMessages)
					? _faultMessages[result]
					: Global.messages.error;
				errorEvent.sendEvent(text);
			}
		}
		
		private function onPageButtonClick(event : MouseEvent) : void
		{
			var button : SimpleButton = SimpleButton(event.target);
			var index : int = button.name.split("_")[1];
			setSelectedIndex(index);
		}
		
		private function setSelectedIndex(value : int) : void 
		{
			trackAnalytics(value);
			
			if (value == _viewStack.indexOf(_registrationView))
			{
				if(_partnerUid)
				{
					new LoginService(onRegister).registerFromPartner(_partnerUid,
						_registrationData.body, _registrationData.color,
						_registrationData.isParent);
				}
				else
				{
					_viewStack.selectedIndex = value;
					_registrationView.show();
				}
			}
			else
			{
				_viewStack.selectedIndex = value;
			}
		}
		
		private function onBehaviorBack(event : Object = null) : void
		{
			backEvent.sendEvent();
		}
		
		private function onBack(event : Object = null) : void
		{
			setSelectedIndex(_viewStack.selectedIndex - 1);
		}
		
		private function onNext(event : Object = null) : void
		{
			setSelectedIndex(_viewStack.selectedIndex + 1);
			_content["pageButton_" + _viewStack.selectedIndex].visible = true;
		}
		
		
	}
}