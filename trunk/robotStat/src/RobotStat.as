package {
	import com.kavalok.modules.WindowModule;
	import com.kavalok.robotStat.StatView;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class RobotStat extends WindowModule
	{
		[Embed('../fonts/BlackWolf.ttf',
			mimeType = "application/x-font",
			fontFamily = 'ModuleFont'
			)]
		static public var moduleFont:Class;
		
		static private var _instance:RobotStat;
		static public function get instance():RobotStat
		{
			return _instance;	
		}
		
		public function RobotStat()
		{
			_instance = this;
		}
		
		override public function initialize():void
		{
			addChild(new StatView().content);
			readyEvent.sendEvent();
		}
		
		public function initTextFields(container:DisplayObjectContainer):void
		{
			var fields:Array = GraphUtils.getAllChildren(container,	new TypeRequirement(TextField));
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
