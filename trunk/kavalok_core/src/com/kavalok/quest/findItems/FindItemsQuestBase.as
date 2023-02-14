package com.kavalok.quest.findItems
{
	import com.kavalok.Global;
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.gameplay.commands.RetriveStuffCommand;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.quest.LocationQuestBase;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;

	public class FindItemsQuestBase extends LocationQuestBase
	{
		protected var _items:Array = [];
		private var _itemClass : Class;
		private var _itemsCount : int;
		private var _bundle : ResourceBundle;
		
		public function FindItemsQuestBase(locationId:String, itemClass : Class, itemsCount : int, bundleId:String)
		{
			super(locationId);
			_bundle = Localiztion.getBundle(bundleId);
			_itemClass = itemClass;
			_itemsCount = itemsCount;
		}
		
		public function get items():Array
		{
			return _items;
		}
		public function get canTake():Boolean
		{
			return true;
		}
		
		public function getState():String
		{
			if (canTake && _items.length == 1)
				return QuestStates.QUEST_COMPLETE;	
			
			if (canTake)
				return QuestStates.NEXT_ITEM;
				
			if (_items.length > 0)	
				return QuestStates.NO_ITEM;
				
			return QuestStates.FIRST_ITEM;
		}

		public function createItems():void
		{
			var locations:Array = Arrays.randomItems(LOCATIONS, _itemsCount);
			
			for each (var location:String in locations)
			{
				_items.push(new QuestItem(location));
				trace('quest item:', location);
			}
		}

		public function removeItem():void
		{
			Arrays.removeItem(getCurrentItem(), _items);
		}

		override protected function processTargetLocation() : void
		{
			Global.locationManager.executeCommand(createNPCCommand());
		}
		
		protected function createNPCCommand() : NPCCommand
		{
			throw new NotImplementedError();
		}
		
		private function getCurrentItem():QuestItem
		{
			return Arrays.firstByRequirement(_items,
				new PropertyCompareRequirement('done', true)) as QuestItem;
		}
		

		public function retriveItem(item:String):void
		{
			new RetriveStuffCommand(item, _bundle.getMessage("npcName")).execute();
		}
		
		protected function createItemCommand(item : QuestItem) : QuestItemCommand
		{
			return new QuestItemCommand(this, item, _itemClass);
		}
		
		protected function hasItem(item:String):Boolean
		{
			return Global.charManager.stuffs.stuffExists(item);
		}
		
		override protected function processLocation(locationId : String) : void
		{
			for each (var item:QuestItem in _items)
			{
				if (item.location == locationId)
				{
					Global.locationManager.executeCommand(createItemCommand(item));
				}
			}
		}
		
	}
}