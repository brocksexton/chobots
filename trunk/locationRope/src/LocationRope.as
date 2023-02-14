package {
	import com.kavalok.Global;
	import com.kavalok.locationRope.Location;
	import com.kavalok.modules.ModuleBase;

	public class LocationRope extends ModuleBase
	{
		override public function initialize():void
		{
			var location : Location = new Location('locationRope');
			location.readyEvent.addListener(readyEvent.sendEvent);
			Global.locationManager.changeLocation(location);
		}
	}
}
