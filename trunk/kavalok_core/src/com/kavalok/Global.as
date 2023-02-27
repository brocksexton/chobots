package com.kavalok {
	/**
	* @Author: Maxym Hryniv
	*/
	
	import com.google.analytics.AnalyticsTracker;
	import com.kavalok.char.CharManager;
	import com.kavalok.char.FloxManager;
	import com.kavalok.char.actions.MagicAction;
	import com.kavalok.char.commands.NightColorModifier;
	import com.kavalok.constants.BrowserConstants;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.ServerPropertiesTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.external.ExternalCalls;
	import com.kavalok.gameplay.ClientTicker;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.LocalSettings;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.Music;
	import com.kavalok.gameplay.commands.LevelAnimCommand;
	import com.kavalok.gameplay.commands.RetriveStuffCommand;
	import com.kavalok.gameplay.frame.GameFrameView;
	import com.kavalok.gameplay.notifications.Notifications;
	import com.kavalok.gameplay.windows.CharWindowView;
	import com.kavalok.level.LevelItem;
	import com.kavalok.level.LevelUp;
	import com.kavalok.location.LocationManager;
	import com.kavalok.location.commands.PlaySwfCommand;
	import com.kavalok.login.AuthenticationManager;
	import com.kavalok.login.LoginManager;
	import com.kavalok.messenger.MessageInbox;
	import com.kavalok.modules.ModuleManager;
	import com.kavalok.pets.PetManager;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;
	import com.kavalok.services.ErrorService;
	import com.kavalok.services.MoneyService;
	import com.kavalok.ui.WindowManager;
	import com.kavalok.utils.AdminConsole;
	import com.kavalok.utils.ClassLibrary;
	import com.kavalok.utils.KeyboardManager;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.PerformanceManager;
	import com.kavalok.utils.Timers;
	import com.kavalok.utils.GraphityUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.ColorTransform;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import flash.xml.*;
	import flash.utils.getTimer;
	
	public class Global {
		//----------------------------------------//
		static public const MAIN_SITE_URL:String = 'https://kavalok.net';
		//----------------------------------------//
		static public var startupInfo:StartupInfo;
		static public var version:String;
		static public var userName:String;
		static public var retrievedItem:Boolean = false;
		static public var gotTries:Boolean = false;
		static public var chatSecurityKey:Array;
		static public var isTrading:Boolean = false;
		static public var anims:Array;
		static public var fakeCitizen = false;
		static public var buildNum:int;
		static public var animArr:Array = new Array();
		static public var batsLeft:int = 8;
		static public var animLink:Array = new Array();
		static public var quests:Object = {};
		static public var youtubePlayer:DisplayObject;
		static public var team:String;
		static public var itemOnMarket:Boolean = false;
		static public var musicVolume:int;
		static public var soundVolume:int = 100;
		static public var shareLocation:Boolean;
		static public var showTips:Boolean;
		static public var panelName:String;
		static public var isAgentGuest:Boolean;
		static public var showCharNames:Boolean;
		public static var _charUserName:String;
		public static var testingMode:Boolean = false;
		static public var acceptRequests:Boolean;
		static public var serverTimeDiff:int;
		static public var urlPrefix:String;
		public static var allowCache:String;
		public static var lockMusic:Boolean = false;
		static public var referer:String;
		static public var serverProperties:ServerPropertiesTO;
		static public var scale:Number = 1;
		static public var _allowDarkness:Boolean;
		static public var partnerUserId:int = 0;
		static public var debugging:Boolean = false;
		static public var DIVIDE_NUM:int = 100;
		static public var login_secs:int = 0;
		static public var my_Date = new Date();
		public static var auas:int = my_Date.getHours();
		public static var alreadyApplied:Boolean = false;
		public static var hours:int;
		public static var initTime:int;
		public static var hoursUTC:int = my_Date.getUTCHours();
		public static var daysUTC:int = my_Date.getUTCDay();
		public static var monthUTC:int = my_Date.getUTCMonth();
		public static var yearUTC:int = 2014;
		public static var minUTC:int = my_Date.getUTCMinutes();
		public static var enteredPassword:String;
		static public var gameVersion:int = 1;
		public static var versionNum:String = String("1");
		public static var loginTimer:Timer = new Timer(1000);
		public static var isWardrobe:Boolean = false;
		public static var enteredUser:String;
		public static var acceptNight:Boolean;
		static public var superUser:Boolean = false;
		public static var currentBody:String;
		static public var accLocked:Boolean = false;
		static public var supaUsa:Boolean = false;
		static private var _lockRect:Sprite;
		static private var _clientTicker:ClientTicker = new ClientTicker();
		static public var isGRE:Boolean = false;
		
		private static var _isFishing:Boolean = false;
		
		public static var stuffsLoaded:Boolean = false;
		
		public static var animationsPeople:Array = new Array("");
		
		//static private var urlPrefix:String = "http://kavalok.net/game/";
		
		static private var _analyticsTracker:AnalyticsTracker;
		
		public static function get analyticsTracker():AnalyticsTracker {
			return _analyticsTracker;
		}
		
		public static function get getDateDetails():String {
			var result:Date = new Date();
			result.time = new Date().time - serverTimeDiff;
			var hours = result.getHours();
			var minutes = result.getMinutes();
			var day = result.getDay();
			return daysUTC + "/" + monthUTC + "/" + "2012 " + hours + ":" + minutes;
		}
		
		static private var _charsCache:Object = {};
		
		static public function get charsCache():Object {
			return _charsCache;
		}
		
		static public function set charsCache(value:Object):void {
			_charsCache = value;
		}
		
		static private var _tableGameCloseEvent:EventSender = new EventSender(String);
		
		static public function get tableGameCloseEvent():EventSender {
			return _tableGameCloseEvent;
		}
		
		static private var _windowManager:WindowManager;
		
		static public function get windowManager():WindowManager {
			return _windowManager;
		}
		
		private static var _resourceBundles:ResourceBundles = new ResourceBundles();
		
		public static function get resourceBundles():ResourceBundles {
			return _resourceBundles;
		}
		
		private static var _performanceManager:PerformanceManager;
		
		public static function get performanceManager():PerformanceManager {
			return _performanceManager;
		}
		
		
		private static var _notifications:Notifications = new Notifications();
		
		public static function get notifications():Notifications {
			return _notifications;
		}
		
		private static var _petManager:PetManager = new PetManager();
		
		public static function get petManager():PetManager {
			return _petManager;
		}
		
		private static var _stage:Stage;
		
		public static function get stage():Stage {
			return _stage;
		}
		
		private static var _topContainer:Sprite = new Sprite();
		
		public static function get topContainer():Sprite {
			return _topContainer;
		}
		
		private static var _borderContainer:Sprite = new Sprite();
		
		public static function get borderContainer():Sprite {
			return _borderContainer;
		}
		
		public static function get totalExp():int {
			return Global.charManager.charLevel * (120 + (Global.charManager.charLevel * 2));
		}
		
		private static var _windowsContainer:Sprite = new Sprite();
		
		public static function get windowsContainer():Sprite {
			return _windowsContainer;
		}
		
		private static var _dialogsContainer:Sprite = new Sprite();
		
		public static function get dialogsContainer():Sprite {
			return _dialogsContainer;
		}
		
		private static var _locationContainer:Sprite = new Sprite();
		
		public static function get locationContainer():Sprite {
			return _locationContainer;
		}
		
		private static var _root:Sprite;
		
		public static function get root():Sprite {
			return _root;
		}
		
		private static var _inbox:MessageInbox;
		
		public static function get inbox():MessageInbox {
			return _inbox;
		}
		
		private static var _keyboard:KeyboardManager;
		
		public static function get keyboard():KeyboardManager {
			return _keyboard;
		}
		
		private static var _localSettings:LocalSettings = new LocalSettings();
		
		public static function get localSettings():LocalSettings {
			return _localSettings;
		}
		
		private static var _authManager:AuthenticationManager = new AuthenticationManager();
		
		public static function get authManager():AuthenticationManager {
			return _authManager;
		}
		
		private static var _music:Music = new Music();
		
		public static function get music():Music {
			return _music;
		}
		
		private static var _locationManager = new LocationManager();
		
		public static function get locationManager():LocationManager {
			return _locationManager;
		}
		
		private static var _frame:GameFrameView = new GameFrameView();
		
		public static function get frame():GameFrameView {
			return _frame;
		}
		
		private static var _classLibrary:ClassLibrary = new ClassLibrary();
		
		public static function get classLibrary():ClassLibrary {
			return _classLibrary;
		}
		
		private static var _moduleManager:ModuleManager = new ModuleManager();
		
		public static function get moduleManager():ModuleManager {
			return _moduleManager;
		}
		
		private static var _externalCalls:ExternalCalls = new ExternalCalls();
		
		public static function get externalCalls():ExternalCalls {
			return _externalCalls;
		}
		
		public static function get level1():int {
			return 1 * (120 + (1 * 2));
		}
		
		/*private static var _nichoFrame:NichoFrameView = new NichoFrameView();
		
		public static function get nichoFrame():NichoFrameView
		{
		return _nichoFrame;
		}*/
		
		private static var _charManager:CharManager = new CharManager();
		
		
		public static function get charManager():CharManager {
			return _charManager;
		}
		
		private static var _floxManager:FloxManager = new FloxManager();
		public static function get floxManager():FloxManager {
			return _floxManager;
		}
		
		public static function get LEVEL_DIVIDE():int {
			return DIVIDE_NUM;
		}
		
		private static var _loginManager = new LoginManager();
		
		public static function get loginManager():LoginManager {
			return _loginManager;
		}
		
		private static var _isLocked:Boolean = false;
		
		public static function get isLocked():Boolean {
			return _isLocked;
		}
		
		private static var _graphityEnabled:Boolean = false;
		
		public static function get graphityEnabled():Boolean {
		  return _graphityEnabled;
		}
		
		public static function set graphityEnabled(value:Boolean):void {
		  _graphityEnabled = value;
		}
		
		public static function sendAchievement(type:String, message:String) : *
		{
			if(Global.charManager.achievements.indexOf(type) == -1)
			{
				new CharService().sendAchievement(Global.charManager.userId,type,message);
				Global.charManager.achievements = Global.charManager.achievements + type;
				return;
			}
		}
		
		public static function set isLocked(value:Boolean):void {
			if (_isLocked != value) {
				_isLocked = value;
				if (_isLocked) {
					if (Global.debugging && !_root)
						return;
					_root.addChild(_lockRect);
					MousePointer.setIconClass(MousePointer.BUSY);
				}
				else {
					if (Global.debugging && !_root)
						return;
					_root.removeChild(_lockRect);
					MousePointer.resetIcon();
				}
				_locationContainer.mouseChildren = !_isLocked;
				_topContainer.mouseChildren = !_isLocked;
				_borderContainer.mouseChildren = !_isLocked;
				_windowsContainer.mouseChildren = !_isLocked;
				_topContainer..mouseChildren = !_isLocked;
			}
			
			stage.focus = null;
		}
		
		static public function getBoostedValue(citizenGetMore:Boolean = true):Number {
			var _time:Date = getServerTime();
			var day:String = _time.getDate() < 10?"0" + _time.getDate().toString():_time.getDate().toString();
		
			if(Global.charManager.isCitizen && citizenGetMore) {
				if(day == "01" || day == "08" || day == "15" || day == "22" || day == "29") {
					return KavalokConstants.EVENT_CITIZEN_MONEY_MULTIPLIER;
				} else {
					return KavalokConstants.CITIZEN_MONEY_MULTIPLIER;
				}
			} else {
				if(day == "01" || day == "08" || day == "15" || day == "22" || day == "29") {
					return KavalokConstants.EVENT_MONEY_MULTIPLIER;
				}
			}
			return 1;
		}
		
		public static function get messages():Object {
			return resourceBundles.kavalok.messages;
		}
		
		public static function get premiumMsg():Object {
			return resourceBundles.premium.messages;
		}
		
		public static function get badgesMessages():Object {
			return resourceBundles.badges.messages;
		}
		
		public static function get charsUserName():String {
			return _charUserName;
		}
		
		public static function set charsUserName(value:String):void {
			_charUserName = value;
		}
		
		public static function handleError(error:Error):void {
			if (error.getStackTrace()) {
				var message:String = Global.locationManager.locationId + '\n' + error.message + '\n' + error.getStackTrace();
				
				new ErrorService().addError(message);
			}
			
			throw error;
		}
		
		public static function initialize(root:Sprite):void {
			
			if (startupInfo.errorLogEnabled) {
				EventSender.errorHandler = handleError;
				Timers.errorHandler = handleError;
			}
			
			_lockRect = new Sprite();
			_lockRect.graphics.beginFill(0, 0);
			_lockRect.graphics.drawRect(0, 0, KavalokConstants.SCREEN_WIDTH, KavalokConstants.SCREEN_HEIGHT);
			_lockRect.graphics.endFill();
			_lockRect.cacheAsBitmap = true;
			
			_root = root;
			_root.addChild(_locationContainer);
			_root.addChild(_borderContainer);
			_root.addChild(_windowsContainer);
			_root.addChild(_dialogsContainer);
			_root.addChild(_topContainer);
			_root.scrollRect = KavalokConstants.SCREEN_RECT;
			initTime = hours;
			_windowManager = new WindowManager();
			
			_stage = _root.stage;
			_keyboard = new KeyboardManager(_root);
			_performanceManager = new PerformanceManager();
			_performanceManager.quality = localSettings.quality;
			_inbox = new MessageInbox();
			_analyticsTracker = new GoogleATracker(_root, KavalokConstants.ANALYTICS_ID)
		}
		
		static public function getServerTime():Date {
			var result:Date = new Date();
			result.time = new Date().time - serverTimeDiff;
			return result;
		}
		
		public static function applyUIColour(window:Sprite):void {
			var transformy:ColorTransform = new ColorTransform();//_content.dialogBg.colourSprite.transform.colorTransform
			transformy.color = Global.charManager.uiColourint;
			window.transform.colorTransform = transformy;
		}
		
		public static function addCheck(amount:int, checkType:String):void {
			new CharService().addCheck(Global.charManager.userId,amount,checkType);
		}
		
		public static function removeUIColour(window:Sprite):void {
			var transformy:ColorTransform = new ColorTransform();
			window.transform.colorTransform = transformy;
		}
		
		public static function getPanelDate():String {
			var result:Date = new Date();
			//result.time = new Date().time - serverTimeDiff;
			var hours = result.getUTCHours();
			var minutes = result.getUTCMinutes();
			var seconds = result.getUTCSeconds();
			var day = result.getDay();
			return (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
		}
		
		public static function upperCase(str:String):String {
			var firstChar:String = str.substr(0, 1);
			var restOfString:String = str.substr(1, str.length);
			
			return firstChar.toUpperCase() + restOfString.toLowerCase();
			
		}
		
		public static function callExternal(functionName:String, parameter:String = null):void {
			if (ExternalInterface.available) {
				try {
					if (parameter)
						ExternalInterface.call(functionName, parameter);
					else
						ExternalInterface.call(functionName);
				}
				catch (e:Error) {
				}
			}
		}
		
		public static function playSound(soundClass:Class, volume:Number = 1):void {
			var sound:Sound = new soundClass();
			var sndVol:Number = Global.soundVolume / 100 * volume;
			sound.play(0, 1, new SoundTransform(sndVol));
		}
		
		public static function getCurrDate():void {
			var hours:int = my_Date.getHours();
			var minutes:int = my_Date.getMinutes();
		}
		
		public static function addExperience(experience:int) {
			
			var expCitizen:int = Math.ceil(experience * 1.5);
			
			if (Global.charManager.charLevel < 60) {
				
				if (!Global.charManager.isCitizen && Global.charManager.charLevel >= 19) {
					return;
				}
				else {
					
					if (Global.charManager.isCitizen) {
						
						new AdminService().addExperience(Global.charManager.userId, expCitizen);
						Global.charManager.experience = Global.charManager.experience + expCitizen;
						new LevelAnimCommand(expCitizen).execute();
						new LevelUp();
					}
					else {
						new AdminService().addExperience(Global.charManager.userId, experience);
						Global.charManager.experience = Global.charManager.experience + experience;
						new LevelAnimCommand(experience).execute();
						new LevelUp();
					}
				}
				
			}
			else {
				return;
			}
			
			return;
		}
		
		public static function newTweet(tweetMsg:String) {
			new AdminService().sendTweet(charManager.userId, charManager.accessToken, charManager.accessTokenSecret, tweetMsg);
		}
		
		public static function removeExperience(experience:int) {
			
			new AdminService().addExperience(Global.charManager.userId, -experience);
			Global.charManager.experience = Global.charManager.experience - experience;
			new LevelAnimCommand(-experience).execute();
		}
		
		private static var bubbleVisible:Boolean = true;
		
		public static function set bubbleValue(value:Boolean):void {
		  bubbleVisible = value;
		}
		
		public static function get bubbleValue():Boolean
		{
		 return bubbleVisible;
		}
		
		public static function addTwitterTokens(accessToken:String, accessTokenSecret:String) {
			
		}
		
		static public function saveSettings():void {
			
			new CharService().saveSettings(musicVolume, soundVolume, acceptRequests, acceptNight, showTips, showCharNames, Global.charManager.publicLocation, Global.charManager.uiColour, Global.charManager.defaultFrame);
		}
		
		static public function openHomePage(e:Event = null):void {
			var request:URLRequest = new URLRequest("http://kavalok.net");
			request.method = URLRequestMethod.GET;
			navigateToURL(request, BrowserConstants.BLANK);
		}

		public static function get isFishing():Boolean
		{
			return _isFishing;
		}

		public static function set isFishing(value:Boolean):void
		{
			_isFishing = value;
		}

		
	}
}