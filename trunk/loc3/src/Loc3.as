package {
	import com.kavalok.Global;
	import com.kavalok.loc3.Location;
	import com.kavalok.modules.ModuleBase;

	public class Loc3 extends ModuleBase
	{
		override public function initialize():void
		{
			var location : Location = new Location('loc3');
			location.readyEvent.addListener(readyEvent.sendEvent);
			Global.locationManager.changeLocation(location);
		}
	}
}
