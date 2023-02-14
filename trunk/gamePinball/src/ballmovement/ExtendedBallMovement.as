package ballmovement
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	public class ExtendedBallMovement extends BallMovement
	{
		private var condPoint:MovieClip;
		private var finishCondPoint:MovieClip;
		private var startSpeed:int;
		private var endPoint:MovieClip
		
		
		public function ExtendedBallMovement(gameBall:GameBall, param:BallMovementParam, startSpeed:int, condPoint:MovieClip, finishCondPoint:MovieClip)
		{
			super(gameBall, param);
			this.condPoint = condPoint;
			this.finishCondPoint = finishCondPoint;
			this.startSpeed = startSpeed;
			this.secondPoint = param.checkPoints[1];
		}
		
		override public function get finishCoords():Point
		{
			return new Point(finishPoint.x, finishPoint.y); 	
		}
		
		
		override protected function update() : void
		{
			if (PinballUtils.circleIntersects(gameBall.ball, condPoint) && startSpeed > -100)
			{
				_gameBall.ball.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_gameBall.ball.visible = true;
				finishPoint = finishCondPoint;
				finish.sendEvent(this);
				return;
			}
			super.update();	
		}
	}
}