package com.kavalok.robotConfig.commands
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.robotConfig.DropZone;
	import com.kavalok.robotConfig.view.effects.HighlightEffect;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	
	import flash.geom.Point;
	
	public class DragDropAction extends ModuleCommandBase
	{
		//static public const SPRITE_SIZE:Number = 50;
		
		private var _item:RobotItemTO;
		private var _content:RobotItemSprite;
		private var _position:Point;
		private var _dropzones:Array;
		
		public function DragDropAction(item:RobotItemTO, position:Point)
		{
			_item = item;
			_position = position;
		}
		
		override public function execute():void
		{
			createContent();
			createDropzone();
			startDrag();
		}
		
		private function createDropzone():void
		{
			if (_item.isSpecialItem)
				_dropzones = mainView.specialItems.getGropZones();
			else if (_item.isArtifact)
				_dropzones = mainView.artifacts.getGropZones();
			else
				_dropzones = mainView.robot.getGropZones();
				
			dropzonesVisible = true;
		}
		
		public function set dropzonesVisible(value:Boolean):void
		{
			for each (var dropzone:DropZone in _dropzones)
			{
				dropzone.content.visible = value;
			}
		}
		
		private function hideDropZones():void
		{
			for each (var dropzone:DropZone in _dropzones)
			{
				dropzone.content.visible = true;
			}
		}
		
		private function startDrag():void
		{
			var dm:DragManager = new DragManager(_content);
			dm.finishEvent.addListener(onDragFinish);
			dm.startDrag();
		}
		
		private function onDragFinish(dm:DragManager):void
		{
			var dropzone:DropZone = getCurrentDropZone();
			
			if (dropzone)
				new UseItemCommand(_item, dropzone.position).execute();
			else
				new UnUseItemCommand(_item).execute();
			
			GraphUtils.detachFromDisplay(_content);
		}
		
		private function getCurrentDropZone():DropZone
		{
			var distance:Number = Number.MAX_VALUE;
			var result:DropZone = null;
			
			for each (var dropzone:DropZone in _dropzones)
			{
				if (_content.hitTestObject(dropzone.content))
				{
					var point:Point = GraphUtils.transformCoords(new Point(),
						dropzone.content, _content.parent);
					var d:Number = GraphUtils.distance(point, _content);
					if (d < distance)
					{
						distance = d;
						result = dropzone;
					}
				}
			}
			
			return result;
		}
		
		private function createContent():void
		{
			_content = new RobotItemSprite(_item);
			_content.useView = false;
			
			new HighlightEffect(_content).apply();
			GraphUtils.setCoords(_content, _position);
			GraphUtils.addBoundsRect(_content).buttonMode = true;
			mainView.content.addChild(_content);
			
		}
		
		
	}
}