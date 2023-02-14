package com.kavalok.quest.findItems
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.commands.LocationCommandBase;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class QuestItemCommand extends LocationCommandBase
	{
		private var _item:QuestItem;
		protected var _sprite:Sprite;
		private var _spriteClass:Class;
		protected var _quest:FindItemsQuestBase;
		
		public function QuestItemCommand(quest : FindItemsQuestBase, bell:QuestItem, spriteClass : Class)
		{
			_item = bell;
			_spriteClass = spriteClass;
			_quest = quest;
		}
		
		override public function execute():void
		{
			if (_item.done && !_quest.canTake)
				_item.done = false;
				
			if (!_item.done)
				createItem();
		}
		
		protected function createItemSprite():Sprite
		{
			return new _spriteClass()
		}
		private function createItem():void
		{
			var point:Point = getBellPosition();
			
			_sprite = createItemSprite();
			_sprite.x = point.x;
			_sprite.y = point.y;
			
			var entryPoint:SpriteEntryPoint = new SpriteEntryPoint(_sprite, point);
			entryPoint.goInEvent.addListener(takeItem);
			
			location.addPoint(entryPoint);
			location.charContainer.addChild(_sprite);
			
			MousePointer.registerObject(_sprite, MousePointer.ACTION);
		}
		
		private function getBellPosition():Point
		{
			/*
			* Determine not overlapped point on location ground.
			*/
			
			var ground:Sprite = location.ground;
			
			while(true)
			{
				var point:Point = GraphUtils.getRandomZonePoint(ground);
				var globalPoint:Point = location.ground.localToGlobal(point);
				var objects:Array = Global.root.getObjectsUnderPoint(globalPoint);
				
				if (objects.length > 0)
				{
					var topObject:DisplayObject = objects[objects.length - 1];
					
					if (ground.contains(topObject))
						break;
				}
			}
			
			return point;
		}
		
		protected function takeItem(sender:SpriteEntryPoint):void
		{
			_item.done = true;
			Timers.callAfter(hideItem, 400, this);
		}
		
		protected function hideItem():void
		{
			GraphUtils.detachFromDisplay(_sprite);
		}
		
	}
}