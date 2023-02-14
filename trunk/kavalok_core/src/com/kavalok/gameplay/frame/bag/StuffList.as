package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	public class StuffList
	{
		private var _overFilters:Array = [new GlowFilter(0xFFFF99,1,2,2, 10), new DropShadowFilter(2, 45,0, 0.5)];
		private var _selectedFilters:Array = [new GlowFilter(0xFFFF99,1,4,4, 6), new DropShadowFilter(2, 45,0, 0.5)];
		private var _margins:uint;
		private var _rowCount:uint;
		private var _columnCount:uint;
		private var _content:Sprite;

		private var _pageIndex:int = 0;
		private var _pagesCount:int;
		private var _items:Array = [];
		private var _selectedItem:StuffSprite;
		private var _selectedItemChange:EventSender = new EventSender();
		private var _itemsChangeEvent:EventSender = new EventSender();
		
		private var _itemWidth:int;
		private var _itemHeight:int;
		private var _backEnabled:Boolean;
		private var _nextEnabled:Boolean;

		public function StuffList(content : Sprite, rowCount : uint, columnCount : uint, margins : uint = 20)
		{
			_margins = margins;
			_content = content;
			_content.visible = true;
			_rowCount = rowCount;
			_columnCount = columnCount;

			_itemWidth = content.width / columnCount - _margins;
			_itemHeight = content.height / rowCount - _margins;
			
			//_itemWidth = 48;
			//_itemHeight = 45;
		}

		public function get selectedItem():StuffSprite { return _selectedItem; }
		public function set selectedItem(value:StuffSprite):void
		{
			 _selectedItem = value;
		}
		
		public function get content():Sprite { return _content; }
		public function get items():Array { return _items; }
		public function get selectedItemChange():EventSender { return _selectedItemChange; }
		public function get itemsChangeEvent():EventSender { return _itemsChangeEvent; }
		public function get nextEnabled():Boolean { return _nextEnabled; }
		public function get backEnabled():Boolean { return _backEnabled; }
		public function get pageIndex():uint { return _pageIndex; }
		
		public function set pageIndex(value : uint) : void 
		{ 
			_pageIndex = value;
			refresh(); 
		}
		
		public function get pagesCount():uint { return _pagesCount; }

		public function addItem(value:StuffSprite):void
		{
			_items.push(value);
			_pagesCount = Math.ceil(_items.length / _rowCount / _columnCount);
			processItem(value);
			refresh();
			itemsChangeEvent.sendEvent();
		}
		public function removeItem(value:StuffSprite):void
		{
			Arrays.removeItem(value, _items);
			_pagesCount = Math.ceil(_items.length / _rowCount / _columnCount);
			unprocessItem(value);
			refresh();
			itemsChangeEvent.sendEvent();
		}
		public function setItems(value:Array):void
		{
			var item:StuffSprite;
			for each (item in _items)
			{
				unprocessItem(item);
			}
			GraphUtils.removeChildren(_content);
			_items = value;
			_pagesCount = Math.ceil(_items.length / _rowCount / _columnCount)
			
			for each (item in _items)
			{
				processItem(item);
			}
			
			if (_pageIndex >= _pagesCount && _pagesCount > 0)
				_pageIndex = _pagesCount - 1;
			
			refresh();
			itemsChangeEvent.sendEvent();
		}
		
		private function unprocessItem(item : StuffSprite):void
		{
			item.pressEvent.removeListener(onItemPress);
			item.overEvent.removeListener(onItemOver);
			item.outEvent.removeListener(onItemOut);
			item.refreshEvent.removeListener(onItemRefresh);
		}
		private function processItem(item : StuffSprite):void
		{
			item.createModels();
			item.pressEvent.addListener(onItemPress);
			item.overEvent.addListener(onItemOver);
			item.outEvent.addListener(onItemOut);
			item.refreshEvent.addListener(onItemRefresh);
		}
		private function resetSelection():void
		{
			if (_selectedItem)
			{
				GraphUtils.removeFilters(_selectedItem, _selectedFilters);
				_selectedItem = null;
				_selectedItemChange.sendEvent();
			}
		}

		public function refresh():void
		{
			resetSelection();
			
			GraphUtils.removeChildren(_content);
			
			var index:int = _pageIndex * _rowCount * _columnCount;
			
			for (var i:int = 0; i < _rowCount; i++)
			{
				for (var j:int = 0; j < _columnCount; j++)
				{
					if (index >= _items.length)
						break;
						
					addItemAt(_items[index], i, j);
					index++;
				}
			}
			
			_backEnabled = _pageIndex > 0;
			_nextEnabled = _pageIndex < _pagesCount - 1;
		}

		private function addItemAt(item:StuffSprite, i:int, j:int) : void
		{
			item.loadModel();
			_content.addChild(item);
			setItemPosition(item, i, j);
		}
		
		private function setItemPosition(item:StuffSprite, i:int, j:int) : void
		{
			item.setSize(_itemWidth, _itemHeight);
			
			var rect:Rectangle = item.getBounds(_content);
			
			item.x += (j + 0.5) * (_itemWidth + _margins) - 0.5 * (rect.left + rect.right);
			item.y += (i + 0.5) * (_itemHeight + _margins) - 0.5 * (rect.top + rect.bottom);
			
		}

		private function onItemOver(item:StuffSprite):void
		{
			if(item.item.type == 'C'){
				if(item.item.name != null && item.item.name != "")
				ToolTips.registerObject(item, item.item.name);
				} else {
			if (item.item.fileName in Localiztion.getBundle(Modules.STUFF_CATALOG).messages)
				ToolTips.registerObject(item, item.item.fileName, Modules.STUFF_CATALOG);
			}
			
			if (item != _selectedItem)
				GraphUtils.addFilters(item, _overFilters);
		}
		
		private function onItemOut(item:StuffSprite):void
		{
			if (item != _selectedItem)
				GraphUtils.removeFilters(item, _overFilters);
		}
		
		private function onItemRefresh(item:StuffSprite):void
		{
			if(item.parent == null)
				return; //other page
			var index : int = _content.getChildIndex(item);
			var i : int = index / _columnCount;
			var j : int = index % _columnCount;
			setItemPosition(item, i, j);
		}
		private function onItemPress(item:StuffSprite):void
		{
			if (item != _selectedItem)
			{
				resetSelection();
				
				_selectedItem = item;
				
				GraphUtils.removeFilters(item, _overFilters);
				GraphUtils.addFilters(item, _selectedFilters);
				
				selectedItemChange.sendEvent();
			}
		}
		
	}
}