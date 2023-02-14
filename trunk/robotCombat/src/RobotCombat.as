package {
	import com.kavalok.Global;
	import com.kavalok.dto.robot.CombatActionTO;
	import com.kavalok.dto.robot.CombatResultTO;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.robotCombat.commands.StartupCommand;
	import com.kavalok.robots.CombatParameters;
	import com.kavalok.robots.RobotUtil;
	
	import flash.text.Font;

	public class RobotCombat extends LocationModule
	{
		[Embed('../fonts/BlackWolf.ttf',
			mimeType = "application/x-font",
			fontFamily = 'ModuleFont'
			)]
		static public var moduleFont:Class;
		
		static private var _instance:RobotCombat;
		static public function get instance():RobotCombat
		{
			return _instance;	
		}
		
		public function RobotCombat()
		{
			_instance = this;
			//traceTable();
		}
		
		override public function initialize():void
		{
			Font.registerFont(moduleFont);
			CombatActionTO.initialize();
			CombatResultTO.initialize();
			
			new StartupCommand(this).execute();
			readyEvent.sendEvent();
		}
		
		public function get opponentId():int
		{
			return CombatParameters(parameters).opponentId;
		}
		
		override public function closeModule():void
		{
			Global.locationManager.returnToPrevLoc();
			super.closeModule();
		}
		
		private function traceTable():void
		{
			for (var level:int = 1; level <= 20; level++)
			{
				trace(
					RobotUtil.getEnergy(level),
					RobotUtil.getExperience(level),
					RobotUtil.getEarnedExp(level),
					RobotUtil.getRepairCost(level),
					RobotUtil.getEarnedMoney(level)
					)
			}
		}
	}
}
