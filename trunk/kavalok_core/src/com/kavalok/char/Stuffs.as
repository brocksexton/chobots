package com.kavalok.char
{
	import com.kavalok.Global;
	import com.kavalok.char.commands.StuffCommandBase;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.dto.stuff.StuffTOBase;
	import com.kavalok.events.EventSender;
	import com.kavalok.messenger.commands.GiftMessage;
	import com.kavalok.remoting.RemoteCommand;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.PrefixRequirement;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.utils.getDefinitionByName;
	
	public class Stuffs
	{
		static public const BACKPACK_REGULAR_SIZE:int = 50;
		static public const BACKPACK_CITIZEN_SIZE:int = 100;
		
		static public const RECYCLE_KOEF:Number = 0.2;
		
		private var _loading:Boolean = false;
		private var _loaded:Boolean = false;
		private var _doneRefresh:EventSender = new EventSender();
		private var _refreshEvent:EventSender = new EventSender();
		private var _itemUsedEvent : EventSender = new EventSender();
		private var _changeEvent : EventSender = new EventSender();
		private var _removeItemFromWardrobe : EventSender = new EventSender();
		private var _list:Array = [];
		private var _idList:Array = [];
		private var _commands:Object = {};
		public var _item:StuffItemLightTO;
		public var _user:Number;
		
		static public function getClothesFromOptimized(optimizedList:Array):Array
		{
			var result:Array = [];
			for each (var optimizedItem:Object in optimizedList)
			{
				var item:StuffItemLightTO = new StuffItemLightTO();
				item.fileName = optimizedItem.n;
				item.color = optimizedItem.c;
				item.colorSec = optimizedItem.c2;
				item.placement = optimizedItem.p;
				item.type = StuffTypes.CLOTHES;
				//	item.name = optimizedItem.n;
				result.push(item);
			}
			return result;
		}
		
		public static function isCompatible(placement1:String, placement2:String):Boolean
		{
			if (placement1 == '*' || placement2 == '*')
				return false;
			
			for (var i:int = 0; i < placement1.length; i++)
			{
				var char:String = placement1.charAt(i);
				if (placement2.indexOf(char) >= 0)
					return false;
			}
			
			return true;
		}
		
		public function Stuffs()
		{
		}
		
		public function refresh():void
		{
			_refreshEvent.sendEvent();
			new CharService(onGetLoadedStuffs).refreshStuffs(Global.charManager.charId);
					//	_list = [];
				//		_idList = [];
		//				new CharService(setListWithLoaded).getCharStuffs();
		}
		
		public function refreshStuffClothes():void
		{
		  new CharService(onGetLoadedStuffs).refreshStuffs(Global.charManager.charId);
		}
		
		public function onGetLoadedStuffs(result:Object):void
		{
		   setList(result.stuffs);
		   _doneRefresh.sendEvent();
		}
		
		public function updateItems(itemsList:Object):void
		{
			var updateList:Array = [];
			
			for each (var staff:StuffItemLightTO in itemsList)
			{
				var item:Object =
					{
						id : staff.id,
							x  : int(staff.position.x),
							y  : int(staff.position.y),
							used : staff.used,
							color : int(staff.color),
							colorSec : int(staff.colorSec)
					}
				
				updateList.push(item);
			}
			
			new CharService().saveCharStuffs(updateList);
		}
		
		public function makePresent(item:StuffItemLightTO, userId:Number):void
		{
			new AdminService(presentVerified).verifyItemOwner(item.id);
			_item = item;
			_user = userId;
		}
		
		public function presentVerified(val:Boolean):void
		{
			if(val){
				new CharService(onItemRemoved).makePresent(_user, _item.id);
				
				var msg:GiftMessage = new GiftMessage();
				msg.itemId = _item.id;
				new MessageService().sendCommand(_user, msg, true);
			} else {
				Global.isLocked = false;
				Dialogs.showOkDialog("Are you sure this item belongs to you? Maybe you put it on the market!");
			}
			
		}
		public function setUsedClothes(appliedClothes:Array):void
		{
			mergeClothes(appliedClothes, true);
			_refreshEvent.sendEvent();
			processStuffCommands();
		}
		
		public function addUsedClothes(appliedClothes:Array):void
		{
			mergeClothes(appliedClothes, false);
			_refreshEvent.sendEvent();
			processStuffCommands();
		}
		
		private function mergeClothes(appliedClothes:Array, replace:Boolean = false):void
		{
			var updateList:Object = {};
			var usedClothes:Array = getUsedClothes();
			var usedItem:StuffItemLightTO;
			if (replace)
			{
				for each (usedItem in usedClothes)
				{
					unUseClothe(usedItem);
					updateList[usedItem.id] = usedItem;
				}
				usedClothes = [];
			}
			for each (var newItem:StuffItemLightTO in appliedClothes)
			{
				for each (usedItem in usedClothes)
				{
					if (!isCompatible(usedItem.placement, newItem.placement))
					{
						unUseClothe(usedItem);
						updateList[usedItem.id] = usedItem;
					}
				}
				newItem = useClothe(newItem.id);
				usedClothes.push(newItem);
				updateList[newItem.id] = newItem;
			}
			updateItems(updateList);
		}
		
		public function unUseClothe(item:StuffItemLightTO):void
		{
			if (item.used)
			{
				item.used = false;
				var command:StuffCommandBase = _commands[item.id];
				if (command)
				{
					command.restore();
					delete _commands[item.id];
				}
			}
		}
		
		private function useClothe(itemId:int):StuffItemLightTO
		{
			var item:StuffItemLightTO = getById(itemId);
			item.used = true;
			checkClotheCommand(item);
			return item;
		}
		
		private function checkClotheCommand(item:StuffItemLightTO):void
		{
			const COMMAND_NAME:String = 'command';
			const PACKAGE:String = 'com.kavalok.char.commands';
			
			var parameters:Object = Strings.getParameters(item.info);
			var commandName:String = parameters[COMMAND_NAME];
			if (commandName)
			{
				var className:String = PACKAGE + '::' + commandName;
				var commandClass:Class = getDefinitionByName(className) as Class;
				var command:StuffCommandBase = new commandClass();
				_commands[item.id] = command;
				command.stuff = item;
				command.parameters = parameters;
				command.apply();
			}
		}
		
		public function processStuffCommands():void
		{
			var items:Array = getUsedClothes();
			for each (var item:StuffItemLightTO in items)
			{
				checkClotheCommand(item);
			}
		}
		
		public function useItem(item:StuffItemLightTO):void
		{
			if (item.type == StuffTypes.CLOTHES)
				Global.charManager.applyClothes([item]); 
			else
				_itemUsedEvent.sendEvent(item);
			
			if(item.type == StuffTypes.STUFF)
				removeItem(item);
		}
		
		public function removeItem(item:StuffTOBase):void
		{
			new StuffServiceNT().removeItem(item.id);
			onItemRemoved(item.id);
		}
		
		public function getIdForStuffID(stuffID:int):int 
		{
			for(var i:int=0; i < _list.length; i++)
			{
				var item:StuffItemLightTO = StuffItemLightTO(_list[i]);
				
				if(item != null) 
				{
					if(item.id == stuffID)
					{
						trace("found match, at index: " + i);
						return i;
					}
				}
			}
			
			return 0;
		}
		
		public function onItemRemoved(itemId:int):void
		{
			trace("remvoing item ::::  " + getById(itemId) + " > "+ getById(itemId));
			Arrays.removeItem(getById(itemId), _list);
			Arrays.removeItem(itemId, _idList);
			_refreshEvent.sendEvent();
			
			if(_list.indexOf( getById( itemId ) )  != -1 ){
				trace("the item is still in the array, check #1");
				
				
			} else {
				trace("mm.., the item was removed, or was never there..");
			}
			
			for each(var res:StuffItemLightTO in _list)
			{
				if(res.id == itemId) 
					trace("oshit the item exists");
			}
			
			
			for each(var rese:int in _idList)
			{
				if(rese == itemId) 
					trace("oshit the item exists #2 in idList");
			}
			
			refreshStuffClothes();
			this.refresh();
		}
		
		public function addItem(item:StuffItemLightTO, sendRefresh : Boolean = true):void
		{
			if (_idList.indexOf(item.id) == -1)
			{
				_list.push(item);
				_idList.push(item.id);
				if(sendRefresh)
					refreshStuffClothes();
			}
		}
		
		public function deleteItem(item:StuffItemLightTO) : void
		{
			if(item.type == StuffTypes.STUFF)
			{
				removeItem(item);
			}
			if(item.type == StuffTypes.PLAYERCARD)
			{
				removeItem(item);
			}
			if(item.type == StuffTypes.FISH)
			{
				removeItem(item);
			}
		}
		
		public function setListWithLoaded(value:Array):void
		{
			addToList(value);
			_loaded=true;
		}
		
		public function addItems(value:Array):void
		{
			var stuffStr : String;
			for (var i:int = 0; i < value.length; i++)
			{
				addItem(value[i], false);
			}
			_refreshEvent.sendEvent();
		}
		
		public function addToList(value:Array):void
		{
			var stuffStr : String;
			for (var i:int = 0; i < value.length; i++)
			{
				var stuffItem:StuffItemLightTO = new StuffItemLightTO(value[i]);
				addItem(stuffItem, false);
			}
			_refreshEvent.sendEvent();
		}
		
		public function setList(value:Array):void
		{
			_list = value;
			_refreshEvent.sendEvent();
		}
		
		public function getBagFish():Array
		{
			return getByType(StuffTypes.FISH)
		}
		
		public function getBagStuffs():Array
		{
			return getByType(StuffTypes.STUFF)
		}
		
		public function getCards():Array
		{
			return getByType(StuffTypes.PLAYERCARD)
		}
		
		public function getGiftableItems():Array
		{
			var result:Array = [];
			for each (var item:StuffItemLightTO in _list)
			{
				if (item.giftable && !item.used)
					result.push(item);
			}
			return result;
		}
		
		public function getTradableItems():Array
		{
		   var result:Array = [];
		   for each (var item : StuffItemLightTO in _list)
		   {
			 result.push(item);
		   }
     	   return result;
		}
		
		public function getCocktails():Array
		{
			return getByType(StuffTypes.COCKTAIL);
		}
		
		public function getClothes():Array
		{
			return getByType(StuffTypes.CLOTHES);
		}
		
		public function getUsedClothes():Array
		{
			return Arrays.getByRequirement(_list,
				new PropertyCompareRequirement('used', true));
		}
		
		public function getUsedClothesOptimized():Array
		{
			var clothes:Array = getUsedClothes();
			var result:Array = [];
			for each (var item:StuffItemLightTO in clothes)
			{
				var optimizedItem:Object = {};
				optimizedItem.n = item.fileName;
				optimizedItem.c = item.color;
				optimizedItem.c2 = item.colorSec;
				optimizedItem.p = item.placement;
				result.push(optimizedItem);
			}
			return result;
		}
		
		public function stuffExists(fileName:String):Boolean
		{
			return Arrays.containsByRequirement(_list,
				new PropertyCompareRequirement('fileName', fileName)); 
		}
		
		public function getStuffsCount(stuffType:String):int
		{
			return Arrays.getByRequirement(_list,
				new PropertyCompareRequirement('type', stuffType)).length;
		}
		
		/*public function getFishCount():int
		{
			var realResult:Array = [];
			var fishBag = getByType(StuffTypes.FISH);
			for each (var item:StuffItemLightTO in fishBag)
			{
				var checkAmount:Array = Arrays.getByRequirement(_list,
					new PropertyCompareRequirement('fileName', item.fileName)).length;
					
				var showItem:Object = {};
				showItem.i = item;
				showItem.n = checkAmount;
				realResult.push(showItem);
			}
				
				
			var result:Array = Arrays.getByRequirement(_list,
				new PropertyCompareRequirement('fileName', fileName)).length;
		}*/
		
		public function getById(id:int):StuffItemLightTO
		{
			var result:Array = Arrays.getByRequirement(_list,
				new PropertyCompareRequirement('id', id));
			
			return (result.length > 0) ? result[0] : null;
		}
		
		private function getByType(stuffType:String):Array
		{
			return Arrays.getByRequirement(_list,
				new PropertyCompareRequirement('type', stuffType));
		}
		
		public function getByShop(shopName:String):Array
		{
			return Arrays.getByRequirement(_list,
				new PropertyCompareRequirement('shopName', shopName));
		}
		
		public function isItemUsed(fileName:String):Boolean
		{
			return Arrays.containsByRequirement(getUsedClothes(),
				new PropertyCompareRequirement('fileName', fileName));
		}
		
		public function get hasFlyStuffs():Boolean
		{
			return Arrays.containsByRequirement(getUsedClothes(),
				new PrefixRequirement('fileName', 'fly')); 
		}
		
		public function get refreshEvent():EventSender { return _refreshEvent; }
		public function get doneRefresh():EventSender { return _doneRefresh; }
		public function get changeEvent():EventSender { return _changeEvent; }
		public function get removedItemFromWardrobe():EventSender { return _removeItemFromWardrobe; }
		public function get itemUsedEvent():EventSender { return _itemUsedEvent; }
		public function get loaded():Boolean { return _loaded; }
		public function get loading():Boolean { return _loading; }
		public function set loading(value : Boolean):void { _loading=value; }
	}
}