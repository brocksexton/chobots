package com.kavalok.gameplay.windows
{
	import com.junkbyte.console.Cc;
	import com.kavalok.Global;
	import com.kavalok.char.CharModel;
	import com.kavalok.char.Char;
	import com.kavalok.commands.char.GetCharCommand;
	import com.kavalok.char.Stuffs;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.controls.StuffListScroller;
	import com.kavalok.gameplay.frame.bag.StuffList;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.gameplay.trade.TradeClient;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.commands.TradeMessage;
	import com.kavalok.services.MessageService;
	import com.kavalok.services.CharService;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	import com.kavalok.ui.Window;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.utils.converting.ConstructorConverter;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;

	public class TradeWindowView extends Window
	{
		public static const ID : String = "tradeWindow";
		private static const REMOTE_ID_FORMAT : String = "trade|{0}|{1}";

		private static var bundle : ResourceBundle = Localiztion.getBundle(ResourceBundles.KAVALOK);
		private static var remoteId:String;
		private static var idRemote:String;

		
		public static function showWindow(charId : String, userId : Number, sendMessage : Boolean, remoteNm : String) : void
		{
			
			var window : TradeWindowView = TradeWindowView(Global.windowManager.getWindow(TradeWindowView.ID));
			idRemote = remoteNm;
			if(window)
			{
				Global.windowManager.activateWindow(window);
				idRemote = remoteNm;
				if(window.partner != charId)
				{
					Dialogs.showOkDialog(bundle.getMessage("tradeCannotOpen2Windows"));
				}
			}
			else
			{
				window = new TradeWindowView(charId);
				Global.windowManager.showWindow(window);
				Global.isTrading = true;
				if(sendMessage)
				{
					var message : TradeMessage = new TradeMessage();
					message.remoteId = idRemote;
					new MessageService().sendCommand(userId, message);
				}
			}
			
		}

		private var _stuffList : StuffList;
		private var _myTradeList : StuffList;
		private var _myScroller : StuffListScroller;
		private var _hisTradeList : StuffList;
		private var _hisScroller : StuffListScroller;
		private var _content : McTradeWindow = new McTradeWindow();
		private var _partner : String;
		private var _partnerID : Number;
		private var _oneAccepted : Boolean;
		private var _finished : Boolean;
		private var _client:TradeClient;
		private var _savedRTid : String;
		private var _giftItems : Array;
		private var _charName : String;
		private var _char : Char;
		private var _timer : Timer;
		private var _chatScroller : TextScroller;
		private var _unsentMessageArray:Array = [];

		private var tradeFForItems:Array = new Array(); 
		//private var itemsIAlreadyHave:Array = new Array();
		
		private var tradeForItems:Array = new Array();
		private var hisTradeForItems:Array = new Array();
		private var itemsIAlreadyHave:Array = new Array();
		
		private function randomIntBT(min:int, max:int):int {
        return Math.round(Math.random() * (max - min) + min);
        }
		
		public function TradeWindowView(partner : String)
		{
			super(_content);
			Dialogs.centerWindow(_content);
			_partner = partner;
			
			_charName = partner;
			new GetCharCommand(Global.charManager.charId, 0, onViewExecuted).execute();
			new GetCharCommand(_charName, 0, onViewExecuted).execute();
			
			var users : Array = [userId, partner];
			users.sort();
			
			_content.chat.chatLog.text = "";
			var rnd : int = randomIntBT(100, 500);
			var rndT : int = randomIntBT(100, 500);
			if(idRemote != null){
			_savedRTid = idRemote;
			}else{
			remoteId = Strings.substitute(REMOTE_ID_FORMAT, users[0] + rnd.toString(), users[1] + rndT.toString());
			_savedRTid = remoteId;
			idRemote = _savedRTid;
			}


			
			_client = new TradeClient();
			_client.connectEvent.addListener(onConnect);
			_client.onCharConnect = onCharConnect;
			_client.onCharDisconnect = onCharDisconnect;
			_client.rAddItem = rAddItem;
			_client.handleMessage = handleMessage;
			_client.rRemoveItem = rRemoveItem;
			_client.rAccept = rAccept;
			_client.connect(_savedRTid);
			
			_content.traderNameField.text = partner;
			GraphUtils.setBtnEnabled(_content.acceptButton, false);


			_chatScroller = new TextScroller(_content.chat.scroller, _content.chat.chatLog);
			
			_content.acceptButton.addEventListener(MouseEvent.CLICK, onAccept);
			
			_content.chat.chatText.maxChars = 100;
			_content.chat.chatText.addEventListener(MouseEvent.CLICK, onClickText);
			_content.chat.chatText.addEventListener(KeyboardEvent.KEY_UP, onKeyDown);

			bundle.registerTextField(_content.partnerField, "tradeWaiting");
			bundle.registerButton(_content.acceptButton, "tradeAccept");
			
			_stuffList = new StuffList(_content.myStuff, 2, 4);
			
			_myTradeList = new StuffList(_content.myTradeStuff, 2, 2);
			_myScroller = new StuffListScroller(_content.myScroller, _myTradeList);
			_hisTradeList = new StuffList(_content.hisTradeStuff, 2, 2);
			_hisScroller = new StuffListScroller(_content.hisScroller, _hisTradeList);
			
			var items : Array = Arrays.getConverted(Global.charManager.stuffs.getTradableItems()	
				, new ConstructorConverter(StuffSprite));
			_stuffList.setItems(items);
			
			_giftItems = Global.charManager.stuffs.getTradableItems();
			
			_content.nothingToTrade.visible = items.length == 0;
			
			_stuffList.selectedItemChange.addListener(onSelectedAddItem);
			_myTradeList.selectedItemChange.addListener(onSelectedRemoveItem);

			ToolTips.registerObject(_stuffList.content, "tradeCannotChangeNotConnected", ResourceBundles.KAVALOK);
			ToolTips.registerObject(_myTradeList.content, "tradeCannotChangeNotConnected", ResourceBundles.KAVALOK);

			Global.charManager.stuffs.refreshEvent.addListener(onStuffChange);
			
			_content.nextButton.addEventListener(MouseEvent.CLICK, onNextClick);			
			_content.prevButton.addEventListener(MouseEvent.CLICK, onPreviousClick);
			_content.sendButton.addEventListener(MouseEvent.CLICK, onSendClick);
			disable();
			refreshButtons();
		}
		
		protected function onClickText(evt:MouseEvent):void
		{
		  if(_content.chat.chatText.length > 2){
		  _content.chat.chatText.text = "";
		  }
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{

			if(event.keyCode == 13){
			if(_content.chat.chatText.length > 0){

			  new MessageService(onGetMessage).checkTradeMessage(_content.chat.chatText.text);
			}
			}
		}
		
		private function onViewExecuted(sender : GetCharCommand) : void
		{
		  _char = sender.char;
		  if(_char && _char.id){
			 if(Global.charManager.charId == _char.id){
			 }else if(_charName == _char.id){
			 _partnerID = _char.userId;
			}
		  }
		}
		
		override public function get windowId():String
		{
			return ID;
		}

		public function get partner():String
		{
			return _partner;
		}
		
		public function get partnerID():Number
		{
		   return _partnerID;
		}

		override public function get dragArea():InteractiveObject
		{
			return _content.headerButton;
		}
		
		override public function onClose():void
		{
			Cc.info("Trade complete or canceled, refreshing items....");
			if(Global.charManager.stuffs.refreshEvent.hasListener(onStuffChange)){
				Global.charManager.stuffs.refreshEvent.removeListener(onStuffChange);
			}
				finishTrade();
			Global.isTrading = false;
			_client.disconnect();
			itemsIAlreadyHave.length = 0;
			tradeFForItems.length = 0;
			tradeForItems.length = 0;
			hisTradeForItems.length = 0;
			}
		
		/*private function finishTrade():void
		{
			trace("we finished trade...");
			
			var itemdd:String = "";
			var itemdi:String = "";
			
			for each(var item_rm:StuffItemLightTO in itemsIAlreadyHave)
			{
				stuffs.onItemRemoved(int(item_rm.id));
			}
			
			for each(var item_add:StuffItemLightTO in tradeForItems)
			{
				stuffs.addItem(item_add, true);
				itemdd += item_add.fileName + ",";
				itemdi += item_add.id + ",";
			}
		
			trace(itemdd);
			if(itemdd != "" && itemdi !=""){
			new LogService().logTrade(itemdd, partnerID, partner, itemdi);
			}
		}*/
		
		private function finishTrade():void
		{
		   trace("Trade was completed...");
		   
		   var itemFileNames:String = "";
		   var itemIDs:String = "";
		   
		   for each(var item_add:StuffItemLightTO in tradeFForItems){
				stuffs.addItem(item_add, true);
			}
			
			for each(var item_log:StuffItemLightTO in hisTradeForItems){
			    itemFileNames += item_log.fileName + ",";
				itemIDs += item_log.id + ",";
			}
		   
		   if(itemFileNames.length >1 && itemIDs.length >1){
		   new LogService().logTrade(itemFileNames, partnerID, partner, itemIDs);
		   }   	
		}
		
		public function onConnect():void
		{
			if(_client.numConnectedChars > 1)
			{
				enable();
			}
		}
		
		private function onCharDisconnect(charId:String):void
		{
			if(!_finished)
			{
				Dialogs.showOkDialog(partner + " " + bundle.getMessage("tradeOtherExit"));
				Global.windowManager.closeWindow(this);
				_client.disconnect();
				Global.isTrading=false;
			}
		}
		
		private function onCharConnect(charId:String):void
		{
			if(_client.numConnectedChars > 1)
			{
				enable();
				sendUnsentMessages();
			}
		}
		
		private function sendUnsentMessages():void
		{
			if(_unsentMessageArray.length > 0){
				for each (var msg:String in _unsentMessageArray){
					var message : Array = new Array(Global.charManager.charId, msg);
		   			 _client.send("handleMessage", userId, message, true);
				}
				_unsentMessageArray = [];
			}
		}

		public function rAccept(charId : String) : void
		{
			if(_oneAccepted)
			{
				Dialogs.showOkDialog(bundle.getMessage("tradeSuccessfull"));
				Global.windowManager.closeWindow(this);
				Global.isTrading=false;
				_finished = true;
				return;
			}
			
			_oneAccepted = true;
			_finished = true;
			disable();
			ToolTips.registerObject(_stuffList.content, "tradeCannotChangeItems", ResourceBundles.KAVALOK);
			ToolTips.registerObject(_myTradeList.content, "tradeCannotChangeItems", ResourceBundles.KAVALOK);
			if(charId == _partner)
			{
				bundle.registerTextField(_content.partnerField, "tradeAccepted");
		    }
		}
		
		public function rRemoveItem(charId : String, item : StuffItemLightTO) : void
		{
			var list : StuffList = charId == userId ? _myTradeList:_hisTradeList;
			var viewInfo : StuffSprite = StuffSprite(Arrays.firstByRequirement(list.items
				, new PropertyCompareRequirement("item.id", item.id)));
			list.removeItem(viewInfo);
			delete tradeFForItems[item];
			var usagee : Array = charId == userId ? tradeForItems:hisTradeForItems;
			delete usagee[item];
			if(userId == charId)
			{
				_stuffList.addItem(new StuffSprite(item));
				refreshButtons();
			}
			
			checkBOX(charId);
		}

		public function rAddItem(charId : String, item : StuffItemLightTO) : void
		{
			var list : StuffList = charId == userId ? _myTradeList:_hisTradeList;
			list.addItem(new StuffSprite(item));
			tradeFForItems.push(item);
			var usage : Array = charId == userId ? tradeForItems:hisTradeForItems;
			usage.push(item);
			if(charId == userId)
			{
				var viewInfo : StuffSprite = StuffSprite(Arrays.firstByRequirement(_stuffList.items
					, new PropertyCompareRequirement("item.id", item.id)));
				_stuffList.removeItem(viewInfo);
				refreshButtons();
			}
			
			checkBOX(charId);
		}
		
		private function checkBOX(charId : String) : void
		{
		   if(tradeFForItems.length() <= 4){
		   var list : StuffList = charId == userId ? _myTradeList:_hisTradeList;
		   list.pageIndex = 0;
		   }
		}
		
		public function handleMessage(charId : String, message : Object, unsent:Boolean) : void
		{
		   var sender : String = message[0];
		   var msg : String = message[1];

		   var myHtmlText:String = "<font color='#22a1e0'><b>" + charId + ": </b></font>";
		   var theirHtmlText:String = "<font color='#E16222'><b>" + charId + ": </b></font>";

		 if(unsent && (sender == Global.charManager.charId))
		 trace("unsent message not added");
		 else
		 _content.chat.chatLog.htmlText += ((charId == Global.charManager.charId) ? myHtmlText : theirHtmlText) + msg.toString() + "<br/>";
		 
		  _chatScroller.position = 1;
		_chatScroller.updateScrollerVisible();
		   //}
		}
		
		private function removeMessage(event: TimerEvent) : void
		{

		}
		
		private function disable() : void
		{
			GraphUtils.makeGray(_stuffList.content);
		}
		
		private function onSelectedRemoveItem() : void
		{
			if(_oneAccepted || _client.numConnectedChars <= 1)
				return;
			if(_myTradeList.selectedItem)
			{
				_client.send("rRemoveItem", userId, _myTradeList.selectedItem.item);
			}
		}
		private function onSelectedAddItem() : void
		{
			if(_oneAccepted || _client.numConnectedChars <= 1)
				return;
			if(_stuffList.selectedItem)
			{
				_client.send("rAddItem", userId, _stuffList.selectedItem.item);
			}
		}
		
		private function onStuffChange(item : Object = null) : void
		{
			if(!_finished)
			{
				
				Global.windowManager.closeWindow(this);
				Global.isTrading=false;
			}
		}
		
		private function onSendClick(event : MouseEvent) : void
		{
		  new MessageService(onGetMessage).checkTradeMessage(_content.chat.chatText.text);
		}
		
		private function onGetMessage(evt : Boolean) : void
		{
		   if(evt){
		    var message : Array = new Array(Global.charManager.charId, _content.chat.chatText.text);
		    _client.send("handleMessage", userId, message, false);
		    _content.chat.chatText.text = "";
		    if(_client.numConnectedChars == 1)
				storeForLaterSend(message[1]);
		   } else {
		   	trace('bad word');
		   }
		}

		private function storeForLaterSend(message:String):void
		{
			_unsentMessageArray.push(message);
			trace("store for later use");

		}
		
		private function onNextClick(event : MouseEvent) : void
		{
			_stuffList.pageIndex++;
			refreshButtons();
		}
		private function onPreviousClick(event : MouseEvent) : void
		{
			_stuffList.pageIndex--;
			refreshButtons();
		}

		private function refreshButtons() : void
		{
			GraphUtils.setBtnEnabled(_content.acceptButton, _myTradeList.items.length > 0);
			GraphUtils.setBtnEnabled(_content.prevButton, _stuffList.backEnabled);
			GraphUtils.setBtnEnabled(_content.nextButton, _stuffList.nextEnabled);
		}
		private function onAccept(event : MouseEvent) : void
		{
			_client.send("rAccept", userId);
			GraphUtils.setBtnEnabled(_content.acceptButton, false);
			GraphUtils.setBtnEnabled(_content.prevButton, false);
			GraphUtils.setBtnEnabled(_content.nextButton, false);
			bundle.registerButton(_content.acceptButton, "tradeAccepted");
		}
		
		private function enable() : void
		{
			ToolTips.registerObject(_stuffList.content, "tradeClickToTrade", ResourceBundles.KAVALOK);
			ToolTips.registerObject(_myTradeList.content, "tradeClickToRemove", ResourceBundles.KAVALOK);
			bundle.registerTextField(_content.partnerField, "tradeTraiding");
			refreshButtons();
			_stuffList.content.filters = [];
		}
		
		public function get userId():String
		{
			 return Global.charManager.charId;
		}
		
		public function get stuffs():Stuffs
		{
			return Global.charManager.stuffs;
		}
		
		
	}
}