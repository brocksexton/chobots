package com.kavalok.gameSweetBattle
{
	import com.kavalok.utils.EventManager;
	import com.kavalok.events.EventSender;
	
	import flash.events.MouseEvent;
	
	public class CloudSight
	{
		private var _content:McCloudSight = new McCloudSight();
		private var _fightEvent:EventSender = new EventSender();
		private var _position:Number;
		private var em:EventManager = GameSweetBattle.eventManager;
		
		public function CloudSight()
		{
			_content.mcArrow.visible = false;
			
			_content.mcArea.alpha = 0;
			
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_MOVE, onMouseMove);
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_DOWN, onMouseDown);
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_OVER, onMouseOver);
			em.registerEvent(_content.mcArea, MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOut(event:MouseEvent):void 
		{
			_content.mcArrow.visible = false;
		}
		
		private function onMouseOver(event:MouseEvent):void 
		{
			_content.mcArrow.visible = true;
			setPosition();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			fight();
		}
		
		private function fight():void
		{
			_position = _content.mcArrow.x;
			_fightEvent.sendEvent();
		}
		
		private function setPosition():void
		{
			_content.mcArrow.x = _content.mouseX;
			_content.mcArrow.y = _content.mcArea.y + _content.mcArrow.height;
		}
		
		private function onMouseMove(e:MouseEvent = null):void 
		{
			setPosition();
			e.updateAfterEvent();
		}
		
		public function get fightEvent():EventSender { return _fightEvent; }
		
		public function get content():McCloudSight { return _content; }
		
		public function get position():Number { return _position; }
		
	}
}