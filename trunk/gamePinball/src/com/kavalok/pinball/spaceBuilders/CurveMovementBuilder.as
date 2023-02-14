package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.pinball.space.EventSpace;
	
	import flash.display.MovieClip;
	
	import org.rje.glaze.engine.dynamics.RigidBody;
	
	public class CurveMovementBuilder extends DynamicSpaceBuilderBase
	{
		private static const CURVE : String = "curve";
		
		public function CurveMovementBuilder(ball : RigidBody)
		{
			super(CURVE, ball);
		}
		
		override protected function createProcessor(game : GamePinball, space:EventSpace, movie:MovieClip, ballBody:RigidBody, params:Object):IDynamicProcessor
		{
			return new CurveMovement(game, space, movie, ballBody, params);
		}
		
	}
}