package {
	import com.kavalok.CinemaLocation;
	import com.kavalok.Global;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.utils.TaskCounter;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class LocationCinema extends LocationModule
	{
		private static var _loader : Loader;
		private static var _counter : TaskCounter = new TaskCounter(2);
		
		override public function initialize() : void
		{
			if(Global.youtubePlayer)
			{
				createLocation(Global.youtubePlayer);
			}
			else
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPlayerLoaded);
				Global.youtubePlayer = _loader;
				_loader.load(new URLRequest(Global.serverProperties.videoPlayerURL));
			}
		}
		
		private function onPlayerLoaded(event : Event) :void
		{
			createLocation(_loader);
		}
		
		private function createLocation(player : DisplayObject) : void
		{
			var location : CinemaLocation = new CinemaLocation(player);
			location.readyEvent.addListener(_counter.completeTask);
			location.initializeEvent.addListener(_counter.completeTask);
			_counter.completeEvent.addListener(readyEvent.sendEvent);
			Global.locationManager.changeLocation(location);
		}
	}
}
