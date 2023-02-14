package com.kavalok.admin.stuffs
{
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.StuffTypeService;
	import mx.controls.TextInput;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.events.ListEvent;
	import org.goverla.collections.ArrayList;
	
	public class StuffsBase extends Canvas
	{
		[Bindable] public var stuffList:ArrayList;
		[Bindable] public var groupNum:int;
		
		[Bindable] public var selectedItem:StuffTypeAdminTO;
		[Bindable] public var shopList:ArrayList;
		[Bindable] public var shopCombo:ComboBox;
		[Bindable] public var groupNumField:TextInput;
		[Bindable] public var saveGroupButton:Button;
		
		public function StuffsBase()
		{
			super();
			new StuffTypeService(onShopList).getShops();
			new AdminService(onGetStuffGroup).getStuffGroupNum();
		}
		
		private function onShopList(result:Array):void
		{
			result.sort();
			shopList = new ArrayList(result);
		}
		
		private function onGetStuffGroup(result:int):void
		{
			groupNum = result;
		}
		
		protected function saveGroupNum():void 
		{
			saveGroupButton.enabled = false;
			var groupNum:int = parseInt(groupNumField.text);
			new AdminService(onSaveGroupNum).saveStuffGroupNum(groupNum);
		}
		
		private function onSaveGroupNum(result:Object):void
		{
			saveGroupButton.enabled = true;
		}
		
		protected function onItemChange(e:ListEvent):void
		{
			selectedItem = StuffTypeAdminTO(e.itemRenderer.data);
		}
		
		protected function refresh():void
		{
			stuffList = null;
			selectedItem = null;
			new StuffTypeService(onGetList).getStuffListByShop(String(shopCombo.selectedItem));
		}
		
		private function onGetList(result:Array):void
		{
			stuffList = new ArrayList(result);
		}
		
		protected function onAddClick():void
		{
			 selectedItem = new StuffTypeAdminTO();
		}
		
	}
}