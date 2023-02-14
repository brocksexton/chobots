package com.kavalok.gameplay.windows
{
	
	import com.kavalok.Global;
	import com.kavalok.McCharWindow;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharManager;
	import com.kavalok.char.CharModel;
	import com.kavalok.char.Stuffs;
	import com.kavalok.char.commands.CharCommandBase;
	import com.kavalok.char.commands.FriendRequest;
	import com.kavalok.char.commands.IgnoreCommand;
	import com.kavalok.char.commands.ModeratorPanel;
	import com.kavalok.char.commands.RemoveFriendCommand;
	import com.kavalok.char.commands.ReportCommand;
	import com.kavalok.char.commands.ShowRulesCommand;
	import com.kavalok.services.CharService;
	import com.kavalok.char.commands.TeleportRequest;
	import com.kavalok.char.commands.UnIgnoreCommand;
	import com.kavalok.commands.char.GetCharCommand;
	import com.kavalok.commands.location.GotoLocationCommand;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.controls.RectangleSprite;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.AdminService;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.ui.Window;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.NameRequirement;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.utils.Strings;

	import flash.external.ExternalInterface;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	
	import fl.transitions.Tween;
    import fl.transitions.TweenEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import fl.transitions.easing.Strong;
	
	
	public class CharWindowView extends Window
	{
		static private const SHOW_CHILD_FRAMES:uint = 5;
		static private const SMALL_MODEL_SCALE:Number = 0.28;
		static private const MODEL_SCALE:Number = 2.3;
		private static const REMOTE_ID_FORMAT : String = "trade|{0}|{1}";
		
		public var moodId:String = null;
		
		private var _char:Char;
		private var _charId:String;
		private var _content:McCharWindow;
		private var _bundle:ResourceBundle = Global.resourceBundles.kavalok;
		private var _playerCard:Sprite;
		private var menu:ContextMenu = new ContextMenu();
		
		private var _childViewSize:Point;
		private var _currentView:CharChildViewBase;
		private var _defaultChildViewHeight:int = 146;
		private var _defaultWindowHeight:int;
		
		private var _refreshIt:EventSender = new EventSender();
		private var _blackNames:Array = new Array("brock", "boo", "default", "lightcol", "light_show");
		
		private var tween:Tween;
		private var _tweenFinished:Boolean;
		
		private var _defaultPanelY:int;
		private var _loading:LoadingSprite;
		public static var charsURL:String = String("http://chobots.icu/profile/panel.php?u=");
		public static var journalistBlogURL:String = String("http://chobots.icu/journalist?u=");
		public static var twitterURL:String = String("http://twitter.com/");
		public static var marketURL:String = String("http://chobots.icu/market/outfit_search.php?userid=");
		
		McFaces;
		
		static public function getWindowId(charId:String):String
		{
			return 'char_' + charId;
		}
		public function get refreshIt():EventSender
		{
			return _refreshIt;
		}
		
		public function CharWindowView(charId:String)
		{
			_charId = charId;
			
			createContent();
			super(_content);
			_content.warnButton.visible = false;

			_defaultWindowHeight = _content.background.height;
			_defaultPanelY = _content.buttonsPanel.y;
			_childViewSize = new Point(_content.childView.width, _content.childView.height);
			
			GraphUtils.removeChildren(_content.childView);
		}
		
		public function createContent():void
		{
			_content = new McCharWindow();
			_loading = new LoadingSprite(_content.cardMask.getBounds(_content));
			_content.addChild(_loading);
			_content.background.gotoAndStop(1);
			
			if (!Global.startupInfo.widget)
			{
				_content.x = 25;
				_content.y = 25;
			}
			
			_content.nameField.text = _charId == "brock" ? "Brock S." : Global.upperCase(_charId); // Change brock to Brock S.
			
			if(_charId == "slenderman") // Turn slenderman's name off
			{
				_content.nameField.text = "";
			}
			else if(_charId == "tyler") //Rename the Ninja
			{
				_content.nameField.text = "A R T S I E";
			}
			
			
			_content.buttonsPanel.visible = false;
			_content.buttonsPanel.deBffButton.visible = false;
			_content.buttonsPanel.bffButton.visible = false;
			_content.cardMask.visible = false;
			_content.charContainer.visible = false;
			_content.onlineInfoField.visible = false;
			_content.refreshButton.visible = false;
			_content.locationField.visible = false;
			//	_content.refreshButton.addEventListener(MouseEvent.CLICK, onRefreshButtonClick);
			_tweenFinished = false;
		}
		
		private function onRefreshButtonClick(e:MouseEvent):void
		{
			//	refreshIt.sendEvent();
		}
		
		public function set char(char:Char):void
		{
			if (!_char)
			{
				Global.charManager.friends.refreshEvent.addListener(refresh);
				Global.charManager.ignores.refreshEvent.addListener(refresh);
				if (char.isUser)
					Global.charManager.playerCardChangeEvent.addListener(refreshPlayerCard);
				GraphUtils.detachFromDisplay(_loading);
			}
			
			_char = char;
			
			initContent();
			initStatus();
			if(!(_charId == "slenderman"))
				createModel();
			
			adjustHeight();
			refresh();
			initButtons();
			refreshPlayerCard();
			//trace("leID: " + _char.id);
			
			if (_char.team != "undefined")
				_content.background.gotoAndStop(_char.team);
			else 
				_content.background.gotoAndStop("chobot");
			
			_content.nameField.textColor = (_blackNames.indexOf(_char.team) != -1) ? 0x000000 : (_char.team == "space2") ? 0x306EFF : 0xFFFFFF;

		}
		
		private function badgeNumGot(result:String):void
		{
			
			if(!_char.isModerator){				
				if(result != "000")
					ToolTips.registerObject(_content.charContainer.agentSign, "Agent #" + result, "kavalok");
			}
		}
		
		/*override public function onClose():void
		{
			if (_char)
			{
				Global.charManager.friends.refreshEvent.removeListener(refresh);
				Global.charManager.ignores.refreshEvent.removeListener(refresh);
				if (_char.isUser)
					Global.charManager.playerCardChangeEvent.removeListener(refreshPlayerCard);
			}
		}*/
		
		override public function get windowId():String
		{
			return getWindowId(_charId);
		}
		
		override public function get dragArea():InteractiveObject
		{
			return _content.headerButton;
		}
		
		private function initContent():void
		{
			_content.localeClip.gotoAndStop(_char.locale);
			_content.localeClip.visible = !_char.isUser;
			
			_content.charContainer.ageField.text = Strings.substitute(Global.messages.charAge, isNaN(_char.age) ? '' : _char.age.toString());
			
			if(_charId == "brock")
				_content.charContainer.ageField.text = "An Old Chobot";
			
			if(_charId == "tyler")
				_content.charContainer.ageField.text = "An Old Chobot";
			
			if(_charId == "nathan")
				_content.charContainer.ageField.text = "Age 420";
			
			if (Global.startupInfo.widget == KavalokConstants.WIDGET_CHAR)
			{
				_content.buttonMode = true;
				_content.closeButton.visible = false;
				_content.warnButton.visible = false;
				_content.addEventListener(MouseEvent.CLICK, Global.openHomePage);
			}
			
			//var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			var item:ContextMenuItem = new ContextMenuItem("Copy Tracker Code");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyEmbed);
			menu.customItems.push(item);
			_content.contextMenu = menu;
			
			if(_charId == "slenderman")
				_content.charContainer.charPosition.visible = false;
		}
		
		private function refreshPlayerCard():void
		{
			if (_playerCard)
				GraphUtils.detachFromDisplay(_playerCard);
			
			_playerCard = new Sprite();
			_playerCard.x = _content.cardMask.x;
			_playerCard.y = _content.cardMask.y;
			_playerCard.scrollRect = new Rectangle(0, 0, _content.cardMask.width, _content.cardMask.height);
			GraphUtils.attachAfter(_playerCard, _content.background);
			
			var _card:StuffItemLightTO = _char.isUser ? Global.charManager.playerCard : _char.playerCard;
			
			if (_card)
			{
				var stuff:ResourceSprite = _card.createModel();
				stuff.useView = false;
				stuff.fitToBounds = false;
				stuff.loadContent();
				_playerCard.addChild(stuff);
			}
			
			if (_char.isUser && !Global.startupInfo.widget && !Global.charManager.isGuest)
			{
				var clickArea:SimpleButton = new SimpleButton();
				clickArea.addEventListener(MouseEvent.CLICK, onCardClick);
				clickArea.hitTestState = new RectangleSprite(_content.cardMask.width, _content.cardMask.height);
				_playerCard.addChild(clickArea);
			}
		}
		
		private function onCardClick(e:MouseEvent):void
		{
			Global.frame.openCards();
			e.stopPropagation();
		}
		
		private function onGetCHome(sender:GetCharCommand) : void
		{
			var params:Object = null;
			_char = sender.char;
			if(_char.userId > 1)
			{
				params = new Object();
				params.charId = _char.id;
				params.userId = _char.userId;
				new GotoLocationCommand("home",params).execute();
			}
			else
			{
				Dialogs.showOkDialog("That user does not exist!",true);
			}
		}
		
		private function copyEmbed(e:Event):void
		{
			var widgetWidth:int = 235;
			var widgetHeight:int = 308;
			var login:String = _char.id;
			
			//var pattern:String = '<object width="{0}" height="{1}">' + '<param name="FlashVars" value="login={3}&urlPrefix={4}">' + '<param name="movie" value="{2}"/>' + '<embed src="{2}" FlashVars="login={3}&urlPrefix={4}" width="{0}" height="{1}"/>' + '</embed></object>'
			var pattern:String = '<iframe src="https://chobots.icu/char/{0}" style="width:235px;height:308px;border:none;" scrolling="no"></iframe>';	


			var result:String = Strings.substitute(pattern, login);
			
			System.setClipboard(result);		
		}
		
		public function set onlineInfo(value:String):void
		{
			_content.onlineInfoField.text = value;
			_content.onlineInfoField.visible = true;
			//	_content.refreshButton.visible = true;
		}
		
		public function set locationInfo(value:String):void
		{
			_content.locationField.text = value;
			_content.locationField.visible = true;
		}
		private function initButtons():void
		{
			
			var modList:Boolean = Global.charManager.moderatorList.indexOf(Global.charManager.charId) != -1;
			var panel:ButtonsPanel = _content.buttonsPanel;
			//var levelTitles:LevelTitle = new LevelTitle();
			initButton(panel.chatButton, onChatClick, 'privateChat');
			initButton(panel.homeShareButton,onHomeShareClick,"Visit " + Global.upperCase(_charId) + "\'s home");
			//initButton(panel.giftButton, onGiftClick, 'present');
			//initButton(panel.badgesButton, onBadgesClick, _char.isUser ? 'My Badges' : _charId + "'s " + 'badges')
			initButton(panel.robotButton, onRobotClick, 'robot');
			initButton(panel.profileButton, onProfileClick, 'profile');
			initButton(_content.powers.underlayer.tradeButton, onTradePClick, 'Trade');
			initButton(_content.powers.underlayer.giftButton, onGiftPClick, 'Gift');
			//initButton(panel.tradeButton, onTradeClick, 'trade');
			initButton(panel.marketButton, onMarketClick, Global.upperCase(_charId) + "'s Auctions")
			//initButton(panel.profileSelfButton, onProfileClick, 'myProfile');
			//initButton(_content.charContainer.journalistSign, onJournalistClick, 'Journalist');
			//initButton(panel.badgeButton, onBadgesClick, 'Achievements');
			
			if (_char.twitterName != "noname"){
				initButton(panel.twitterButton, onTwitterClick, 'Twitter Profile');
				}	
				
				if(Global.charManager.isMerchant){
				initButton(panel.tradeGift, onTradeGiftClick, 'Trade or Gift');
				}else{
				initButton(panel.giftButton, onGiftClick, 'present');
				}
			
			initButton(panel.bffButton, onBffClick, "Get notified when\n" + Global.upperCase(_charId) + " comes online");
			initButton(panel.deBffButton, onDeBffClick, "Don't get notified when\n" + Global.upperCase(_charId) + " comes online");
			
			bindCommand(panel.addButton, FriendRequest, 'addFriend');
			bindCommand(panel.removeButton, RemoveFriendCommand, 'removeFriend');
			bindCommand(panel.teleportButton, TeleportRequest, 'inviteToPlace');
			bindCommand(panel.ignoreButton, IgnoreCommand, 'ignoreUser');
			bindCommand(panel.unignoreButton, UnIgnoreCommand, 'unIgnoreUser');
			if(!Global.startupInfo.widget){
				
				if ((modList || Global.charManager.hasTools) && Global.charManager.isCitizen)
				{bindMod(_content.warnButton, ModeratorPanel, 'Mod Tools');}
				else
				{bindCommand(_content.warnButton, ShowRulesCommand, 'warnUser');}
			}
			bindCommand(panel.reportButton, ReportCommand, 'reportUser');
			
		}
		
		private function sendWarning():void
		{
			new AdminService().sendAgentRules(_char.userId);
		}
		
		private function bindCommand(button:InteractiveObject, commandClass:Class, tip:String):void
		{
			var handler:Function = function():void
			{
				var command:CharCommandBase = new commandClass();
				command.char = _char;
				command.charId = _charId;
				command.execute();
			}
			
			initButton(button, handler, tip);
		}
		
		private function bindMod(button:InteractiveObject, commandClass:Class, tip:String):void
		{
			var handler:Function = function():void
			{
				var command:CharCommandBase = new commandClass();
				command.char = _char;
				command.charId = _charId;
				command.execute();
			}
			
			initButton(button, handler, tip);
		}

		private function onBffClick(e:MouseEvent):void
		{
			new CharService(onBffd).addBestFriend(_char.userId);
		//	new MessageService().sendCommand(_char.userId, new RemoveBFMessage());
		}

		private function onDeBffClick(e:MouseEvent):void
		{
			new CharService(onDeBffd).removeBestFriend(_char.userId);
		}


		private function onBffd(result:String):void
		{
		//	if(result == "success")
			//	Dialogs.showOkDialog(Global.upperCase(_charId) + " has been added to your watchlist.");
		//	else
		//		Dialogs.showOkDialog("There was an issue with adding " + Global.upperCase(_charId) + " to your watchlist.");
			
			refresh();
		}

		private function onDeBffd(result:String):void
		{
			//if(result == "success")
			//	Dialogs.showOkDialog(Global.upperCase(_charId) + " has been removed from your watchlist.");
			//else
			//	Dialogs.showOkDialog("There was an issue with removing " + Global.upperCase(_charId) + " from your watchlist.");
			
			refresh();
		}
		
		private function onPanelClick(e:MouseEvent):void
		{
			if(Global.charManager.isModerator)
				new AdminService(getPanelResult).openModeratorPanel();
			else if(Global.charManager.hasTools)
				Dialogs.showModeratorDialog();
			
			trace("initiating adminservice for moderator panel");
			//Dialogs.showModeratorDialog();
		}
		
		private function getPanelResult(result:String):void
		{
			if(!Global.startupInfo.widget){
				//	trace("panel result!! = " + result);
				if((Global.charManager.hasTools) || result)
					Dialogs.showModeratorDialog();
				else
					return;
			}
		}
		public function initStatus():void
		{
			var charContainer:CharContainer = _content.charContainer;
			
			/** PLAYER CARD */
			charContainer.visible = true;

			charContainer.agentSign.visible = _char.isAgent && !_char.isModerator;
			
			
			charContainer.staffSign.visible = false;
			charContainer.supportSign.visible = false;
			charContainer.devSign.visible = false;
			charContainer.artSign.visible = false;
			
			charContainer.moderatorSign.visible = _char.isModerator;
			charContainer.staffSign.visible = _char.isStaff;
			charContainer.supportSign.visible = _char.isSupport;
			charContainer.devSign.visible = _char.isDev;
			charContainer.artSign.visible = _char.isDes;
			
			charContainer.kingSign.visible = false;
			charContainer.coolSign.visible = false;
			charContainer.ninjaSign.visible = _char.isNinja && !_char.isModerator;
			charContainer.scoutSign.visible = _char.isScout;
			charContainer.emeraldSign.visible = _char.isMerchant;
			
			charContainer.journalistSign.visible = _char.isJournalist && !_char.isEliteJournalist;
			charContainer.eliteJournalistSign.visible = _char.isEliteJournalist;
			charContainer.forumSign.visible = _char.isForumer;
			
			
			charContainer.passportSign.visible = _char.isCitizen;
			charContainer.charStatusField.visible = _char.isCitizen;
			
			/*
			charContainer.statusField.visible = (_char.isAgent || _char.isModerator || _char.isDes || _char.isDev);
			//(_char.isStaff || _char.isAgent || _char.isNinja || _char.isDev || _char.isDes || _char.isSupport || _char.isModerator || _char.isScout);
			*/

			charContainer.statusField.visible = (_char.isAgent || _char.isModerator || _char.isDes || _char.isDev || _char.isStaff || _char.isAgent || _char.isNinja || _char.isDev || _char.isDes || _char.isSupport || _char.isModerator || _char.isScout);

			charContainer.moodField.visible = false;
			charContainer.levelSign.levelField.text = _char.charLevel;
			if(_char.isJournalist || _char.isEliteJournalist){
				charContainer.levelSign.y=157.65;
				charContainer.levelSign.x=157.15;
				charContainer.emeraldSign.x=172;
				charContainer.emeraldSign.y=130;
			}
			
			if(!Global.startupInfo.widget){
				ToolTips.registerObject(charContainer.forumSign, "Forum Legend");
				ToolTips.registerObject(charContainer.scoutSign, "Discord Booster");
				ToolTips.registerObject(charContainer.ninjaSign, "Ninja");
				//	ToolTips.registerObject(charContainer.levelSign, "ChoLevel " + _char.charLevel);
				ToolTips.registerObject(charContainer.journalistSign, "Journalist - " + _char.blogTitle);
				ToolTips.registerObject(charContainer.eliteJournalistSign, "Elite Journalist");
				//	ToolTips.registerObject(charCotainer.levelSign, "Level: ")
			}
			
			if (_char.charLevel < 4)
				charContainer.levelSign.starClip.gotoAndStop(1);
			else if (_char.charLevel < 8)
				charContainer.levelSign.starClip.gotoAndStop(2);
			else if (_char.charLevel < 12)
				charContainer.levelSign.starClip.gotoAndStop(3);
			else if (_char.charLevel < 16)
				charContainer.levelSign.starClip.gotoAndStop(4);
			else if (_char.charLevel < 20)
				charContainer.levelSign.starClip.gotoAndStop(5);
			else if (_char.charLevel < 24)
				charContainer.levelSign.starClip.gotoAndStop(8);
			else if (_char.charLevel < 28)
				charContainer.levelSign.starClip.gotoAndStop(9);
			else if (_char.charLevel < 32)
				charContainer.levelSign.starClip.gotoAndStop(10);
			else if (_char.charLevel < 36)
				charContainer.levelSign.starClip.gotoAndStop(11);
			else if (_char.charLevel < 40)
				charContainer.levelSign.starClip.gotoAndStop(12);
			else if (_char.charLevel < 44)
				charContainer.levelSign.starClip.gotoAndStop(13);
			else if (_char.charLevel < 48)
				charContainer.levelSign.starClip.gotoAndStop(14);
			else if (_char.charLevel < 52)
				charContainer.levelSign.starClip.gotoAndStop(16);
			else if (_char.charLevel < 56)
				charContainer.levelSign.starClip.gotoAndStop(17);
			else if (_char.charLevel < 60)
				charContainer.levelSign.starClip.gotoAndStop(18);
			else
				charContainer.levelSign.starClip.gotoAndStop(7);
			
			charContainer.levelSign.visible = false;
			
			if (_char.isModerator){
				charContainer.agentSign.visible = false;
			}

			if (_char.isStaff){
				charContainer.agentSign.visible = false;
				charContainer.moderatorSign.visible = false;
			}
			
			if (_char.isSupport){
				charContainer.agentSign.visible = false;
				charContainer.moderatorSign.visible = false;
				charContainer.staffSign.visible = false;
			}
			
			if (_char.isDes){
				charContainer.agentSign.visible = false;
				charContainer.moderatorSign.visible = false;
				charContainer.staffSign.visible = false;
				charContainer.supportSign.visible = false;
			}

			if(_char.isDev){
				charContainer.agentSign.visible = false;
				charContainer.moderatorSign.visible = false;
				charContainer.staffSign.visible = false;
				charContainer.supportSign.visible = false;
				charContainer.artSign.visible = false;
			}
			
			if(_char.isScout && _char.isForumer && !_char.isJournalist){
				charContainer.scoutSign.x=163.95;
				charContainer.scoutSign.y=165.85;
				charContainer.levelSign.x=189.60;
				charContainer.levelSign.y=159.65;

			} else if(_char.isScout && _char.isForumer && _char.isJournalist){
				charContainer.scoutSign.x=6;
				charContainer.scoutSign.y=120.35;
			}
			
			if (_char.isCitizen)
				_bundle.registerTextField(charContainer.charStatusField, 'statusCitizen');
			
			if (_char.status == "default") {doStatus();}
			else if (_char.status == null) {doStatus();}
			else if (_char.status == "") {doStatus();} 
			else {_bundle.registerTextField(charContainer.statusField, _char.status);}
			
			if(_char.isAgent)
				new AdminService(badgeNumGot).getBadgeNum(_char.userId);

			//if(isFriend)
		//	new CharService(gotFriendStatus).isBestFriend(_char.userId);

		}

		private function gotFriendStatus(result:Boolean):void
		{

			_content.buttonsPanel.deBffButton.visible = false;
			_content.buttonsPanel.bffButton.visible = false;

			if(Global.charManager.isCitizen){
			if(result)
			_content.buttonsPanel.deBffButton.visible = true;
			else
			_content.buttonsPanel.bffButton.visible = true;
		}
		}
		
		private function doStatus():void
		{
			var charContainer:CharContainer = _content.charContainer;
			//if (_charId == "Zach" || _charId == "Smoochict")
			//	_bundle.registerTextField(charContainer.statusField, 'statusKing');
			if (_char.isDev)
				_bundle.registerTextField(charContainer.statusField, 'statusDev');
			else if (_char.isDes)
				_bundle.registerTextField(charContainer.statusField, 'statusArt');
			else if (_char.isSupport)
				_bundle.registerTextField(charContainer.statusField, 'statusSupport');
			else if (_char.isStaff)
				_bundle.registerTextField(charContainer.statusField, 'statusStaff');
			else if (_char.isNinja)
				_bundle.registerTextField(charContainer.statusField, 'statusNinja');
			else if (_char.isModerator)
				_bundle.registerTextField(charContainer.statusField, 'statusModerator');
			else if (_char.isAgent)
				_bundle.registerTextField(charContainer.statusField, 'statusAgent');
			//else if (_char.isScout)
			//	_bundle.registerTextField(charContainer.statusField, 'statusScout');
		}
		private function createModel():void
		{
			var charMask:Sprite = GraphUtils.createRectSprite(_content.cardMask.width, _content.cardMask.height);
			charMask.x = _content.cardMask.x;
			charMask.y = _content.cardMask.y;
			_content.addChild(charMask);
			_content.charContainer.mask = charMask;
			
			var model:CharModel = new CharModel(_char);
			model.refresh();
			model.scale = MODEL_SCALE;
			_content.charContainer.charPosition.addChild(model);
			
			if (moodId)
			{
				var head:Sprite = model.head;
				var faceItems:Array = GraphUtils.getAllChildren(head, new NameRequirement('mcFace'));
				for each (var faceItem:DisplayObject in faceItems)
				{
					GraphUtils.detachFromDisplay(faceItem);
				}
				
				var faceClass:Class = Class(getDefinitionByName(moodId + 'Face'));
				var face:Sprite = new faceClass();
				face.removeChildAt(0);
				head.addChildAt(face, 1);
			}
			
		}
		
		public function refresh():void
		{
			var isIgnored:Boolean = Global.charManager.ignores.contains(_char.id);
			var canViewTwitter:Boolean = (Global.charManager.twitterName != "noname" && _char.twitterName != "noname");
			var canBeIgnored:Boolean = !_char.isModerator;
			var locationExists:Boolean = Global.locationManager.locationExists;
			var panel:ButtonsPanel = _content.buttonsPanel;
			var modList:Boolean = Global.charManager.moderatorList.indexOf(Global.charManager.charId) != -1;
			panel.visible = !Global.startupInfo.widget && !_char.isDev && !(_charId == "slenderman") && !(_charId == "brock");
			
			if(isFriend)
			new CharService(gotFriendStatus).isBestFriend(_char.userId);

			panel.homeShareButton.visible = !_char.isUser && isFriend;
			panel.chatButton.visible = !_char.isUser;
			panel.giftButton.visible = false; // No need for gifting :P !_char.isUser && Global.charManager.isModerator;
			panel.tradeGift.visible = !_char.isUser && Global.charManager.isCitizen && Global.charManager.isMerchant && _char.isCitizen;
			panel.badgesButton.visible = false;
			//panel.bffButton.visible = !_char.isUser && isFriend;
			panel.addButton.visible = !_char.isUser && !isFriend && !_char.isGuest;
			panel.removeButton.visible = !_char.isUser && isFriend;
			panel.reportButton.visible = !_char.isUser && !_char.isModerator;// && !_char.isStaff && !_char.isDev;
			//	panel.chatBanButton.visible = (Global.charManager.isModerator); //(Global.charManager.isModerator);
			panel.teleportButton.visible = !_char.isUser && !_char.isGuest;
			panel.ignoreButton.visible = !_char.isUser && !isFriend && !isIgnored && canBeIgnored && !_char.isModerator && (!Global.charManager.isAgent);
			panel.unignoreButton.visible = !_char.isUser && isIgnored;
			
			_content.powers.underlayer.tradeButton.visible = !_char.isUser && _char.isCitizen && Global.charManager.isMerchant && Global.charManager.isCitizen;
			_content.powers.underlayer.giftButton.visible = !_char.isUser && _char.isCitizen && Global.charManager.isMerchant && Global.charManager.isCitizen;
			
			panel.tradeButton.visible = false;
			//panel.tradeButton.visible = !_char.isUser && (charManager.charId  == "ethan" || charManager.charId == "zoo" ); //!_char.isUser && Global.charManager.isCitizen;
			
			panel.twitterButton.visible = canViewTwitter && !_char.isUser;
			panel.robotButton.visible = !_char.isUser && _char.hasRobot;
			//	panel.kickButton.visible = (Global.charManager.isModerator);
			
			_content.warnButton.visible = !_char.isUser && (Global.charManager.isAgent || Global.charManager.isModerator || Global.charManager.hasTools);
			panel.profileButton.visible = false; // !_char.isUser
			panel.profileSelfButton.visible = false; // _char.isUser
			panel.marketButton.visible = false; //!_char.isModerator;
			
			GraphUtils.setBtnEnabled(panel.addButton, acceptRequests);
			//GraphUtils.setBtnEnabled(panel.addButton, (acceptRequests) && !_char.isModerator); //Moderators cannot receive friend requests
			
			GraphUtils.setBtnEnabled(panel.chatButton, chatButtonEnabled && _char.isOnline);
			GraphUtils.setBtnEnabled(panel.giftButton, _char.isOnline && !(_currentView is GiftView) && acceptRequests);
			GraphUtils.setBtnEnabled(panel.homeShareButton,acceptRequests && _char.isOnline);
			GraphUtils.setBtnEnabled(panel.robotButton, !(_currentView is RobotView));
			
			//GraphUtils.setBtnEnabled(panel.giftButton, _char.isOnline && acceptRequests);
			GraphUtils.setBtnEnabled(panel.teleportButton, _char.isOnline && acceptRequests);
			GraphUtils.setBtnEnabled(panel.tradeGift, _char.isOnline && acceptRequests);
			
			if(_char.isModerator && (Global.charManager.isJournalist || Global.charManager.isEliteJournalist))
				GraphUtils.setBtnEnabled(panel.chatButton, true);
			
			if (!_char.isUser)
				panel.profileSelfButton.visible = false;
			
			GraphUtils.setBtnEnabled(panel.tradeButton, _char.server == Global.loginManager.server && acceptRequests);

		}
		
		public function get isFriend():Boolean
		{
			if(Global.charManager.friends != null && _char != null){
				return Global.charManager.friends.contains(_char.id);
			}
			
			return false;
			
		}
		
		public function get whatIsTitle():String
		{
			return null;
		}
		
		public function get acceptRequests():Boolean
		{
			if(_char != null){
				return _char.acceptRequests || isFriend || _char.isUser || Global.superUser || Global.charManager.isModerator;
			} else {
				return Global.superUser || Global.charManager.isModerator;
			}
			return false;
			
		}
		
		private function get chatButtonEnabled():Boolean
		{
			if(_char == null)
				return false;
			/*if(_char == null ){
			return !_char.isUser && _char.isOnline && !(_currentView is PrivateChatView);
			} else {*/
			trace(_char);
			return !_char.isUser && _char.isOnline && acceptRequests && !(_currentView is PrivateChatView);
			//}
			
		}
		
		/*public function onBadgesClick(e:MouseEvent):void
		{
			Dialogs.showBadgesDialog(_char.userId, "Char's Achievements");
		}*/
		
		public function showChat(force:Boolean = false):void
		{
			if (chatButtonEnabled || force && !(_currentView is PrivateChatView))
				showChildView(new PrivateChatView(_char.id, _char.userId));
		}
		
		override public function set alpha(value:Number):void
		{
			var items:Array = [_content.background, _content.childView, _content.buttonsPanel];
			for each (var object:DisplayObject in items)
			{
				object.alpha = value;
			}
		}
		
		private function onHomeShareClick(e:MouseEvent) : void
		{
			new GetCharCommand(_charId,0,onGetCHome).execute();
		}
		
		private function onChatClick(e:MouseEvent):void
		{
			showChat(false);
		}
		
		private function onJournalistClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(journalistBlogURL + _charId), "_blank");
		}
		
		private function onLevelClick(event:MouseEvent):void
		{
			return;
		}
		
		private function randomIntBT(min:int, max:int):int {
        return Math.round(Math.random() * (max - min) + min);
        }
		
		private function onTradeClick(event:MouseEvent):void
		{
			if(!Global.stuffsLoaded)
			{
				Dialogs.showOkDialog("Please wait a few moments for the game to finish loading before trading.", true);
				return;
			}
			
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else
			{
			    var rnd : int = randomIntBT(100, 500);
			    var rndT : int = randomIntBT(100, 500);
				var remoteId : String;
				remoteId = Strings.substitute(REMOTE_ID_FORMAT, Global.charManager.charId + rnd.toString(), _char.id + rndT.toString());
				Global.windowManager.closeWindow(this);
				TradeWindowView.showWindow(_char.id, _char.userId, true, remoteId);
			}
		}
		
		private function onTradeGiftClick(event:MouseEvent):void
		{
		
		if(!Global.stuffsLoaded)
			{
				Dialogs.showOkDialog("Please wait a few moments for the game to finish loading", true);
				return;
			}
			
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else
			{   
			    if(_tweenFinished == false){
				tween = new Tween(_content.powers, "alpha", Strong.easeIn, 0, 7, 15, false);
				_tweenFinished = true;
				}else{
				_tweenFinished = false;
		        tween = new Tween(_content.powers, "alpha", Strong.easeOut, 1, 0, 15, false);
				}
			}
		
		}
		
		private function onTradePClick(event:MouseEvent):void
		{
		   var rnd : int = randomIntBT(100, 500);
		   var rndT : int = randomIntBT(100, 500);
		   var remoteId : String;
		   remoteId = Strings.substitute(REMOTE_ID_FORMAT, Global.charManager.charId + rnd.toString(), _char.id + rndT.toString());
		   Global.windowManager.closeWindow(this);
		   _tweenFinished = false;
		   tween = new Tween(_content.powers, "alpha", Strong.easeOut, 1, 0, 15, false);
		   TradeWindowView.showWindow(_char.id, _char.userId, true, remoteId);
		}
		
		private function onGiftPClick(event:MouseEvent):void
		{
	      _tweenFinished = false;
		  tween = new Tween(_content.powers, "alpha", Strong.easeOut, 1, 0, 15, false);
		  showChildView(new GiftView(_char.id, _char.userId));
		}
		
		
		private function onMarketClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(marketURL + _char.userId), "_blank");
		}
		
		private function onGiftClick(event:MouseEvent):void
		{
			if(!Global.stuffsLoaded)
			{
				Dialogs.showOkDialog("Please wait a few moments for the game to finish loading before gifting.", true);
				return;
			}
			
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
				new RegisterGuestCommand().execute();
			else
				showChildView(new GiftView(_char.id, _char.userId));
		}
		
		private function onProfileClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(charsURL + _charId), "_blank");
			
		}
		
		private function onTwitterClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(twitterURL + _char.twitterName), "_blank");
			
		}
		
		private function onRobotClick(event:MouseEvent):void
		{
			showChildView(new RobotView(_char, acceptRequests));
		}
		
		private function showChildView(view:CharChildViewBase):void
		{
			if (_currentView == null)
			{
				if (Global.performanceManager.quality != 0)
				{
					var properties:Object = {scaleX: SMALL_MODEL_SCALE, scaleY: SMALL_MODEL_SCALE};
					new SpriteTweaner(_content.charContainer, properties, SHOW_CHILD_FRAMES, null, onTweenEnd);
					_content.childView.visible = false;
				}
				else
				{
					_content.charContainer.scaleX = SMALL_MODEL_SCALE;
					_content.charContainer.scaleY = SMALL_MODEL_SCALE;
				}
				_playerCard.visible = false;
			}
			else
			{
				_currentView.heightChanging.removeListener(onChildHeightChanging);
				_content.childView.removeChild(_currentView.content);
				_currentView.destroy();
			}
			_currentView = view;
			_currentView.heightChanging.addListener(onChildHeightChanging);
			_content.childView.addChild(_currentView.content);
			adjustHeight();
			GraphUtils.claimBounds(_content, KavalokConstants.SCREEN_RECT)
			_currentView.initialize();
			refresh();
		}
		
		private function onChildHeightChanging(newHeight:Number = NaN):void
		{
			adjustHeight(newHeight);
		}
		
		private function adjustHeight(newHeight:Number = NaN):void
		{
			var childHeight:int = isNaN(newHeight) ? _defaultChildViewHeight : newHeight;
			if(_content.background.getChildByName("background")) {
				_content.background.background.height = _defaultWindowHeight - _defaultChildViewHeight + childHeight;
			} else {
				_content.background.height = _defaultWindowHeight - _defaultChildViewHeight + childHeight;
			}
			_content.buttonsPanel.y = _defaultPanelY + childHeight - _defaultChildViewHeight;
			GraphUtils.claimBounds(_content, KavalokConstants.SCREEN_RECT);
		}
		
		private function onTweenEnd(sender:Object):void
		{
			_content.childView.visible = true;
		}
		
		private function get charManager():CharManager { return Global.charManager; }
		
	}
}