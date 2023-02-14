package com.kavalok.missionNichos
{
	import com.kavalok.missionNichos.location.entryPoint.MoneyEntryPoint;
	import com.kavalok.missionNichos.location.modifiers.StagePassModifier;
	
	import flash.display.MovieClip;

	public class NichosStage1 extends NichosStageBase
	{

		private static const LOC_ID:String='missionNichos';

		private var _location:McLocation;
		private var _columnsPassModifier:StagePassModifier;

		public function NichosStage1()
		{
			super(LOC_ID, "missionNichos1", new McLocation());
			addPoint(new MoneyEntryPoint(this));
			
			if(!hasLight()){
				_blurContainer.width=201;
				_blurContainer.height=201;
				_blurContainer.x=146;
				_blurContainer.y=109;
				this.content.mask.width=200;
				this.content.mask.height=200;
				this.content.mask.x=146;
				this.content.mask.y=109;
			}
			
		}
	}

}













