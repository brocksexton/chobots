package {
	import com.kavalok.Global;
	import com.kavalok.locDudes.Location;
	import com.kavalok.modules.ModuleBase;
    import com.kavalok.locDudes.entryPoints.RopeEntryPoint;
	public class LocDudes extends ModuleBase
	{
			private var _ropeEntry:RopeEntryPoint;
		override public function initialize():void
		{
			var location : Location = new Location('locDudes');
			location.readyEvent.addListener(readyEvent.sendEvent);
			Global.locationManager.changeLocation(location);
			
			
		}
		
	}
}
