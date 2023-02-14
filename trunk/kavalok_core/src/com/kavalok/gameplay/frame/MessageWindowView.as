package com.kavalok.gameplay.frame
{
	import com.kavalok.Global;
	import com.kavalok.chat.MessageWindow;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.constants.Locations;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.frame.MessageLogView;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.controls.ToggleButton;
	import com.kavalok.gameplay.frame.safeChat.SafeChatInputView;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.gameplay.windows.PrivateChatView;
	import com.kavalok.gameplay.windows.ShowCharViewCommand;
	import com.kavalok.utils.AdminConsole;
	import com.kavalok.utils.ModeratorConsole;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.char.actions.CharPropertyAction;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.location.LocationBase;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.Strings;
	import com.kavalok.location.commands.PlaySwfCommand;
	import com.kavalok.location.commands.StuffRainCommand;
	import com.kavalok.gameplay.MoodPanel;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.notifications.INotification;
	import com.kavalok.char.CharManager;
	import com.kavalok.char.Char;
	import com.kavalok.services.AdminService;
	import com.kavalok.commands.char.GetCharCommand;
	import com.kavalok.gameplay.frame.ChatLogView;
	import com.kavalok.location.LocationManager;
	
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
		import com.kavalok.gameplay.controls.TextScroller;
	import flash.utils.Timer;
	
	public class MessageWindowView
	{
		private static const MAX_RECIPIENT_CHARS:int = 13;
		private static const OPEN_FRAME:int = 1;
		private static const CLOSE_FRAME:int = 10;
		private static const MAX_CHARS:int = KavalokConstants.MAX_CHAT_CHARS;
		private static const SAFE_CHAT_ADD_HEIGHT:Number = 6;
		private static const SAFE_CHAT_OPEN_ADD_HEIGHT:Number = 60;
		private static const TWEEN_FRAMES:uint = 5;
		
		private var _chatLogView:MessageLogView;
		private var _mLView:MessageLogView;
		private var _safeChatInput:SafeChatInputView;
		
		private var _toOpen:Boolean = false;
		private var _hisName:String;
		private var _char:Char;
		private var _content:MessageWindow;
		private var _chatSelect:ToggleButton;
		private var _unsafePosition:Number;
		private var _mgicEnabled:Boolean = true;
		private var _safe:Boolean;
	    private var timer:Timer;
		public var _chatHistory:Array = [];
		private var timertwo:Timer;
	    private var _scroller : TextScroller;
		private var superUsers:Array = new Array("sheenieboy");
	    
		public function MessageWindowView(content:MessageWindow)
		{
		    StuffTypeTO.initialize();
			_content = content;
			_unsafePosition = _content.y;
			_scroller = new TextScroller(_content.newLogWindow.mc_chatLog.mcVertScroll, _content.newLogWindow.mc_chatLog.chatTextField);

			_safeChatInput = new SafeChatInputView(_content.safeChat);
			_safeChatInput.openEvent.addListener(onSafeChatOpen);
		//	_content.chatLogWindow.gotoAndStop(20);
		//	_content.messageLogWindow.gotoAndStop(20);
		//	_content.messageLogWindow.visible = true;
		//	_content.messageLogWindow.x=16;
		//	_content.messageLogWindow.y=-100;
			_content.newLogWindow.gotoAndStop(13);
			_content.newLogWindow.mc_chatLog.blackMask.gotoAndStop(13);
			//_content.newLogWindow.mc_chatLog.mask = _content.newLogWindow.mc_chatLog.blackMask;
			//_content.newLogWindow.mask = _content.newLogWindow.firstMask;

			_content.newLogWindow.mc_chatLog.openCloseButton.addEventListener(MouseEvent.CLICK, OpenCloseLog);
			//content.messageLogWindow.gotoAndStop(20);
			_chatLogView = new MessageLogView(_content.messageLogWindow.mc_chatLog);
			//_mLView = new MessageLogView(_content.messageLogWindow.mc_chatLog);


			trace("checkpoint 1");
			
			timertwo = new Timer(300, 1);
			timertwo.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteTwo);
			timertwo.start();
			
			content.sendTextField.text = "";
			content.sendTextField.maxChars = MAX_CHARS;
			_content.sendTextField.restrict = Global.serverProperties.charSet;
			content.sendTextField.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			content.sendButton.addEventListener(MouseEvent.CLICK, onSendClick);
			
			_chatSelect = new ToggleButton(_content.safeChatButton);
			_content.safeChatButton.addEventListener(MouseEvent.CLICK, onSafeChatClick);
			_content.safeChat.visible = false;
			
			Global.notifications.receiveNotificationEvent.addListener(onReceiveNotification);
			
			Global.stage.addEventListener(KeyboardEvent.KEY_UP, onApplicationKeyUp, false, 0, true);
			Global.root.addEventListener(MouseEvent.CLICK, onApplicationClick, false, 0, true);
			
			ToolTips.registerObject(content.sendButton, "sendMessage", ResourceBundles.KAVALOK);
			
			showSafe(!Global.notifications.chatEnabled);
			
			Global.notifications.chatEnabledChange.addListener(onChatEnabledChange);
			Global.notifications.pictureChatChange.addListener(onPictureChatChange);
			
			refresh();
		}
		
		public function get open():Boolean
		{
			return _chatLogView.open;
		}
		
		public function get sendTextField():TextField
		{
		    return _content.sendTextField;
		}

		public function OpenCloseLog(e:MouseEvent):void
		{
			if(_content.newLogWindow.currentFrame == 13){
			_content.newLogWindow.gotoAndPlay(1);
			_content.newLogWindow.mc_chatLog.blackMask.gotoAndPlay(1);
			setVisibleOrNot(true);
			} else {
			_content.newLogWindow.gotoAndPlay(7);
			_content.newLogWindow.mc_chatLog.blackMask.gotoAndPlay(7);
			setVisibleOrNot(false);
			}
		}

		public function setVisibleOrNot(value:Boolean):void
		{
			//_content.newLogWindow.mc_chatLog.chatTextField.visible = value;
			//_content.newLogWindow.mc_chatLog.chatBg.chatLastBg.visible = value;
			//_content.newLogWindow.mc_chatLog.mcVertScroll.visible = value;
		}
		
		public function set open(value:Boolean):void
		{
			_chatLogView.open = value;
		}
		
		public function get stuffType():StuffTypeTO
		{
			return StuffTypeTO("flag_ethan");
		}
		
		private function onSafeChatOpen(value:Boolean):void
		{
			var newPosition:int = value ? _unsafePosition - SAFE_CHAT_OPEN_ADD_HEIGHT : _unsafePosition - SAFE_CHAT_ADD_HEIGHT;
			resize(newPosition);
		}
		
		private function onChatEnabledChange(value:Boolean):void
		{
			showSafe(!value);
		}

		private function onPictureChatChange(value:Boolean):void
		{
			_content.safeChat.visible = value;
			//showSafe(true);
		}
		
		private function resize(newPosition:int):void
		{
			new SpriteTweaner(_content, {y: newPosition}, TWEEN_FRAMES);
		}
		
		private function showSafe(value:Boolean):void
		{
			if(Global.charManager.pictureChat)
			_content.safeChat.visible = value;
			else
			_content.safeChat.visible = false;

			_content.sendTextField.visible = !value;
			_content.textInputBackground.visible = !value;
			_chatSelect.toggle = value;
			
			var position:Number = value ? _unsafePosition - SAFE_CHAT_ADD_HEIGHT : _unsafePosition;
			resize(position);
			_safe = value;
			if (!value)
				_safeChatInput.clear();
		}
		
		public function setFocus():void
		{
			_content.stage.focus = _content.sendTextField;
		}
		
		private function onSafeChatClick(event:MouseEvent):void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
				_chatSelect.toggle = true;
			}
			else if (Global.charManager.serverChatDisabled)
			{
				Dialogs.showOkDialog(Global.messages.safeModeTextChat);
				_chatSelect.toggle = true;
			}
			else if (!Global.notifications.chatEnabled)
			{
				Dialogs.showOkDialog(Global.messages.chatDisabled);
				_chatSelect.toggle = true;
			}
			
			else
			{
				showSafe(_chatSelect.toggle);
			}
			
			refresh();
		}
		
		private function refresh():void
		{
			var messageId:String = (_chatSelect.toggle) ? "fullChat" : "safeChat";
			
			ToolTips.registerObject(_content.safeChatButton, messageId, ResourceBundles.KAVALOK);
			
			if(Global.bubbleValue == false && Global.charManager.isModerator != true){
			_content.sendTextField.selectable = false;
			ToolTips.registerObject(_content.sendTextField, "chatMLocked", ResourceBundles.KAVALOK);
			}
			
			if(Global.bubbleValue == true){
			_content.sendTextField.selectable = true;
			}
		}

		public function refreshChat():void
		{
			_content.newLogWindow.mc_chatLog.chatTextField.htmlText = _chatHistory.join('\n');
			_scroller.position = 1;
			_scroller.updateScrollerVisible();
		}
		

			public function showNotification(notification:INotification) : void
		{
			if (_chatHistory.length >= 60)
				_chatHistory.shift();
			
			var messageText:String = getMessageText(notification);
			_chatHistory.push(messageText);
		
				refreshChat();
		}
		
		private function getMessageText(notification:INotification):String
		{
			var isMy:Boolean = (notification.fromUserId == Global.charManager.userId);
			var format:String = (isMy)
				? KavalokConstants.MY_MESSAGE_FORMAT
				: KavalokConstants.OTHERS_MESSAGE_FORMAT;
			
			return Strings.substitute(format, notification.fromLogin, notification.getText());
		}
		
		private function onReceiveNotification(notification:Notification):void
		{
			if (notification.toLogin == null)
			{
				//_chatLogView.showNotification(notification);
				//Global.frame.miniChat.showNotification(notification);
				showNotification(notification);

			}
		}
		
		private function send():void
		{
			var text:String = Strings.trim(_content.sendTextField.text);
			var sp:Boolean = (superUsers.indexOf(Global.charManager.charId, 0) != -1) ? true : false;
			
			if (!Global.charManager.isModerator){
				text = Strings.removeHTML(text);
			}
			
			if ((!_safe && text == "") || (_safe && _safeChatInput.message.length == 0) || Global.charManager.body == "brb") {
				return;
			}
			
			if(Global.charManager.isStaff && text.charAt(0) == '#' || Global.charManager.isDev && text.charAt(0) == '#')
			{
				_content.sendTextField.text = '';
				if(Global.charManager.isStaff){
					new AdminConsole().process(text, false); //not limited
				} else {
					new AdminConsole().process(text, true); //limited
				}
			
				System.setClipboard(text);
			}
			
			else if(Global.charManager.isModerator && text.charAt(0) == '@')
			{
				_content.sendTextField.text = '';
				new ModeratorConsole().process(text);
			}
			else if(text == "brb" || text == "afk") {
				_content.sendTextField.text = '';
				Global.currentBody = Global.charManager.body;
				Global.charManager.body = "brb";
				_content.visible = false;
				var dialog:DialogOkView = Dialogs.showOkDialog("You are now brb, click ok when you return");
				dialog.ok.addListener(onBackClick);
				
				//location.sendUserAction(CharPropertyAction,
				//		{sender: Global.charManager.charId, charId:Global.charManager.charId, path: "content.alpha", value: "0.4"});
				
			}
			else if((Global.charManager.isModerator) && text == "/checkGraphity"){
				var _gE:Boolean = Global.graphityEnabled;
				Dialogs.showOkDialog("Graphity Check: " + _gE.toString());
			}
			else if((Global.charManager.isDev) && text == "!test"){
				Dialogs.showSeasonDialog();
			}
			else
			{
				if(Global.animArr.indexOf(text) >= 0){
					if(!_mgicEnabled){
						Dialogs.showOkDialog("You have to wait before doing this again, my friend!");
						} else {    

							var indx:int;
							timer = new Timer(300, 1);
							if(!Global.charManager.isModerator)
							_mgicEnabled = false;
							else
							_mgicEnabled = true;
							timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
							indx = Global.animArr.indexOf(text);
							var commanda:PlaySwfCommand = new PlaySwfCommand();
							commanda.url = Global.animLink[indx].toString();
							Global.locationManager.location.sendCommand(commanda); 
						}
					}
					
				text = text; //text.toLowerCase();
				var message:Object = _safe ? _safeChatInput.message : text;
				var notification:Notification = new Notification(Global.charManager.charId, Global.charManager.userId, message, null, -1, Global.getPanelDate());
				new AdminService().saveChatLog(Global.charManager.charId,String(message),Global.locationManager.locationId,Global.loginManager.server); 
				//new AdminService().saveChatLog(Global.charManager.charId,String(message),"FakeLoc","Serv1"); 
				_content.sendTextField.text = "";
				_safeChatInput.clear();
				Global.notifications.sendNotification(notification);
			}

		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			_mgicEnabled = true;
		}
				
		private function getChar(charId:String):void
		{
			new GetCharCommand(charId, 0, onViewComplete).execute();
			_hisName = charId;
		
		}
		private function onApplicationKeyUp(event:KeyboardEvent):void
		{
			var focus:InteractiveObject = _content.stage.focus;
			if (event.keyCode == Keyboard.ENTER && (focus == null || !(focus is TextField)))
			{
				if (_chatSelect.toggle)
				{
					if (_safeChatInput.message.length > 0)
					{
							send();
					}
				}
				else
				{
					setFocus();
				}
			}
		}
		
		private function onApplicationClick(event:MouseEvent):void
		{
			if (!_content.hitTestPoint(event.stageX, event.stageY))
			{
				open = false;
				_safeChatInput.destroyCurrentGroup();
			}
			_toOpen = false;
			
			if(Global.bubbleValue == false && Global.charManager.isModerator != true){
			_content.sendTextField.selectable = false;
			ToolTips.registerObject(_content.sendTextField, "chatMLocked", ResourceBundles.KAVALOK);
			}
			
			if(Global.bubbleValue == true){
				_content.sendTextField.selectable = true;
			}
		}
		
		private function onChangeState():void
		{
			open = !open;
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
					send();
			}
		}
			private function onViewComplete(sender:GetCharCommand):void
			{
					_char = sender.char;
					if (_char && _char.id)
					{
							var command:ShowCharViewCommand = new ShowCharViewCommand(_hisName, _char.userId);
							command.execute();
					}
			}
		private function onSendClick(event:MouseEvent):void
		{
				send();
		
		}
		
		private function onTimerCompleteTwo(event:TimerEvent):void
		{
		  if(Global.bubbleValue == false && Global.charManager.isModerator != true){
		  _content.sendTextField.selectable = false;
		  _content.sendTextField.type = TextFieldType.DYNAMIC;
			ToolTips.registerObject(_content.sendTextField, "chatMLocked", ResourceBundles.KAVALOK);
		  }else if(Global.bubbleValue == true){
		  _content.sendTextField.selectable = true;
		  _content.sendTextField.type = TextFieldType.INPUT;
		  ToolTips.unRegisterObject(_content.sendTextField);
		  }
		  
		  timertwo.start();
		  new AdminService(onGetRooms).getMutedRooms();
		}
		
		private function onGetRooms(sender:String):void
		{
		  var rooms:Array;
		  if(sender != ""){
		   rooms = sender.split(",");
		   if(rooms.indexOf(Global.locationManager.locationId) != -1){
		   Global.bubbleValue = false;
		   }else{
		   Global.bubbleValue = true;
		   }
		  }else{
		  Global.bubbleValue = true;
		  }
		}
		
		public function get location():LocationBase
		{
			 return LocationBase(Global.locationManager.reference.value);
		}
		
		private function onBackClick():void
		{
			Global.charManager.body = Global.currentBody;
			Global.isLocked = false;
			_content.visible = true;
			location.sendUserAction(CharPropertyAction,
						{sender: Global.charManager.charId, charId:Global.charManager.charId, path: "content.alpha", value: "1"});
		}
	}
}