package {
	import com.kavalok.Global;
	import com.kavalok.commands.IAsincCommand;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.robotConfig.commands.StartupCommand;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class RobotConfig extends WindowModule
	{
		[Embed('../fonts/BlackWolf.ttf',
			mimeType = "application/x-font",
			fontFamily = 'ModuleFont'
			)]
		static public var moduleFont:Class;
		
		static private var _instance:RobotConfig;
		static public function get instance():RobotConfig
		{
			return _instance;	
		}
		
		public function RobotConfig()
		{
			_instance = this;
			
			Font.registerFont(moduleFont);
			
			if (Global.charManager.hasRobot)
			{
				var command:StartupCommand = new StartupCommand(this);
				command.completeEvent.addListener(onStartupComplete);
				command.execute();
			}
			else
			{
				Dialogs.showOkDialog(Global.resourceBundles.robots.messages.haveNotRobot);
				addEventListener(Event.ENTER_FRAME, forceCloseModule);
			}
		}
		
		private function forceCloseModule(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, forceCloseModule);
			readyEvent.sendEvent();
			closeModule();
		}
		
		private function onStartupComplete(sender:IAsincCommand):void
		{
			readyEvent.sendEvent();
		}
		
		public function initButton(button:SimpleButton):void
		{
			var fields:Array = GraphUtils.extractTextFieldsFromButton(button);
			for each (var field:TextField in fields)
			{
				RobotConfig.instance.initTextField(field);	
			}
		}
		
		public function initTextField(field:TextField):void
		{
			var format:TextFormat = field.getTextFormat(0, 1);
			format.font = 'ModuleFont';
			
			field.embedFonts = true;
			field.selectable = false;
			field.defaultTextFormat = format;
			field.setTextFormat(format);
			field.antiAliasType = AntiAliasType.ADVANCED;
		}		
	}
}
