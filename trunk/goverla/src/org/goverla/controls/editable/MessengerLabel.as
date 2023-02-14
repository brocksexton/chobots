package org.goverla.controls.editable {

	import mx.containers.BoxDirection;
	import mx.controls.Image;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	import mx.validators.EmailValidator;
	
	import org.goverla.constants.Icons;
	import org.goverla.controls.editable.messenger.MessengerProperties;
	import org.goverla.controls.editable.validators.AIMValidator;
	import org.goverla.controls.editable.validators.GoogleTalkValidator;
	import org.goverla.controls.editable.validators.ICQValidator;
	import org.goverla.controls.editable.validators.SkypeValidator;
	import org.goverla.controls.editable.validators.YahooValidator;

	public class MessengerLabel extends TextInputLabel {
		
		protected static const DASH_EXPRESSION : RegExp = /[-]/g;
		
		protected static const ICQ : String = "ICQ";
		
		protected static const SKYPE : String = "Skype";
		
		protected static const YAHOO : String = "Yahoo";
		
		protected static const WINDOWS_LIVE_MESSENGER : String = "Windows Live Messenger"; 
		
		protected static const GOOGLE_TALK : String = "Google Talk"; 
		
		protected static const AIM : String = "AIM"; 

		protected static const ICQ_INDICATOR : String = "http://status.icq.com/online.gif?icq={0}&img=5";
		
		protected static const SKYPE_INDICATOR : String = "http://mystatus.skype.com/smallicon/{0}";
		
		protected static const YAHOO_INDICATOR : String = "http://opi.yahoo.com/online?u={0}&m=g&t=0";
		
		protected static const WINDOWS_LIVE_MESSENGER_INDICATOR : Class = Icons.ICON_16x16_WINDOWS_LIVE_MESSENGER;
		
		protected static const GOOGLE_TALK_INDICATOR : Class = Icons.ICON_16x16_GOOGLE_TALK;
		
		protected static const AIM_INDICATOR : Class = Icons.ICON_16x16_AIM;

		public function MessengerLabel() {
			super();

			viewBox.direction = BoxDirection.HORIZONTAL;
			
			var icqValidator : ICQValidator = new ICQValidator();
			var skypeValidator : SkypeValidator = new SkypeValidator();
			var yahooValidator : YahooValidator = new YahooValidator();
			var windowsLiveMessengerValidator : EmailValidator = new EmailValidator();
			var googleTalkValidator : GoogleTalkValidator = new GoogleTalkValidator();
			var aimValidator : AIMValidator = new AIMValidator();
			
			_properties = new Object();
			_properties[ICQ] = new MessengerProperties(ICQ_INDICATOR, icqValidator);
			_properties[SKYPE] = new MessengerProperties(SKYPE_INDICATOR, skypeValidator);
			_properties[YAHOO] = new MessengerProperties(YAHOO_INDICATOR, yahooValidator);
			_properties[WINDOWS_LIVE_MESSENGER] = new MessengerProperties(WINDOWS_LIVE_MESSENGER_INDICATOR,
				windowsLiveMessengerValidator);
			_properties[GOOGLE_TALK] = new MessengerProperties(GOOGLE_TALK_INDICATOR, googleTalkValidator);
			_properties[AIM] = new MessengerProperties(AIM_INDICATOR, aimValidator);
/* 			_properties[WINDOWS_LIVE_MESSENGER] = new MessengerProperties(null, windowsLiveMessengerValidator);
			_properties[GOOGLE_TALK] = new MessengerProperties(null, googleTalkValidator);
			_properties[AIM] = new MessengerProperties(null, aimValidator);
 */			
			maxChars = 32;

			viewIcon = new Image();
			viewIcon.width = viewIcon.height = 16;
			viewIcon.scaleContent = false;
			viewIcon.setStyle("brokenImageSkin", null);
			viewIcon.setStyle("brokenImageBorderSkin", null);
		}
		
		[Inspectable(enumeration="ICQ,Skype,Yahoo,Windows Live Messenger,Google Talk,AIM")]
		public function get messenger() : String {
			return _messenger;
		}
		
		public function set messenger(messenger : String) : void {
			_messenger = messenger;
			_messengerChanged = true;
			invalidateProperties();
		}
		
		protected function get viewIcon() : Image {
			return _viewIcon;
		}
		
		protected function set viewIcon(viewIcon : Image) : void {
			if (_viewIcon != null) {
				viewBox.removeChild(_viewIcon);
			}
			_viewIcon = viewIcon;
			_viewIconChanged = true;
			invalidateProperties();
		}
		
		protected function get messengerProperties() : MessengerProperties {
			return MessengerProperties(_properties[messenger]);
		}
		
		public function get indicator() : Object {
			return messengerProperties.indicator;
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
			
			if (_viewIconChanged) {
				viewBox.addChildAt(_viewIcon, 0);
				_viewIconChanged = false;
			}
			
			if (_messengerChanged) {
				viewIcon.source = getViewIconSource();
				validator = messengerProperties.validator;
				_messengerChanged = false;
			}
		}
		
		override protected function submitEditedValue() : void {
			super.submitEditedValue();
			
			viewIcon.source = getViewIconSource();
		}
		
		override protected function onViewControlValueCommit(event : FlexEvent) : void {
			super.onViewControlValueCommit(event);
			
			viewIcon.source = getViewIconSource();
		}
		
		protected function getViewIconSource() : Object {
			var result : Object = indicator;
			if (indicator is String) {
				result =
					StringUtil.substitute(String(indicator),
						(messenger != ICQ || text == null ?
							text : text.replace(DASH_EXPRESSION, "")));
			}
			return result;
		}
		
		private var _viewIcon : Image;
		
		private var _viewIconChanged : Boolean;
		
		private var _messenger : String;
		
		private var _messengerChanged : Boolean;
		
		private var _properties : Object;
		
	}

}