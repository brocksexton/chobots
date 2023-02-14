package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.char.LocationChar;
	import com.kavalok.char.actions.PropertyActionBase;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.RetriveStuffByIdCommand;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.commands.MoveToLocationCommand;
	import com.kavalok.location.commands.NotificationCommand;
	import com.kavalok.location.commands.PlayMP3Command;
	import com.kavalok.location.commands.PlaySwfCommand;
	import com.kavalok.location.commands.PromoCommand;
	import com.kavalok.location.commands.StuffRainCommand;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.MoveDemChars;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	import fl.controls.TextInput;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;

	public class DialogPanelView extends DialogViewBase
	{
		public var unmuteButton:SimpleButton;
		public var page3BButton:SimpleButton;
		public var globalField:TextInput;
		public var redBack:Sprite;
		public var glowButton:SimpleButton;
		public var setColor:Button;
		public var charBtn:CheckBox;
		public var gitemField:TextInput;
		public var promoButton:SimpleButton;
		public var promoField:TextInput;
		public var page2BButton:SimpleButton;
		public var page2FButton:SimpleButton;
		public var notifyField:TextInput;
		public var lockButton:SimpleButton;
		public var statusText:TextField;
		public var changeBodyButton:SimpleButton;
		public var sliderSAT:Slider;
		public var gmoneyButton:SimpleButton;
		protected var _char:LocationChar;
		public var movetoField:TextInput;
		public var page2Text:Sprite;
		public var mp3Button:SimpleButton;
		public var swfButton:SimpleButton;
		public var movetoButton:SimpleButton;
		public var muteField:TextInput;
		public var page1FButton:SimpleButton;
		public var sliderHUE:Slider;
		public var blueBack:Sprite;
		public var godonButton:SimpleButton;
		public var glowField:TextInput;
		public var sliderBRI:Slider;
		public var changeChatButton:SimpleButton;
		public var godoffButton:SimpleButton;
		public var greenBack:Sprite;
		public var glowoffButton:SimpleButton;
		public var defaultBodyButton:SimpleButton;
		public var changeBodyUField:TextInput;
		public var swfField:TextInput;
		public var unlockButton:SimpleButton;
		public var _rainName:String;
		public var sliderGREEN:Slider;
		public var muteButton:SimpleButton;
		public var changeBodyField:TextInput;
		public var changeChatField:TextInput;
		public var globalButton:SimpleButton;
		public var sliderBLUE:Slider;
		public var rainidButton:SimpleButton;
		public var rainField:TextInput;
		public var gmoneyField:TextInput;
		public var defaultChatButton:SimpleButton;
		public var gitemButton:SimpleButton;
		public var changeChatUField:TextInput;
		public var page1Text:Sprite;
		public var page3Text:Sprite;
		public var clearBtn:Button;
		public var bgBtn:CheckBox;
		public var gitemcField:TextInput;
		public var sliderCON:Slider;
		public var rainButton:SimpleButton;
		public var mp3Field:TextInput;
		public var sliderRED:Slider;
		public var sendnotifButton:SimpleButton;
		public var allBtn:CheckBox;
		public var exitButton:SimpleButton;

		public function DialogPanelView(text:String = null, modal:Boolean = true)
		{
			super(new DialogPanel(),text,modal);
			ToolTips.registerObject(godonButton,"Godmode on");
			ToolTips.registerObject(godoffButton,"Godmode off");
			ToolTips.registerObject(sendnotifButton,"Send notification");
			ToolTips.registerObject(globalButton,"Send Global Message");
			ToolTips.registerObject(unmuteButton,"Unmute Rooms");
			ToolTips.registerObject(muteButton,"Mute");
			ToolTips.registerObject(rainButton,"Rain");
			ToolTips.registerObject(rainidButton,"Rain");
			ToolTips.registerObject(promoButton,"Send Plane");
			ToolTips.registerObject(swfButton,"Play Swf");
			ToolTips.registerObject(mp3Button,"Play MP3");
			ToolTips.registerObject(page1FButton,"Page 2");
			ToolTips.registerObject(page2BButton,"Page 1");
			ToolTips.registerObject(page2FButton,"Page 3");
			ToolTips.registerObject(page3BButton,"Page 2");
			ToolTips.registerObject(movetoButton,"Move");
			ToolTips.registerObject(gmoneyButton,"Give Money");
			ToolTips.registerObject(lockButton,"Lock Mouse");
			ToolTips.registerObject(unlockButton,"Unlock Mouse");
			ToolTips.registerObject(gitemButton,"Give Item");
			ToolTips.registerObject(glowButton,"Glow");
			ToolTips.registerObject(glowoffButton,"Turn off Glow");
			ToolTips.registerObject(changeChatButton,"Change Chat");
			ToolTips.registerObject(changeBodyButton,"Change Body");
			ToolTips.registerObject(defaultChatButton,"Default chat");
			ToolTips.registerObject(defaultBodyButton,"Default body");
			ToolTips.registerObject(gitemField,"Item id");
			ToolTips.registerObject(gitemcField,"Item Colour Code");
			ToolTips.registerObject(changeChatUField,"Username");
			ToolTips.registerObject(changeBodyUField,"Username");
			ToolTips.registerObject(changeChatField,"Chat colour");
			ToolTips.registerObject(changeBodyField,"Body name");

			exitButton.addEventListener(MouseEvent.CLICK,onExitClick);
			setColor.addEventListener(MouseEvent.CLICK,onColorClick);
			clearBtn.addEventListener(MouseEvent.CLICK,onClearClick);
			godonButton.addEventListener(MouseEvent.CLICK,onGodonClick);
			godoffButton.addEventListener(MouseEvent.CLICK,onGodoffClick);
			sendnotifButton.addEventListener(MouseEvent.CLICK,onNotifClick);
			globalButton.addEventListener(MouseEvent.CLICK,onGlobalClick);
			unmuteButton.addEventListener(MouseEvent.CLICK,onUnmuteClick);
			muteButton.addEventListener(MouseEvent.CLICK,onMuteClick);
			rainButton.addEventListener(MouseEvent.CLICK,onRainClick);
			rainidButton.addEventListener(MouseEvent.CLICK,onRainidClick);
			promoButton.addEventListener(MouseEvent.CLICK,onPromoClick);
			swfButton.addEventListener(MouseEvent.CLICK,onSwfClick);
			mp3Button.addEventListener(MouseEvent.CLICK,onMp3Click);
			page1FButton.addEventListener(MouseEvent.CLICK,onPage2Click);
			page2BButton.addEventListener(MouseEvent.CLICK,onPage1Click);
			page2FButton.addEventListener(MouseEvent.CLICK,onPage3Click);
			page3BButton.addEventListener(MouseEvent.CLICK,onPage2Click);
			movetoButton.addEventListener(MouseEvent.CLICK,onMovetoClick);
			gmoneyButton.addEventListener(MouseEvent.CLICK,onGiveMoneyClick);
			lockButton.addEventListener(MouseEvent.CLICK,onLockClick);
			unlockButton.addEventListener(MouseEvent.CLICK,onUnlockClick);
			gitemButton.addEventListener(MouseEvent.CLICK,onGiftItemClick);
			glowButton.addEventListener(MouseEvent.CLICK,onGlowClick);
			glowoffButton.addEventListener(MouseEvent.CLICK,onGlowoffClick);
			changeChatButton.addEventListener(MouseEvent.CLICK,onChangeChatClick);
			changeBodyButton.addEventListener(MouseEvent.CLICK,onChangeBodyClick);
			defaultChatButton.addEventListener(MouseEvent.CLICK,onDefaultChatClick);
			defaultBodyButton.addEventListener(MouseEvent.CLICK,onDefaultBodyClick);
			setStatusText("Welcome, " + Global.charManager.charId);
			page(1,true);
			page(2,false);
			page(3,false);
		}

		public function onPage2Click(e:MouseEvent) : void
		{
			page(1,false);
			page(2,true);
			page(3,false);
		}

		public function onUnmuteClick(e:MouseEvent) : void
		{
			new AdminService().saveMutedRooms("");
			setStatusText("Unmuted all locations");
		}

		public function onColorClick(e:MouseEvent) : void
		{
			if(bgBtn.selected)
			{
				new AdminService().sendState(-1,location._locId,"L","rAddLocationModifier","modifier_BackgroundColorModifier",colorInfo);
			}
			if(charBtn.selected)
			{
				new AdminService().sendState(-1,location._locId,"L","rAddLocationModifier","modifier_CharContainerColorModifier",colorInfo);
			}
			if(allBtn.selected)
			{
				new AdminService().sendState(-1,location._locId,"L","rAddLocationModifier","modifier_LocationColorModifier",colorInfo);
			}
			setStatusText("Changed room colour");
		}

		public function onSwfClick(e:MouseEvent) : void
		{
			var command:PlaySwfCommand = new PlaySwfCommand();
			command.url = swfField.text;
			Global.locationManager.location.sendCommand(command);
			setStatusText("You just played a swf");
		}

		public function onGodonClick(e:MouseEvent) : void
		{
			MoveDemChars.instance.started = true;
			setStatusText("Godmode turned on");
		}

		public function setStatusText(newStatus:String) : void
		{
			statusText.text = newStatus;
		}

		public function onGiftItemClick(e:MouseEvent) : void
		{
			var colour:Number = Number(gitemcField.text);
			var gItem:int = int(gitemField.text);
			if(!colour)
			{
				colour = Maths.random(16777215);
			}
			new RetriveStuffByIdCommand(gItem,"gift",colour).execute();
			setStatusText("Gifted yourself an item");
		}

		public function onGiveMoneyClick(e:MouseEvent) : void
		{
			var moneyAmount:int = int(gmoneyField.text);
			new AddMoneyCommand(moneyAmount,"Daily Login",false).execute();
			setStatusText("Gave yourself " + moneyAmount + " bugs");
		}

		public function onUnlockClick(e:MouseEvent) : void
		{
			location.sendUserAction(PropertyActionBase,{
			"sender":Global.charManager.userId,
			"path":"isLocked",
			"value":0
			});
			setStatusText("Unlocked everyone\'s mouse");
		}

		public function onGlowoffClick(e:MouseEvent) : void
		{
			_char.model.filters = [];
			_char.model.transform.colorTransform = new ColorTransform();
			setStatusText("Removed glow from everyone");
		}

		public function onRainClick(e:MouseEvent) : void
		{
			var rainNameId:Number = Number(rainField.text);
			if(isNaN(rainNameId))
			{
				new StuffServiceNT(stuffResult).getStuffType(rainField.text);
			} else {
				new StuffServiceNT(stuffResult).getStuffTypeFromId(rainNameId);
			}
		}

		public function onChangeBodyClick(e:MouseEvent) : void
		{
			var newBody:String = changeBodyField.text;
			var bodyUsername:String = changeBodyUField.text;
			new CharService().saveBodyPanel(newBody,Global.charManager.color,bodyUsername);
			setStatusText("Changed " + bodyUsername + "\'s body to " + newBody);
		}

		public function onChangeChatClick(e:MouseEvent) : void
		{
			var newChat:String = changeChatField.text;
			var chatUsername:String = changeChatUField.text;
			new CharService().setChatColor(newChat,chatUsername);
			setStatusText("Changed " + chatUsername + "\'s chat colour to " + newChat);
		}

		public function onGlobalClick(e:MouseEvent) : void
		{
			setStatusText("Feature is broken");
		}

		public function onMp3Click(e:MouseEvent) : void
		{
			var command:PlayMP3Command = new PlayMP3Command();
			command.url = mp3Field.text;
			Global.locationManager.location.sendCommand(command);
			setStatusText("You just played a song");
		}

		public function onPage1Click(e:MouseEvent) : void
		{
			page(1,true);
			page(2,false);
			page(3,false);
		}

		public function onNotifClick(e:MouseEvent) : void
		{
			var command:NotificationCommand = new NotificationCommand();
			command.notify = notifyField.text;
			location.sendCommand(command);
			setStatusText("Sent global notification saying: " + notifyField.text);
		}

		public function onGodoffClick(e:MouseEvent) : void
		{
			MoveDemChars.instance.started = false;
			setStatusText("Godmode turned off");
		}

		public function page(page:int, value:Boolean) : void
		{
			if((Global.charManager.isModerator && Global.charManager.permissions.indexOf("tools;") != -1) || Global.charManager.isDev) 
			{
				if(page == 1)
				{
					page1Text.visible = value;
					godoffButton.visible = value;
					godonButton.visible = value;
					sendnotifButton.visible = value;
					notifyField.visible = value;
					globalButton.visible = value;
					globalField.visible = value;
					muteButton.visible = value;
					muteField.visible = value;
					unmuteButton.visible = value;
					rainButton.visible = value;
					rainField.visible = value;
					rainidButton.visible = false;
					promoButton.visible = value;
					promoField.visible = value;
					swfButton.visible = value;
					swfField.visible = value;
					mp3Button.visible = value;
					mp3Field.visible = value;
					movetoField.visible = value;
					movetoButton.visible = value;
					page1FButton.visible = value;
				}
				else if(page == 2)
				{
					page2Text.visible = value;
					lockButton.visible = value;
					unlockButton.visible = value;
					gmoneyField.visible = value;
					gmoneyButton.visible = value;
					gitemField.visible = value;
					gitemcField.visible = value;
					gitemButton.visible = value;
					glowField.visible = value;
					glowButton.visible = value;
					glowoffButton.visible = value;
					changeChatUField.visible = value;
					changeChatField.visible = value;
					changeChatButton.visible = value;
					defaultChatButton.visible = value;
					changeBodyUField.visible = value;
					changeBodyField.visible = value;
					changeBodyButton.visible = value;
					defaultBodyButton.visible = value;
					page2BButton.visible = value;
					page2FButton.visible = value;
				}
				else if(page == 3)
				{
					page3Text.visible = value;
					sliderRED.visible = value;
					sliderGREEN.visible = value;
					sliderBLUE.visible = value;
					redBack.visible = value;
					blueBack.visible = value;
					greenBack.visible = value;
					sliderCON.visible = value;
					sliderSAT.visible = value;
					sliderHUE.visible = value;
					sliderBRI.visible = value;
					charBtn.visible = value;
					bgBtn.visible = value;
					allBtn.visible = value;
					setColor.visible = value;
					clearBtn.visible = value;
					page3BButton.visible = value;
				}
			} else {
				Dialogs.showOkDialog("Invalid permissions.");
			}
		}

		public function onClearClick(e:MouseEvent) : void
		{
			sliderRED.value = 1;
			sliderGREEN.value = 1;
			sliderBLUE.value = 1;
			sliderHUE.value = 0;
			sliderSAT.value = 0;
			sliderBRI.value = 0;
			sliderCON.value = 0;
			new AdminService().removeState(-1,location._locId,"L","rRemoveLocationModifier","modifier_LocationColorModifier");
			new AdminService().removeState(-1,location._locId,"L","rRemoveLocationModifier","modifier_CharContainerColorModifier");
			new AdminService().removeState(-1,location._locId,"L","rRemoveLocationModifier","modifier_BackgroundColorModifier");
			setStatusText("Cleared all colours");
		}

		public function onPage3Click(e:MouseEvent) : void
		{
			page(1,false);
			page(2,false);
			page(3,true);
		}

		private function stuffResult(result:StuffTypeTO) : void
		{
			var command:StuffRainCommand = null;
			if(result.fileName == "")
			{
				setStatusText("Item not found");
			} else {
				command = new StuffRainCommand();
				command.itemId = result.id;
				command.fileName = result.fileName;
				command.stuffType = result.type;
				Global.locationManager.location.sendCommand(command);
				setStatusText("Rained: " + result.fileName);
			}
		}

		public function onMovetoClick(e:MouseEvent) : void
		{
			var command:MoveToLocationCommand = new MoveToLocationCommand();
			command.locId = movetoField.text;
			location.sendCommand(command);
		}

		public function onRainidClick(e:MouseEvent) : void
		{
		}

		public function get colorInfo() : Object
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

		public function onDefaultBodyClick(e:MouseEvent) : void
		{
			var bodyUsername:String = changeBodyUField.text;
			new CharService().saveBodyPanelToDefault(Global.charManager.color,bodyUsername);
			setStatusText("Changed " + bodyUsername + "\'s body to default");
		}

		public function onDefaultChatClick(e:MouseEvent) : void
		{
			var chatUsername:String = changeChatUField.text;
			new CharService().setChatColorToDefault(chatUsername);
			setStatusText("Changed " + chatUsername + "\'s chat to default");
		}

		public function onMuteClick(e:MouseEvent) : void
		{
			if(Global.charManager.isDev)
			{
				new AdminService().saveMutedRooms(muteField.text);
				setStatusText("Muted " + muteField.text);
			} else {
				setStatusText("Shadow only k? k.");
			}
		}

		public function onGlowClick(e:MouseEvent) : void
		{
			setStatusText("Made everyone glow");
		}

		public function get location() : LocationBase
		{
			return LocationBase(Global.locationManager.reference.value);
		}

		public function onExitClick(e:MouseEvent) : void
		{
			hide();
		}

		public function onPromoClick(e:MouseEvent) : void
		{
			var command:PromoCommand = new PromoCommand();
			command.Ptype = "original";
			command.text = promoField.text;
			Global.locationManager.location.sendCommand(command);
			setStatusText("Sent a promo saying " + promoField.text);
		}

		public function onLockClick(e:MouseEvent) : void
		{
			if(Global.charManager.isDev)
			{
				location.sendUserAction(PropertyActionBase,{
				"sender":Global.charManager.userId,
				"path":"isLocked",
				"value":1
				});
				setStatusText("Locked everyone\'s mouse");
			}
			else
			{
				setStatusText("Shadow only k? k.");
			}
		}

	}
}
