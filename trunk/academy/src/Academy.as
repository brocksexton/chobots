package {
	
	import com.kavalok.academy.McAcademy;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.events.MouseEvent;

	public class Academy extends WindowModule
	{
		private var _content:McAcademy = new McAcademy();
		
		public function Academy()
		{
			initContent();
			addChild(_content);
		}
		
		override public function initialize():void
		{
			readyEvent.sendEvent();
		}
		
		private function initContent():void
		{
			new ResourceScanner().apply(_content);
			_content.closeButton.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		private function onClose(e:MouseEvent):void
		{
			closeModule();
		}
	}
}
