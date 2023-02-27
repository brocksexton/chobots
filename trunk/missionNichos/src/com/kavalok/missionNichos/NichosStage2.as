package com.kavalok.missionNichos
{
	import com.kavalok.location.ModelsFactory;
	import com.kavalok.missionNichos.location.entryPoint.GuneEntryPoint;
	import com.kavalok.missionNichos.location.entryPoint.MoneyEntryPoint;
	import com.kavalok.missionNichos.location.entryPoint.NichosRopeEntryPoint;
	import com.kavalok.missionNichos.location.modifiers.StagePassModifier;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class NichosStage2 extends NichosStageBase
	{

		private static const LOC_ID:String='missionNichos';

		private var _columnsPassModifier:StagePassModifier;
		private var _content:McLocation2;
		private var _ropeEntry:NichosRopeEntryPoint;
		private var _missionPassed:Boolean=false;

		public function NichosStage2()
		{
			_content=new McLocation2();
			super(LOC_ID, "missionNichos2", _content);
			MovieClip(content).ground.groundEnd.visible=false;
			_content.finalAnim.gotoAndStop(1);
			//_content.finalAnim.gotoAndPlay(1);
			_charModelsFactory=new ModelsFactory();

			addPoint(new MoneyEntryPoint(this));
			addPoint(new GuneEntryPoint(this));

			_ropeEntry = new NichosRopeEntryPoint(remoteId, this);
			_ropeEntry.ropeSuccessEvent.addListener(onRopeSuccess);
			addPoint(_ropeEntry);


		}

		public function onRopeSuccess():void
		{
			if (!_missionPassed)
			{
				_ropeEntry.bonus=1;
				_content.finalAnim.addEventListener(Event.ENTER_FRAME, onEnterFailFrame);
				disableDarkness();
				_content.finalAnim.play();
			}
		}

		private function onEnterFailFrame(e:Event):void
		{
			var obj:MovieClip=MovieClip(e.currentTarget);
			if (obj.currentFrame == obj.totalFrames)
			{
				obj.stop();
				MovieClip(content).ground.groundEnd.visible=true;
				_missionPassed = true;
			}
		}
		
		public function get missionPassed():Boolean
		{
			return _missionPassed;
		}

	}
}







