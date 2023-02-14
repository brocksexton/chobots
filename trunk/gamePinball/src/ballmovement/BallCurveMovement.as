package ballmovement
{
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	import com.kavalok.interfaces.IRequirement;
	import com.kavalok.utils.Maths;
	
	internal class BallCurveMovement
	{
		private var ball:MovieClip;
		private var pointsMovieClip:Array;
		private var firstPoint:MovieClip;
		private var endPoint:MovieClip;
		private var speed:Number;
		private var accelerationConst:Number
		private var acceleration:Number;
		private var points:ArrayCollection;
		
		public function BallCurveMovement(ball:MovieClip, pointsMovieClip:Array, speed:Number, acceleration:Number)
		{
			this.ball = ball;
			this.speed = speed;
			this.accelerationConst = acceleration;
			this.acceleration = acceleration;
			
			if (pointsMovieClip != null)
			{
				this.firstPoint = MovieClip(pointsMovieClip[0]);
				this.endPoint = MovieClip(pointsMovieClip[pointsMovieClip.length - 1]);
				this.points = new ArrayCollection();
				for (var i : uint = 0; i < pointsMovieClip.length; i++)
				{
					this.points.addItem(new Point(MovieClip(pointsMovieClip[i]).x, MovieClip(pointsMovieClip[i]).y));
				}
			}
		}
		
		
		public function draw():ReturnResult
		{
			if (points == null)
			{
				return new ReturnResult(true, false);
			}
			
			if (PinballUtils.circleIntersects(ball, firstPoint))
			{
				return new ReturnResult(true, true);
			}	
			
			if (PinballUtils.circleIntersects(ball, endPoint))
			{
				
				return new ReturnResult(true, false);
			}
			
			ball.x += speed;
			ball.y = Maths.getInterpolatedValue(points, ball.x);
			speed += acceleration;
			acceleration += accelerationConst;
			
			return new ReturnResult(false, false);	
		}

	}
}