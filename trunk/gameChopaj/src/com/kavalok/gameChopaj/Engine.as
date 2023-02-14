package com.kavalok.gameChopaj
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameChopaj.data.FireData;
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameChopaj.McCellsClip;
	import gameChopaj.McDesk;
	import GameChopaj.SndBorder;
	import gameChopaj.SndHide;
	import gameChopaj.SndHit;
	
	public class Engine extends Controller
	{
		static public const MIN_SPEED:Number = 1;
		static public const MAX_SPEED:Number = 15;
		static public const FRICTION:Number = 0.1;
		static public const IDLE_SPEED:Number = 1;
		
		private var _completeEvent:EventSender = new EventSender();
		
		private var _items:Array;
		private var _bounds:Rectangle;
		private var _started:Boolean = false;
		private var _isIdle:Boolean;
		
		public function Engine(bounds:Rectangle)
		{
			_bounds = bounds;
		}
		
		public function start(data:FireData):void
		{
			if (_started)
				throw new Error('Engine already started!');
				
			_started = true;
			
			_items = game.getAllItems();
			for each (var item:Item in _items)
			{
				item.v.setMembers(0, 0);
			}
			
			var speed:Number = MIN_SPEED + data.power * (MAX_SPEED - MIN_SPEED);
			
			item = game.items[data.itemIndex];
			item.v.x = speed * Math.cos(data.direction);
			item.v.y = speed * Math.sin(data.direction);
			
			game.content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			doStep();
			
			//if (!_isIdle)
			//	doStep();
		}
		
		private function doStep():void
		{
			_items = game.getAllItems();
			
			for each (var item:Item in _items)
			{
				moveItem(item);
				checkBorder(item);
			}
			
			checkCollisions();
			
			for each (item in _items)
			{
			}
			
			_isIdle = true;
			
			for each (item in _items)
			{
				if (itemOutside(item))
					removeItem(item);
				else if (item.v.magnitude() < IDLE_SPEED)
					item.v.mulScalar(0);
				else
					_isIdle = false;
			}
			
			if (_isIdle)
			{
				stop();
				_completeEvent.sendEvent();
			}
		}
		
		private function checkBorder(item:Item):void
		{
			var desk:McCellsClip = game.content.deskClip.cellsClip;
			
			if (item.v.y < 0 && item.hit.hitTestObject(desk.topBorder))
			{
				Global.playSound(SndBorder);
				item.v.y *= -0.8;
				item.y = desk.topBorder.y + item.radius;
			}
			if (item.v.y > 0 && item.hit.hitTestObject(desk.bottomBorder))
			{
				Global.playSound(SndBorder);
				item.v.y *= -0.8;
				item.y = desk.bottomBorder.y - item.radius;
			}
			if (item.v.x < 0 && item.hit.hitTestObject(desk.leftBorder))
			{
				Global.playSound(SndBorder);
				item.v.x *= -0.8;
				item.x = desk.leftBorder.x + item.radius;
			}
			if (item.v.x > 0 && item.hit.hitTestObject(desk.rightBorder))
			{
				Global.playSound(SndBorder);
				item.v.x *= -0.8;
				item.x = desk.rightBorder.x - item.radius;
			}
		}
		
		private function itemOutside(item:Item):Boolean
		{
			var point:Point = GraphUtils.transformCoords(new Point(), item, game.content.deskClip);
			return !_bounds.containsPoint(point);
		}
		
		private function removeItem(item:Item):void
		{
			game.items[item.data.index] = null;
			new SpriteTweaner(item, { scaleX:0.1, scaleY:0.1 }, 10, null, onHide);
			Global.playSound(SndHide);
		}
		
		private function onHide(item:Item):void
		{
			GraphUtils.detachFromDisplay(item);
		}
		
		public function moveItem(item:Item):void
		{
			item.x += item.v.x;
			item.y += item.v.y;
			
			var v:Number = item.v.magnitude();
			if (v > 0)
			{
				var newV:Number = Math.max(v - FRICTION, 0);
				item.v.mulScalar(newV / v);
			}
		}
		
		private function checkCollisions():void
		{
			for (var i:int = 0; i < _items.length; i++)
			{
				var item1:Item = _items[i]
				
				for (var j:int = i + 1; j < _items.length; j++)
				{
					var item2:Item = _items[j];
					if (isCollide(item1, item2))
					{
						resolve(item1, item2);
						Global.playSound(SndHit);
					}
				}
			}
		}
		
		public function resolve(item1:Item, item2:Item):void
		{
			var b1Velocity:Vector2D = item1.v.clone();
			var b2Velocity:Vector2D = item2.v.clone();
			var b1Mass:Number     = item1.weight;
			var b2Mass:Number     = item2.weight;
			
			var lineOfSight:Vector2D = new Vector2D(item1.x - item2.x,
				item1.y - item2.y);
				
			var v1Prime:Vector2D = b1Velocity.vectorProjectionOnto(lineOfSight);
			var v2Prime:Vector2D = b2Velocity.vectorProjectionOnto(lineOfSight);

			var v1Prime2:Vector2D = new Vector2D();
			v1Prime2.copyVector(v2Prime);
			v1Prime2.mulScalar(2*b2Mass);
			v1Prime2.addVector(v1Prime.getMulScalar(b1Mass - b2Mass));
			v1Prime2.mulScalar(1.0/(b1Mass + b2Mass));

			var v2Prime2:Vector2D = new Vector2D();
			v2Prime2.copyVector(v1Prime);
			v2Prime2.mulScalar(2*b1Mass);
			v2Prime2.subVector(v2Prime.getMulScalar(b1Mass - b2Mass));
			v2Prime2.mulScalar(1.0/(b1Mass + b2Mass));

			v1Prime2.subVector(v1Prime);
			v2Prime2.subVector(v2Prime);

			item1.v.addVector(v1Prime2);
			item2.v.addVector(v2Prime2);
			
			pull(item1, item2);
		}
		
		private function pull(item1:Item, item2:Item):void
		{
			var tv:Vector2D = new Vector2D(
				item1.x - item2.x,
				item1.y - item2.y);
				
			var distance:Number = tv.magnitude();
			var min_distance:Number = item1.radius + item2.radius;
			
			if (distance > min_distance)
				return;
			
			tv.mulScalar((0.1+min_distance-distance)/distance);
			item1.x += tv.x;
			item1.y += tv.y;
		}
		
		public function isCollide(item1:Item, item2:Item):Boolean
		{
			var r:Number = item1.radius + item2.radius;
			return distance2(item1, item2) < r * r;
		}
		
		public function distance2(item1:Item, item2:Item):Number
		{
			var dx:Number = item1.x - item2.x;
			var dy:Number = item1.y - item2.y;
			
			return dx * dx + dy * dy;
			return dx * dx + dy * dy;
		}
		
		public function stop():void
		{
			_started = false;
			game.content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
	}
	
}