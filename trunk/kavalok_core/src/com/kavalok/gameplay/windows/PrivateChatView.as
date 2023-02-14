package com.kavalok.gameplay.windows
{
	import com.kavalok.Global;
	import com.kavalok.services.AdminService;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.gameplay.controls.ToggleButton;
	import com.kavalok.gameplay.frame.safeChat.SafeChatInputView;
	import com.kavalok.gameplay.frame.safeChat.SafeChatListView;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.layout.VBoxLayout;
	import com.kavalok.utils.Objects;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Strings;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	public class PrivateChatView extends CharChildViewBase
	{
	//	FromArrow; ToArrow;
		
		private static const FROM_MESSAGE_FORMAT : String = KavalokConstants.MY_MESSAGE_FORMAT;
		private static const TO_MESSAGE_FORMAT : String = KavalokConstants.OTHERS_MESSAGE_FORMAT;
		private static const BUTTONS_OFFSET : Number = 113;
		private static const OPEN_HEIGHT : Number = 260;
		
		private var _window : CharWindowChat = new CharWindowChat();
		private var _recipient : String;
		private var _recipientUserId : Number;
		private var _safeChatButton : ToggleButton;
		private var _scroller : Scroller;
		private var _safeChatInput : SafeChatInputView;
		private var _safe : Boolean;
		private var _chatLog : Sprite = new Sprite();
		private var _chatLogLayout : VBoxLayout;
		
		public function PrivateChatView(recipient : String, recipientUserId : Number)
		{
			super(_window);
			
			_recipient = recipient;
			_recipientUserId = recipientUserId;
			
			_chatLog.x = _window.chatLog.x;
			_chatLog.y = _window.chatLog.y;
			_chatLogLayout = new VBoxLayout(_chatLog);
			
			_window.addChild(_chatLog);
			_window.swapChildren(_chatLog, _window.safeChat);
			_window.chatInput.text = "";
			_window.chatInput.restrict = Global.serverProperties.charSet;
			_window.chatInput.maxChars = KavalokConstants.MAX_CHAT_CHARS;
			_window.removeChild(_window.safeChat);
			
			_scroller = new Scroller(_window.scroller);
			_scroller.scrollerVisible = false;
			new ScrollBox(_chatLog, _window.chatLog, _scroller);
			
			_safeChatButton = new ToggleButton(_window.safeChatButton);
			
			new ResourceScanner().apply(_window);
			Global.stage.focus = _window.chatInput;
			
			_window.chatInput.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_window.sendButton.addEventListener(MouseEvent.CLICK, onSendClick);
			_window.safeChatButton.addEventListener(MouseEvent.CLICK, onSafeChatClick);
			
			_safeChatInput = new SafeChatInputView(_window.safeChat);
			var history : ArrayList = Global.notifications.getHistory(_recipient);
			for each(var notification : Notification in history)
			{
				showNotification(notification);
			}
			
			refresh();
		}
		
		override public function destroy() : void
		{
			Global.notifications.receiveNotificationEvent.removeListener(onReceiveNotification);
			Global.notifications.chatEnabledChange.removeListener(onChatEnabledChange);
		}
		
		override public function initialize() : void
		{
			Global.notifications.chatEnabledChange.addListener(onChatEnabledChange);
			Global.notifications.receiveNotificationEvent.addListener(onReceiveNotification);
			setSafe(!Global.notifications.chatEnabled);
		}
		
		private function onChatEnabledChange(value : Boolean) : void
		{
			setSafe(!value);
		}
		
		private function onReceiveNotification(notification : Notification) : void
		{
			if(notification.fromUserId  == _recipientUserId && notification.toUserId == Global.charManager.userId)
			{
				showNotification(notification);
			}
		}
		
		public function quickMessage(text : String, recipient : String) : void
		{			
			var text : String;
			var recipient : String;
			if((!_safe && text == "") || (_safe && _safeChatInput.message.length == 0))
				return;
			var message : Object = _safe ? _safeChatInput.message : text;
			var notification : Notification = new Notification(Global.charManager.charId, Global.charManager.userId, message, recipient, _recipientUserId);
			_window.chatInput.text = "";
			_safeChatInput.clear();
			Global.notifications.sendNotification(notification);
			showNotification(notification);
		}
		
		private function sendMessage() : void
		{			
			var text : String = Strings.trim(_window.chatInput.text);
			if((!_safe && text == "") || (_safe && _safeChatInput.message.length == 0))
				return;
			var message : Object = _safe ? _safeChatInput.message : text;
			var notification : Notification = new Notification(Global.charManager.charId, Global.charManager.userId, message, _recipient, _recipientUserId);
			_window.chatInput.text = "";
			_safeChatInput.clear();
			Global.notifications.sendNotification(notification);
			showNotification(notification);
		}
		
		private function showNotification(notification : Notification) : void
		{
           if(notification.message is String)
			{
				appendText(notification);
			}
			else
			{
				appendArray(notification);
			}
		}
		
		private function appendArray(notification : Notification) : void
		{
			var container : Sprite = new Sprite();
			var textField : TextField = getHeaderTextField(notification);
			container.addChild(textField);
			var safeChat : SafeChatListView = new SafeChatListView(null, Objects.castToArray(notification.message), 3);
			safeChat.content.x = textField.textWidth;
			container.addChild(safeChat.content);
			appendObject(container);
		}
		
		private function appendText(notification : Notification) : void
		{
			var textField : TextField = getHeaderTextField(notification, Objects.castToString(notification.message));
			appendObject(textField);
		}

		private function getHeaderTextField(notification : Notification, message : String = "") : TextField
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Tahoma";
			textFormat.size = 12;
			
			var textField : TextField = new TextField();
			textField.multiline = true;
			textField.wordWrap = true;
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = false;
			
			var format : String = (notification.fromUserId == Global.charManager.userId) ? FROM_MESSAGE_FORMAT : TO_MESSAGE_FORMAT;
			textField.htmlText = Strings.substitute(format, notification.fromLogin, message);

			textField.width = _window.chatLog.width;
			textField.height = textField.textHeight + 4;
			return textField;
			
		}
		
		private function appendObject(object : DisplayObject) : void
		{
			_chatLog.addChild(object);
			_chatLogLayout.apply();
			_scroller.position = 1;
		}
		
		private function setSafe(value : Boolean) : void
		{
			if(_safe == value)
				return;
				
			_safe = value;
			_window.chatInput.visible = !_safe;
			_window.chatInputBackground.visible = !_safe;
			_safeChatButton.toggle = value;
			
			if(_safe)
				_window.addChild(_window.safeChat);
			else
				_window.removeChild(_window.safeChat);
			
			_window.safeChatButton.y += _safe ? BUTTONS_OFFSET : - BUTTONS_OFFSET;
			_window.sendButton.y += _safe ? BUTTONS_OFFSET : - BUTTONS_OFFSET;
			
			heightChanging.sendEvent(_safe ? OPEN_HEIGHT : null);
			
		}
		private function onSafeChatClick(event : MouseEvent) : void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
				_safeChatButton.toggle = true;
			}
			else if (Global.charManager.serverChatDisabled)
			{
				Dialogs.showOkDialog(Global.messages.safeModeTextChat);
				_safeChatButton.toggle = true;
			}
			else if (!Global.notifications.chatEnabled)
			{
				Dialogs.showOkDialog(Global.messages.chatDisabled);
				_safeChatButton.toggle = true;
			}
			else
			{
				setSafe(_safeChatButton.toggle);
			}
			
			refresh();
		}
		
		private function refresh():void
		{
			var messageId:String = (_safeChatButton.toggle)
				? "fullChat"
				: "safeChat";
				
			ToolTips.registerObject(_window.safeChatButton, messageId, ResourceBundles.KAVALOK);
		}
		
		private function onSendClick(event : MouseEvent) : void
		{
			sendMessage();
		}
		
		private function onKeyUp(event : KeyboardEvent) : void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				sendMessage();
			}
		}
		
		
	}
}