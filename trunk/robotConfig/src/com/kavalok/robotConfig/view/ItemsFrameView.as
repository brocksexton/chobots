package com.kavalok.robotConfig.view
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.controls.CheckBox;
	import com.kavalok.gameplay.controls.RadioGroup;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.layout.TileLayout;
	import com.kavalok.robotConfig.commands.DragDropAction;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import robotConfig.McItemBackground;
	import robotConfig.McItemsFrame;
	
	public class ItemsFrameView extends ModuleViewBase
	{
		static public const NUM_COLUMNS:int = 3;
		static public const ITEM_DISTANCE:Number = 5;
		
		private var _content:McItemsFrame;
		private var _buttonGroup:RadioGroup;
		private var _itemsContainer:Sprite;
		private var _itemsBox:ScrollBox;
		
		public function ItemsFrameView(content:McItemsFrame)
		{
			_content = content;
			initialize();
		}
		
		private function initialize():void
		{
			_itemsContainer = new Sprite();
			GraphUtils.attachBefore(_itemsContainer, _content.maskClip);
			GraphUtils.setCoords(_itemsContainer, _content.maskClip);
			
			var scroller:Scroller = new Scroller(null, _content.scrollerClip);
			_itemsBox = new ScrollBox(_itemsContainer, _content.maskClip, scroller);
			
			ToolTips.registerObject(_content.baseCheckBox, 'baseItems', ResourceBundles.ROBOTS);
			ToolTips.registerObject(_content.specialCheckBox, 'specialItems', ResourceBundles.ROBOTS);
			ToolTips.registerObject(_content.artifactCheckBox, 'artifacts', ResourceBundles.ROBOTS);
			
			_buttonGroup = new RadioGroup();
			_buttonGroup.addButton(new CheckBox(_content.baseCheckBox));
			_buttonGroup.addButton(new CheckBox(_content.specialCheckBox))
			_buttonGroup.addButton(new CheckBox(_content.artifactCheckBox))
			_buttonGroup.clickEvent.addListener(onGroupClick);
			_buttonGroup.selectedIndex = 0;
		}
		
		private function onGroupClick(sender:RadioGroup):void
		{
			refresh();
		}
		
		public function setItems(items:Array):void
		{
			items.sortOn(['name','level']);
			GraphUtils.removeChildren(_itemsContainer);
			for each (var item:RobotItemTO in items)
			{
				var sprite:RobotItemSprite = createItemSprite(item);
				_itemsContainer.addChild(sprite);
			}
			applyLayout();
			_itemsBox.refresh();
		}
		
		private function createItemSprite(item:RobotItemTO):RobotItemSprite
		{
			var sprite:RobotItemSprite = new RobotItemSprite(item);
			sprite.useView = false;
			sprite.background = new McItemBackground();
			sprite.boundsMargin = 4;
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onSpritePress); 
			GraphUtils.bringToFront(sprite.background);
			
			return sprite;
		}
		
		private function onSpritePress(e:MouseEvent):void
		{
			var sprite:RobotItemSprite = e.currentTarget as RobotItemSprite;
			sprite.content.alpha = 0.25;
			
			var position:Point = GraphUtils.transformCoords(new Point(), sprite, _content.parent);
			new DragDropAction(sprite.item, position).execute();
		}
		
		private function applyLayout():void
		{
			var layout:TileLayout = new TileLayout(_itemsContainer);
			layout.direction = TileLayout.HORIZONTAL;
			layout.maxItems = NUM_COLUMNS;
			layout.distance = ITEM_DISTANCE;
			layout.apply();
		}
		
		public function refresh():void
		{
			if (_buttonGroup.selectedIndex == 0)
				setItems(configData.getFreeBaseItems());
			else if (_buttonGroup.selectedIndex == 1)
				setItems(configData.getFreeSpecialItems());
			else
				setItems(configData.getFreeArtifacts());
		}

	}
}