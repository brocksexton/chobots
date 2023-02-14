package  
{
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.family.FamilyView;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.services.CharService;
	
	public class Family extends WindowModule
	{
		private var _view:FamilyView;
		
		private var _chars:Array = [];
		
		override public function initialize():void
		{
			new CharService(onGetInfo).getFamilyInfo();
		}
		
		private function onGetInfo(result:Array):void
		{
			initFamily(result);
			
			_view = new FamilyView(this);
			addChild(_view.content);
			
			readyEvent.sendEvent();
		}
		
		private function initFamily(infoList:Array):void
		{
			for each (var info:Object in infoList)
			{
				_chars.push(new Char(info));
			}
			
		}
		
		public function get chars():Array
		{
			 return _chars;
		}
		
	}
	
}