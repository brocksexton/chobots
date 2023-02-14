package com.kavalok.admin.stuffs 
{
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	import com.kavalok.services.StuffTypeService;
	import mx.controls.ColorPicker;
	import mx.containers.Canvas;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import org.goverla.collections.ArrayList;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class StuffChooserBase extends Canvas
	{
		
		[Bindable] public var shopListCombo : ComboBox;
		[Bindable] public var shopItemsListCombo : ComboBox;
		[Bindable] public var shopList:ArrayList;
		[Bindable] public var shopItemsList:ArrayList;
		[Bindable] public var item:StuffTypeAdminTO;
		[Bindable] public var stuffItemView:StuffItemView;
		[Bindable] public var colorPicker : ColorPicker;
		[Bindable] public var colorPickerLabel : Label;
		[Bindable] public var color : int = 0xFFFFFF;
		[Bindable] public var allowedTypes:Array = null;
		
		public function StuffChooserBase() 
		{
			super();
			new StuffTypeService(onShopList).getShops();
		}
		
		private function onShopList(result:Array):void
		{
			result.sort();
			shopList = new ArrayList(result);
			new StuffTypeService(onGetStuffTypes).getStuffListByShop(shopList[0]);
		}
		
		protected function onShopChange():void
		{
			stuffItemView.setStuffType(null);
			var shopName:String = String(shopListCombo.selectedItem);
			new StuffTypeService(onGetStuffTypes).getStuffListByShop(shopName);
		}
		
		private function onGetStuffTypes(result:Array):void
		{
			result.sortOn("fileName");
			var newList:Array = [];
			for each (var stuff:StuffTypeAdminTO in result) 
			{
				if (!allowedTypes || allowedTypes.indexOf(stuff.type) >= 0)
					newList.push(stuff);
			}
			
			shopItemsList = new ArrayList(newList);
			//shopItemsListCombo.dataProvider = shopItemsList;
			item = (shopItemsList.length > 0)
				? StuffTypeAdminTO(shopItemsList[0])
				: null;
			stuffItemView.setStuffType(item);
			colorPicker.visible = item && item.hasColor;
			colorPickerLabel.visible = item && item.hasColor;
		}
		
		protected function onShopItemChange():void
		{
			item = StuffTypeAdminTO(shopItemsListCombo.selectedItem);
			stuffItemView.setStuffType(item);
			colorPicker.visible = item.hasColor;
			colorPickerLabel.visible = item.hasColor;
		}
		
		protected function onColorChange():void
		{
			color = colorPicker.selectedColor;
			stuffItemView.setStuffType(item, colorPicker.selectedColor);
		}
		
		
	}

}