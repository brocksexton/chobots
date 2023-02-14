package com.kavalok.admin.stuffs
{
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.services.StuffTypeService;
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.Strings;
	import mx.controls.ComboBox;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.containers.Canvas;
	import mx.utils.ObjectUtil;
	import org.goverla.collections.ArrayList;
	
	public class StuffTypeViewBase extends Canvas
	{
		[Bindable] public var premiumBox:CheckBox;
		[Bindable] public var giftableBox:CheckBox;
		[Bindable] public var colorBox:CheckBox;
		[Bindable] public var rainableBox:CheckBox;
		[Bindable] public var priceField:TextInput;
		[Bindable] public var groupNumField:TextInput;
		[Bindable] public var shopCombo:ComboBox;
		[Bindable] public var nameField:TextInput;
		[Bindable] public var fileNameField:TextInput;
		[Bindable] public var typeField:TextInput;
		[Bindable] public var placementField:TextInput;
		[Bindable] public var infoField:TextArea;
		[Bindable] public var itemOfTheMonthField:TextInput;
		
		[Bindable] public var item:StuffTypeAdminTO;
		[Bindable] public var shopList:ArrayList;
		[Bindable] public var saveButton:Button;
		
		public function StuffTypeViewBase()
		{
			super();
		}
		
		public function save():void
		{
			item.premium = premiumBox.selected;
			item.hasColor = colorBox.selected;
			item.giftable = giftableBox.selected;
			item.rainable = rainableBox.selected;
			item.price = parseInt(priceField.text);
			item.shopName = shopCombo.selectedItem?String(shopCombo.selectedItem):"";
			item.placement = Strings.trim(placementField.text);
			item.info = Strings.trim(infoField.text);
			item.itemOfTheMonth = Strings.trim(itemOfTheMonthField.text);
			item.groupNum = parseInt(groupNumField.text);
			item.name = Strings.trim(nameField.text)
			item.fileName = Strings.trim(fileNameField.text)
			item.type = Strings.trim(typeField.text)
			
			saveButton.enabled = false;
			new StuffTypeService(onSave).saveItem(item);
		}
		
		private function onSave(result:Object):void
		{
			saveButton.enabled = true;
		}
		
	}
	
}