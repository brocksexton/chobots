package {
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.academySelector.SelectorView;
	import com.kavalok.loaders.LoadURLCommand;
	import com.kavalok.modules.LocationModule;

	public class AcademySelector extends LocationModule
	{
		static private var _instance:AcademySelector;
		
		override public function initialize():void
		{
			_instance = this;
			
			new LoadURLCommand(folderURL + '/content.xml', onXMLComplete).execute();
		}
		
		public function onXMLComplete(data:Object):void
		{
			var itemsInfo:XML = new XML(data);
			changeView(new SelectorView(itemsInfo));
			
			readyEvent.sendEvent();
		}
		
		public function goto(moduleId:String):void
		{
			Global.moduleManager.loadModule(moduleId);
			closeModule();
		}
		
		public function close():void
		{
			Global.locationManager.returnToPrevLoc();
			closeModule();
		}
		
		public function get folderURL():String
		{
			return URLHelper.moduleFolder("academySelector") + parameters.folder;
		}
		
		public static function get instance():AcademySelector
		{
			 return _instance;
		}
	}
}
