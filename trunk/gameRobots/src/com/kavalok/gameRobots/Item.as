package com.kavalok.gameRobots
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;

	internal class Item
	{
		public var stage:GameStage;
		public var position:int;
		public var movie:MovieClip;
		
		private var _itemCheck:Item = null;
		
		public function move(distance:int):void
		{
			position = Math.min(position + distance, stage.path.length - 1);
			
			var nextItem:Item = getNextItem();
			
			if(nextItem == null)
				return;
			
			if (distance < 0 && _itemCheck == null)
				_itemCheck = this;
				
			var d:int = nextItem.position - position;
			
			var nextDistance:int = distance;
			
			if (d < stage.itemDistance)
			{
				nextDistance = Math.min(distance + 1, (stage.itemDistance - d));
			}
			else if (d > stage.itemDistance)
			{
				if (nextItem.currentFrame == currentFrame)
				{
					nextDistance = -3;
				}
				else
				{
					if (distance > 0)
						nextDistance = 0;
				}
			}
			
			if (_itemCheck == this && distance > 0)
			{
				stage.checkItem(this);
				_itemCheck = null;
			}
			
			nextItem.move(nextDistance);
		}
		
		public function getPrevItem():Item
		{
			var nextIndex:int = index - 1;
			
			return (nextIndex < 0) ?
				null : stage.items[nextIndex];
		}
		
		public function getNextItem():Item
		{
			var nextIndex:int = index + 1;
			return (nextIndex == stage.items.length) ?
				null : stage.items[nextIndex];
		}
		
		public function get coord():Point
		{
			return stage.path[position];
		}
		
		public function get currentFrame():int
		{
			return movie.currentFrame;
		}
		
		public function get index():int
		{
			return stage.items.indexOf(this);
		}
		
		public function destroy():void
		{
			stage.events.registerEvent(movie, Event.ENTER_FRAME, onDestroy);
		}
		
		private function onDestroy(e:Event):void
		{
			movie.scaleX -= 0.2;
			movie.scaleY -= 0.2;
			if (movie.scaleX <= 0)
			{
				stage.events.removeEvent(movie, Event.ENTER_FRAME, onDestroy);
				movie.parent.removeChild(movie);
				movie = null;
				
				stage.checkForFinish();
			}
		}
		
		public function refresh():void
		{
			movie.x = stage.path[position].x;
			movie.y = stage.path[position].y;
		}
	}
}
