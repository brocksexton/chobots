package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.Global;
	import com.kavalok.pinball.PinballUtil;
	import com.kavalok.pinball.space.EventSpace;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.dynamics.RigidBody;
	
	public class Animation implements IDynamicProcessor
	{
		private static const SOUNDS : Array = [SoundHit2,SoundHit3,SoundHit4,SoundHit5];
		
		private var _ballBody : RigidBody;
		private var _space : EventSpace;
		private var _movie : MovieClip;
		private var _finalSpeed : Point;
		private var _game : GamePinball;
		private var _hideBall : Boolean;
		private var _points : Number;
		private var _enters : Array = [];
		
		public function Animation(game : GamePinball, space : EventSpace, movie : MovieClip, ballBody : RigidBody, params : Object)
		{
			for(var i : uint = 0; i < movie.numChildren; i++)
			{
				var child : DisplayObject = movie.getChildAt(i);
				if(child is MovieClip && MovieClip(child).name == "enter")
				{
					_enters.push(child);
					child.visible = false;
				}
			}
			if(movie.params != null)
			{
				movie.params.visible = false;
				var params : Object = PinballUtil.getParams(movie.params);
				_points = params.points;
			}
			if(movie.exit != null)
			{
				movie.exit.visible = false;
			}
			_ballBody = ballBody
			_hideBall = params.hideBall;
			_space = space;
			_movie = movie;
			_game = game;
			if(params.finalSpeedX != null)
			{
				_finalSpeed = new Point(params.finalSpeedX, params.finalSpeedY);
			}
			doStop();
		}
		
		public function tryStart() : Boolean
		{
			for each(var enter : MovieClip in _enters)
			{
				var enterPoint : Point = GraphUtils.transformCoords(new Point(), enter, Global.root);
				var radius : Number = enter.width / 2 + GamePinball.BALL_RADIUS;
				var distance : Number =  PinballUtil.getDistanceSqr(_ballBody.p, enterPoint);
				if(distance < radius * radius)
				{
					if(_hideBall)
					{
						_ballBody.p.setTo(-100, -100);
						_space.stoped = true;
						_movie.visible = true;
					}
					Global.playSound(Arrays.randomItem(SOUNDS), 0.5);
					_movie.play();
					_movie.addEventListener(Event.ENTER_FRAME, onEnterFrame);
					return true;
				}
			}
			return false;
		}
		
		public function stop() : void
		{
			doStop();
		}
		private function doStop() : void
		{
			_movie.gotoAndStop(1);
			if(_hideBall)
			{
				_movie.visible = false;
				var exit : Point = GraphUtils.transformCoords(new Point(), _movie.exit, Global.root); 
				_ballBody.p.setTo(exit.x, exit.y);
				_space.stoped = false;
			}
			if(_finalSpeed != null)
			{
				_ballBody.v.setTo(_finalSpeed.x, _finalSpeed.y);
			}
		}

		private function onEnterFrame(event : Event) : void
		{
			if(_movie.currentFrame == _movie.totalFrames)
			{
				if(!isNaN(_points))
				{
					_game.addPoints(_points);
				}
				_movie.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				doStop();
			}
		}

	}
}