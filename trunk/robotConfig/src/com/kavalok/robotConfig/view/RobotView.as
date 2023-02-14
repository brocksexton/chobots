package com.kavalok.robotConfig.view
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.robotConfig.DropZone;
	import com.kavalok.robotConfig.commands.DragDropAction;
	import com.kavalok.robots.RobotModel;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	import robotConfig.McRobotClip;
	
	public class RobotView extends ModuleViewBase
	{
		private var _content:McRobotClip;
		private var _model:RobotModel;
		
		public function RobotView(content:McRobotClip)
		{
			_content = content;
			_content.modelPosition.visible = false;
			_content.dropzone.visible = false;
			super();
		}
		
		public function refresh():void
		{
			createModel();
			_content.dropzone.visible = false;
		}
		
		private function createPartButtons():void
		{
			for each (var item:RobotItemTO in _model.robot.items)
			{
				var sprites:Array = _model.getItemSprites(item);
				if (sprites.length > 0)
				{
					var button:Sprite = sprites[0];
					button.buttonMode = true;
					button.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					button['data'] = item;
				}
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			var button:Sprite = e.currentTarget as Sprite;
			button.alpha = 0.30;
			
			var item:RobotItemTO = button['data'];
			var position:Point = new Point(
				_content.parent.mouseX - 30,
				_content.parent.mouseY - 30);
				
			new DragDropAction(item, position).execute();
		}
		
		private function createModel():void
		{
			if (_model)
				GraphUtils.detachFromDisplay(_model);
				
			_model = new RobotModel(configData.currentRobot);
			_model.scale = _content.modelPosition.scaleY;
			_model.filters = [new DropShadowFilter(0, 45, 0, 0.5)];
			_model.interactive = true;
			_model.updateModel();
			
			if (_model.ready)
				onModelReady();
			else
				_model.readyEvent.addListener(onModelReady);
			
			_content.addChild(_model);
		}
		
		private function onModelReady():void
		{
			createPartButtons();
		}
		
		public function getGropZones():Array
		{
			return [new DropZone(_content.dropzone)];
		}
		
		
		
	}
}