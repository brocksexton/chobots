package com.kavalok.stuffCatalog.view
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.controls.ColorPicker;
	import com.kavalok.gameplay.controls.Spinner;
	import com.kavalok.gameplay.frame.bag.StuffList;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.stuffCatalog.CatalogConfig;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.char.CharModel;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import stuffCatalog.McCatalog;
	import stuffCatalog.McStufControls;
	
	public class CatalogView
	{
 		public var byeEnabled:Boolean = true; 
 		public var viewOnCharacter:Boolean = false; 
 		
		private var _closeEvent:EventSender = new EventSender();
		private var _buyEvent:EventSender = new EventSender();
		private var _buyEmeraldsEvent:EventSender = new EventSender();
 		
 		private var _content:McCatalog;
		private var _controls:McStufControls;
		private var _colorPicker:ColorPicker;
		private var _colorPickerSec:ColorPicker;
		private var _count:Spinner;
		
		private var _selectionWidth:int;
		private var _selectionHeight:int;
		private var _bundle:ResourceBundle = Localiztion.getBundle(Modules.STUFF_CATALOG);;

		private var _stuffList : StuffList;
		public var colourSprite2:Sprite;
		
		private var _config:CatalogConfig;
		private var _loading:LoadingSprite;

		public function CatalogView(config : CatalogConfig):void
		{
			_config = config;
			
			createContent();
			
			_controls.btnPrev.addEventListener(MouseEvent.MOUSE_DOWN, onPrevPress);
			_controls.btnNext.addEventListener(MouseEvent.MOUSE_DOWN, onNextPress);
			_controls.btnClose.addEventListener(MouseEvent.MOUSE_DOWN, _closeEvent.sendEvent);
			_controls.btnBuy.addEventListener(MouseEvent.MOUSE_DOWN, _buyEvent.sendEvent);
			_controls.btnBuyEmeralds.addEventListener(MouseEvent.MOUSE_DOWN, _buyEmeraldsEvent.sendEvent);
			_controls.btnCharacter.addEventListener(MouseEvent.MOUSE_DOWN, onCharacterPress);
			
			_controls.btnLeft.addEventListener(MouseEvent.MOUSE_DOWN,onLPress);
			_controls.btnRight.addEventListener(MouseEvent.MOUSE_DOWN,onRPress);
			
			_colorPicker.clickEvent.addListener(onColorChange);
			_colorPickerSec.clickEvent.addListener(onColorChange);
			_stuffList.selectedItemChange.addListener(onSelectedItemChange);
			
			_bundle.registerButton(_controls.btnBuy, 'buy');
			_bundle.registerButton(_controls.btnBuyEmeralds, 'buyEmeralds');
			
			setDialogColor();
		}
		
		private function createContent():void
		{
			_content = new McCatalog();
			_loading = new LoadingSprite(_content.background.getBounds(_content));
			_content.addChild(_loading);
			GraphUtils.optimizeSprite(_content.background);
			
			_controls = _content.mcControls;
			_controls.btnLeft.visible = false;
			_controls.btnRight.visible = false;
			_controls.mcOverFilter.visible = false;
			_controls.mcSelectedFilter.visible = false;
			_controls.coin.visible = false;
			_controls.emerald.visible = false;
			_controls.btnCharacter.visible = false;
			_controls.btnCharacter.buttonMode = true;
			_controls.btnCharacter.mouseChildren = false;
			_controls.mcPrice.visible = false;
			_controls.mcEmeralds.visible = false;
			_controls.btnBuy.visible = false;
			_controls.btnBuyEmeralds.visible = false;
			_controls.visible = false;
			
			_colorPicker = new ColorPicker(_controls.colorPicker)
			_colorPicker.content.visible = false;
			_colorPickerSec = new ColorPicker(_controls.colorPickerSec);
			_colorPickerSec.content.visible = false;
			
			_count = new Spinner(_controls.mcCount);
			_count.minValue = 1;
			_count.maxValue = 9;
			_count.content.visible = false;
			_count.changeEvent.addListener(onCountChange);
			_count.value = 1;
			
			_selectionWidth = _controls.mcSelection.width;
			_selectionHeight = _controls.mcSelection.height;
			
			_stuffList = new StuffList(_controls.mcItemsList, _config.rowCount, _config.columnCount);
			
			_controls.btnCharacter.txtCaption.text = "View on my character";
			
			priceField.defaultTextFormat = priceField.getTextFormat(); 
			emeraldsField.defaultTextFormat = emeraldsField.getTextFormat(); 
			
			GraphUtils.removeChildren(_controls.mcItemsList);
			GraphUtils.removeChildren(_controls.mcSelection);
		}
		
		public function get selectedItem() : StuffSprite
		{
			return _stuffList.selectedItem;
		}
		
		private function onLPress(e:MouseEvent) : void
		{
			ClothesItemView.rotateLeft();
		}
      
		private function onRPress(e:MouseEvent) : void
		{
			ClothesItemView.rotateRight();
		}
		
		private function setDialogColor() : void
		{
			Global.applyUIColour(_content.background.colourSprite);
			Global.applyUIColour(_content.background.colourSprite2);
			
			_content.background.colourSprite2.alpha = 0.6;
			_content.background.colourSprite.alpha = 0.3;
		}

		public function setItems(value:Array):void
		{
			GraphUtils.detachFromDisplay(_loading);
			_controls.visible = true;
			_stuffList.setItems(value);
			if (value.length == 1)
				forceFirstItem();
			refresh();
		}
		
		private function forceFirstItem():void
		{
			var item:StuffSprite = _stuffList.items[0];
			if (item.enabled)
			{
				_stuffList.selectedItem = item;
				if (item.ready)
					onSelectedItemChange();
				else
					item.refreshEvent.addListener(onSelectedItemChange);
			}
		}
		
		public function refreshList():void
		{
			_stuffList.refresh();
			refresh();
		}
		
		private function refresh():void
		{
			if(_stuffList.pagesCount > 1)
			{
				_controls.mcPointer.x = _controls.mcLine.x +
				_controls.mcLine.width * _stuffList.pageIndex / (_stuffList.pagesCount - 1);
			}
			
			GraphUtils.setBtnEnabled(_controls.btnPrev, _stuffList.backEnabled );
			GraphUtils.setBtnEnabled(_controls.btnNext, _stuffList.nextEnabled);
		}
		
		private function onSelectedItemChange(sender:Object = null):void
		{
			GraphUtils.removeChildren(_controls.mcSelection);
			
			var itemSelected:Boolean = Boolean(_stuffList.selectedItem); 
			
			_controls.coin.visible = itemSelected && !_config.futureItems;
			_controls.emerald.visible = itemSelected && _config.emeraldsEnabled;
			_controls.mcPrice.visible = itemSelected && !_config.futureItems;
			_controls.mcEmeralds.visible = itemSelected && _config.emeraldsEnabled;
			_controls.btnBuy.visible = itemSelected && byeEnabled && !_config.futureItems;
			_controls.btnBuyEmeralds.visible = itemSelected && byeEnabled && _config.emeraldsEnabled;
			_colorPicker.content.visible = itemSelected && _stuffList.selectedItem.hasColor;
			_colorPickerSec.content.visible = itemSelected && _stuffList.selectedItem.doubleColor;
			_count.content.visible = itemSelected && _config.countVisible;
				
			if (itemSelected)
			{
				_stuffList.selectedItem.color = _colorPicker.color;
				_stuffList.selectedItem.colorSec = _colorPickerSec.color;
				
				var itemInfo:StuffSprite = _stuffList.selectedItem;
				var pageSprite:ItemViewBase;
				if (itemInfo.item.type == StuffTypes.ROBOT)
					pageSprite = new RobotItemView(itemInfo);
				else if (itemInfo.item.type == StuffTypes.CLOTHES)
					if(!viewOnCharacter) {
						pageSprite = new ClothesDefaultItemView(itemInfo);
					} else {
						pageSprite = new ClothesItemView(itemInfo);
					} 
				else if (itemInfo.item.type == StuffTypes.BUGS)
					pageSprite = new BugsItemView(itemInfo);
				else 
					pageSprite = new StuffItemView(itemInfo);
							
				_controls.mcSelection.addChild(pageSprite);
				GraphUtils.alignCenter(pageSprite,
					new Rectangle(0, 0, _selectionWidth, _selectionHeight));
				
				priceField.text = getPriceText();
				emeraldsField.text = getEmeraldsText();
				
				_controls.btnLeft.visible = itemSelected && byeEnabled && itemInfo.item.type == StuffTypes.CLOTHES;
				_controls.btnRight.visible = itemSelected && byeEnabled && itemInfo.item.type == StuffTypes.CLOTHES;
				_controls.btnCharacter.visible = itemSelected && byeEnabled && itemInfo.item.type == StuffTypes.CLOTHES;
			}
		}
		
		private function getPriceText():String
		{
			var result:String;
			var stuff:StuffTypeTO = selectedItem.item as StuffTypeTO;
			if (stuff.skuInfo)
			{
				var sign:String = Global.resourceBundles.currencies.messages[stuff.skuInfo.sign];
				result = stuff.skuInfo.price + sign;
			}
			else
			{
				result = (stuff.price * _count.value) + KavalokConstants.MONEY_CHAR
				if(result == "0") { result = "Free"; }
			}
			return result;			
		}
		
		private function getEmeraldsText():String
		{
			var result:String;
			var stuff:StuffTypeTO = selectedItem.item as StuffTypeTO;
			if (stuff.skuInfo)
			{
				var sign:String = Global.resourceBundles.currencies.messages[stuff.skuInfo.sign];
				result = stuff.skuInfo.emeralds + sign;
			}
			else
			{
				result = (stuff.emeralds * _count.value) + KavalokConstants.EMERALDS_CHAR
				if(result == "0") { result = "Free"; }
			}
			return result;		
		}
		
		private function onColorChange(sender:ColorPicker):void
		{
			onSelectedItemChange();
		}
		
		private function onCountChange(sender:Spinner):void
		{
			onSelectedItemChange();
		}
		
		private function onCharacterPress(event:MouseEvent) : void
		{
			if(viewOnCharacter) { 
				viewOnCharacter = false;
				_controls.btnCharacter.txtCaption.text = "View on my character";
			} else { 
				viewOnCharacter = true; 
				_controls.btnCharacter.txtCaption.text = "View on default body";
			}
			onSelectedItemChange();
			//refresh();
		}
		
		private function onPrevPress(event:MouseEvent) : void
		{
			_stuffList.pageIndex--;
			refresh();
		}
		
		private function onNextPress(event:MouseEvent) : void
		{
			_stuffList.pageIndex++;
			refresh();
		}
		
		public function get priceField():TextField
		{
			return TextField(_controls.mcPrice.txtCaption);
		}
		
		public function get emeraldsField():TextField
		{
			return TextField(_controls.mcEmeralds.txtCaption);
		}
		
		public function get closeEvent():EventSender { return _closeEvent; }
		
		public function get content():Sprite { return _content; }
		public function get buyEvent():EventSender { return _buyEvent; }
		public function get buyEmeraldsEvent():EventSender { return _buyEmeraldsEvent; }
		public function get count():int { return _count.value; }
	}
	
}