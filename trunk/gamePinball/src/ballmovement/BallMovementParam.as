package ballmovement
{
	import flash.display.MovieClip;
	
	import org.rje.glaze.engine.math.Vector2D;
	
	public class BallMovementParam
	{
		public var checkPoints:Array;
		public var speedmult:Number;
		public var acceleration:Number;
		public var clip:MovieClip;
		public var finishPoint:MovieClip;
		public var finishVelocity:Vector2D;
		public var willUseBody:Boolean;
		public var bottomMovieClip:MovieClip;
		
		public function BallMovementParam(checkPoints:Array, speedmult:Number, acceleration:Number, clip:MovieClip, finishPoint:MovieClip, finishVelocity:Vector2D, willUseBody:Boolean, bottomMovieClip:MovieClip)
		{
			this.checkPoints = checkPoints;
			this.speedmult = speedmult;
			this.acceleration = acceleration;
			this.clip = clip;
			this.finishPoint = finishPoint;
			this.finishVelocity = finishVelocity;
			this.willUseBody = willUseBody;
			this.bottomMovieClip = bottomMovieClip;
		}

	}
}