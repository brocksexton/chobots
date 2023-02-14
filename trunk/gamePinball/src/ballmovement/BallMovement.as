package ballmovement
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import com.kavalok.events.EventSender;
	import org.rje.glaze.engine.math.Vector2D;
	
	public class BallMovement
	{
		protected var _gameBall:GameBall;
		protected var firstPoint:MovieClip;
		protected var secondPoint:MovieClip;
		protected var finishPoint:MovieClip;
		protected var _finishVelocity:Vector2D;
		protected var ballCurveMovement:BallCurveMovement;
		protected var ballClipMovement:BallClipMovement;
		
		protected var continueDraw:Boolean = false;
		
		private var _willUseBody:Boolean;
		private var _finish:EventSender = new EventSender();
		private var _removeRigidBody:EventSender = new EventSender();
		
		private var _initBallLayer:uint;
		
		public function BallMovement(gameBall:GameBall, param:BallMovementParam)
		{	
			this._gameBall = gameBall;
			this._initBallLayer = _gameBall.ball.parent.getChildIndex(_gameBall.ball);
			if (param.bottomMovieClip != null)
			{
				var ball:MovieClip = _gameBall.ball;
				var layerInd:uint = _gameBall.ball.parent.getChildIndex(param.bottomMovieClip);
				_gameBall.ball.parent.setChildIndex(ball, layerInd + 1);	
			}
			if (param.checkPoints != null)
			{
				this.firstPoint = param.checkPoints[0];
				this.secondPoint = param.checkPoints[0];
			}
			this.finishPoint = param.finishPoint;
			this._finishVelocity = param.finishVelocity;
			this.gameBall.ball.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this._willUseBody = param.willUseBody;
			var speed:int;
			if (_gameBall.ballBody.v.x < 0 || _gameBall.ballBody.v.y < 0)
			{
				speed = Math.min(_gameBall.ballBody.v.x, _gameBall.ballBody.v.y) 
			} 
			else
			{
				speed = Math.max(_gameBall.ballBody.v.x, _gameBall.ballBody.v.y)
			}
			ballCurveMovement = new BallCurveMovement(_gameBall.ball, param.checkPoints, speed*param.speedmult, param.acceleration);
			ballClipMovement = new BallClipMovement(_gameBall.ball, param.clip);	
		}
		
		protected function onEnterFrame(event : Event):void
		{
			update();
		}
		
		public function get finishCoords() : Point
		{
			return new Point(finishPoint.x, finishPoint.y);
		}
		
		public function get willUseBody() : Boolean
		{
			return _willUseBody;
		}
		
		public function get finishVelocity() : Vector2D
		{
			return new Vector2D(_finishVelocity.x, _finishVelocity.y)
		}
		
	
		public function get finish():EventSender
		{
			return _finish;
		}
		
		public function get gameBall():GameBall
		{
			return _gameBall;
		}
		
		public function get removeRigidBody():EventSender
		{
			return _removeRigidBody;
		}
		
		public function get initBallLayer():uint		
		{
			return _initBallLayer;
		}
	
		
		protected function update() : void
		{
			if (_removeRigidBody != null)
			{
				_removeRigidBody.sendEvent(this.gameBall);
				_removeRigidBody = null;	
			}
			
			var ballMovementState : ReturnResult = ballCurveMovement.draw(); 
			while (!ballMovementState.finishedDrawing)
			{
				return;
			} 
			if (ballMovementState.exitDrawing)
			{
				_gameBall.ball.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_gameBall.ball.visible = true;
				finishPoint = secondPoint;
				finish.sendEvent(this);
				return;			
			}
			ballMovementState = ballClipMovement.draw();
			while (!ballMovementState.finishedDrawing)
			{
				return;
			}
			_gameBall.ball.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_gameBall.ball.visible = true;
			finish.sendEvent(this);
		}	
	}
	

}