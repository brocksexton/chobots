package com.kavalok.locationRope.entryPoints
{
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.RopeEntryPointBase;

	public class RopeEntryPoint extends RopeEntryPointBase
	{

		public function RopeEntryPoint(remoteId:String, location:LocationBase)
		{

			END_LEFT_POSITION_Y=327;
			END_RIGHT_POSITION_Y=327;
			BONUS=2;
			GIVE_BONUS_IF_ONE_TEAM = false;
			ROPE_PLACE_OFFSET_X=33;
			ROPE_PLACE_OFFSET_Y=0;
			START_LEFT_POSITION_X=465;
			START_LEFT_POSITION_Y=307;
			START_RIGHT_POSITION_X=675;
			START_RIGHT_POSITION_Y=307;
			CENTER_POSITION_X=(START_LEFT_POSITION_X + START_RIGHT_POSITION_X) / 2;
			CENTER_POSITION_Y=307;
			START_ROPE_POSITION_X=441;
			START_ROPE_POSITION_Y=307;
			END_LEFT_POSITION_X=390;
			END_RIGHT_POSITION_X=725;
			UPDATE_RIGHT_CURVE=true;
			UPDATE_LEFT_CURVE=true;
			
			ROPE_COLOR = 0xFF9900

			super(remoteId, location);
		}

	}
}



