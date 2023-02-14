package com.kavalok.location
{
	import com.kavalok.Global;
	import com.kavalok.char.actions.CharPropertyAction;
	import com.kavalok.char.actions.MoodAction;
	import com.kavalok.char.actions.StuffAction;
	import com.kavalok.char.commands.NightColorModifier;
	import com.kavalok.constants.Locations;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.location.commands.LocationCommandBase;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.URLUtil;
	import com.kavalok.utils.WeakReference;
	import com.kavalok.services.AdminService;
	import flash.external.ExternalInterface;
	
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import flash.geom.Point;
	
	public class LocationManager 
	{
		private static const HOME_PREFIX : String = "home|";
		
		public var _location:LocationBase = null;
		public var locOutside:Array = new Array("loc3", "loc0");
		private var _prevLocId:String = Locations.LOC_0;
		private var _prevLocParameters:Object;
		private var _prevRemoteId:String;
		private var _loader:Loader;
		private var magicPlaying:Boolean = false;
		private var movie:MovieClip;
		
		private var _isInit:Boolean = false;
		private var _isFirstLocation:Boolean = true;
		private var _isLocationReady:Boolean = false;
	
		private var _firstLocationEvent:EventSender = new EventSender();
		private var _locationDestroy:EventSender = new EventSender();
		private var _locationChange:EventSender = new EventSender();
		
		private var _userPosChanged:EventSender = new EventSender();
		
		static public function getHomeRemoteId(charId:String, level:int):String
		{
			return HOME_PREFIX + charId + '|' + level;
		}
		
		public function get userPosChanged():EventSender
		{
			 return _userPosChanged;
		}
		
		public function LocationManager() 
		{
			super();
		}
		
		public function goHome() : void
		{
			Global.moduleManager.loadModule(Modules.HOME, 
				{charId : Global.charManager.charId, userId : Global.charManager.userId});
		}
		public function goAgent() : void
		{
			Global.moduleManager.loadModule(Modules.AGENTS);
		}
		
		public function stopUser() : void
		{
			if(_location)
				_location.stopUser();
		}
		
		private function initialize():void
		{
			_isInit = true;
			Global.frame.moodEvent.addListener(onMood);
			Global.charManager.stuffs.itemUsedEvent.addListener(onStuff);
			Global.charManager.charViewChangeEvent.addListener(onClothesChange);
			Global.charManager.addModifierEvent.addListener(onModifierAdded);
			Global.charManager.changeModelEvent.addListener(onModelChanged);
			Global.charManager.removeModifiearEvent.addListener(onModifierRemoved);
			Global.performanceManager.shadowEnabledChanged.addListener(onShadowEnabledChanged);
		}
		
		private function onShadowEnabledChanged():void
		{
			if (_location)
				_location.updatePerformance();
		}
		
		private function onModifierAdded(modifierInfo:Object):void
		{
			if (_location)
				_location.sendAddModifier(modifierInfo);
		}

		private function onModelChanged(info:Object):void
		{
			if (_location)
				_location.sendChangeModel(info);
		}
		
		private function onModifierRemoved(className:String):void
		{
			if (_location)
				_location.sendRemoveModifier(className);
		}
		
		private function onClothesChange():void
		{
			if (_location)
				_location.sendUpdateClothes();
		}
		
		private function onMood(moodId:String):void
		{
			var state:Object = {moodId : moodId};
			_location.sendUserState(null, state);
			_location.sendUserAction(MoodAction, state);
		}
		
		private function onStuff(item:StuffItemLightTO):void
		{
			if (item.type == StuffTypes.STUFF)
				_location.sendUserAction(StuffAction, {fileName : item.fileName});
		}

		public function get locationChange():EventSender
		{
			return _locationChange;
		}
		
		public function get locationDestroy():EventSender
		{
			return _locationDestroy;
		}
		
		public function get location():LocationBase
		{
			return _location;
		}
		
		public function get locationId():String
		{
			 return (_location) ? _location.locId : null;
		}
		
		public function get locationExists():Boolean
		{
			 return Boolean(_location);
		}
		
		public function get remoteId():String
		{
			 return _location.remoteId;
		}
		public function get userPosition():Point
		{
			if (_location && _location.user)
				return _location.user.position;
			else
				return null; 
		}
		
		public function changeLocation(location:LocationBase):void
		{
			if (!_isInit)
				initialize();
			
			if (_location)
				destroyLocation();
	
			_location = location;
			_isLocationReady = false;
			_location.readyEvent.addListener(onLocationReady);
			_location.userPosChanged.addListener(_userPosChanged.sendEvent);
			
			if(isStaticLocation(_location.locId))
			{
				Global.localSettings.locationId = _location.locId;
			}
			
			Global.locationContainer.addChildAt(_location.content, 0);
			
			_location.create();
			
			if(location)
			Global.charManager.location = _location.locId;
			
			if(movie) {
				GraphUtils.stopAllChildren(movie);
				GraphUtils.detachFromDisplay(movie);
			}
			//_loader = new Loader();
			//_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			//_loader.load(new URLRequest("/game/resources/magic/snowfallBackground.swf"));
			Global.addCheck(1,"location");
		}
		
		private function onLoadComplete(e:Event):void
		{
			movie = LoaderInfo(e.target).content as MovieClip;
			movie.mouseEnabled = false;
			movie.mouseChildren = false;
			Global.locationContainer.addChild(movie);
		}

		public function get locLol():LocationBase
		{
			return LocationBase(Global.locationManager.reference.value);
		}
		
		public function isStaticLocation(locId : String):Boolean
		{
			return locId && !Strings.contains(locId, "|")
				&& locId != Modules.HOME;
		}
		
		private function onLocationReady():void
		{
			_isLocationReady = true;
			_locationChange.sendEvent();
			
			if (_isFirstLocation)
			{
				_isFirstLocation = false;
				_firstLocationEvent.sendEvent();
			}
		}
		
		public function returnToPrevLoc():void
		{
			if (_prevLocId)
				Global.moduleManager.loadModule(_prevLocId, _prevLocParameters);
		}
		
		public function executeCommand(command:LocationCommandBase):void
		{
			command.location = _location;
			command.execute();
		}
		
		public function destroyLocation():void
		{
			if (_location)
			{
				_location.userPosChanged.removeListener(_userPosChanged.sendEvent);
				_locationDestroy.sendEvent();
				
				_prevLocId = _location.locId;
				_prevLocParameters = _location.invitationParams;
				_prevRemoteId = _location.remoteId;
			
				GraphUtils.detachFromDisplay(_location.content);
				
				_location.destroy();
				_location = null;
			}
		}
		
		public function get isOwnHome():Boolean
		{
			 return Strings.startsWidth(_location.remoteId,
			 	HOME_PREFIX + Global.charManager.charId + '|');
		}
		
		public function get danceEnabled():Boolean
		{
			if (_location)
				return _location.user.danceEnabled;
			else
				return false; 	
		}
		
		public function get reference():WeakReference
		{
			return new WeakReference(_location);
		}
		
		public function get firstLocationEvent():EventSender { return _firstLocationEvent; }
		
		public function get isLocationReady():Boolean { return _isLocationReady; }
		public function get prevLocId():String { return _prevLocId; }
		public function get prevLocParameters():Object { return _prevLocParameters; }
		public function get prevRemoteId():String { return _prevRemoteId; }
		
	}
}