package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.pinball.space.EventSpace;
	
	import flash.display.MovieClip;
	
	import org.rje.glaze.engine.dynamics.RigidBody;

	public class LineMovementBuilder extends DynamicSpaceBuilderBase
	{
		public function LineMovementBuilder(ballBody:RigidBody)
		{
			super("line", ballBody);
		}
		
		override protected function createProcessor(game : GamePinball, space:EventSpace, movie:MovieClip, ballBody:RigidBody, params:Object):IDynamicProcessor
		{
			return new LineMovement(game, space, movie, ballBody, params);
		}
	}
}