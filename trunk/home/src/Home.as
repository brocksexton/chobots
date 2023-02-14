package {
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.dto.home.CharHomeTO;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.home.HomeFrameView;
	import com.kavalok.home.HomeLocation;
	import com.kavalok.home.data.FurnitureInfo;
	import com.kavalok.loaders.LocationLoaderView;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.location.LocationManager;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	

	public class Home extends ModuleBase
	{
		private static const HOME_FILE_FORMAT : String = "home{0}";
		
		private var _view : LocationLoaderView = new LocationLoaderView();
		private var _loader : SafeLoader;
		private var _home : CharHomeTO;
		private var _room : int;
		private var _homeFrameView : HomeFrameView;
		private var _location : HomeLocation;
		public var didLike:Boolean = false;
		public var likedUsers:String = "";
		public var likedUsersArray:Array = [ ];
		
		public function Home()
		{
			CharHomeTO.initialize();			
		}
		
		
		override public function initialize():void
		{
			readyEvent.sendEvent();
			new CharService(onGetCharHome).getCharHome(parameters.userId);
			Global.root.addChild(_view.content);
			if((Global.charManager.userId == parameters.userId) || (Global.charManager.isDev))
			{
				_homeFrameView = new HomeFrameView();
				Global.frame.content.addChild(_homeFrameView.content);
				_homeFrameView.stuffSelectEvent.addListener(onStuffSelect);
				_homeFrameView.editModeEvent.addListener(onEditMode);
			}
			Global.isLocked = true;
		}
		
		
		private function onDestroy() : void
		{
			Global.locationManager.locationDestroy.removeListener(onDestroy);
			if(_homeFrameView)
				Global.frame.content.removeChild(_homeFrameView.content);
		}

		private function onGetCharHome(home : CharHomeTO) : void
		{
			_home = home;
			//likedUsers = _home.crit;
			//likedUsersArray = likedUsers.split(",");
			_room = parameters.room == null ? 0 : parameters.room; 
			var homeFile : String = URLHelper.resourceURL(Strings.substitute(HOME_FILE_FORMAT, _room), "home");
			_loader = new SafeLoader(_view);
			_loader.load(new URLRequest(homeFile));
			_loader.completeEvent.addListener(onLoad);
			if(_homeFrameView)
			{
				_homeFrameView.furniture = _home.furniture;
			}
			//likedUsers = _home.crit.split(",");
		//	didLike = likedUsersArray.indexOf(Global.charManager.charId) != -1;
		//	trace("did like: " + didLike);
		//	trace("liked users: " + likedUsers);

		}	
			
		private function onDragFinish(info : FurnitureInfo) : void
		{
			if(_homeFrameView.overBox)
			{
				_homeFrameView.addFurniture(info.item);
				_location.removeMyFurniture(info);
			}
		}
		
		private function onEditMode(value : Boolean) : void
		{
			_location.editMode = value;
		}
		private function onStuffSelect(item : StuffItemLightTO) : void
		{
			_location.addMyFurniture(item);
		}
		
		private function onLoad() : void
		{
			_location = new HomeLocation(parameters.charId, parameters.userId, _home, _room, _homeFrameView);
			_location.readyEvent.addListener(onLocationReady);
			var content : MovieClip = MovieClip(_loader.content);
			_location.setContent(content);
			Global.locationManager.changeLocation(_location);
			Global.locationManager.locationDestroy.addListener(onDestroy);
			
			if(Global.charManager.charId == parameters.charId)
			{
				_location.dragFinishEvent.addListener(onDragFinish);
			}
		}
		
		private function onLocationReady() : void
		{
			Global.isLocked = false;
			Global.root.removeChild(_view.content);
			
		}
		
	}
}
