package com.kavalok.robotConfig.view
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.robotConfig.DropZone;
	import com.kavalok.robotConfig.commands.DragDropAction;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DropableView extends ModuleViewBase
	{
		private var _dropzones:Array = [];
		private var _itemsContainer:Sprite;
		private var _content:Sprite;
		
		public function DropableView(content:Sprite)
		{
			super();
			_content = content;
			createItemsContainer();
			initDropzones();
			initialize();
		}
		
		private function initDropzones():void
		{
			var sprites:Array = getDropSrites(); 
			for (var i:int = 0; i < sprites.length; i++)
			{
				_dropzones.push(new DropZone(sprites[i], i))
			}
		}
		
		protected function initialize():void {}
		
		public function getGropZones():Array
		{
			return Arrays.findByProperty(_dropzones, "used", false);
		}
		
		public function refresh():void
		{
			GraphUtils.removeChildren(_itemsContainer);
			resetDropZones();
			constructItems();
		}
		
		protected function getItems():Array
		{
			throw new NotImplementedError();
		}
		
		protected function getDropSrites():Array
		{
			throw new NotImplementedError();
		}
		
		protected function createItemSprite(item:RobotItemTO):RobotItemSprite
		{
			throw new NotImplementedError();
		}
		
		protected function createItemsContainer():void
		{
			_itemsContainer = new Sprite();
			_content.addChild(_itemsContainer);
		}
		
		private function constructItems():void
		{
			var items:Array = getItems();
			for each (var item:RobotItemTO in items)
			{
				var sprite:RobotItemSprite = createItemSprite(item);
				sprite.addEventListener(MouseEvent.MOUSE_DOWN, onSpritePress);
				var dropzone:DropZone = _dropzones[item.position];
				dropzone.used = true;
				placeSprite(sprite, dropzone);
				_itemsContainer.addChild(sprite);
			}
		}
		
		protected function placeSprite(sprite:Sprite, dropzone:DropZone):void
		{
			GraphUtils.setCoords(sprite, dropzone.content);
		}
		
		private function onSpritePress(e:MouseEvent):void
		{
			var sprite:RobotItemSprite = e.currentTarget as RobotItemSprite;
			sprite.content.alpha = 0.25;
			var item:RobotItemTO = sprite.item;
			var dropzone:DropZone = _dropzones[item.position];
			dropzone.used = false;
			
			var position:Point = GraphUtils.transformCoords(new Point(), sprite, _content.parent);
			new DragDropAction(sprite.item, position).execute();
		}
		
		protected function resetDropZones():void
		{
			for each (var dropzone:DropZone in _dropzones)
			{
				dropzone.used = false;
				dropzone.content.visible = false;
			}
		}
		
		
	}
}