package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.pinball.space.EventSpace;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.dynamics.RigidBody;

	public class LineMovement extends CurveMovement
	{
		public function LineMovement(game:GamePinball, space:EventSpace, object:MovieClip, ballBody:RigidBody, params:Object)
		{
			super(game, space, object, ballBody, params);
		}
		
		override protected function getY(x:Number):Number
		{
			var i : uint = 0;
			while(greater(x, points[i].x))
			{
				i++;
			}
			var nextPoint : Point = points[i];
			var previousPoint : Point = points[i - 1];
			return previousPoint.y + (nextPoint.y - previousPoint.y) * (x - previousPoint.x) / (nextPoint.x - previousPoint.x);
		}
		
		private function greater(x : Number, newX : Number) : Boolean
		{
			if(direction > 0)
			{
				return x > newX;
			}
			else
			{
				return x <= newX;
			}
		}
	}
}