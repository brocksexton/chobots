package com.kavalok.gameplay.windows
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.layout.TileLayout;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GiftView extends CharChildViewBase
	{
		private var _items:Array = [];
		private var _selection:ViewItem;
		private var _charId:String;
		private var _userId:Number;
		
		private var _view:McGift = new McGift();
		private var _scroller:Scroller = new Scroller(_view.scroller);
		private var _panel:Sprite = new Sprite();
		private var _scrollBox:ScrollBox = new ScrollBox(_panel, _view.contentRect, _scroller);
		private var _layout:TileLayout = new TileLayout(_panel);
		
		public function GiftView(charId:String, userId:Number)
		{
			super(_view);
			_charId = charId;
			_userId = userId;
			_view.addChild(_panel);
			_layout.direction = TileLayout.HORIZONTAL;
			_layout.maxItems = 4;
			
			_view.giftButton.addEventListener(MouseEvent.CLICK, onGiftClick);
			stuffs.refreshEvent.addListener(rebuild);
			
			new ResourceScanner().apply(_view);
			refresh();
		}
		
		override public function initialize():void
		{
			rebuild();
		}
		
		private function rebuild():void
		{
			var viewItem:ViewItem;
			
			for each (viewItem in _items)
			{
				_panel.removeChild(viewItem.content);
			}
			
			_items = [];
			
			var giftableItems:Array = stuffs.getGiftableItems(); 
			for each (var stuffItem:StuffItemLightTO in giftableItems)
			{
				if(stuffItem.giftable){
				viewItem = new ViewItem(stuffItem);
				viewItem.selectionEvent.addListener(onSelectionChange);
				_items.push(viewItem);
				_panel.addChild(viewItem.content);
			}
			
			}
			
			_layout.apply();
			_selection = null;
			
			refresh();
		}
		
		private function onGiftClick(e:MouseEvent):void
		{
			Global.isLocked = true;
			stuffs.refreshEvent.addListener(onStuffsRefresh);
			stuffs.makePresent(_selection.stuff, _userId);
			

			//new AdminService().S4sP(Global.charManager.charId, _charId, _selection.stuff.fileName.toString());
			Global.sendAchievement("ac10;","Gift");
			new LogService().giftLog(_selection.stuff.fileName.toString(), _userId, _charId, _selection.stuff.id);
		}
		
		private function onStuffsRefresh():void
		{
			Global.isLocked = false;
			stuffs.refreshEvent.removeListener(onStuffsRefresh);
		}
		
		public function refresh():void
		{
			_scrollBox.refresh();
			GraphUtils.setBtnEnabled(_view.giftButton, Boolean(_selection));
		}
		
		override public function destroy():void
		{
			stuffs.refreshEvent.removeListener(rebuild);
		}
		
		private function onSelectionChange(item:ViewItem):void
		{
			if (_selection) 
				_selection.selected = false;
				
			_selection = item;
			
			refresh();
		}
		
		public function get stuffs():Stuffs
		{
			 return Global.charManager.stuffs;
		}
		
	}
}
	
	import flash.display.Sprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.GraphUtils;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.windows.McSelectionBorder;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.ResourceSprite;
	

internal class ViewItem
{
	static private const ITEM_WIDTH:int = 45;
	static private const ITEM_HEIGHT:int = 45;
	
	public var stuff:StuffItemLightTO;
	public var content:Sprite = new Sprite();
	public var selectionEvent:EventSender = new EventSender(ViewItem);
	
	private var _border:MovieClip;
	private var _selected:Boolean = false;
	
	public function ViewItem(stuff:StuffItemLightTO):void
	{
		this.stuff = stuff;
		
		_border = new McSelectionBorder();
		_border.width = ITEM_WIDTH;
		_border.height = ITEM_HEIGHT;
		_border.useHandCursor = true;
		content.addChild(_border);
		
		var model:Sprite = stuff.createModel();
		ResourceSprite(model).loadContent();
		content.addChildAt(model, 0);
		GraphUtils.scale(model, 0.7 * _border.height, 0.7 * _border.width);
		GraphUtils.alignCenter(model, _border.getBounds(model.parent)); 
		_border.gotoAndStop(3);
		
		content.addEventListener(MouseEvent.ROLL_OVER, onOver);
		content.addEventListener(MouseEvent.ROLL_OUT, onOut);
		content.addEventListener(MouseEvent.CLICK, onClick);
	}
	
	private function onOver(e:MouseEvent):void
	{
		if (!_selected)
			_border.gotoAndStop(1);
	}
	
	private function onOut(e:MouseEvent):void
	{
		if (!_selected)
			_border.gotoAndStop(3);
	}
	
	public function set selected(value:Boolean):void
	{
		if (value == _selected)
		 	return;
		 
		 _selected = value;
		 
		if (_selected)
			_border.gotoAndStop(2);
		else
			_border.gotoAndStop(3);
			
		selectionEvent.sendEvent(this);
	}
	
	private function onClick(e:MouseEvent):void
	{
		if (!_selected)
			selected = true;
	}
}