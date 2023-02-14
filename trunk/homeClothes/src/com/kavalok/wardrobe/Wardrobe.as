package com.kavalok.wardrobe
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.wardrobe.commands.QuitCommand;
	import com.kavalok.wardrobe.view.ItemSprite;
	
	public class Wardrobe
	{
		private var _items:Array = [];
		private var _usedItems:Array = [];
		private var _updateList:Object = {};
		
		private var _usedChangeEvent:EventSender = new EventSender();
		
		public function Wardrobe()
		{
			initialize();
			//Global.charManager.stuffs.refreshEvent.addListenerIfHasNot(onRefreshEvent);
		}
		
		private function onRefreshEvent(e:Object = null):void
		{
			// TODO Auto Generated method stub
			trace("refresh event on wardrobe");
		}
		
		private function initialize():void
		{
			if(Global.itemOnMarket){
				Global.charManager.stuffs.refresh();
				Global.itemOnMarket = false;
			}
		
			var clothes:Array = Global.charManager.stuffs.getClothes();
			for each (var stuff:StuffItemLightTO in clothes)
			{
				var item:ItemSprite = new ItemSprite(stuff);
				_items.push(item);
				
				if (stuff.used)
					_usedItems.push(item);
			}
		}
		
		public function addToUpdateList(item:ItemSprite):void
		{
			_updateList[item.stuff.id] = item.stuff;	
		}
		
		public function randomize():void
		{
			unUseAll();
			useItem(getRandomItem(0));
			useItem(getRandomItem(1));
			useItem(getRandomItem(2));
		}
		
		private function getRandomItem(groupNum:int):ItemSprite
		{
			var items:Array = Arrays.getByRequirement(getItems(groupNum),
				new PropertyCompareRequirement('enabled', true));
			return Arrays.randomItem(items);
		}
		
		public function unUseAll():void
		{
			var usedItemsCopy:Array = _usedItems.slice();
			for each (var item:ItemSprite in usedItemsCopy)
			{
				unUseItem(item);
			}
		}
		
		public function get usedClothes():Array
		{
			var result:Array = [];
			for each (var item:ItemSprite in _usedItems)
			{
				result.push(item.stuff);	
			} 
			 
			 return result;
		}
		
		public function useItem(newItem:ItemSprite):void
		{
			if (!newItem)
				return;
			
			var usedItemsCopy:Array = _usedItems.slice();
			for each (var item:ItemSprite in usedItemsCopy)
			{
				if (!Stuffs.isCompatible(item.placement, newItem.placement))
					unUseItem(item);
			}
			
			_usedItems.push(newItem);
			_usedChangeEvent.sendEvent();
			newItem.visible = false;
		}
		
		public function unUseLast():void
		{
			if (_usedItems.length > 0)
				unUseItem(Arrays.lastItem(_usedItems) as ItemSprite);
		}
		
		public function unUseItem(item:ItemSprite):void
		{
			Arrays.removeItem(item, _usedItems);
			item.visible = true;
			_usedChangeEvent.sendEvent();
		}
		
		public function removeItem(item:ItemSprite):void
		{
			Global.charManager.stuffs.removeItem(item.stuff);
			Arrays.removeItem(item, _items);
		}
		
		public function removeItemNoServer(item:ItemSprite):void 
		{
			Arrays.removeItem(item, _items);
		}
		
		public function getItem(id:String):ItemSprite
		{
			return Arrays.firstByRequirement(_items,
				new PropertyCompareRequirement('id', id)) as ItemSprite;
		}
		
		public function getItems(groupNum:int):Array
		{
			return Arrays.getByRequirement(_items, new GroupRequirement(groupNum));
		}
		
		public function get updateList():Object { return _updateList; }
		
		public function get usedChangeEvent():EventSender { return _usedChangeEvent; }
	}
}