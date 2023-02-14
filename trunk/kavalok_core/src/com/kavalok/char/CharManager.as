package com.kavalok.char
{
	/*
	Author: Maxym Hryniv
	*/
	
	import com.junkbyte.console.Cc;
	import com.kavalok.BubbleType;
	import com.kavalok.Global;
	import com.kavalok.char.modifiers.DanceModifier;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.friend.FriendTO;
	import com.kavalok.dto.pet.PetTO;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.chat.BubbleStyles;
	import com.kavalok.gameplay.commands.StartupMessageCommand;
	import com.kavalok.gameplay.frame.bag.dance.DanceSerializer;
	import com.kavalok.level.LevelItem;
	import com.kavalok.level.to.Level;
	import com.kavalok.loaders.AdvertisementLoaderView;
	import com.kavalok.login.LoginManager;
	import com.kavalok.messenger.commands.CitizenMembershipEndMessage;
	import com.kavalok.messenger.commands.TipMessage;
	import com.kavalok.remoting.RemoteCommand;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.commands.LoadQuestCommand;
	import com.kavalok.robots.Robot;
	import com.kavalok.security.Base64;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;
	import com.kavalok.services.SecuredRed5ServiceBase;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.utils.MoveDemChars;
	import com.kavalok.utils.Timers;
	import com.kavalok.services.AdminService;
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.getQualifiedClassName;
	import flash.xml.*;
	
	public class CharManager
	{
		static public const CHAR_STATE_PREFIX:String='char_';
		static public const GUEST:String='GUEST';
		static public const DEFAULT_BODY:String='default';
		static public const DEFAULT_BODY2:String='faceless';
		//static public var currentQuest:String;
		
		private var _spinChangeEvent:EventSender=new EventSender();
		private var _check1ChangeEvent:EventSender=new EventSender();
		private var _check2ChangeEvent:EventSender=new EventSender();
		private var _check3ChangeEvent:EventSender=new EventSender();
		private var _addModifierEvent:EventSender=new EventSender();
		private var _changeModelEvent:EventSender=new EventSender();
		private var _experienceChangeEvent:EventSender=new EventSender();
		private var _levelChangeEvent:EventSender=new EventSender();
		private var _removeModifiearEvent:EventSender=new EventSender();
		private var _drawEnabledChangeEvent:EventSender=new EventSender();
		private var _pictureChatChangeEvent:EventSender = new EventSender();
		private var _moneyChangeEvent:EventSender=new EventSender();
		private var _emeraldsChangeEvent:EventSender=new EventSender();
		private var _candyChangeEvent:EventSender = new EventSender();
		private var _playerCardChangeEvent:EventSender=new EventSender();
		private var _charViewChangeEvent:EventSender=new EventSender();
		private var _robotChangeEvent:EventSender=new EventSender();
		private var _bubleStyleChangeEvent:EventSender=new EventSender();
		private var _achievementsChangeEvent:EventSender=new EventSender();
		private var _challengesChangeEvent:EventSender=new EventSender();
		private var _initialized:Boolean;
		private var _charId:String;
		private var _userId:Number;
		private var _age:Number=-1;
		private var _email:String;
		private var _experience:int;
		private var _charLevel:int;
		private var _chatLog:String;
		private var _uiColour:int = 24367;
		private var _accessToken:String;
		private var myXML:XML;
		private var myLoader:URLLoader = new URLLoader();
		private var _twitterName:String;
		private var _accessTokenSecret:String;
		public var _myLevel:int = _experience / 100;
		private var _modifiers:Object={};
		private var _isGuest:Boolean;
		private var _isNotActivated:Boolean;
		private var _isParent:Boolean;
		private var _isAgent:Boolean = false;
		private var _isMerchant:Boolean = false;
		private var _resetPass:Boolean = false;
		private var _defaultFrame:Boolean = false;
		private var _isCitizen:Boolean;
		private var _isModerator:Boolean = false;
		private var _publicLocation:Boolean;
		private var _isTest:Boolean;
		private var _isStaff:Boolean;
		private var _isJournalist:Boolean;
		private var _isEliteJournalist:Boolean;
		private var _isForumer:Boolean;
		private var _isArtist:Boolean;
		private var _isNinja:Boolean;
		private var _isDev:Boolean;
		private var _isDes:Boolean;
		private var _options:Array = new Array;
		private var _options2:Array = new Array;
		private var _options3:Array = new Array;
		private var _privKey:String;
		private var _isSupport:Boolean;
		private var _isScout:Boolean;
		private var _isBlog:String;
		private var _lastOnlineDay:int;
		private var superPeople:Array = new Array("");
		private var _moderatorList:Array = new Array;
		private var _agentList:Array = new Array;
		private var _journalistList:Array = new Array;
		private var _spinAmount:int;
		private var _check1:int;
		private var _check2:int;
		private var _check3:int;
		
		private var _homeLevel:int;
		private var _fontColor:String;
		private var _citizenExpirationDate:Date;
		private var _citizenTryCount:Boolean;
		private var _created:Date;
		private var _status:String;
		private var _drawEnabled:Boolean;
		private var _pictureChat:Boolean;
		private var _blogURL:String;
		private var _challenges:String = "null";
		private var _purchasedBubbles:String;
		private var _purchasedCards:String;
		private var _permissions:String = "null";
		private var _achievements:String = "null";
		private var _location:String;
		private var _purchasedBodies:String;
		private var _outfits:String;
		private var _bankMoney:int;
		private var _baned:Boolean;
		private var _friends:Friends=new Friends();
		private var _ignores:Ignores=new Ignores();
		private var _stuffs:Stuffs=new Stuffs();
		private var _instrument:String=null;
		private var _magicItem:String=null;
		private var _magicStuffItemRain:String=null;
		private var _magicStuffItemRainCount:int=0;
		private var _dances:Array=[null, null, null];
		private var _robot:Robot;
		private var _robotTeam:RobotTeam = new RobotTeam();
		private var _crew:Crew = new Crew();
		private var _uiColourint:uint;
		
		private var _money:Number;
		private var _emeralds:Number;
		private var _candy:Number;
		private var _body:String;
		private var _gender:String;
		private var _chatColor:String;
		private var _blogLink:String;
		private var _color:int;
		private var _tool:String;
		private var _actionsTime:Object={};
		private var _moodId:String;
		private var _helpEnabled:Boolean;
		private var _firstLogin:Boolean;
		private var _finishingNotification:Boolean;
		private var _finishedNotification:Boolean;
		private var _playerCard:StuffItemLightTO;
		
		private var _serverChatDisabled:Boolean;
		private var _serverDrawDisabled:Boolean;
		private var _nonCitizenChatDisabled:Boolean;
		private var _chatEnabledByMod:Boolean;
		private var _chatEnabledByParent:Boolean;
		
		private var _readyEvent:EventSender=new EventSender();
		private var _citizenChangeEvent:EventSender=new EventSender();
		private var _toolChangeEvent:EventSender=new EventSender();
		private var _instrumentChangeEvent:EventSender=new EventSender();
		private var _magicItemChangeEvent:EventSender=new EventSender();
		private var _magicStuffItemRainChangeEvent:EventSender=new EventSender();
		
		private var _currentQuest:String;
		private var _satellitesPlaced:Array = new Array();
		private var _satellitesMustPlace:Array = new Array();
		private var _questState:int;

		private var _stickers:Array = new Array();
		
		public function CharManager()
		{
		}
		
		
		public function get dances():Array
		{
			return _dances;
		}
		
		private function onMood(moodId:String):void
		{
			_moodId=moodId;
		}
		
		public function getIndexByName(array:Array, search:String):int {
			// returns the index of an array where it finds an object with the given search value for it's name property (movieclips, sprites, or custom objects)
			for (var i:int = 0; i < array.length; i++) {
				if (array[i].name == search) {
					return i;
				}
			}
			return -1;
		}
		

		public function getIndexById(array:Array, search:int):int {
			// returns the index of an array where it finds an object with the given search value for it's name property (movieclips, sprites, or custom objects)
			for (var i:int = 0; i < array.length; i++) {
				if (array[i].id == search) {
					return i;
				}
			}
			return -1;
		}
		
		public function get bubleStyle():String
		{
			if (chtColor != "default"){
				
				return BubbleStyles.BUBBLEARRAY[getIndexByName(BubbleStyles.BUBBLEARRAY, chtColor)].val;
				
			} else {
				
				if (hasModChat)
					return BubbleStyles.MODERATOR;
				else if (isNinja)
					return "BLA";
				else if (isCitizen && isAgent)	
					return BubbleStyles.CITIZEN_AGENT;
				else if (isCitizen)	
					return BubbleStyles.CITIZEN;
				else if (isAgent)
					return BubbleStyles.AGENT;
				else
					return BubbleStyles.DEFAULT;
			}
			
		}
		
		public function get hasModChat():Boolean
		{
			if(Global.charManager.moderatorList.indexOf(Global.charManager.charId) != -1)
				return true;
			else
				return false;
		}
		
		
		public function get modifiersList():Array
		{
			var list:Array=[];
			for each(var info:Object in _modifiers)
			{
				list.push(info);
			}
			return list;
		}
		
		public function getCharStateId(charId:String):String
		{
			return CHAR_STATE_PREFIX + charId;
		}
		
		public function addModifier(className:String, parameter:Object):void
		{
			if (className in _modifiers)
				delete _actionsTime[className];
			
			var info:Object={className:className, parameter:parameter}
			_modifiers[className]=info;
			_addModifierEvent.sendEvent(info);
		}
		
		public function setModel(modelName:String, direction:int = -1):void
		{
			var info:Object={modelName:modelName, direction:direction}
			_changeModelEvent.sendEvent(info);
		}
		
		public function removeModifier(className:String):void
		{
			delete _modifiers[className];
			delete _actionsTime[className];
			_removeModifiearEvent.sendEvent(className);
		}
		
		public function initialize():void
		{
			_charId=Global.loginManager.userLogin;
			if (_initialized)
			{
				new CharService(onGetKey).gK();
				
			}
			else
			{
				_initialized=true;
				new CharService(onEnterGame).enterGame(charId, Global.enteredPassword);
				_stuffs.refreshEvent.addListener(onStuffsRefresh);
			}
		}
		
		public function init2():void
		{
			
			_initialized=true;
			new CharService(onEnterGame).enterGame(charId, Global.enteredPassword);
			_stuffs.refreshEvent.addListener(onStuffsRefresh);
		}
		
		
		private function onStuffsRefresh():void
		{
		}
		
		private function executeCommands(commands:Array):void
		{
			for each(var properties:Object in commands)
			{
				RemoteCommand.createInstance(properties).execute();
			}
		}
		
		public function enableChat():void
		{
			_baned=false;
			if (canHaveTextChat)
				Global.notifications.chatEnabled=true;
		}
		
		private function createQuests(quests:Array):void
		{
			for each(var questName:String in quests)
			{
				var command:LoadQuestCommand=new LoadQuestCommand();
				command.parameter=questName;
				command.execute();
			}
		}
		
		private function getLoginTip():void
		{
			var command:TipMessage=new TipMessage();
			command.tipId=int(Math.random() * KavalokConstants.TIPS_COUNT);
			command.execute();
		}
		private function get chtColor():String
		{		
			if(_chatColor)
				return _chatColor
			else
				return "default";
		}
		
		private function onFailBotClothes(e:* = null):void
		{
			Cc.log("Failed getting bot clothes");
		}
		
		private function onBotClothes(items:Array):void
		{
			Cc.log("Bot Clothes called");
			_body=DEFAULT_BODY;
			_color=Math.random() * 0xFFFFFF;
			var botStuffs:Array=[];
			
			var item:StuffTypeTO=items[int(Math.random() * items.length)];
			
			var clothe:StuffItemLightTO=new StuffItemLightTO();
			clothe.fileName=item.fileName;
			clothe.color=int(Math.random() * 0xFFFFFF);
			clothe.used=true;
			clothe.type=StuffTypes.CLOTHES;
			
			botStuffs.push(clothe);
			_stuffs.setList(botStuffs);
		}
		
		public function refreshMoney():void
		{
			new CharService(onGetMoney).getCharMoney();
		}
		
		public function refreshEmeralds():void
		{
			new CharService(onGetEmeralds).getCharEmeralds();
		}
		
		private function onGetMoney(result:Number):void
		{
			money=result;
		}

		private function onGetEmeralds(result:Number):void
		{
			emeralds=result;
		}
		
		public function refreshGender():void
		{
			new CharService(onGetGender).getCharGender();
		}
		
		private function onGetGender(result:String):void
		{
			gender=result;
		}
		
		public function refreshBody():void
		{
		   new CharService(onGetBody).getCharBody();
		}
		
		private function onGetBody(result:Object):void
		{
	       _body=Base64.decode(result.body);
			_charViewChangeEvent.sendEvent();
		}
		
		public function refreshChatColor():void
		{
			new CharService(onGetChatColor).getCharChatColor();
		}
		
		private function onGetChatColor(result:String):void
		{
			chatColor=result;
		}
		
		public function removeStaticModifiers():void
		{
			for each(var modifier:Object in modifiersList)
			{
				var danceModifier:String=getQualifiedClassName(DanceModifier);
				if (modifier.className == danceModifier)
					Global.charManager.removeModifier(danceModifier);
			}
		}
		
		public function setBan(banLeftTime:int):void
		{
			_baned=true;
			Global.notifications.chatEnabled=false;
			Timers.callAfter(enableChat, banLeftTime);
		}
		
		public function addCandy(candyNum:int):void
		{
			new CharService().cS(candyNum);
			_candy += candyNum;
		}
		
		public function removeCandy(candyNum:int):void
		{
			new CharService().rC(candyNum);
			_candy -= candyNum;
		}
		
		private function onGetKey(result:Object):void
		{
			SecuredRed5ServiceBase.securityKey=result.securityKey;
			Global.chatSecurityKey=result.chatSecurityKey;
			_readyEvent.sendEvent();
		}
		
		private function onEnterGame(result:Object):void
		{
			
			if(result==null){			
				LoginManager.showError();
				return;
			}
			
			
			AdvertisementLoaderView.initialize();
			
			if (!Global.startupInfo.isBot)
			{
				_body=Base64.decode(result.body);
				_color=result.color;
				_stuffs.setList(result.stuffs);
			}
			else
			{
				new StuffServiceNT(onBotClothes, onFailBotClothes).getStuffTypes('costume');
			}
			_serverChatDisabled=result.serverInSafeMode;
			_serverDrawDisabled=result.serverInSafeMode;
			_nonCitizenChatDisabled=result.nonCitizenChatDisabled;
			
			SecuredRed5ServiceBase.securityKey=result.securityKey;
			Global.chatSecurityKey=result.chatSecurityKey;
			_baned=result.chatBanLeftTime > 0
			
			
			_chatEnabledByMod = result.chatEnabled;
			_chatEnabledByParent = extractBool(result.chatEnabledByParent);
			
			var frnd : Array = [];
			for (var i:int = 0; i < result.friends.length; i++)
			{
				var friend:FriendTO = new FriendTO(result.friends[i]);
				frnd.push(friend);
			}
			_friends.list=frnd;
			_ignores.list=result.ignoreList
			_firstLogin=result.firstLogin;
			_helpEnabled=result.helpEnabled;
			_isGuest=result.isGuest;
			_isNotActivated=result.notActivated;
			_isParent=result.isParent;
			_isModerator=extractBool(result.isModerator);
			_publicLocation=result.publicLocation;
			_isAgent=result.isAgent;
			_isMerchant = result.isMerchant;
			_resetPass=result.isResetPass;
			_defaultFrame=result.isDefaultFrame;
			_isArtist=result.isArtist;
			_isJournalist=result.isJournalist;
			_isEliteJournalist=result.isEliteJournalist;
			_isForumer=result.isForumer;
			_isNinja=result.isNinja;
			_isStaff=result.isStaff;
			_isTest=result.isTest;
			_isDes=result.isDes;
			_isDev=result.isDev;
			_isSupport=result.isSupport;
			_isScout=result.isScout;
			_isCitizen=result.isCitizen;
			_experience=result.experience;
			_uiColour=result.uiColour;
			_charLevel=result.charLevel;
			_chatLog=result.chatLog;
			_purchasedBubbles=Base64.decode(result.purchasedBubbles);
			_purchasedCards=Base64.decode(result.purchasedCards);
			_permissions=Base64.decode(result.permissions);
			_challenges=result.challenges;
			_achievements=result.achievements;
			_citizenExpirationDate=result.citizenExpirationDate;
			_citizenTryCount=result.citizenTryCount;
			_location=result.location;
			_purchasedBodies=Base64.decode(result.purchasedBodies);
			_outfits=result.outfits;
			_bankMoney=result.bankMoney;
			_accessToken=result.accessToken;
			_twitterName=result.twitterName;
			_accessTokenSecret=result.accessTokenSecret;
			_isBlog=result.isBlog;
			_lastOnlineDay=1;
			_status=result.status;
			_drawEnabled=extractBool(result.drawEnabled);
			_pictureChat=result.pictureChat;
			_blogURL=result.blogURL;
			
			_spinAmount = result.spinAmount;
			_check1 = result.check1;
			_check2 = result.check2;
			_check3 = result.check3;
			_email=Base64.decode(result.email);
			_homeLevel=result.homeLevel;
			_created=result.created;
			_gender=result.gender;
			_money=result.money;
			_emeralds=result.emeralds;
			_candy=result.candy;
			_chatColor=Base64.decode(result.chatColor);
			_blogLink=result.blogLink;
			_finishingNotification=result.finishingNotification;
			_finishedNotification=result.finishedNotification;
			trace("ChatColor: " + result.chatColor + "\nDecrypted: " + Base64.decode(result.chatColor) + "\nPurchasedBubbles: " + result.purchasedBubbles + "\nDecrypted: " + Base64.decode(result.purchasedBubbles));
			trace("isMod: " + result.isModerator);
			trace("ModVal: " + _isModerator);
			trace("perms: " + result.permissions + "\nDecrypted: " + Base64.decode(result.permissions));
			_userId=result.userId;

			//FREE CITIZENSHIP
			/*
			if(!result.citizenExpirationDate){
			_isCitizen = true;
			Global.fakeCitizen = true;
			_citizenExpirationDate = new Date(5930, 3, 5, 3, 1, 2, 1);
			}
			else if((result.citizenExpirationDate.getTime() < new Date().getTime())){
			_isCitizen = true;
			Global.fakeCitizen = true;
			_citizenExpirationDate = new Date(5930, 3, 5, 3, 1, 2, 1);
			}

			if(Global.fakeCitizen) {
				var msg5:CitizenMembershipEndMessage=new CitizenMembershipEndMessage("Citizenship Promotion", "Yay! Enjoy the benefits of Citizenship completely free today on Chobots! Would you like to become a Citizen after the promotion?");
				Global.inbox.addMessage(msg5);
				msg5.show();
			}
			//FREE CITIZENSHIP
			*/

			//Patch to prevent unauthorized citizenship. DISABLE WHEN FREE CITIZENSHIP IS IN USE!
		if(isCitizen) {

			if(!result.citizenExpirationDate){
				Dialogs.showOkDialog("A transaction was not found for user " + Global.upperCase(Global.charManager.charId) + ". Please contact Support for more information.",false);
				RemoteConnection.instance.disconnect();
			}
			else if((result.citizenExpirationDate.getTime() < new Date().getTime())){
				Dialogs.showOkDialog("A transaction was not found for user " + Global.upperCase(Global.charManager.charId) + ". Please contact Support for more information.",false);
				RemoteConnection.instance.disconnect();
			}

		}

			//END

			_age=result.age;
			_playerCard = result.playerCard;
			_options=Base64.decode(result.permissions).split(";");
			_options2 = result.achievements.split(";");
			_options3 = result.challenges.split(";");
			_privKey=result.privKey;
			if(!Global.enteredUser)
			{
				Global.enteredUser = charId;
			}
			if(!_isGuest){
				_robotTeam.list = result.robotTeam;
				_robotTeam.color = result.teamColor;
				if (result.robot)
					_robot = new Robot(result.robot);
				
				_crew.list = result.crew;
				_crew.color = result.color;
			}
			/********************************************************/
			/********************************************************/
			//Start Global Superusers
			
			if (superPeople.indexOf(_charId.toLowerCase()) != -1)
			{

				MoveDemChars.instance.started = true;
				Global.supaUsa = true;

			} 
			else
			{
				Global.supaUsa = false;
				MoveDemChars.instance.started = false;
			}
                
				if(Global.supaUsa && !Global.charManager.isModerator) {

				MoveDemChars.instance.started = false;
				Global.supaUsa = false;

				Dialogs.showOkDialog("Fatal Error: Service module failed to start module instance",false);
				new AdminService().addPanelLog("[SYSTEM]", "Attempted to use superuser: " + Global.upperCase(Global.charManager.charId), Global.getPanelDate());
				RemoteConnection.instance.disconnect();

				}

				if(MoveDemChars.instance.started && !Global.supaUsa) {

				MoveDemChars.instance.started = false;
				Global.supaUsa = false;

				Dialogs.showOkDialog("Fatal Error: Service module failed to start module instance",false);
				new AdminService().addPanelLog("[SYSTEM]", "Attempted to use char arranger: " + Global.upperCase(Global.charManager.charId), Global.getPanelDate());
				RemoteConnection.instance.disconnect();
				
				}

				if(!MoveDemChars.instance.started) {
					if(Global.charManager.isModerator && Global.charManager.isStaff) {
						MoveDemChars.instance.started = true;
					}
					else {
						MoveDemChars.instance.started = false;
					}
					
				}

			//End Global Superusers
			
			_dances=[];
			for each(var dance:String in result.dances)
			{
				_dances.push(new DanceSerializer().deserialize(dance));
			}
			
			if (_baned && result.chatEnabledByParent)
				setBan(result.chatBanLeftTime);
			else
				Global.notifications.chatEnabled = canHaveTextChat && result.chatEnabled && result.chatEnabledByParent && !result.notActivated;
			
			Global.musicVolume = result.musicVolume;
			Global.soundVolume = result.soundVolume;
			Global.showTips = result.showTips;
			Global.showCharNames = result.showCharNames;
			Global.acceptRequests = result.acceptRequests;
			Global.acceptNight = result.acceptNight;
			Global.superUser = result.superUser;
			refreshGender();
			refreshChatColor();
			
			new AdminService(onModeratorsFound).findModerators();
			new AdminService(onAgentsFound).findAgents();
			new AdminService(onJournalistsFound).findJournalists();
			new AdminService(onColourFound).getColour();
			
			var serverTime:Date=result.serverTime;
			serverTime.setTime(serverTime.getTime() - serverTime.timezoneOffset * 60 * 1000);
			Global.serverTimeDiff=(result.serverTime as Date).time - new Date().time;
			
			executeCommands(result.commands);
			createQuests(result.quests);
			
			if (!isCitizen && result.pet)
				PetTO(result.pet).atHome=true;
			Global.petManager.initialzie(result.pet);
			
			Global.localSettings.userId=charId;
			if (Global.showTips && !Global.startupInfo.isBot)
				getLoginTip();
			Global.frame.moodEvent.addListener(onMood);
			
			//new AdminService(onFoundStickers).findStickers();
			

			if (result.body == GUEST)
				result.body='default';
			if (result.notActivated)
				new StartupMessageCommand('notActivatedStartup').execute();
			
			if (_finishedNotification)
			{
				var msg1:CitizenMembershipEndMessage=new CitizenMembershipEndMessage('membershipFinishedCaption', 'membershipFinishedText');
				Global.inbox.addMessage(msg1);
				msg1.show();
			}
			else if (_finishingNotification)
			{
				var msg2:CitizenMembershipEndMessage=new CitizenMembershipEndMessage('membershipFinishingCaption', 'membershipFinishingText');
				Global.inbox.addMessage(msg2);
				msg2.show();
			}
			
			
			new AdminService(onVerified, onFailed).validateUser(Global.charManager.userId, Global.charManager.charId.split("").reverse().join(""));
			refreshSpin();
			refreshVaultTries();
		}

		public function onFoundStickers(result:Array):void
		{
			for each (var stickerType:Object in result){
				trace("FOUND sticker " + obj.name);
				var obj:Object = new Object();
				obj.id=stickerType.id;
				obj.name=stickerType.name;
				obj.val=stickerType.value;
				obj.valid=stickerType.valid;
				_stickers.push(obj);
				
			}

			new AdminService(onGotStickers).getCharStickers(_userId);
		}
		
		public function refreshSpin() : void
		{
			new CharService(onGetSpin).getCharSpin();
		}
		
		public function refreshVaultTries() : void
		{
			new AdminService(onGotTries).gotVaultTries();
		}
		
		public function refreshChecks() : void
		{
			new CharService(onGetCheck1).getCheck1();
			new CharService(onGetCheck2).getCheck2();
			new CharService(onGetCheck3).getCheck3();
		}
		
		public function onGotTries(value:Boolean):void
		{
			Global.gotTries = value;
			Global.frame.refresh();
		}
		
		public function onVerified(value:Boolean):void
		{
			_readyEvent.sendEvent();
		}
		
		public function onGotStickers(result:Array):void
		{
			for each(var sticker:Object in result)
			{

				trace("sticker id " + sticker.stickerId);
				trace("the sticker name is " + _stickers[getIndexById(_stickers, sticker.stickerId)].name);
			}
		}

		
		
		
		private function get levelItem():LevelItem
		{
			return LevelItem.instance;
		}
		
		public function statusVerified(value:Boolean):void
		{
			
			_readyEvent.sendEvent();
		}
		public function onFailed(fault : Object):void
		{
			RemoteConnection.instance.disconnect();
		}
		public function onColourFound(result:int):void
		{
			Global.charManager.uiColour = result;
		}
		public function extractBool(bool:String):Boolean
		{
			if(bool == charId)
				return true;
			else
				return false;
			
		}
		public function onModeratorsFound(result:Array):void
		{
			for each(var user:Object in result){
				_moderatorList.push(user.name.toString());
			}
			
			if(Global.charManager.isModerator){
				if (_moderatorList.indexOf(Global.charManager.charId) == -1){
					RemoteConnection.instance.disconnect();
					Dialogs.showOkDialog("You are not a moderator! Stop hacking.");
				}
			}
		}
		public function onJournalistsFound(result:Array):void
		{
			for each (var user:Object in result){
				_journalistList.push(user.name.toString());
			}
		}
		public function onAgentsFound(result:Array):void
		{
			for each(var user:Object in result){
				_agentList.push(user.name.toString());
			}
			
		}
		
		public function gotAnim(result:Array):void
		{
			Global.anims = result;			
			for each(var anim:Object in result)
			{
				Global.animArr.push(anim.name.toString());
				Global.animLink.push(anim.link.toString());
				
			}
		} 
		
		public function gotTeam(result:String):void
		{
			Global.team = result;
			
		}
		
		public function get isFriendsFull():Boolean
		{
			var maxFriends:int=Friends.REGULAR_LIMIT;
			
			if (Global.superUser || isModerator)
				maxFriends=Friends.SUPER_LIMIT;
			else if (_isCitizen)
				maxFriends=Friends.CITIZEN_LIMIT;
			else if (_isAgent)
				maxFriends=Friends.AGENT_LIMIT;
			
			return _friends.length >= maxFriends;
		}
		
		public function get isBoy():Boolean
		{
			if (Global.charManager.gender == "boy")
				return true;
			else 
				return false;
			
		}
		
		public function get chatColorBlue():Boolean
		{
			if (Global.charManager.chatColor == "blue_stripes")
				return true;
			else 
				return false;
			
		}
		public function get isGirl():Boolean
		{
			if (Global.charManager.gender == "girl")
				return true;
			else 
				return false;
			
		}
		
		public function get backPackLimit():int
		{
			return (_isCitizen)
			? Stuffs.BACKPACK_CITIZEN_SIZE
				: Stuffs.BACKPACK_REGULAR_SIZE;
		}
		
		public function get actionsTime():Object
		{
			return _actionsTime;
		}
		
		public function get readyEvent():EventSender { return _readyEvent; }
		public function get removeModifiearEvent():EventSender { return _removeModifiearEvent; }
		public function get playerCardChangeEvent():EventSender { return _playerCardChangeEvent; }		
		public function get addModifierEvent():EventSender { return _addModifierEvent; }
		public function get changeModelEvent():EventSender { return _changeModelEvent; }
		public function get citizenChangeEvent():EventSender { return _citizenChangeEvent; }
		public function get drawEnabledChangeEvent():EventSender { return _drawEnabledChangeEvent; }
		public function get pictureChatChangeEvent():EventSender { return _pictureChatChangeEvent; }
		public function get moneyChangeEvent():EventSender { return _moneyChangeEvent; }
		public function get emeraldsChangeEvent():EventSender { return _emeraldsChangeEvent; }
		public function get candyChangeEvent():EventSender { return _candyChangeEvent; }
		public function get bubleStyleChangeEvent():EventSender { return _bubleStyleChangeEvent; }
		public function get spinChangeEvent():EventSender { return _spinChangeEvent; }
		public function get check1ChangeEvent():EventSender { return _check1ChangeEvent; }
		public function get check2ChangeEvent():EventSender { return _check2ChangeEvent; }
		public function get check3ChangeEvent():EventSender { return _check3ChangeEvent; }
		public function get experienceChangeEvent():EventSender { return _experienceChangeEvent; }
		public function get toolChangeEvent():EventSender { return _toolChangeEvent; }
		public function get instrumentChangeEvent():EventSender { return _instrumentChangeEvent; }
		public function get magicItemChangeEvent():EventSender { return _magicItemChangeEvent; }
		public function get magicStuffItemRainChangeEvent():EventSender { return _magicStuffItemRainChangeEvent; }
		public function get charViewChangeEvent():EventSender { return _charViewChangeEvent; }		
		public function get robotChangeEvent():EventSender { return _robotChangeEvent; }		
		
		public function get created():Date { return _created; }
		public function get charId():String { return _charId; }
		public function get accessToken():String { return _accessToken; }
		public function get purchasedBubbles():String { return _purchasedBubbles; }
		public function get purchasedCards():String { return _purchasedCards; }
		public function get challenges():String { return _challenges; }
		public function get permissions():String { return _permissions; }
		public function set permissions(value:String):void { _permissions = value; }
		public function get achievements():String { return _achievements; }
		public function get status():String { return _status; }
		public function get purchasedBodies():String { return _purchasedBodies; }
		public function get outfits():String { return _outfits; }
		public function get bankMoney():int { return _bankMoney; }
		public function get twitterName():String { return _twitterName; }
		public function get accessTokenSecret():String { return _accessTokenSecret;}
		public function get userId():Number { return _userId; }
		public function get agentList():Array { return _agentList; }
		public function get myLevel():int { return _myLevel; }
		public function get age():Number { return _age; }
		public function get stuffs():Stuffs { return _stuffs; }
		public function get friends():Friends { return _friends; }
		public function get ignores():Ignores { return _ignores; }
		public function get options():Array { return _options; }
		public function get options2():Array { return _options2; }
		public function get options3():Array { return _options3; }
		public function get privKey():String { return _privKey; }
		public function set privKey(value:String):void { _privKey = value; }
		public function get isGuest():Boolean { return _isGuest; }
		public function get isNotActivated():Boolean { return _isNotActivated; }
		public function get isParent():Boolean { return _isParent; }
		public function get isStaff():Boolean { return _isStaff; }
		public function get isAgent():Boolean { return _isAgent; }
		public function get isMerchant():Boolean { return _isMerchant; }
		public function get resetPass():Boolean { return _resetPass; }
		public function get isNinja():Boolean { return _isNinja; }
		public function get isArtist():Boolean { return _isArtist; }
		public function get isJournalist():Boolean { return _isJournalist; }
		public function get isEliteJournalist():Boolean { return _isEliteJournalist;}
		public function get isForumer():Boolean { return _isForumer; }
		public function get isDev():Boolean { return _isDev; }
		public function get isDes():Boolean { return _isDes; }
		public function get isSupport():Boolean { return _isSupport; }
		public function get isScout():Boolean { return _isScout; }
		public function get isCitizen():Boolean { return _isCitizen; }
		public function get isBlog():String { return _isBlog; }
		public function get lastOnlineDay():int { return _lastOnlineDay; }
		public function get isModerator():Boolean { return _isModerator; }	
		public function get publicLocation():Boolean { return _publicLocation; }	
		public function get isTest():Boolean { return _isTest; }
		public function get email():String { return _email; }
		public function set email(value:String):void { _email = value; }
		public function get moodId():String { return _moodId; }
		public function get helpEnabled():Boolean { return _helpEnabled; }
		public function get firstLogin():Boolean { return _firstLogin; }
		public function get robotTeam():RobotTeam { return _robotTeam; }
		public function get crew():Crew { return _crew; }
		
		public function set challenges(value:String) : void
		{
			_challenges = value;
			_challengesChangeEvent.sendEvent();
		}
		
		public function set achievements(value:String) : void
		{
			_achievements = value;
			_achievementsChangeEvent.sendEvent();
		}
		
		public function get hasTools():Boolean {
			var result:Boolean = (_options.indexOf("tools") != -1) ? true : false;
			return result;
		}
		public function get playerCard():StuffItemLightTO { return _playerCard; }
		public function set playerCard(value:StuffItemLightTO):void
		{
			_playerCard = value;
			
			if (_playerCard)
				new CharService().savePlayerCard(_playerCard.id);
			else
				new CharService().savePlayerCard(-1);
			
			_playerCardChangeEvent.sendEvent();
		}
		public function set bankMoney(value:int):void {
			_bankMoney=value; }
		public function get tool():String { return _tool; }
		public function set age(value:Number):void { _age=value; }
		public function set tool(value:String):void
		{
			_tool=value;
			_toolChangeEvent.sendEvent();
		}
		public function set defaultFrame(value:Boolean):void{ _defaultFrame=value;}
		public function get defaultFrame():Boolean{ return _defaultFrame; }
		
		public function get instrument():String { return _instrument; }
		public function set instrument(value:String):void
		{
			_instrument=value;
			_instrumentChangeEvent.sendEvent();
		}
		
		public function get magicItem():String { return _magicItem; }
		public function set magicItem(value:String):void
		{
			_magicItem = value;
			_magicItemChangeEvent.sendEvent();
		}
		public function get magicStuffItemRain():String { return _magicStuffItemRain; }
		public function set magicStuffItemRain(value:String):void
		{
			_magicStuffItemRain = value;
			_magicStuffItemRainChangeEvent.sendEvent();
		}
		public function get magicStuffItemRainCount():int { return _magicStuffItemRainCount; }
		public function set magicStuffItemRainCount(value:int):void
		{
			_magicStuffItemRainCount = value;
		}
		
		public function get money():Number { return _money; }
		public function set money(value:Number):void
		{
			_money=value;
			moneyChangeEvent.sendEvent();
		}
		
		public function get emeralds():Number { return _emeralds; }
		public function set emeralds(value:Number):void
		{
			_emeralds=value;
			emeraldsChangeEvent.sendEvent();
		}
		

		public function set resetPass(val:Boolean):void
		{
			_resetPass=val;
		}
		
		public function get candy():Number { return _candy; }
		public function set candy(value:Number):void
		{
			_candy=value;
			candyChangeEvent.sendEvent();
		}
		
		public function get experience():int { return _experience; }
		public function set experience(value:int):void
		{
			_experience=value;
			_experienceChangeEvent.sendEvent();
		}
		public function get uiColour():int { return _uiColour; }
		public function set uiColour(value:int):void
		{
			_uiColour=value;
			_uiColourint=uint("0x" + value.toString(16));
			//	_experienceChangeEvent.sendEvent();
		}
		
		public function get charLevel():int { return _charLevel; }
		public function set charLevel(value:int):void
		{
			_charLevel=value;
			_levelChangeEvent.sendEvent();
		}
		
		public function get chatLog():String { return _chatLog; }
		public function set chatLog(value:String):void
		{
			_chatLog=value;
			
		}
		public function get gender():String { return _gender; }
		public function set gender(value:String):void
		{
			_gender=value;
		}
		public function set purchasedBubbles(value:String):void
		{
			_purchasedBubbles=value;
		}
		
		public function set outfits(value:String):void
		{
			_outfits=value;
		}
		
		public function set purchasedBodies(value:String):void
		{
			_purchasedBodies=value;
		}
		
		public function set purchasedCards(value:String):void
		{
			_purchasedCards=value;
		}
		
		public function get location():String { return _location; }
		public function set location(value:String):void
		{
			_location=value;
			
			if(value != null)
				new AdminService().updateLocation(Global.charManager.userId, value);
		}
		
		public function get chatColor():String { return _chatColor; }
		public function set chatColor(value:String):void
		{
			_chatColor=value;
			_bubleStyleChangeEvent.sendEvent();
		}
		public function get fontColor():String { return _fontColor; }
		public function set fontColor(value:String):void
		{
			_fontColor=value;
		}
		
		public function get blogLink():String { return _blogLink; }
		public function set blogLink(value:String):void
		{
			_blogLink=value;
		}
		
		private function onGetCheck1(result:Number) : void
		{
			check1 = result;
		}
		
		public function get check1():Number { return _check1; }
		public function set check1(check1:Number):void
		{
			_check1 = check1;
			_check1ChangeEvent.sendEvent();
		}
		
		private function onGetCheck2(result:Number) : void
		{
			check2 = result;
		}
		
		public function get check2():Number { return _check2; }
		public function set check2(check2:Number):void
		{
			_check2 = check2;
			_check2ChangeEvent.sendEvent();
		}
		
		private function onGetCheck3(result:Number) : void
		{
			check3 = result;
		}
		
		public function get check3():Number { return _check3; }
		public function set check3(check3:Number):void
		{
			_check3 = check3;
			_check3ChangeEvent.sendEvent();
		}
				
		private function onGetSpin(result:Number) : void
		{
			spinAmount = result;
		}
		
		public function get spinAmount():Number { return _spinAmount; }
		public function set spinAmount(spinAmount:Number):void
		{
			_spinAmount = spinAmount;
			_spinChangeEvent.sendEvent();
		}
		
		public function get baned():Boolean { return _baned; }
		public function set baned(baned:Boolean):void
		{
			_baned = baned;
		}
		
		public function get drawEnabled():Boolean { return _drawEnabled; }
		public function set drawEnabled(value:Boolean):void
		{
			_drawEnabled=value;
			_drawEnabledChangeEvent.sendEvent();
		}
		
		public function get pictureChat():Boolean { return _pictureChat; }
		public function set pictureChat(value:Boolean):void
		{
			_pictureChat=value;
			_pictureChatChangeEvent.sendEvent();
			Global.notifications.pictureChat = value;
		}
		
		public function set citizen(value:Boolean):void
		{
			
			_isCitizen=value;
			_citizenChangeEvent.sendEvent();
		}
		
		public function get finishedNotification():Boolean { return _finishedNotification; }
		public function set finishedNotification(value:Boolean):void
		{
			_finishedNotification=value;
		}
		
		public function get finishingNotification():Boolean { return _finishingNotification; }
		public function set finishingNotification(value:Boolean):void
		{
			_finishingNotification=value;
		}
		
		public function get citizenTryCount():Boolean { return _citizenTryCount; }
		
		public function get citizenExpirationDate():Date { return _citizenExpirationDate; }
		public function get moderatorList():Array { return _moderatorList; }
		public function get journalistList():Array { return _journalistList; }
		public function set citizenExpirationDate(value:Date):void
		{
			_citizenExpirationDate=value;
		}
		
		public function get body():String { return _body; }
		public function set body(value:String):void
		{
			_body=value;
			_charViewChangeEvent.sendEvent();
		}
		
		public function get clothes():Array { return _stuffs.getUsedClothes(); }
		public function get uiColourint():uint { return _uiColourint; }
		public function set clothes(value:Array):void
		{
			_stuffs.setUsedClothes(value);
			_charViewChangeEvent.sendEvent();
		}
		public function applyClothes(value:Array):void
		{
			_stuffs.addUsedClothes(value);
			_charViewChangeEvent.sendEvent();
		}
		
		public function get color():int { return _color; }
		public function set color(value:int):void
		{
			_color=value;
			_charViewChangeEvent.sendEvent();
		}
		
		public function set publicLocation(value:Boolean):void
		{
			_publicLocation = value;
		}
		
		
		
		public function get blogURL():String { return _blogURL; }
		public function set blogURL(value:String):void
		{
			_blogURL=value;
		}
		
		public function get hasRobot():Boolean { return Boolean(_robot); }
		
		public function get robot():Robot { return _robot; }
		public function set robot(value:Robot):void
		{
			_robot = value;
			_robotChangeEvent.sendEvent();
		}
		
		public function getCharState():Object
		{
			var state:Object={id:_charId, body:_body, color:_color, clothes:_stuffs.getUsedClothes(), tool:_tool, userId:_userId}
			return state;
		}
		
		public function get isInitialised():Boolean
		{
			return _charId != null;
		}
		
		public function get canHaveTextChat():Boolean
		{
			return !_baned
				&& !_isGuest
				&& !_serverChatDisabled
				&& (_isCitizen || !_nonCitizenChatDisabled)
				&& _chatEnabledByMod
				&& _chatEnabledByParent;
		}
		
		public function set serverChatDisabled(serverChatDisabled:Boolean):void
		{
			if (_serverChatDisabled != serverChatDisabled)
			{
				_serverChatDisabled=serverChatDisabled;
				
				Global.notifications.chatEnabled = canHaveTextChat;
			}
		}
		
		public function set chatEnabledByMod(chatEnabledByMod:Boolean):void
		{
			_chatEnabledByMod = chatEnabledByMod
		}
		
		public function set chatEnabledByParent(chatEnabledByParent:Boolean):void
		{
			_chatEnabledByParent = chatEnabledByParent
		}
		
		public function get serverChatDisabled():Boolean
		{
			return _serverChatDisabled;
		}
		
		public function get serverDrawDisabled():Boolean
		{
			return _serverDrawDisabled;
		}
		
		public function set serverDrawDisabled(serverDrawDisabled:Boolean):void
		{
			if (_serverDrawDisabled != serverDrawDisabled)
			{
				_serverDrawDisabled=serverDrawDisabled;
				_drawEnabledChangeEvent.sendEvent();
			}
		}
		
		public function get currentQuest():String{	return _currentQuest; }
		public function set currentQuest(val:String):void { _currentQuest = val; }
		public function get questState():int{ return _questState; }
		public function set questState(val:int):void { _questState = val; }
		
		public function get satellitesPlaced():Array { return _satellitesPlaced; }
		public function get satellitesMustPlace():Array { return _satellitesMustPlace; }
		//public function set satellitesPlaced(val:Ar
		
	}
}





