package com.kavalok.gameplay.frame
{
	import com.kavalok.Global;
	import com.kavalok.border.McBorder;
	import com.kavalok.char.charZone;
	import com.kavalok.char.Char;
	import com.kavalok.char.LocationChar;
	import com.kavalok.char.modifiers.Scale2Modifier;
	import com.kavalok.constants.Locations;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.DialogMoneyView;
	import com.kavalok.dialogs.DialogOutfitsView;
	import com.kavalok.dialogs.DialogTwitterView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.GameMenu;
	import com.kavalok.gameplay.MoodPanel;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.frame.bag.MiniBagView;
	import com.kavalok.gameplay.frame.bag.MiniCandyView;
	import com.kavalok.gameplay.frame.bag.MiniCardsView;
	import com.kavalok.gameplay.frame.bag.MiniChatView;
	import com.kavalok.gameplay.frame.bag.MiniCitizenView;
	import com.kavalok.gameplay.frame.bag.MiniDanceView;
	import com.kavalok.gameplay.frame.bag.MiniMagicView;
	import com.kavalok.gameplay.frame.bag.MiniMusicView;
	import com.kavalok.gameplay.frame.tips.TipsWindowView;
	import com.kavalok.gameplay.tips.TipWindow;
	import com.kavalok.level.Levels;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.location.LocationBase;
	import com.kavalok.messenger.Messenger;
	import com.kavalok.services.AdminService;
	import com.kavalok.ui.Window;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Strings;
	import com.kavalok.char.CharModel;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.services.CharService;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.*;
	import flash.utils.Timer;

	import fl.transitions.Tween;
    import fl.transitions.TweenEvent;
    import fl.transitions.easing.Strong;

	public class GameFrameView
	{
		private static const MONEY_FORMAT:String = "{0}";
		private var _content:McBorder;
		private var _messageWindowView:MessageWindowView;
		private var _miniBag:MiniBagView;
		private var _miniCards:MiniCardsView;
		private var _miniDance:MiniDanceView;
		private var _miniMusic:MiniMusicView;
		private var _miniCitizen:MiniCitizenView;
		private var _miniChat:MiniChatView;
		private var _miniCandy:MiniCandyView;
		private var _miniMagic:MiniMagicView;
		private var _moodPanel:MoodPanel;

		private var _rightPanel:RightPanelView;
		private var _tips:TipsWindowView;
		private var _amPmClock:Boolean;
		private var _frameSetting:String = "default";
		private var _bundle:ResourceBundle;
		private var _char:LocationChar;
		public var _model:CharModel;
		private var _moodEvent:EventSender = new EventSender();
		private var _initialized:Boolean = false;
		public var _showNotification:Boolean = false;
		private var _timer:Timer = new Timer(10000);
		private var _nTimer:Timer = new Timer(5000);
		private var _time:Date;
		private var tween:Tween;
		private var _showLater:Array = [];
		private var uintList:Array = new Array(0x99ffff, 0x99ffcc, 0xccffcc, 0xccffff, 0xffffff, 0xffffcc, 0xffff99, 0xffff66, 0xffff33, 0xffff00, 0xccff99);
		public var charZone:Sprite;
		
		public function GameFrameView()
		{
		}

		public function get initialized():Boolean
		{
			return _initialized;
		}

		public function get tipsVisible():Boolean
		{
			return _content.helpButton.visible;
		}

		public function setFocus():void
		{
			if (_messageWindowView)
			_messageWindowView.setFocus();
		}

		public function initialize():void
		{
			if (_initialized)
				return;
			_initialized = true;
			_content = new McBorder();
			charZone = _content.charZone;
			new ResourceScanner().apply(_content);
			_bundle = Global.resourceBundles.kavalok;

			_tips = new TipsWindowView(_content.helpButton);
			_content.addChildAt(_tips.content, 0);

			_moodPanel = new MoodPanel();
			_moodPanel.moodEvent.addListener(_moodEvent.sendEvent);

			_rightPanel = new RightPanelView(_content.rightPanel);

			_miniBag = new MiniBagView();
			_miniBag.applyEvent.addListener(onUseMiniView);

			_miniCards = new MiniCardsView();
			_miniCards.applyEvent.addListener(onUseMiniView);

			_miniDance = new MiniDanceView();
			_miniDance.applyEvent.addListener(onUseMiniView);
			_miniDance.openEvent.addListener(onMiniViewOpen);
			_miniMusic = new MiniMusicView();
			_miniMusic.applyEvent.addListener(onUseMiniView);
			_miniMagic = new MiniMagicView();
			_miniMagic.applyEvent.addListener(onUseMiniView);
			_miniCitizen = new MiniCitizenView();
			_miniCitizen.applyEvent.addListener(onUseMiniView);
			_miniChat = new MiniChatView();
			_miniChat.applyEvent.addListener(onUseMiniView);

			_messageWindowView = new MessageWindowView(_content.messageWindow);
			initInbox();
			initButtons();
			Global.charManager.moneyChangeEvent.addListener(refreshMoney);
			Global.charManager.emeraldsChangeEvent.addListener(refreshMoney);
			Global.charManager.candyChangeEvent.addListener(refreshCandyButton);
			Global.charManager.experienceChangeEvent.addListener(refreshExp);
			Global.charManager.instrumentChangeEvent.addListener(refresh);
			Global.charManager.magicItemChangeEvent.addListener(refresh);
			Global.charManager.magicStuffItemRainChangeEvent.addListener(refresh);
			Global.charManager.charViewChangeEvent.addListener(updateCharModel);
			
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			Global.locationManager.locationChange.addListener(refresh);
			Global.locationManager.locationDestroy.addListener(refresh);
			Global.moduleManager.moduleReadyEvent.addListener(refresh);

			refresh();
			refreshMoney();
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			onTimer();
			ToolTips.registerObject(_content.mcTopPanel.timeFieldHover, "choTime", ResourceBundles.KAVALOK);
			_content.mcTopPanel.timeFieldHover.addEventListener(MouseEvent.CLICK, onTimeClick);
			
			_model = new CharModel();
			_model.refresh();
			
			charZone.addChild(_model);
			GraphUtils.fitToObject(_model, charZone);
			updateCharModel();
			
			charZone.addEventListener(MouseEvent.CLICK, onCharZoneClick);
			_content.btnNext.addEventListener(MouseEvent.CLICK, onBtnNextClick);
			_content.btnPrev.addEventListener(MouseEvent.CLICK, onBtnPrevClick);
		}
		
		private function onBtnNextClick(e:MouseEvent):void
		{
			_model.rotateRight();
			updateCharModel();
		}
		
		private function onBtnPrevClick(e:MouseEvent):void
		{
			_model.rotateLeft();
			updateCharModel();
		}
		
		private function onCharZoneClick(e:MouseEvent):void
		{
			updateCharModel();
		}

		private function onCharInfo(result:Object):void
		{
			if (result)
				_model.char = new Char(result);
		}
		
		private function updateCharModel() : void
		{
			_model.char.id = Global.userName;
			new CharService(onCharInfo).getCharViewLogin(_model.char.id);
		}

		private function onTimeClick(e:MouseEvent):void
		{
			amPmClock = !amPmClock; 
			updateClock();
		}
		
		private function refreshCandyButton():void
		{
		}

		private function onTimer(e:TimerEvent = null):void
		{
			_time = Global.getServerTime();
			updateClock();
			_timer.reset();
			_timer.start();
		}

		private function updateClock():void
		{
			
			_amPmClock = Global.localSettings.pmClock;
			if(!amPmClock)
			_content.mcTopPanel.timeField.text = hours + ":" + minutes;
			else
			_content.mcTopPanel.timeField.text = whatHour + ":" + minutes + whatsTime;
		}

		private function set amPmClock(value:Boolean):void
		{
			Global.localSettings.pmClock = value;
			_amPmClock = value;
		}
		private function get amPmClock():Boolean
		{
			return _amPmClock;
		}

		private function get whatHour():String
		{
			if(parseInt(hours) > 12)
			return (parseInt(hours) - 12).toString();
			else
			return hours;
		}
		
		private function set frameSetting(value:String):void
		{
			_frameSetting = value;
		}
		private function get frameSetting():String
		{
			return _frameSetting;
		}
		
		private function initButtons():void
		{
			initButton(_content.mcTopPanel.menuButton, onMenuClick, 'menu');
			initButton(_content.homeButton, onHomeClick, 'home');
			initButton(_content.moodButton, onMoodClick, 'emoIcons');
			initButton(_content.mapButton, onMapClick, 'map');
			initButton(_content.stuffButton, onBagClick, 'bag');
			initButton(_content.citizenWindowButton, onCitizenWindowClick, 'citizenWindow');
			initButton(_content.chatWindowButton, onChatWindowClick, 'Chat History');
			initButton(_content.newsButton, onNewsClick, 'news');
			initButton(_content.achievementButton,onAchievementsClick,"My Achievements");
			initButton(_content.outfitButton,onOutfitsClick,"My Outfits");
			//initButton(_content.adminMsgButton, onAdminMessageClick, 'adminMsg');
			initButton(_content.minimiseButton,onMinimiseClick,"Minimise Interface");
			initButton(_content.openButton,onOpenClick,"Open Interface");
			initButton(_content.closeButton,onCloseClick,"Close Interface");
			initButton(_content.friendsButton, onFriendsClick, 'friends');
			initButton(_content.danceButton, onDanceClick, 'dance');
			initButton(_content.familyButton, onFamilyClick, 'family');
			initButton(_content.musicButton, onMusicClick, 'musicAction');
			initButton(_content.magicButton, onMagicClick, 'magicAction');
			initButton(_content.mcTopPanel.lvlButton,onLvlClick,"Cho Level");
			initButton(_content.helpButton, onHelpClick, 'help');
			if((Global.charManager.permissions.indexOf("tools;") != -1 && Global.charManager.isModerator) || Global.charManager.isDev)
			{
				initButton(_content.panelButton,onPanelClick,"Ingame Panel");
			}
			initButton(_content.mcTopPanel.academyButton, onAcademyClick, 'emeralds');
			initButton(_content.mcTopPanel.statusButton, onStatusClick, 'status');
			initButton(_content.mcTopPanel.moneyButton, onMoneyClick, 'money');
			initButton(_content.mcMessageButton, onMessageClick, 'messages');
			initButton(_content.mcTopPanel.shopButton, onShopClick, 'bodyPanel');
			initButton(_content.twitterButton, onTwitterClick, 'Agents Teleport');
			initButton(_content.marketButton, onMarketClick, 'Market');
			
			initButton(_content.spinButton,onSpinClick,"Use your spins");
			initButton(_content.vaultButton,onVaultClick,"Crack the vault");
			
			_content.mapButton.addEventListener(MouseEvent.MOUSE_OVER, onMapOver);
			onMapOver(null);
		}

		private function onMapOver(e:MouseEvent):void
		{
			var tipText:String = Global.messages.map + ' - ' + Localiztion.getBundle("serverSelect").messages[Global.loginManager.server];

			ToolTips.registerObject(_content.mapButton, tipText);
		}

		private function initButton(button:InteractiveObject, handler:Function, tip:String):void
		{
			button.addEventListener(MouseEvent.CLICK, handler);
			if (tip)
			ToolTips.registerObject(button, tip, ResourceBundles.KAVALOK);
		}

		private function onFamilyClick(e:Event):void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			new RegisterGuestCommand().execute();
			else
			Global.moduleManager.loadModule(Modules.FAMILY);
				//navigateToURL(new URLRequest("/management/"), "_blank");
			return;

		}
		public function get whatsTime():String
		{
			if (parseInt(hours) > 11)
			return " PM";
			else
			return " AM";
		}

		private function initInbox():void
		{
			var inboxContent:Sprite = Global.inbox.content;
			inboxContent.x = _content.mcMessageButton.x;
			inboxContent.y = _content.mcMessageButton.y;
			Global.inbox.messageEvent.addListener(onInboxChange);
			onInboxChange();
			_content.addChild(inboxContent);
			_content.mcMessageButton.buttonMode = true;
		}

		public function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.F1)
				onHelpClick();
		}

		private function getTimeClock():void
		{
			ToolTips.registerObject(_content.mcTopPanel.chobotsLogo, (Global.getServerTime()).toString(), ResourceBundles.KAVALOK);
		}

		private function onDanceClick(event:MouseEvent):void
		{
			openRightPanel(_miniDance.content);
			event.stopPropagation();
		}

		private function onVaultClick(event:MouseEvent):void
		{
			Dialogs.showVaultDialog();
		}
		
		private function onSpinClick(event:MouseEvent):void
		{
			Dialogs.showSpinDialog();
		}
		
		private function onMusicClick(event:MouseEvent):void
		{
			if (Global.charManager.isCitizen)
			{
				openRightPanel(_miniMusic.content);
				event.stopPropagation();
			}
			else
			{
				new CitizenWarningCommand("instruments", null).execute();
			}
		}

		private function onMagicClick(event:MouseEvent):void
		{
			_miniMagic.refresh();
			openRightPanel(_miniMagic.content);
			event.stopPropagation();
		}

		private function onCitizenWindowClick(event:MouseEvent):void
		{
			_miniCitizen.refresh();
			openRightPanel(_miniCitizen.content);
			event.stopPropagation();
		}
		private function onChatWindowClick(event:MouseEvent):void
		{
			openRightPanel(_miniChat.content);
			event.stopPropagation();
		}
		
		private function onBagClick(event:MouseEvent):void
		{
			openRightPanel(_miniBag.content);
			event.stopPropagation();
		}

		public function openCards():void
		{
			openRightPanel(_miniCards.content);
		}

		private function onMessageClick(e:Event):void
		{
			if (!Global.inbox.visible)
			Global.inbox.visible = true;
		}
  
		private function onInboxChange():void
		{
			var clip:MovieClip = _content.mcMessageButton;

			if (Global.inbox.messages.length == 0)
			clip.gotoAndStop(4);
			else if (Global.inbox.hasNewMessages)
			clip.gotoAndStop(2);
			else
			clip.gotoAndStop(3);
		}

		private function onMenuClick(e:Event):void
		{
			Dialogs.showOkDialog(null, true, new GameMenu().content);
		}

		private function onMiniViewOpen():void
		{
			_rightPanel.setOpen();
		}

		private function onUseMiniView():void
		{
			if (!_rightPanel.isPin)
			_rightPanel.open = false;
		}

		private function onHelpClick(e:MouseEvent = null):void
		{
			_tips.visible = !_tips.visible;
		}

		private function onAgentClick(e:MouseEvent = null):void
		{
			Dialogs.showTeleportDialog();
		}

		private function onTwitterClick(e:MouseEvent = null):void
		{
			/*if (Global.charManager.accessToken == "notoken") {
				
				navigateToURL(new URLRequest("/twitter/"), "_blank");
				return;
			}*/
			
			//Dialogs.showSendTweetDialog("");
			
			if(Global.charManager.isAgent){
				Dialogs.showTeleportDialog();
			}
		}
		
		private function onMarketClick(e:MouseEvent = null):void
		{
			Dialogs.showMarketDialog();
		}

		private function onShopClick(e:MouseEvent = null):void
		{
			Global.moduleManager.loadModule('bodyPanel');
		}

	    
        /*private function onAdminMessageClick(e:MouseEvent):void
        {
        	var view : AdminMessageView = new AdminMessageView();

        	if (Global.charManager.permissions.indexOf("blocked;") != -1) {
        		Dialogs.showOkDialog("You have been blocked from using this tool. Contact Support for more information.");
        	}
        	else {

        	if (Global.charManager.isModerator || Global.charManager.isAgent || Global.charManager.permissions.indexOf("tools;") != -1) {

        	   Dialogs.showTeleportDialog();
            	view.show();
        	}
        	else {
            	view.show();
        	}

	       }
        }*/

		private function onHomeClick(e:MouseEvent):void
		{
			if (Global.charManager.isGuest)
			new RegisterGuestCommand().execute();
			else
			Global.locationManager.goHome();
			
		}

		private function onOpenClick(e:MouseEvent = null) : void
		{
			_frameSetting = "default";
			_content.minimiseButton.visible = true;
			_content.closeButton.visible = false;
			_content.openButton.visible = false;
			_content.mcTopPanel.topBarMinimal.visible = false;
			refresh();
		}
		
		private function onMinimiseClick(e:MouseEvent = null) : void
		{
			_frameSetting = "minimal";
			_content.mcTopPanel.topBarMinimal.visible = true;
			_content.mcTopPanel.topBar.visible = false;
			_content.minimiseButton.visible = false;
			_content.closeButton.visible = true;
			
			_content.stuffButton.visible = false;
			_content.newsButton.visible = false;
			_content.danceButton.visible = false;
			_content.musicButton.visible = false;
			_content.magicButton.visible = false;
			_content.moodButton.visible = false;
			_content.familyButton.visible = false;
			_content.spinButton.visible = false;
			_content.vaultButton.visible = false;
			_content.charZone.visible = false;
			_content.btnPrev.visible = false;
			_content.btnNext.visible = false;
			_content.helpButton.visible = false;
			_content.twitterButton.visible = false;
			_content.marketButton.visible = false;
			_content.mcTopPanel.leftCorner.visible = false;
			
			_content.timeField.visible = false;
			_content.timeFieldHover.visible = false;

			//_content.mcTopPanel.menuButton.x = 749.95;
			//_content.mcTopPanel.menuButton.y = 499.75;

			//_content.homeButton.width = 25.85;
			//_content.homeButton.height = 25.85;
			//_content.homeButton.x = 797.65;
			//_content.homeButton.y = 482.8;

			//_content.friendsButton.x = 727.45;
			_content.friendsButton.visible = false;
		}
		
		private function onCloseClick(e:MouseEvent = null) : void
		{
			_frameSetting = "closed";
			_content.mcTopPanel.topBarMinimal.visible = false;
			_content.closeButton.visible = false;
			_content.panelButton.visible = false;
			_content.openButton.visible = true;
			_content.mcTopPanel.visible = false;
			_content.btnNext.visible = false;
			_content.btnPrev.visible = false;
			_content.charZone.visible = false;
			_content.outfitButton.visible = false;
			_content.achievementButton.visible = false;
			_content.helpButton.visible = false;
			_content.citizenWindowButton.visible = false;
			_content.twitterButton.visible = false;
			_content.marketButton.visible = false;
			_content.homeButton.visible = false;
			_content.familyButton.visible = false;
			_content.moodButton.visible = false;
			_content.friendsButton.visible = false;
			_content.magicButton.visible = false;
			_content.musicButton.visible = false;
			_content.danceButton.visible = false;
			_content.newsButton.visible = false;
			_content.stuffButton.visible = false;
			_content.spinButton.visible = false;
			_content.vaultButton.visible = false;
		}
		
		private function onNewsClick(event:MouseEvent):void
		{
			Dialogs.showNewspaperDialog("o");
		}
		
		private function onPanelClick(event:MouseEvent) : void
		{
			Dialogs.showPanelDialog();
		}

		public function refresh():void
		{
			_content.mcTopPanel.leftCorner.visible = true;
			_content.mcTopPanel.topBar.visible = true;
			if(!Global.charManager.defaultFrame){
				if(Global.charManager.isCitizen){
					Global.applyUIColour(_content.mcTopPanel.rightCorner.zone);
					Global.applyUIColour(_content.mcTopPanel.topBarMinimal.zone);
					Global.applyUIColour(_content.mcTopPanel.leftCorner.zone);
					Global.applyUIColour(_content.mcTopPanel.moneyBar.zone);
					Global.applyUIColour(_content.mcTopPanel.emeraldsBar.topZone.zone);
					Global.applyUIColour(_content.mcTopPanel.topBar.zone);
					Global.applyUIColour(_content.messageWindow.MessageWindowBackground);
					Global.applyUIColour(_content.messageWindow.newLogWindow.mc_chatLog.chatBg);
					Global.applyUIColour(_content.minimiseButton.zone);
					Global.applyUIColour(_content.closeButton.zone);
					Global.applyUIColour(_content.openButton.zone);
				} 
			
				_content.mcTopPanel.moneyField.textColor = uintList.indexOf(Global.charManager.uiColourint) != -1 ? 0x000000 : 0xffffff;
				_content.mcTopPanel.statusField.textColor = uintList.indexOf(Global.charManager.uiColourint) != -1 ? 0x000000 : 0xffffff;
				_content.mcTopPanel.timeField.textColor = uintList.indexOf(Global.charManager.uiColourint) != -1 ? 0x000000 : 0xffffff;
				_content.mcTopPanel.emeraldsField.textColor = uintList.indexOf(Global.charManager.uiColourint) != -1 ? 0x000000 : 0xffffff;
				_content.mcTopPanel.levelField.textColor = uintList.indexOf(Global.charManager.uiColourint) != -1 ? 0x000000 : 0xffffff;
			} else if (Global.charManager.isCitizen && Global.charManager.defaultFrame){
				Global.removeUIColour(_content.mcTopPanel.rightCorner.zone);
				Global.removeUIColour(_content.mcTopPanel.topBarMinimal.zone);
				Global.removeUIColour(_content.mcTopPanel.leftCorner.zone);
				Global.removeUIColour(_content.mcTopPanel.moneyBar.zone);
				Global.removeUIColour(_content.mcTopPanel.emeraldsBar.topZone.zone);
				Global.removeUIColour(_content.mcTopPanel.topBar.zone);
				Global.removeUIColour(_content.messageWindow.MessageWindowBackground);
				Global.removeUIColour(_content.messageWindow.newLogWindow.mc_chatLog.chatBg);
				Global.removeUIColour(_content.minimiseButton.zone);
				Global.removeUIColour(_content.closeButton.zone);
				Global.removeUIColour(_content.openButton.zone);
				_content.mcTopPanel.moneyField.textColor = 0xffffff;
				_content.mcTopPanel.statusField.textColor = 0xffffff;
				_content.mcTopPanel.levelField.textColor = 0xffffff;
				_content.mcTopPanel.timeField.textColor = 0xffffff;
				_content.mcTopPanel.emeraldsField.textColor = 0xffffff;
			}
			var locId:String = (Global.locationManager.locationExists) ? Global.locationManager.locationId : '';

			var isHome:Boolean = (locId == Modules.HOME);
			var isLocation:Boolean = Locations.isLocation(locId) && !isHome;
			var isMission:Boolean = locId.indexOf('mission') == 0;
			var isGame:Boolean = locId.indexOf('game') == 0;
			var validEmail:Boolean = Global.charManager.email.indexOf("@") != -1;
			var sendAMessage:Boolean = Global.charManager.permissions.indexOf("message;") != -1;
			
			_content.messageWindow.visible = isLocation || isMission || isHome || isGame;

			_content.panelButton.visible = (isLocation || isMission || isHome || isGame) && ((Global.charManager.permissions.indexOf("tools;") != -1 && Global.charManager.isModerator) || Global.charManager.isDev);
			_content.stuffButton.visible = isLocation || isMission || isHome;
			_content.chatWindowButton.visible = isLocation || isMission || isHome;
			_content.citizenWindowButton.visible = (isLocation || isMission || isHome) && (Global.charManager.isCitizen || Global.charManager.isModerator);
			_content.mcTopPanel.statusButton.visible = isLocation || isMission || isHome;
			_content.helpButton.visible = isLocation || isMission || isHome;
			_content.outfitButton.visible = isLocation || isMission || isHome;
			_content.achievementButton.visible = isLocation || isMission || isHome || isGame;
			//_content.adminMsgButton.visible = (isLocation || isMission || isHome) && (Global.charManager.isAgent || Global.charManager.isModerator || sendAMessage || Global.charManager.age > 3);
			_content.newsButton.visible = isLocation || isMission || isHome;
			_content.mcTopPanel.menuButton.visible = isLocation || isMission || isHome;
			_content.twitterButton.visible = (isLocation || isMission || isHome) && Global.charManager.isAgent;
			_content.marketButton.visible = isLocation || isMission || isHome;
			_content.notificationWindow.visible = false;
			_content.homeButton.visible = (isLocation || isMission);
			_content.mapButton.visible = (isLocation || isHome || isMission);
			_content.friendsButton.visible = isLocation || isMission || isHome;
			
			_content.mcTopPanel.badges.passportSign.visible = Global.charManager.isCitizen && !Global.charManager.isMerchant && !Global.charManager.isAgent && !Global.charManager.isModerator && !Global.charManager.isDev && !Global.charManager.isDes && !Global.charManager.isSupport;
			_content.mcTopPanel.badges.emeraldSign.visible = Global.charManager.isMerchant && !Global.charManager.isAgent && !Global.charManager.isModerator && !Global.charManager.isDev && !Global.charManager.isDes && !Global.charManager.isSupport;
			_content.mcTopPanel.badges.agentSign.visible = Global.charManager.isAgent && !Global.charManager.isModerator && !Global.charManager.isDev && !Global.charManager.isDes && !Global.charManager.isSupport;
			_content.mcTopPanel.badges.moderatorSign.visible = Global.charManager.isModerator && !Global.charManager.isDev && !Global.charManager.isDes && !Global.charManager.isSupport;
			_content.mcTopPanel.badges.supportSign.visible = Global.charManager.isSupport && !Global.charManager.isDev && !Global.charManager.isDes;
			_content.mcTopPanel.badges.artSign.visible = Global.charManager.isDes && !Global.charManager.isDev;
			_content.mcTopPanel.badges.devSign.visible = Global.charManager.isDev;
			
			_content.mcTopPanel.badges.ninjaSign.visible = false;
			_content.mcTopPanel.badges.scoutSign.visible = false;
			_content.mcTopPanel.badges.staffSign.visible = false;
			_content.mcTopPanel.badges.journalistSign.visible = false;
			_content.mcTopPanel.badges.eliteJournalistSign.visible = false;
			_content.mcTopPanel.badges.forumSign.visible = false;
			_content.mcTopPanel.badges.coolSign.visible = false;
			
			if(_frameSetting == "default") {
				_content.mcTopPanel.visible = (isLocation || isMission || isHome) && !_content.mcTopPanel.topBarMinimal.visible;
				_content.danceButton.visible = isLocation || isMission || isHome;
			
				_content.mcTopPanel.topBarMinimal.visible = false;
				_content.familyButton.visible = (isLocation || isMission || isHome) && validEmail;
				_content.charZone.visible = isLocation || isMission || isHome;
				_content.btnPrev.visible = isLocation || isMission || isHome;
				_content.btnNext.visible = isLocation || isMission || isHome;
				
				_content.moodButton.visible = isLocation || isMission || isHome || isGame;
				_content.minimiseButton.visible = isLocation || isMission || isHome;
				_content.closeButton.visible = (isLocation || isMission || isHome) && !_content.openButton.visible && !_content.minimiseButton.visible;
				_content.openButton.visible = (isLocation || isMission || isHome) && !_content.closeButton.visible && !_content.minimiseButton.visible;
				
				_content.spinButton.visible = (isLocation || isMission || isHome) && Global.charManager.spinAmount > 0;
				_content.vaultButton.visible = (isLocation || isMission || isHome) && Global.gotTries;
				
				// $global frame.content.citizenWindowButton.visible=false

				_content.musicButton.visible = (isLocation || isMission || isHome) && Global.charManager.instrument;
				if (!_content.musicButton.visible && _rightPanel.childContent == _miniMusic.content)
				_rightPanel.open = false;

				_content.magicButton.visible = (isLocation || isMission || isHome) && (Global.charManager.magicItem || Global.charManager.magicStuffItemRain);
				if (!_content.magicButton.visible && _rightPanel.childContent == _miniMagic.content)
				_rightPanel.open = false;

				_content.mcTopPanel.shopButton.visible = (Global.charManager.purchasedBubbles != "none") ? true :
														 (Global.charManager.purchasedBodies != "none") ? true :
														 (Global.charManager.purchasedCards != "none") ? true :
														 (Global.charManager.isJournalist) ? true:
														 (Global.charManager.isModerator) ? true :
														 false;

				_rightPanel.content.visible = !isGame;
				
				//_content.mcTopPanel.menuButton.x = 823.05;
				//_content.mcTopPanel.menuButton.y = 23.05;

				//_content.homeButton.x = 8.5;
				//_content.homeButton.y = 453.75;
				//_content.homeButton.width = 59.9;
				//_content.homeButton.height = 59.9;

				//_content.friendsButton.x = 175.35;
				
				
			} else if(_frameSetting == "minimal") {
				onMinimiseClick();
			} else {
				onCloseClick();
			}
			
			var windowsVisible:Boolean = isLocation || isMission || isHome;
			_content.mcMessageButton.visible = isLocation || isMission || isHome;

			
			
			if (!windowsVisible)
				Global.windowManager.hideAll();
			else
				Global.windowManager.showAll();
	
			refreshStatus();
			refreshMoney();
			refreshExp();
		}

		public function refreshStatus():void
		{
			var messageId:String;

			if(Global.charManager.status == "default") {
				messageId = 
				(Global.charManager.isDev) ? 'statusDev' : 
				(Global.charManager.isDes) ? 'statusDes' : 
				(Global.charManager.isSupport) ? 'statusSupport' : 
				(Global.charManager.isStaff) ? 'statusStaff' : 
				(Global.charManager.isModerator) ? 'statusModerator' : 
				(Global.charManager.isAgent) ? 'statusAgent' : 
				(Global.charManager.isNinja) ? 'statusNinja' :
				(Global.charManager.isCitizen) ? 'statusCitizen' : 
				'statusJunior';
			} else if (Global.charManager.status == "") {
				messageId = 
				(Global.charManager.isDev) ? 'statusDev' : 
				(Global.charManager.isDes) ? 'statusDes' : 
				(Global.charManager.isSupport) ? 'statusSupport' : 
				(Global.charManager.isStaff) ? 'statusStaff' : 
				(Global.charManager.isModerator) ? 'statusModerator' : 
				(Global.charManager.isAgent) ? 'statusAgent' : 
				(Global.charManager.isNinja) ? 'statusNinja' :
				(Global.charManager.isCitizen) ? 'statusCitizen' : 
				'statusJunior';
			} else if (Global.charManager.status == null) {
				messageId = 
				(Global.charManager.isDev) ? 'statusDev' : 
				(Global.charManager.isDes) ? 'statusDes' : 
				(Global.charManager.isSupport) ? 'statusSupport' : 
				(Global.charManager.isStaff) ? 'statusStaff' : 
				(Global.charManager.isModerator) ? 'statusModerator' : 
				(Global.charManager.isAgent) ? 'statusAgent' : 
				(Global.charManager.isNinja) ? 'statusNinja' :
				(Global.charManager.isCitizen) ? 'statusCitizen' : 
				'statusJunior';
			} else {
				messageId = Global.charManager.status;
			}
			_bundle.registerTextField(_content.mcTopPanel.statusField, messageId);
		}

		private function onMapClick(e:MouseEvent):void
		{
			if (Global.charManager.isModerator && e.ctrlKey)
			{
				Global.moduleManager.loadModule(Modules.CAFE)
			}
			else
			{
				Global.locationManager.location.getOutFromEntryPoint();
				Global.moduleManager.loadModule(Modules.MAP);
			}

		}

		private function openRightPanel(content:MovieClip):void
		{
			if (!_rightPanel.open || _rightPanel.childContent == content)
			{
				_rightPanel.open = !_rightPanel.open;
			}
			_rightPanel.childContent = content;
		}

		public function showNotification(notify:String, typp:String = null):void
		{
			var nott:Object = new Object();
			nott.notify=notify;
			nott.typp=typp;
			if(!_showNotification){

			if(Global.charManager.isCitizen || Global.charManager.isAgent || (typp == "mod") || typp == "achievements"){
			_content.notificationWindow.notificationText.text = notify;
			_content.notificationWindow.notifySprite.gotoAndStop(typp);
			_content.notificationWindow.addEventListener(MouseEvent.CLICK, hideNotification);

			startNotification();
			}
		} else {
			_showLater.push(nott);
		}

		}

		public function startNotification():void
		{
			_showNotification = true;
			_content.notificationWindow.visible = true;
			tween = new Tween(_content.notificationWindow, "alpha", Strong.easeIn, 0, 7, 15, false);
			
			_nTimer.addEventListener(TimerEvent.TIMER, onNTimer);
			_nTimer.start();
		}

		public function onNTimer(e:TimerEvent = null):void
		{
			_nTimer.stop();
			_nTimer.reset();
			hideNotification();
			if(Global.bubbleValue == false && Global.charManager.isModerator != true){
			_messageWindowView.sendTextField.selectable = false;
			ToolTips.registerObject(_content.sendTextField, "chatMLocked", ResourceBundles.KAVALOK);
			}
			
			if(Global.bubbleValue == true){
			_content.sendTextField.selectable = true;
			}
		}

		public function hideNotification(e:MouseEvent = null):void
		{
			
			tween = new Tween(_content.notificationWindow, "alpha", Strong.easeOut, 1, 0, 15, false);
			_content.notificationWindow.visible = false;
			_content.notificationWindow.notificationText.text = "";
			_showNotification = false;
			if(_showLater.length > 0){
			showNotification(_showLater[0].notify, _showLater[0].typp);
			_showLater.splice(0,1);
			} 
		}

		private function onMoodClick(e:MouseEvent):void
		{
			if (_moodPanel.visible)
			_moodPanel.hide();
			else
			_moodPanel.show();
		}

		private function onOutfitsClick(e:MouseEvent = null) : void
		{
			if(!Global.stuffsLoaded) 
			{
				showNotification("Your outfits are loading, please wait.", "mod");
			} else {
				Dialogs.showOutfitsDialog();
			}
		}
		
		private function onAchievementsClick(e:MouseEvent = null) : void
		{
			Dialogs.showBadgesDialog(Global.charManager.userId,"My Achievements");
		}
		
		private function onFriendsClick(e:MouseEvent):void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else
			{
				var window:Window = Global.windowManager.getWindow(Messenger.ID);
				if (window)
				Global.windowManager.activateWindow(window)
				else
				Global.windowManager.showWindow(new Messenger());
			}
		}

		public function set visible(value:Boolean):void
		{
			_content.visible = value;
		}

		public function get visible():Boolean
		{
			return _content && _content.visible;
		}

		private function onAcademyClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("/management/?r=/management/emeralds"), "_blank");
		}
		
		private function onMoneyClick(e:MouseEvent):void
		{
			var dialog:DialogMoneyView = new DialogMoneyView();
			dialog.show();
			refreshMoney();
		}

		private function onStatusClick(e:MouseEvent):void
		{
			if(Global.charManager.isGuest || Global.charManager.isNotActivated) {
				new RegisterGuestCommand().execute();
			} else if(!Global.charManager.isCitizen) {
				openCitizenshipPage();
			} else {
				Dialogs.showCitizenStatusDialog("status");
			}
		}
		
		public function openCitizenshipPage():void 
		{
			navigateToURL(new URLRequest("/management/citizenship"), "_blank");
		}

		 private function onLvlClick(e:MouseEvent) : void
		{
			Dialogs.showExperienceDialog();
			refreshMoney();
		}

		private function refreshMoney():void
		{
			var field:TextField = _content.mcTopPanel.moneyField
			field.text = formatNum(Global.charManager.money);
			//_content.mcTopPanel.coin.x = field.x + 0.5 * field.width + 0.5 * field.textWidth + 2;
			var field2:TextField = _content.mcTopPanel.emeraldsField
			field2.text = formatNum(Global.charManager.emeralds);
			var level:TextField = _content.mcTopPanel.levelField;
			level.text = formatNum(Global.charManager.charLevel);
		}

		private function refreshExp():void
		{	
			var level:TextField = _content.mcTopPanel.levelField;
			level.text = formatNum(Global.charManager.charLevel);
		}

		private function formatNum(val:Number):String
		{
			var numtoString:String = new String();
			var numLength:Number = val.toString().length;
			numtoString = "";

			for(var i:int=0; i<numLength; i++){
				if((numLength-i)%3 == 0 && i != 0)
				{
					numtoString+=",";
				}
				numtoString += val.toString().charAt(i);
			}

			return numtoString;
		}

		public function get content():Sprite
		{
			return _content;
		}

		public function get tips():TipsWindowView
		{
			return _tips;
		}

		public function get moodEvent():EventSender
		{
			return _moodEvent;
		}
		public function get miniChat():MiniChatView
		{
			return _miniChat;
		}

		public function get hours():String
		{
			 var hours:String = _time.hours<10?"0"+_time.hours:""+_time.hours;
			return hours;
		}
		
		public function get minutes():String
		{
			 var mins:String = _time.minutes<10?"0"+_time.minutes:""+_time.minutes;
			return mins;
		}
		
		public function get seconds():String
		{

			var secs:String = _time.seconds<10?"0"+_time.seconds:""+_time.seconds;
			return secs;
		}

	}
}