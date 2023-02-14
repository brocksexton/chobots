package {
	import com.kavalok.Global;
	import com.kavalok.dialogs.DialogBuyAccount;
	import com.kavalok.external.ExternalCalls;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.display.Sprite;

	public class Membership extends WindowModule
	{
		private var _showBorder : Boolean;
		public function Membership()
		{
			//var view : MembershipView = new MembershipView(true);
			var view : DialogBuyAccount = new DialogBuyAccount("site");
			new ResourceScanner().apply(view.content);
			addChild(view.content);
			//Global.externalCalls.changeModeEvent.addListener(onChangeMode);
			view.closeEvent.addListener(closeModule);
			destroyEvent.addListener(onModuleDestroy);
			if(Global.border)
			{
				_showBorder = Global.border.visible;
				Global.border.visible = true;
			}
			
		}
		
		override public function initialize():void
		{
			readyEvent.sendEvent();
			ExternalCalls.callExternal("ch_set_active_page", ExternalCalls.MEMBERSHIP);
		}
		
		
		private function onChangeMode() : void
		{
			if(Global.externalCalls.getMode() != ExternalCalls.MEMBERSHIP)
				closeModule();
		}
		private function onModuleDestroy(sender : Membership) : void
		{
			if(Global.border)
				Global.border.visible = _showBorder;
			//Global.externalCalls.changeModeEvent.removeListener(onChangeMode);
			ExternalCalls.callExternal("ch_set_active_page", ExternalCalls.HOMEPAGE);
		}
		
	}
}
