package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.pinball.space.EventSpace;
	
	import flash.display.MovieClip;
	
	import org.rje.glaze.engine.dynamics.RigidBody;

	public class AnimationBuilder extends DynamicSpaceBuilderBase
	{
		private static const ANIMATION : String = "animation";
		
		public function AnimationBuilder(ballBody : RigidBody)
		{
			super(ANIMATION, ballBody);
		}
		
		override protected function createProcessor(game : GamePinball, space:EventSpace, movie:MovieClip, ballBody:RigidBody, params:Object):IDynamicProcessor
		{
			return new Animation(game, space, movie, ballBody, params);
		}
		
	}
}