package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.Global;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.pinball.PinballUtil;
	import com.kavalok.pinball.space.EventSpace;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.dynamics.RigidBody;
	
	public class CurveMovement implements IDynamicProcessor
	{
		private static const POINT_PREFIX : String = "point";
		
		private static const MAX_ANGLE : Number = Maths.degreesToRadians(45);
		private static const SPEED_COEFF : Number = 25;
		private static const MIN_SPEED : Number = 5;
		private static const WIDTH : Number = 5;
		
		protected var points : ArrayList = new ArrayList();
		protected var direction : Number;
		private var _started : Boolean;
		private var _space : EventSpace;
		private var _object : MovieClip;
		private var _ballBody : RigidBody;
		private var _maxDistance : Number;
		private var _finalSpeed : Point;
		private var _acc : Number = 0;
		private var _ignoreSpeed : Boolean;
		private var _level : String;
		private var _speedCoeff : Number = SPEED_COEFF;
		private var _startSpeed : Number = 0;
		
		private var _vx : Number;
		private var _game : GamePinball;
		
		public function CurveMovement(game : GamePinball, space : EventSpace, object : MovieClip, ballBody : RigidBody, params : Object)
		{
			_game = game;
			_ballBody = ballBody;
			_space = space;
			_object = object;
			_maxDistance = (GamePinball.BALL_RADIUS + WIDTH) * (GamePinball.BALL_RADIUS + WIDTH); 
			_ignoreSpeed = params.ignoreSpeed;
			_level = params.level;
			if(params.finalSpeedX != null)
			{
				_finalSpeed = new Point(params.finalSpeedX, params.finalSpeedY);
			}
			if(params.speedCoeff != null)
			{
				_speedCoeff = params.speedCoeff;
			}
			if(params.startSpeed != null)
			{
				_startSpeed = params.startSpeed;
			}
			if(params.acc != null)
			{
				_acc = params.acc;
			}
			var i : uint = 0;
			var point : MovieClip;
			do
			{
				point = _object[POINT_PREFIX + i];
				if(point != null)
				{
					i++;
					var globalPoint:Point = GraphUtils.transformCoords(new Point(), point, Global.root);
					points.addItem(globalPoint);
				}
			} while(point != null);
			direction = points.last.x - points.first.x;
			direction = direction / Math.abs(direction)
		}
		
		public function tryStart() : Boolean
		{
			if(_started)
				return false;
			var distanceSqr : Number = PinballUtil.getDistanceSqr(_ballBody.p, Point(points.first));
			var intersects : Boolean = distanceSqr < _maxDistance;
			if(intersects)
			{
				var direction : Point = new Point(points[1].x - points[0].x, points[1].y - points[0].y);
				var directionAngle : Number = Math.atan2(direction.y, direction.x);
				var angle : Number = directionAngle - Math.atan2(_ballBody.v.y, _ballBody.v.x);
				var speed : Number = _ballBody.v.x * _ballBody.v.x + _ballBody.v.y * _ballBody.v.y;
				//trace(speed, _startSpeed);
				if(_ignoreSpeed || (Math.abs(angle) < MAX_ANGLE && speed > _startSpeed))
				{
					_space.stoped = true;
					var v : Number = Math.cos(angle) * Math.sqrt(_ballBody.v.x *_ballBody.v.x + _ballBody.v.y * _ballBody.v.y);
					_vx = Math.cos(directionAngle) * v / _speedCoeff;
					if(Math.abs(_vx) < MIN_SPEED)
					{
						_vx = this.direction * MIN_SPEED;
					}
					start();
					return true;
				}
			}
			return false;
		}
		
		public function stop() : void
		{
			_started = false;
			_object.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function start() : void
		{
			if(_level != null)
			{
				_game.setBallLevel(_level);
			}
			_ballBody.p.setTo(points.first.x, points.first.y);
			_ballBody.v.setTo(0,0);
			_started = true;
			_object.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 1);
		}
		
		private function getSpeed(startPoint : Point, endPoint : Point) : Point
		{
			var angle : Number = Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
			var vY : Number = _vx * Math.tan(angle);
			return new Point(_vx * _speedCoeff, vY * _speedCoeff);
		}
		private function onEnterFrame(event : Event) :void
		{
			var point : Point;
			var speed : Point;
			if(direction > 0)
			{
				if(_ballBody.p.x + _vx >= points.last.x)
				{
					point = Point(points.last);
					speed = _finalSpeed || getSpeed(Point(points.getItemAt(points.length - 2)), Point(points.last));
				}
				else if(_ballBody.p.x < points.first.x)
				{
					point = Point(points.first);
					speed = getSpeed(Point(points.getItemAt(1)), Point(points.first));
				}
			} 
			else
			{
				if(_ballBody.p.x + _vx <= points.last.x)
				{
					point = Point(points.last);
					speed = _finalSpeed || getSpeed(Point(points.getItemAt(points.length - 2)), Point(points.last));
				}
				else if(_ballBody.p.x > points.first.x)
				{
					point = Point(points.first);
					speed = getSpeed(Point(points.getItemAt(1)), Point(points.first));
				}
			}
			
			if(point != null)
			{
				_object.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_ballBody.p.setTo(point.x, point.y);
				_ballBody.v.setTo(speed.x, speed.y);
				_space.stoped = false;
				_started = false;
				_game.setBallLevel(null);

			}
			else
			{
				_ballBody.p.x += _vx;
				_ballBody.p.y = getY(_ballBody.p.x);
			}
			_vx += _acc
		}
		
		protected function getY(x : Number) : Number
		{
			return Maths.getInterpolatedValue(points, x);
		}
		
		

	}
}