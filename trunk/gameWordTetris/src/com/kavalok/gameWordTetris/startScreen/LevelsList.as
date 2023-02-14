package com.kavalok.gameWordTetris.startScreen
{
	import com.kavalok.gameplay.controls.ListBox;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.gameWordTetris.McLevelList;
	import flash.display.Sprite;
	
	public class LevelsList
	{
		private var _selectedItem:LevelListItem;
		
		private var _content:McLevelList;;
		
		private var _listBox:ListBox;
		private var _scroller:Scroller;
		private var _scrollBox:ScrollBox;
		
		public function LevelsList(content:McLevelList, levels:XML)
		{
			_content = content;
			_listBox = new ListBox();
			_scroller = new Scroller(_content.listScroller);
			_scrollBox = new ScrollBox(_listBox.content, _content.listArea, _scroller);
			
			_content.addChild(_listBox.content);
			_listBox.content.x = _content.listArea.x;
			_listBox.content.y = _content.listArea.y;
			
			createItems(levels);
		}
		
		public function get levelNum():int
		{
			return _listBox.items.indexOf(_selectedItem);
		}
		
		public function set levelNum(value:int):void
		{
			setSelectedItem(_listBox.items[value]);
		}
		
		private function createItems(levels:XML):void
		{
			var num:int = 0;
			
			for each (var level:XML in levels.level)
			{
				num++;
				
				var item:LevelListItem = new LevelListItem('Level' + num);
				item.clickEvent.addListener(setSelectedItem);
				
				_listBox.addItem(item);
			}
			
			_listBox.refresh();
		}
		
		private function setSelectedItem(item:LevelListItem):void
		{
			if (_selectedItem)
				_selectedItem.selected = false;
				
			_selectedItem = item;
			_selectedItem.selected = true;
		}
		
	}
	
}