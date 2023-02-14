package
{
	import com.kavalok.Global;
	import com.kavalok.locGraphity.Location;
	import com.kavalok.modules.ModuleBase;

	public class LocGraphityA extends ModuleBase
	{
		override public function initialize():void
		{
			var location:Location = new Location('locGraphityA');
			location.readyEvent.addListener(readyEvent.sendEvent);
			Global.locationManager.changeLocation(location);
		}
	}
}
