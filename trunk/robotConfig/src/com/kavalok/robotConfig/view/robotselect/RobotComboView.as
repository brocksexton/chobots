package com.kavalok.robotConfig.view.robotselect
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.IListItem;
	import com.kavalok.gameplay.controls.ListBox;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.robots.Robot;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import robotConfig.McRobotCombo;
	
	public class RobotComboView
	{
		private var _content:McRobotCombo;
		private var _items:Array;
		private var _currentItem:Object;
		private var _nameField:String;
		
		private var _robotsList:ListBox;
		
		private var _changeEvent:EventSender = new EventSender();
		
		public function RobotComboView(content:McRobotCombo, items:Array, nameField:String)
		{
			_content = content;
			_items = items;
			_nameField = nameField;
			
			initialize();
			refresh();
		}
		
		private function initialize():void
		{
			createList();
			RobotConfig.instance.initTextField(_content.titleClip.captionField);
			downButton.addEventListener(MouseEvent.CLICK, onDownClick);
			listVisible = false;
		}
		
		private function createList():void
		{
			_robotsList = new ListBox();
			_content.listClip.addChild(_robotsList.content);
			
			for each (var robot:Robot in _items)
			{
				var item:ListItem = new ListItem(robot);
				item.caption = robot.localizedName;
				item.clickEvent.addListener(onItemClick);
				
				_robotsList.addItem(item);
				
				if (_items.indexOf(robot) < _items.length - 1)
					_robotsList.addItem(new ListSeparator());
			}
			
			_robotsList.refresh();
			
			var scroller:Scroller = new Scroller(null, _content.listClip.scrollerClip);
			var scrollBox:ScrollBox = new ScrollBox(
				_robotsList.content, _content.listClip.maskClip, scroller);
		}
		
		private function onItemClick(sender:ListItem):void
		{
			if (sender.data != currentItem)
			{
				currentItem = sender.data;
				_changeEvent.sendEvent();
			}
		}
		
		private function onDownClick(e:MouseEvent):void
		{
			listVisible = !listVisible;
		}
		
		public function get currentItem():Object { return _currentItem; }
		public function set currentItem(value:Object):void
		{
			_currentItem = value;
			listVisible = false;
			refresh();
		}
		
		public function get listVisible():Boolean { return _content.listClip.visible; }
		public function set listVisible(value:Boolean):void
		{
			_content.listClip.visible = value;
		}
		
		private function refresh():void
		{
			_content.titleClip.captionField.text = (_currentItem)
				? _currentItem[_nameField]
				: '';
				
			for each (var item:IListItem in _robotsList.items)
			{
				if (item is ListItem)
					ListItem(item).selected = (ListItem(item).data == _currentItem);
			}
			
			GraphUtils.setBtnEnabled(downButton, _items.length > 1);
		}
		
		public function get downButton():SimpleButton
		{
			 return _content.downButton;
		}
		
		public function get changeEvent():EventSender { return _changeEvent; }
	}
}