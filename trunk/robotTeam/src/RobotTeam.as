package {
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.robotTeam.TeamCreateView;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.SimpleButton;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class RobotTeam extends ModuleBase
	{
		static private var _instance:RobotTeam;
		static public function get instance():RobotTeam
		{
			 return _instance;
		}
		
		[Embed('../fonts/BlackWolf.ttf', mimeType = "application/x-font", fontFamily = 'ModuleFont')]
		static public var moduleFont:Class;
		
		private var _view:TeamCreateView;
		
		public function RobotTeam()
		{
			_instance = this;
		}
		
		override public function initialize():void
		{
			if (Global.charManager.hasRobot)
			{
				_view = new TeamCreateView();
				_view.show();
			}
			else
			{
				var dialog:DialogOkView = Dialogs.showOkDialog(Global.resourceBundles.robots.messages.haveNotRobot);
				dialog.ok.addListener(closeModule);
			}
			readyEvent.sendEvent();
		}
		
		override public function closeModule():void
		{
			if (_view)
				_view.hide();
			super.closeModule();
		}
		
		public function initButton(button:SimpleButton):void
		{
			var fields:Array = GraphUtils.extractTextFieldsFromButton(button);
			for each (var field:TextField in fields)
			{
				initTextField(field);	
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
			field.text = '';
		}		
		
	}
}
