package com.kavalok.missionNichos.location.entryPoint
{
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.EntryPointBase;
	import com.kavalok.missionNichos.NPCDialog;
	import com.kavalok.missionNichos.NichosStage2;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class GuneEntryPoint extends EntryPointBase
	{
		private var _alreadyShown : Boolean = false;
		private var _loc : NichosStage2;
		
		public function GuneEntryPoint(location:LocationBase)
		{
			super(location, "gunestatue", null);
			_loc = NichosStage2(_location);;
		}
		
		override public function initialize(clip : MovieClip):void
		{
			clip.buttonMode = true;
			MousePointer.registerObject(clip, MousePointer.ACTION);
		}
		override public function goIn():void
		{
			super.goIn();
			var dialog:NPCDialog = new NPCDialog(_loc.missionPassed, _alreadyShown);
			dialog.execute();
		 	if(_loc.missionPassed){
		 		_alreadyShown = true;
		 	}
		}
		
		override protected function onClick(event : MouseEvent) : void
		{
			if(_loc.missionPassed){
				clickedClip = MovieClip(event.currentTarget);
				activateEvent.sendEvent(this);
			}else{
				goIn();
			}
		}
		
		
		
	}
}