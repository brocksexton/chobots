package com.kavalok.modules
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.constants.Locations;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.errors.IllegalStateError;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.loaders.AdvertisementLoaderView;
	import com.kavalok.loaders.ILoaderView;
	import com.kavalok.loaders.LocationLoaderView;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.location.LocationBase;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TaskCounter;
	
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class ModuleManager
	{
		private static const ADVERTISEMENT_INDEXES : Array = [3];
		private static var loaderIndex : int = 0;
		public var _loader:SafeLoader;
		public var _view:ILoaderView;
		public var _parameters:Object;
		public var _moduleId:String;
		public var _loadTasks:TaskCounter; 
		public var _empty:Boolean = true; 
		public var _currentModuleEvents:ModuleEvents; 
		
		private var _moduleReadyEvent:EventSender = new EventSender(); 
		private var _currentModules:ArrayList = new ArrayList();
		
		public function ModuleManager()
		{
		}

		public function doLoaderView():void
		{
			_view = new AdvertisementLoaderView();
			_loadTasks = new TaskCounter(1);
			_loadTasks.completeEvent.addListener(onLoadComplete);	
			_loader = new SafeLoader(_view);
			_loader.completeEvent.setListener(_loadTasks.completeTask);
			_loader.load(new URLRequest(URLHelper.moduleUrl("loc3")));
		}
		
		public function get loading() : Boolean
		{
			return _loader != null;
		}
		public function get currentModuleEvents() : ModuleEvents
		{
			return _currentModuleEvents;
		}
		public function get currentModules() : ArrayList
		{
			return _currentModules;
		}
		public function get empty() : Boolean
		{
			return _empty;
		}
		public function abortLoading() : void
		{
			_loader.cancelLoading();
			_loader = null;
			_currentModuleEvents.abortEvent.sendEvent();
			GraphUtils.detachFromDisplay(_view.content);
			
		}
		
		public function loadModule(moduleId:String, parameters:Object = null, destroyCurrent : Boolean = false):ModuleEvents
		{
			if(moduleId == Modules.HOME_CLOTHES){
				if(!Global.stuffsLoaded) 
				{
					Dialogs.showOkDialog("Your wardrobe is loading, please try again", true);
					return new ModuleEvents();
				}
				else if(Global.isTrading) 
				{
					Dialogs.showOkDialog("Not while you're trading, honey.", true);
					return new ModuleEvents();
				}
				
			}
			
			
			if(_loader)
				throw new IllegalStateError("trying to load " + moduleId + " while other module is loading");
			_currentModuleEvents = new ModuleEvents();
			trackAnalytics(moduleId);
			_empty = false;
			Global.locationManager.stopUser();
			if(!Global.debugging && destroyCurrent)
			{
				Global.locationManager.destroyLocation();
			}
			
			_loadTasks = new TaskCounter(1);
			_loadTasks.completeEvent.addListener(onLoadComplete);	
					
			var bundle:ResourceBundle = Localiztion.getBundle(moduleId);
			if (!bundle.loaded)
			{
				_loadTasks.addCount();
				bundle.load.addListener(_loadTasks.completeTask);
				bundle.loadError.addListener(_loadTasks.completeTask);
			}
			
			_moduleId = moduleId;
			_parameters = parameters ? parameters : {};
			
			if(AdvertisementLoaderView.initialized && Locations.isLocation(moduleId))
				loaderIndex++;
			
			var advertise : Boolean = ADVERTISEMENT_INDEXES.indexOf(loaderIndex) != -1;
			if(Global.charManager.isInitialised 
				&& !Global.charManager.isGuest 
				&& !Global.charManager.isNotActivated 
				&& !Global.charManager.isCitizen 
				&& advertise && AdvertisementLoaderView.initialized
				&& Locations.isLocation(moduleId))
			{
				_view = new AdvertisementLoaderView();
			}
			else
			{
				_view = new LocationLoaderView();
			}


			if(moduleId=="girlsRegistration")
			{
				var gameScale:Number = Math.min(507 / KavalokConstants.SCREEN_WIDTH, 464 / KavalokConstants.SCREEN_HEIGHT);
				var gameWidth:int = KavalokConstants.SCREEN_WIDTH * gameScale;
				var gameHeight:int = KavalokConstants.SCREEN_HEIGHT * gameScale;
				
				
				_view.content.x = int(0.5 * (507 - gameWidth));
				_view.content.y = int(0.5 * (464 - gameHeight));
				_view.content.scaleX = gameScale;
				_view.content.scaleY = gameScale;
			}
				
			
			if(!Global.debugging)
				Global.root.addChild(_view.content);
			if(!_view.ready)
			{
				_loadTasks.addCount();
				_view.readyEvent.addListener(_loadTasks.completeTask);
			}
			ToolTips.hideText();
			
			_loader = new SafeLoader(_view);
			_loader.completeEvent.setListener(_loadTasks.completeTask);
			_loader.load(new URLRequest(URLHelper.moduleUrl(moduleId)));
			MousePointer.resetIcon();
			return _currentModuleEvents;
		}
		
		private function trackAnalytics(moduleId : String):void
		{
			if(Global.debugging)
				return;
			var prefix : String = Locations.isLocation(moduleId) ? "/f/location/" : "/f/module/";
			Global.analyticsTracker.trackPageview(prefix + moduleId);
		}
		private function onLoadComplete():void
		{
			if (_loader.content is ModuleBase)
			{
				var module:ModuleBase = ModuleBase(_loader.content)
				module.parameters = _parameters; 
				module.destroyEvent.addListener(onModuleDestroy);
				module.destroyEvent.addListener(_currentModuleEvents.destroyEvent.sendEvent);
				
				if (module is WindowModule)
				{
					GraphUtils.attachModalShadow(module);
					Global.windowsContainer.addChild(module);
				}
				else if (module is LocationModule)
				{
					Global.locationManager.destroyLocation();
					Global.locationContainer.addChild(module);
				}
				
				module.readyEvent.addListener(onModuleReady);
				module.initialize();
				module.id = _moduleId;
			}
			else
			{
				var loc:LocationBase = new LocationBase(_moduleId, _parameters.remoteId);
				loc.setContent(Sprite(_loader.content));
				loc.readyEvent.addListener(onModuleReady);
				Global.locationManager.changeLocation(loc);
				loc.destroyEvent.addListener(_currentModuleEvents.destroyEvent.sendEvent);
			}
			
			MousePointer.resetIcon();
			_view.text = Global.messages.connecting || 'Connecting...';
			_loader = null;
		}
		
		private function onModuleReady():void
		{
			_currentModules.push(_moduleId);
			GraphUtils.detachFromDisplay(_view.content);
			moduleReadyEvent.sendEvent();
			_currentModuleEvents.loadEvent.sendEvent();	
		}
		
		private function onModuleDestroy(module:ModuleBase):void
		{
			_currentModules.removeItem(module.id);
			if (module.stage)
				GraphUtils.detachFromDisplay(module);
		}
		
		public function get moduleReadyEvent():EventSender { return _moduleReadyEvent; }

	}
}