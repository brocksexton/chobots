package
{
	import com.kavalok.Global;
	import com.kavalok.missionFarm.FarmStage;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.utils.EventManager;
	
	public class MissionFarm extends ModuleBase
	{
		static private var _eventManager:EventManager;
		
		override public function initialize():void
		{
			MissionFarm._eventManager = this.eventManager;
			var loc:FarmStage = new FarmStage(parameters.remoteId);
			loc.readyEvent.addListener(readyEvent.sendEvent);
			Global.locationManager.changeLocation(loc);
		}
		
		static public function get eventManager():EventManager
		{
			return _eventManager;
		}
	}
	
}