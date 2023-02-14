package com.kavalok.dialogs
{
	import com.kavalok.Global;

	import flash.display.SimpleButton;
	import com.kavalok.dialogs.DialogYesNoView;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	import fl.controls.Button;
		import com.kavalok.char.Char;
		import com.kavalok.localization.Localiztion;
	import com.kavalok.char.CharModel;
		import com.kavalok.services.CharService;
	import fl.controls.TextArea;
	import fl.controls.CheckBox;
	import com.kavalok.utils.GraphUtils;
	import fl.controls.Slider;
	import flash.events.Event;
	import fl.controls.TextInput;
	import com.kavalok.char.commands.ModeratorPanel;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;

	import com.kavalok.events.EventSender;

	public class DialogModeratorView extends DialogViewBase
	{
		public var banButton : SimpleButton;
		public var kickButton : SimpleButton;
		public var msgButton : SimpleButton;
	//	public var msgText:TextInput;
		public var banText:TextInput;
		public var statusText:TextField;
		public var warnButton : SimpleButton;
		public var chat_1 : SimpleButton;
		public var chat_2 : SimpleButton;
		public var chat_3 : SimpleButton;
		public var locationButton:SimpleButton;
		public var lastChat:TextArea;
		public var exitButton : SimpleButton;
		public var usernameTxt : TextField;
		public var _usersId:int;
		public var charUserName:String;
		public var _charId:String;
		public var sliderRED:Slider;
		public var sliderGREEN:Slider;
		public var sliderBLUE:Slider;
		public var sliderCON:Slider;
		public var reloadBtn:SimpleButton;
		public var sliderSAT:Slider;
		public var sliderHUE:Slider;
		public var sliderBRI:Slider;
		public var charBtn:CheckBox;
		public var bgBtn:CheckBox;
		public var allBtn:CheckBox;
		public var setColor:Button;
		public var magicBack:Sprite;
		public var servField:TextField;
		public var userField:TextField;
		public var ageField:TextField;
		public var statusField:TextField;
		public var locField:TextField;
		public var clearBtn:Button;
		public var charZone:Sprite;
		
     
		private var _kick : EventSender = new EventSender();
		private var _chatBan : EventSender = new EventSender();
		private var _chatBan2 : EventSender = new EventSender();
		private var _chatBan3 : EventSender = new EventSender();
		private var _model:CharModel;
		
		private var _changeLoc : EventSender = new EventSender();
		private var _warn : EventSender = new EventSender();
		private var _ban : EventSender = new EventSender();
		private var _modMsg : EventSender = new EventSender();

		public function DialogModeratorView(text:String = null, modal : Boolean = true)
		{
			super(new DialogModerator(), text, modal);
			Global.resourceBundles.robots.registerButton(warnButton, "warn");
			Global.resourceBundles.robots.registerButton(kickButton, "kick");
			Global.resourceBundles.robots.registerButton(locationButton, "go");
			Global.resourceBundles.robots.registerButton(chat_1, "5min");
			Global.resourceBundles.robots.registerButton(chat_2, "15min");
			Global.resourceBundles.robots.registerButton(chat_3, "12hr");
			Global.resourceBundles.robots.registerButton(msgButton, "msg");
			Global.resourceBundles.robots.registerButton(banButton, "ban");
			Global.resourceBundles.robots.registerButton(reloadBtn, "refresh");
			_model = new CharModel();

			_model.refresh();
			
			charZone.addChild(_model);

			GraphUtils.fitToObject(_model, charZone);
			
			
			updateCharModel();


			kickButton.addEventListener(MouseEvent.CLICK, onKickClick);
			chat_1.addEventListener(MouseEvent.CLICK, onChatBanClick);
			chat_2.addEventListener(MouseEvent.CLICK, onChatBanClick);
			chat_3.addEventListener(MouseEvent.CLICK, onChatBanClick);
			banButton.addEventListener(MouseEvent.CLICK, onBanClick);
			locationButton.addEventListener(MouseEvent.CLICK, onLocationClick);
			exitButton.addEventListener(MouseEvent.CLICK, onExitClick);
			warnButton.addEventListener(MouseEvent.CLICK, onWarnClick);
			msgButton.addEventListener(MouseEvent.CLICK, onMsgClick);
			reloadBtn.addEventListener(MouseEvent.CLICK, onReloadClick);
			setColor.addEventListener(MouseEvent.CLICK, onColorClick);
			clearBtn.addEventListener(MouseEvent.CLICK, onClearClick);
			reload(_usersId);
			statusText.visible = false;
			trace("Username is: " + Global.charsUserName + " and the id is " + _usersId);
			canDoMagic();
		}

		private function onCharInfo(result:Object):void
		{
			if (result)
				_model.char = new Char(result);

			userField.htmlText = Global.upperCase(Global.charsUserName);
			ageField.htmlText = "Age: <br /><font color='#FF0000'>"+_model.char.age+"</font>";
			statusField.htmlText = "Status: <br /><font color='#FF0000'>"+(_model.char.isModerator ? "Moderator" : _model.char.isAgent ? "Agent" : _model.char.isCitizen ? "Citizen" : "Junior") + "</font>";
			locField.htmlText = "Location: <br /><font color='#FF0000'>"+Global.messages[_model.char.location]+"</font>";
			servField.htmlText = "Server: <br /><font color='#FF0000'>"+Localiztion.getBundle("serverSelect").messages[_model.char.server]+"</font>";

		}
		protected function updateCharModel(e:Event = null):void
		{
				_model.char.id = Global.charsUserName.toString();
				new CharService(onCharInfo).getCharViewLogin(Global.charsUserName.toString());
			
		}
		
		public function get kick():EventSender{return _kick;}	
		public function get chatBan():EventSender{return _chatBan;}
		public function get chatBan2():EventSender{return _chatBan2;}
		public function get modMsg():EventSender{return modMsg;}
		public function get chatBan3():EventSender{return _chatBan3;}
		public function get warn():EventSender{return _warn;}
		public function get changeLoc():EventSender{return _changeLoc;}
		public function get ban():EventSender{return _ban;}

		private function onKickClick(e:MouseEvent) : void
		{
					var dialog2:DialogYesNoView = Dialogs.showYesNoDialog("Are you sure you want to kick this user?");
					dialog2.yes.addListener(eventSendKick);
			}
		private function onBanClick(e:MouseEvent):void
		{
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog("Are you sure you want to ban this user?");
				dialog.yes.addListener(clickedBan);
		}
			
		public function onColorClick(e:MouseEvent):void
		{
					if (bgBtn.selected)
					new AdminService().sendState((-1), location._locId, 'L', 'rAddLocationModifier', 'modifier_BackgroundColorModifier', colorInfo);
	
	
					if (charBtn.selected)
					new AdminService().sendState((-1), location._locId, 'L', 'rAddLocationModifier', 'modifier_CharContainerColorModifier', colorInfo);

					if(allBtn.selected)
					new AdminService().sendState((-1), location._locId, 'L', 'rAddLocationModifier', 'modifier_LocationColorModifier', colorInfo);
				}

		public function onClearClick(e:MouseEvent):void
				{
	
					sliderRED.value = 1;
					sliderGREEN.value = 1;
					sliderBLUE.value = 1;
					sliderHUE.value=0;
					sliderSAT.value=0;
					sliderBRI.value=0;
					sliderCON.value=0;
									
					if(allBtn.selected)
					new AdminService().removeState((-1), location._locId, 'L', 'rRemoveLocationModifier', 'modifier_LocationColorModifier');
					
					if(charBtn.selected)
					new AdminService().removeState((-1), location._locId, 'L', 'rRemoveLocationModifier', 'modifier_CharContainerColorModifier');

				   if(bgBtn.selected)
				   new AdminService().removeState((-1), location._locId, 'L', 'rRemoveLocationModifier', 'modifier_BackgroundColorModifier');
  			 	}

			public function setStatusText(newStatus:String):void
			{
				statusText.text = newStatus;
				statusText.visible = true;
			}

			public function onReloadClick(e:MouseEvent):void
			{
				Global.isLocked = true;
				reload(_usersId);
			}
			
			public function reload(userId : int) : void
			{
				new AdminService(onGetMessages).getUserLastChatMessages(Global.charsUserName.toString());
			}
			
			public function onLocationClick(e:MouseEvent):void
			{
				changeLoc.sendEvent();
				trace(".....sent event for location change");
			}

			private function onGetMessages(result : String) : void
			{
				Global.isLocked = false;
				lastChat.text = result;
			}

			public function get colorInfo():Object
			{
			var clInfo:Object = new Object();
			clInfo.red = sliderRED.value;
			clInfo.green = sliderGREEN.value;
			clInfo.blue = sliderBLUE.value;
			clInfo.hue = sliderHUE.value;
			clInfo.saturation = sliderSAT.value;
			clInfo.brightness = sliderBRI.value;
			clInfo.contrast = sliderCON.value;
			
			return clInfo;
			}
			private function onMsgClick(e:MouseEvent):void
			{
				if(banText.length < 5){
					setStatusText("Please enter a message to send...");
				}
				else{
					new AdminService().sendModMessageFromGame(_usersId, banText.text);
					new AdminService().addPanelLog("[GM] " + Global.upperCase(Global.charManager.charId), "Sent mod message to " + Global.charsUserName.toString() + " saying \"" + banText.text + "\"", Global.getPanelDate());
					setStatusText("Moderator message sent to " + Global.charsUserName.toString());
					new LogService().toolsLog("Sent mod message saying: " + banText.text, _usersId, Global.charsUserName, "tools");
				}
			}


			
			private function onWarnClick(e:MouseEvent):void
			{
                warn.sendEvent();
				trace("warning sent..");
				setStatusText("Warning sent to " + Global.charsUserName.toString());

			}
			private function onChatBanClick(e:MouseEvent) : void
			{
				var cBut:SimpleButton = SimpleButton(e.currentTarget);		

				if(cBut.name.indexOf("_1") != -1)		
				{
					chatBan.sendEvent();
					setStatusText(Global.charsUserName.toString() + "'s chat was banned for 5 minutes");

				}
				else if (cBut.name.indexOf("_2") != -1)
				{
					chatBan2.sendEvent();
					setStatusText(Global.charsUserName.toString() + "'s chat was banned for 15 minutes");
				}
				else if (cBut.name.indexOf("_3") != -1)
				{
					chatBan3.sendEvent();
					setStatusText(Global.charsUserName.toString() + "'s chat was banned for 12 hours");
				}

				trace("chat ban sent");
			}

			private function clickedBan() : void
			{
				if (banText.length < 5){
					setStatusText("Please set a ban reason...");
					}	else
					{
						new AdminService().saveGameBan(_usersId, true, banText.text + "    " + "\nBanned by ");
						banText.text = "";
						setStatusText(Global.charsUserName.toString() + " was banned");
						new LogService().toolsLog("Banned", _usersId, Global.charsUserName, "tools");
						new AdminService().addPanelLog("[GM] " + Global.upperCase(Global.charManager.charId), "Banned " + Global.charsUserName, Global.getPanelDate());
					}
				}

				private function get location():Object
    {
        return Global.locationManager.reference.value;
    }


			private function onExitClick(e:MouseEvent):void
			{
				hide();
			}

			private function canDoMagic():void
			{
				if(Global.charManager.permissions.indexOf("modmagic;") != -1){
					sliderRED.visible = true;
					sliderGREEN.visible = true;
					sliderBLUE.visible = true;
					sliderCON.visible = true;
					sliderSAT.visible = true;
					sliderHUE.visible = true;
					sliderBRI.visible = true;
					charBtn.visible = true;
					bgBtn.visible = true;
					allBtn.visible = true;
					setColor.visible = true;
					clearBtn.visible = true;
					magicBack.visible = true;
				} else {
					sliderRED.visible = false;
					sliderGREEN.visible = false;
					sliderBLUE.visible = false;
					sliderCON.visible = false;
					sliderSAT.visible = false;
					sliderHUE.visible = false;
					sliderBRI.visible = false;
					charBtn.visible = false;
					bgBtn.visible = false;
					allBtn.visible = false;
					setColor.visible = false;
					clearBtn.visible = false;
					magicBack.visible = false;
				}
			}

			private function eventSendKick():void
			{
				kick.sendEvent();
				trace("kick event sent");
				setStatusText(Global.charsUserName.toString() + " was kicked");
			}

		}
	}