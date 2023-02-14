package {
	import com.kavalok.Global;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.danceConstructor.DanceConstructorView;
	import com.kavalok.danceConstructor.McBackground;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.frame.bag.dance.DanceSerializer;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.services.CharService;
	
	import flash.events.MouseEvent;

	public class DanceConstructor extends WindowModule
	{
		private var _view : DanceConstructorView;
		
		public function DanceConstructor()
		{
		}
		
		override public function initialize():void
		{
			Global.isLocked = true;
			new CharService(onCharInfo).getCharView(Global.charManager.userId);
		}
		private function onCharInfo(result:Object):void
		{
			Global.isLocked = false;
			var content : McBackground = new McBackground();
			_view = new DanceConstructorView(result, content);
			var dance : ArrayList = new ArrayList(Global.charManager.dances[parameters.index]);
			dance.removeFirst();
			dance.removeLast();
			if(dance.length > 0)
				_view.frames = dance; 
			content.saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
			content.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
			content.closeButton.addEventListener(MouseEvent.CLICK, onCancelClick);
			addChild(_view.content);
			readyEvent.sendEvent();
		}
		
		private function onSaveClick(event : MouseEvent) : void
		{
			if (Global.charManager.isGuest || Global.charManager.isNotActivated)
			{
				new RegisterGuestCommand().execute();
			}
			else if(!Global.charManager.isCitizen)
			{
				new CitizenWarningCommand("dance", Global.messages.itemForCitizens, closeModule).execute()
			}
			else
			{
				Global.charManager.dances[parameters.index] = _view.finalFrames;
				new CharService().saveDance(new DanceSerializer().serialize(_view.finalFrames), parameters.index);
				closeModule();
			}
		}
		
		private function onCancelClick(event : MouseEvent) : void
		{
			closeModule();
		}
		
	}
}
