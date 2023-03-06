package com.kavalok.missionNichos.location.entryPoint
{
	import com.kavalok.Global;
	import com.kavalok.char.Directions;
	import com.kavalok.char.LocationChar;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.RopeEntryPointBase;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.SmoothCurveRope;

	public class NichosRopeEntryPoint extends RopeEntryPointBase
	{
		public function NichosRopeEntryPoint(remoteId : String, location : LocationBase){
			START_LEFT_POSITION_X = 585;
			START_LEFT_POSITION_Y = 355;

			END_LEFT_POSITION_X = 550;
			END_LEFT_POSITION_Y = 405;

			START_RIGHT_POSITION_X = 795;
			START_RIGHT_POSITION_Y = 115;

			END_RIGHT_POSITION_X = 795;
			END_RIGHT_POSITION_Y = 115;


			START_ROPE_POSITION_X = 425;
			START_ROPE_POSITION_Y = 335;

			CENTER_POSITION_X = 795;
			CENTER_POSITION_Y = 115;
			
			ROPE_PLACE_OFFSET_X = 25;
			ROPE_PLACE_OFFSET_Y = -25;
			
			UPDATE_RIGHT_CURVE = false;

			BONUS = 400;
			ROPE_COLOR = 0xFFFE65;

			GIVE_BONUS_IF_ONE_TEAM = true;

			super(remoteId, location);
		}

		override public function get id() : String
		{
			return "NichosRopeEntryPoint";
		}
	}
}