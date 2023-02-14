package com.kavalok.academySelector
{
	import com.kavalok.constants.Modules;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.controls.IFlashView;
	import com.kavalok.layout.TileLayout;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.kavalok.localization.Localiztion;
	
	public class SelectorView implements IFlashView
	{
		static private const ITEM_WIDTH:int = 180;
		static private const ITEM_HEIGHT:int = 150;
		static private const ITEM_DISTANCE:int = 10;
		static private const NUM_COLUMNS:int = 3;
		static private const NUM_ROWS:int = 2;
		
		private var _content:McSelector = new McSelector();
		private var _items:Sprite = new Sprite();
		private var _itemsRect:Rectangle = _content.menuArea.getBounds(_content);
		
		//private var _bundle = Localiztion.getBundle(Modules.ACADEMY_SELECTOR);
		
		public function SelectorView(itemsInfo:XML)
		{
			initContent();
			createItems(itemsInfo);
		}
		
		private function createItems(itemsInfo:XML):void
		{
			for each (var itemName:String in itemsInfo.item)
			{
				var url:String = module.folderURL + '/' + itemName + '.swf'; 
				var item:ResourceSprite = new ResourceSprite(url, 'McItem');
				item.readyEvent.addListener(onItemReady);
				item.name = itemName;
				item.width = ITEM_WIDTH;
				item.height = ITEM_HEIGHT;
				
				ToolTips.registerObject(item, itemName, Modules.ACADEMY_SELECTOR);
				
				_items.addChild(item);
			}
			
			var layout:TileLayout = new TileLayout(_items);
			layout.distance = ITEM_DISTANCE;
			layout.maxItems = 3;
			layout.apply();
		}
		
		private function onItemReady(item:ResourceSprite):void
		{
			item.addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			module.goto(DisplayObject(e.currentTarget).name);
		}
		
		private function initContent():void
		{
			GraphUtils.optimizeBackground(_content.background);
			
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			
			_content.removeChild(_content.menuArea);
			_content.addChild(_items);
			
			_items.x = _itemsRect.x + 0.5 * _itemsRect.width
				- 0.5 * NUM_COLUMNS * ITEM_WIDTH
				- 0.5 * (NUM_COLUMNS - 1) * ITEM_DISTANCE;
			_items.y = _itemsRect.y + 0.5 * _itemsRect.height
				- 0.5 * NUM_ROWS * ITEM_HEIGHT
				- 0.5 * (NUM_ROWS - 1) * ITEM_DISTANCE;
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			module.close();
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		protected function get module():AcademySelector
		{
			return AcademySelector.instance;
		}

	}
}