package com.kavalok.gameplay.controls
{
	import com.kavalok.Global;
	import com.kavalok.controls.McScroller;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Scroller
	{
		static private const SCROLL_DELAY:int = 3; // (frames)
		
		protected var _position:Number;
		protected var _scrollStep:Number = 0.1;
		
		private var _changeEvent:EventSender = new EventSender(Scroller);
		private var _changeCompleteEvent:EventSender = new EventSender(Scroller);
		
		protected var _content:Sprite;
		protected var _upButton:SimpleButton;
		protected var _downButton:SimpleButton;
		protected var _line:Sprite;
		protected var _pointer:Sprite;
		
		private var _scrollDirection:int;
		private var _scrollCounter:int;
		private var _dm:DragManager;
		
		public function Scroller(container:Sprite, content:Sprite = null)
		{
			if (container)
				_content = new McScroller();
			else
				_content = content;
				
			_upButton = _content['upButton'];
			_downButton = _content['downButton'];
			_line = _content['line'];
			_pointer = _content['pointer'];
			
			if (container)
				initContainer(container);
			
			initialize();
		}
		
		private function initContainer(container:Sprite):void
		{
			var size:int = Math.max(container.width, container.height) 
			_line.height = size - 2 * _upButton.height;
			_downButton.y = size - _downButton.height;
			
			GraphUtils.removeChildren(container);
			container.addChild(_content);
			container.scaleX = container.scaleY = 1;
		}
		
		private function initialize():void
		{
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
			
			_pointer.buttonMode = true;
			
			_dm = new DragManager(_pointer);
			_dm.bounds = new Rectangle(
				_line.x - 0.5 * _pointer.width,
				_line.y,
				_pointer.width,
				_line.height
			)
			_dm.dragEvent.addListener(onDrag);
			_dm.finishEvent.addListener(onFinishDrag);
			
			position = 0;
		}
		
		protected function onUpClick(e:MouseEvent):void
		{
			startScrolling(-1);
		}
			
		protected function onDownClick(e:MouseEvent):void
		{
			startScrolling(1);
		}
		
		private function startScrolling(direction:int):void
		{
			_scrollDirection = direction;
			_scrollCounter = 0;
			_content.addEventListener(Event.ENTER_FRAME, doScrollStep);
			Global.root.addEventListener(MouseEvent.MOUSE_UP, stopScrolling);
			doScrollStep();
		}
		
		private function doScrollStep(e:Event = null):void
		{
			if (++_scrollCounter == SCROLL_DELAY)
			{
				_scrollCounter = 0;
				
				position += _scrollStep * _scrollDirection;
				changeEvent.sendEvent(this);
				changeCompleteEvent.sendEvent(this);
			}
		}
		
		private function stopScrolling(e:Event):void
		{
			_content.removeEventListener(Event.ENTER_FRAME, doScrollStep);
			Global.root.removeEventListener(MouseEvent.MOUSE_UP, stopScrolling);
		}
		
		public function set scrollStep(value:Number):void
		{
			 _scrollStep = value;
		}
		
		private function onDrag(sender:DragManager):void
		{
			_position = (_pointer.y - _line.y) / (_line.height - _pointer.height);
			_position = GraphUtils.claimRange(_position, 0, 1);
			
			_changeEvent.sendEvent(this);
		}
		
		private function onFinishDrag(sender:DragManager):void
		{
			_changeCompleteEvent.sendEvent(this);
		}
		
		public function set scrollerVisible(value:Boolean):void
		{
			_content.visible = value;
		}
		
		public function get position():Number { return _position; }
		public function set position(value:Number):void
		{
			 _position = GraphUtils.claimRange(value, 0, 1);
			 _pointer.y = _line.y + (_line.height - _pointer.height) * _position;
			 
			 changeEvent.sendEvent(this);
		}
		
		public function get changeEvent():EventSender { return _changeEvent; }
		public function get changeCompleteEvent():EventSender { return _changeCompleteEvent; }
		

	}
}