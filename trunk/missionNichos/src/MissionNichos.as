package
{
	import com.kavalok.Global;
	import com.kavalok.location.LocationBase;
	import com.kavalok.missionNichos.NichosStage1;
	import com.kavalok.missionNichos.NichosStage2;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.utils.EventManager;



	public class MissionNichos extends ModuleBase
	{
		static private var _eventManager:EventManager;

		override public function initialize():void
		{
			MissionNichos._eventManager=this.eventManager;
			var loc : LocationBase = '2' == parameters.stage ? new NichosStage2() : new NichosStage1();

			loc.readyEvent.addListener(readyEvent.sendEvent);
			Global.locationManager.changeLocation(loc);

		}

		static public function get eventManager():EventManager
		{
			return _eventManager;
		}
	}

}



