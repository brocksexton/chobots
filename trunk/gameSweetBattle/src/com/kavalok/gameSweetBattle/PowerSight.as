package com.kavalok.gameSweetBattle
{
	import com.kavalok.char.Directions;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.events.EventSender;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PowerSight
	{
		private static const PI:Number = Math.PI;
		private static const MAX_ANGLE:Number = 0.7 * PI;
		
		private var _content:McPowerSight = new McPowerSight();
		private var _player:Player;
		private var _fightEvent:EventSender = new EventSender();
		private var _powerEvent:EventSender = new EventSender();
		private var _power:Number;
		private var _active:Boolean;
		private var em:EventManager = GameSweetBattle.eventManager;
		
		public function PowerSight(player:Player)
		{
			_player = player;
			
			_content.mcArrow.visible = false;
			_content.mcArrow.stop();
			
			_content.mcArea.alpha = 0;
			
			_power = 0;
			
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_MOVE, onMouseMove);
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_DOWN, onMouseDown);
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_UP, onMouseUp);
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_OVER, onMouseOver);
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function show():void
		{
			setPosition();
			setRotation();
		}
		
		private function onMouseOut(event:MouseEvent):void 
		{
			_content.mcArrow.visible = false;
		}
		
		private function onMouseOver(event:MouseEvent):void 
		{
			_content.mcArrow.visible = true;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			_active = true;
			_powerEvent.sendEvent();
			em.registerEvent(_content, Event.ENTER_FRAME, onPowerFrame);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if(_active)
			{
				_active = false;
				fight();
			}
		}
		
		private function fight():void
		{
			em.removeEvent(_content, Event.ENTER_FRAME, onPowerFrame);
			_fightEvent.sendEvent();
		}
		
		private function onPowerFrame(e:Event):void 
		{
			if (_content.mcArrow.currentFrame == _content.mcArrow.totalFrames) 
			{
				fight();
			}
			else 
			{
				_content.mcArrow.nextFrame();
				_power =  0.2 + 0.8 * _content.mcArrow.currentFrame / (_content.mcArrow.totalFrames);
			}
		}
		
		private function setPosition():void
		{
			var p:Point = new Point(0, -0.7 * _player.height);
			
			GraphUtils.transformCoords(p, _player, _content.parent)
			
			_content.mcArrow.x = p.x;
			_content.mcArrow.y = p.y;
		}
		
		private function onMouseMove(e:MouseEvent = null):void 
		{
			setRotation();
			e.updateAfterEvent();
		}
		
		private function setRotation():void
		{
			var a:Number = Math.atan2(_content.mouseY - _content.mcArrow.y,
									  _content.mouseX - _content.mcArrow.x);
									  
			var a0:Number = _player.rotation / 180 * PI - 0.5 * PI;
			
			var aDiff:Number = GraphUtils.angleDiff(a0, a);
			
			if (aDiff > MAX_ANGLE) 
			{
				a = a0 + MAX_ANGLE;
			}
			else if (aDiff < -MAX_ANGLE) 
			{
				a = a0 - MAX_ANGLE;
			}
			
			if (aDiff > 0) 
			{
				_player.direction = Directions.RIGHT
			}
			else 
			{
				_player.direction = Directions.LEFT
			}
			
			_content.mcArrow.rotation = a / PI * 180;
		}
		
		public function get direction():Number
		{
			return _content.mcArrow.rotation / 180 * PI;
		}
		
		public function get position():Point
		{
			return new Point(_content.x, _content.y);
		}
		
		public function get power():Number
		{
			return _power;
		}
		
		public function get fightEvent():EventSender { return _fightEvent; }
		
		public function get powerEvent():EventSender { return _powerEvent; }
		
		public function get content():McPowerSight { return _content; }
		
	}
}