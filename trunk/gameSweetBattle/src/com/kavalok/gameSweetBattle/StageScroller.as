package com.kavalok.gameSweetBattle 
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	public class StageScroller
	{
		private var _mouseX:Number;
		private var _mouseObject:Sprite;
		private var _content:Sprite;
		private var _dx:Number;
		private var _counter:int;
		private var _width:Number;
		
		private var em:EventManager = GameSweetBattle.eventManager;
		
		private var _centerEvent:EventSender = new EventSender();
		
		public function StageScroller(width : Number, content:Sprite, mouseObject:Sprite) 
		{
			_width = width;
			_content = content;
			_mouseObject = mouseObject;
			MousePointer.registerObject(_mouseObject, MousePointer.HAND); 
			em.registerEvent(_mouseObject, MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			_mouseX = Global.stage.mouseX;
			if(MousePointer.pointer)
				MousePointer.pointer.gotoAndStop(2);
			em.registerEvent(Global.root, MouseEvent.MOUSE_MOVE, onMouseMove);
			em.registerEvent(Global.root, MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			_content.x = GraphUtils.claimRange(
				_content.x + Global.stage.mouseX - _mouseX,
				Config.GAME_WIDTH - _width,
				0
			)
			
			_mouseX = Global.stage.mouseX;
		}
		
		public function centerView(point:Point, animate:Boolean = true):void
		{
			var newX:Number = GraphUtils.claimRange(
				0.5 * Config.GAME_WIDTH - point.x,
				Config.GAME_WIDTH - _width,
				0
			)
			
			if (Math.abs(newX - _content.x) > 20 && animate)
			{
				var c:int = 5;
				_dx = (newX - _content.x) / c;
				_counter = c;
				em.registerEvent(_content, Event.ENTER_FRAME, onCenterFrame);
				_content.filters = [new BlurFilter(Math.abs(_dx), 0)];
				_content.cacheAsBitmap = true;
			}
			else 
			{
				_content.x = newX;
				_centerEvent.sendEvent();
			}
		}
		
		private function onCenterFrame(e:Event):void 
		{
			_content.x += _dx;
			
			if (--_counter == 0) 
			{
				em.removeEvent(_content, Event.ENTER_FRAME, onCenterFrame);
				_centerEvent.sendEvent();
				_content.filters = [];
				_content.cacheAsBitmap = false;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if(MousePointer.pointer)
				MousePointer.pointer.gotoAndStop(1);
			em.removeEvent(Global.root, MouseEvent.MOUSE_MOVE, onMouseMove);
			em.removeEvent(Global.root, MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function get centerEvent():EventSender { return _centerEvent; }
		
	}
	
}