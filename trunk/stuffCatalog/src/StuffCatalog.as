package
{
	
	import com.kavalok.Global;
	import com.kavalok.billing.BillingUtil;
	import com.kavalok.char.Stuffs;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.dto.stuff.StuffTOBase;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.BuyConfirmEmeraldsCommand;
	import com.kavalok.gameplay.commands.BuyConfirmCommand;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.robots.RobotItemInfoSprite;
	import com.kavalok.robots.commands.RefreshRobotCommand;
	import com.kavalok.services.BillingTransactionService;
	import com.kavalok.services.RobotService;
	import com.kavalok.services.StuffService;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.stuffCatalog.CatalogConfig;
	import com.kavalok.stuffCatalog.view.CatalogView;
	import com.kavalok.utils.ReflectUtil;
	
	import flash.events.Event;
	
	import stuffCatalog.McStarPayment;
	import stuffCatalog.McStarPremium;
	import stuffCatalog.McLevel;
	
	public class StuffCatalog extends WindowModule
	{
		private static const DEFAULT_ROW_COUNT : int = 3;
		private static const DEFAULT_COLUMN_COUNT : int = 3;
		
		private static var bundle : ResourceBundle = Localiztion.getBundle(Modules.STUFF_CATALOG);

		private var _view:CatalogView;
		private var _items:Array = [];
		private var _newStuffs:Array = [];
		private var _newClothes:Array = [];
		private var _oldClothes:Array = stuffs.getUsedClothes();
		private var _canDisable:Boolean;
		private var _config:CatalogConfig;
		private var _stuffsNeedRefresh:Boolean = false;
		
		public function StuffCatalog()
		{
		}
		
		override public function initialize():void
		{
			var shopName:String = parameters.shop; 
			_config = new CatalogConfig();
			_config.rowCount = parameters.rowCount || DEFAULT_ROW_COUNT;
			_config.columnCount = parameters.columnCount || DEFAULT_COLUMN_COUNT;
			_config.countVisible = parameters.countVisible != "false";
			_config.futureItems = parameters.futureItems == "true";
			_config.emeraldsEnabled = parameters.emeraldsEnabled == "true";
			_config.canGetCho = parameters.canGetCho == "true";
			
			_canDisable = parameters.canDisable;
			_view = new CatalogView(_config);
			
			addChild(_view.content);
			
			_view.closeEvent.addListener(onClose);
			_view.buyEvent.addListener(onBuy);
			_view.buyEmeraldsEvent.addListener(onBuyEmeralds);
			
			new StuffServiceNT(onGetTypes).getStuffTypes(parameters.shop);
			
			readyEvent.sendEvent();
		}
		
		private function onGetTypes(result:Array) : void
		{
			createItems(result);
		}
		
		private function createItems(stuffs:Array):void
		{
			for each (var stuff:StuffTypeTO in stuffs)
			{
				var item:StuffSprite = new StuffSprite(stuff, stuff.enabled);
				if (stuff.skuInfo && stuff.type == StuffTypes.ROBOT)
					item.star = new McStarPayment();
				if (stuff.premium)
					item.star = new McStarPremium();
				if (stuff.type == StuffTypes.ROBOT && !stuff.enabled)
					createToolTip(item);
				
				_items.push(item);
				if(stuff.doubleColor)
				trace("YES, doubleColor");
			}
			_view.setItems(_items);
		}
		
		private function createToolTip(stuffSprite:StuffSprite):void
		{
			var itemTO:RobotItemTO = new RobotItemTO();
			itemTO.name = stuffSprite.item.name;
			ReflectUtil.copyFieldsAndProperties(StuffTypeTO(stuffSprite.item).robotInfo, itemTO);
			var tip:String = new RobotItemInfoSprite(itemTO).htmlText;
			ToolTips.registerObject(stuffSprite, tip);
		}
		
		private function onBuyEmeralds(e:Event):void
		{
			var item:StuffTOBase = _view.selectedItem.item;
			if(Global.charManager.isGuest || Global.charManager.isNotActivated){
				closeModule();
				new RegisterGuestCommand().execute();
			}
			else if(item.premium && !Global.charManager.isMerchant)
				new CitizenWarningCommand("stuffCatalog", Global.messages.itemForCitizens, closeModule).execute()
			else
				buyItemEmeralds();
		}
		
		private function onBuy(e:Event):void
		{
			var item:StuffTOBase = _view.selectedItem.item;
			if(Global.charManager.isGuest || Global.charManager.isNotActivated){
				closeModule();
				new RegisterGuestCommand().execute();
			}
			else if(item.premium && !Global.charManager.isCitizen)
				new CitizenWarningCommand("stuffCatalog", Global.messages.itemForCitizens, closeModule).execute()
			else
				buyItem();
		}
		
		private function buyItem():void
		{
			var item:StuffTypeTO = StuffTypeTO(_view.selectedItem.item);
			var count:int = _view.count;
			
			if (item.type == StuffTypes.STUFF && !Global.superUser && !Global.charManager.isModerator)
			{
				var totalLength:int = _newStuffs.length	+ stuffs.getStuffsCount(StuffTypes.STUFF) + count; 
				if (totalLength > Global.charManager.backPackLimit)
				{
					Dialogs.showOkDialog(Global.messages.bagIsFull);
					return;
				}
			}
			if (item.skuInfo)
				onBuyAccept();
			else
				new BuyConfirmCommand(item.price * count, onBuyAccept).execute();
		}
		
		private function buyItemEmeralds():void
		{
			var item:StuffTypeTO = StuffTypeTO(_view.selectedItem.item);
			var count:int = _view.count;
			
			if (item.type == StuffTypes.STUFF && !Global.superUser && !Global.charManager.isModerator)
			{
				var totalLength:int = _newStuffs.length	+ stuffs.getStuffsCount(StuffTypes.STUFF) + count; 
				if (totalLength > Global.charManager.backPackLimit)
				{
					Dialogs.showOkDialog(Global.messages.bagIsFull);
					return;
				}
			}
			if (item.skuInfo)
				onBuyEmeraldsAccept();
			else
				new BuyConfirmEmeraldsCommand(item.emeralds * count, onBuyEmeraldsAccept).execute();
		}
		
		private function onBuyEmeraldsAccept():void
		{
			Global.isLocked = true;
			
			var stuff:StuffTypeTO = StuffTypeTO(_view.selectedItem.item);
			var typeId:int = stuff.id;
			var color:int = _view.selectedItem.color;
			var colorSec:int = _view.selectedItem.colorSec;
			
			if (_config.canGetCho){
				Global.addExperience(1);
			}
			
			new StuffService(onBuyStuffComplete).buyItemEmeralds(typeId, _view.count, color, colorSec);
			_stuffsNeedRefresh = true;
		}
		
		private function onBuyAccept():void
		{
			Global.isLocked = true;
			
			var stuff:StuffTypeTO = StuffTypeTO(_view.selectedItem.item);
			var typeId:int = stuff.id;
			var color:int = _view.selectedItem.color;
			var colorSec:int = _view.selectedItem.colorSec;
			
			if (_config.canGetCho){
				Global.addExperience(1);
			}
			
			if (stuff.type == StuffTypes.ROBOT)
			{
				if (stuff.skuInfo)
					new BillingTransactionService(onRequestRobotsItem).requestRobotsItem(stuff.skuInfo.id, 'stuffCatalog');
				else
					new RobotService(onByRobotComplete).buyItem(typeId, color);
			}
			else
			{
				if (stuff.skuInfo)
					new BillingTransactionService(onRequestRobotsItem).requestPayedItem(stuff.skuInfo.id, 'stuffCatalog');
				else{
					new StuffService(onBuyStuffComplete).buyItem(typeId, _view.count, color, colorSec);
					_stuffsNeedRefresh = true;
				}
			}
		}
		
		private function onRequestRobotsItem(result:Object):void
		{
			Global.isLocked = false;
 			BillingUtil.processPaymentForm(result);			
		}
		
		private function onRequestPayedItem(result:Object):void
		{
			Global.isLocked = false;
 			BillingUtil.processPaymentForm(result);			
		}

		private function onByRobotComplete(result:Object):void
		{
			Global.isLocked = false;
			new RefreshRobotCommand().execute();
			
			if (!Global.charManager.hasRobot)
			{
				Dialogs.showOkDialog(Global.resourceBundles.robots.messages.onBuyRobotMessage);
				closeModule();
			}
		}
		
		private function onBuyStuffComplete(result:Array):void
		{
			if(_canDisable)
				_view.selectedItem.enabled = false;
			Global.isLocked = false;
			
			_newStuffs = _newStuffs.concat(result);
			stuffs.addItems(result);
			if (_view.selectedItem.item.type == StuffTypes.CLOTHES)
				_newClothes.push(result[0]);
			_view.refreshList();
		}
		
		private function onClose(e:Event):void
		{
			if (_stuffsNeedRefresh)
			{
				Global.isLocked = true;
				stuffs.refreshEvent.addListener(onRefreshComplete);
				stuffs.refresh();
			}
			else
			{
				closeModule();
			}
		}
		
		private function onRefreshComplete():void
		{
			Global.isLocked = false;
			stuffs.refreshEvent.removeListener(onRefreshComplete);
			
			if (_newClothes.length > 0)
				Global.charManager.applyClothes(_newClothes);
			
			if (_newClothes.length > 0 && _oldClothes.length > 0)
				Dialogs.showOkDialog(Global.messages.stuffsAtHome, true, null, true, "I just bought an item from the catalog @Chobots!");
			
			closeModule();
		}
		
		public function get stuffs():Stuffs
		{
			 return Global.charManager.stuffs;
		}
	}
	
}