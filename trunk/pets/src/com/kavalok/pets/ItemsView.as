package com.kavalok.pets
{
	import com.kavalok.events.EventSender;
	import com.kavalok.layout.TileLayout;
	import com.kavalok.utils.GraphUtils;
	import flash.geom.Point;
	
	import flash.display.Sprite;
	
	public class ItemsView
	{
		private var _content:Sprite = new Sprite();
		private var _layout:TileLayout;
		private var _selection:ItemView;
		private var _items:Array = [];
		
		private var _selectionChange:EventSender = new EventSender();
		
		public function ItemsView()
		{
			_content = content;
			
			_layout = new TileLayout(_content);
			_layout.direction = TileLayout.HORIZONTAL;
			_layout.maxItems = 4;
			_layout.distance = 20;
		}
		
		public function get selectedItem():PetItem
		{
			return _selection.petItem;
		}
		
		public function set selectedItem(petItem:PetItem):void
		{
			for each (var itemView:ItemView in _items)
			{
				if (itemView.petItem == petItem)
				{
					setSelection(itemView);
					break;
				}
			}
		}
		
		public function setItems(items:Array):void
		{
			_items = [];
			GraphUtils.removeChildren(_content);
			
			for each (var petItem:PetItem in items)
			{
				var itemView:ItemView = new ItemView(petItem);
				itemView.clickEvent.addListener(onItemClick);
				_items.push(itemView);
				_content.addChild(itemView.content);
			}
			
			_layout.apply();
		}
		
		private function onItemClick(sender:ItemView):void
		{
			if (sender != _selection)
			{
				setSelection(sender);
				_selectionChange.sendEvent();
			}
		}
		
		private function setSelection(itemView:ItemView):void
		{
			if (_selection)
				_selection.selected = false;
				
			_selection = itemView;
			_selection.selected = true;
		}
		
		public function get content():Sprite { return _content; }
		
		public function get selectionChange():EventSender { return _selectionChange; }
		
	}
}

import com.kavalok.gameplay.ResourceSprite;
import com.kavalok.URLHelper;
import com.kavalok.pets.PetItem
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import com.kavalok.utils.GraphUtils;
import com.kavalok.events.EventSender;

internal class ItemView
{
	static private const SIZE:int = 40;
	
	private var _petItem:PetItem;
	private var _content:ResourceSprite;
	private var _clickEvent:EventSender = new EventSender();
	
	public function ItemView(petItem:PetItem)
	{
		_petItem = petItem
		_content = new ResourceSprite(URLHelper.petItemURL(_petItem.name), 'McItem');
		_content.width = SIZE;
		_content.height = SIZE;
		GraphUtils.addBoundsRect(_content);
		_content.readyEvent.addListener(onContentReady);
	}
	
	private function onContentReady(sender:ResourceSprite):void
	{
		_content.addEventListener(MouseEvent.CLICK, onItemClick);
		_content.buttonMode = true;
	}
	
	private function onItemClick(e:MouseEvent):void
	{
		_clickEvent.sendEvent(this);
	}
	
	public function set selected(value:Boolean):void
	{
		if (value)
			_content.filters = [new GlowFilter(0xFFFFCE, 1, 4, 4, 5)];
		else
			_content.filters = [];
	}
	
	public function get content():Sprite { return _content; }
	
	public function get clickEvent():EventSender { return _clickEvent; }
	
	public function get petItem():PetItem { return _petItem; }
}