package {
	import flash.external.ExternalInterface;
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharManager;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.login.LoginManager;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.remoting.RemoteConnection;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import com.kavalok.gameplay.ToolTips;

	import CharWindowBackground;

	public class BodyPanel extends WindowModule
	{
		private var _content:McBodies = new McBodies();
		private var bodyItems:Array = new Array();
		private var cardItems:Array = new Array();
		private var chatItems:Array = new Array();
		private var _mod:Boolean = Global.charManager.isModerator;
		private var _charId:String = Global.loginManager.userLogin;
		private var selectedChat : String = Global.charManager.chatColor;
		private var selectedBody : String = Global.charManager.body;
		public var playercard:CharWindowBackground = new CharWindowBackground;
		
		private var selectedCard : String;
		private var chatList:Array = new Array('fusion','blublastr','spring','salmon','puryel','black','futuristic','gia','PinkGreen','royal','ora_stripes','turquoise','polka','neon','silver','red_stripes','blue_stripes','rainbow','purple','dgrey','orange','pink','glowblue','pinkpur','whiteblue','pets','caramel','abstrgreen','nicho','army','red_sand','fire','circles','stars','redDia','cfiber','glassWork','candyCane','greenBlack');
		private var bodyList:Array = new Array('alexCube','apple','ball','star','xmas_tree','xmas_tree_toy','present_sock','snowflake','pumpkin','petbot','present','ninjasuitpet','keyn','nicho_lord');
		private var cardList:Array = new Array('purple','blue','red','green','gold','black','vintage','pink','blueGreen','jake','journalist','sand','purpleOrange','space','fire','spring','purstripe','blackstripe','greenyellow','bhexagon','bwbox','byelstripe','lightcol','tree','rainbow','abstrblue','bubgreen','grump','leopard','papyrus','racerblue','redshoe','space2','red_stealth','city_lights','light_show','cfiber','skyb2','glassWork','snakes','pumpkinOct13','redwave','snowleopard','grayfur','purpleFade','rainbow2','inagalaxy','bowPC','kingCrownPC','MusicNotes');
	
		public function BodyPanel()
		{
			Global.isLocked = true;
			new AdminService(onGotData).getPurchasedData();
		}

		public function onGotData(result:String):void
		{
			Global.charManager.purchasedBodies = result.split("#")[0];
			Global.charManager.purchasedBubbles = result.split("#")[1];
			selectedCard = result.split("#")[2] != "undefined" ? result.split("#")[2] : "chobot";
			initContent();
			addChild(_content);
			_content.addChild(playercard);
			_content.addChild(_content.container_bodies);
			_content.addChild(_content.container_chats);
			playercard.Width = 235.05;
			playercard.Height = 307.95;
			playercard.x = 341.5;
			playercard.y = 114.95;
		}
		
		override public function initialize():void
		{
			readyEvent.sendEvent();
		}
		
		private function findInArray(str:String, arr:Array):int {
			for(var i:int = 0; i < arr.length; i++){
				if(arr[i] == str){
					return i;
				}
			}
			return -1;
		}
		
		private function initContent():void
		{
			new ResourceScanner().apply(_content);
			_content.closeButton.addEventListener(MouseEvent.CLICK, onClose);

			bodyItems = Global.charManager.purchasedBodies.indexOf("none") != -1 ? (Global.charManager.purchasedBodies.split("none")[1]).split(",") : Global.charManager.purchasedBodies.split(",");
			cardItems = Global.charManager.purchasedCards.indexOf("none") != -1 ? (Global.charManager.purchasedCards.split("none")[1]).split(",") : Global.charManager.purchasedCards.split(",");
			chatItems = Global.charManager.purchasedBubbles.indexOf("none") != -1 ? (Global.charManager.purchasedBubbles.split("none")[1]).split(",") : Global.charManager.purchasedBubbles.split(",");
			if(_mod) {
				bodyItems = bodyList;
				chatItems = chatList;
				cardItems = cardList;
			}
			bodyItems.unshift("default");
			chatItems.unshift("default");
			cardItems.unshift("chobot");
			
			_content.container_chats.gotoAndStop(selectedChat);
			playercard.gotoAndStop(selectedCard);
			_content.container_bodies.gotoAndStop(selectedBody);
			//_content.setChildIndex(_content.container_bodies, _content.numChildren - 1);
			
			_content.mc_nextChat.addEventListener(MouseEvent.CLICK, onNextChatClick);
			_content.mc_prevChat.addEventListener(MouseEvent.CLICK, onPrevChatClick);
			_content.mc_nextBody.addEventListener(MouseEvent.CLICK, onNextBodyClick);
			_content.mc_prevBody.addEventListener(MouseEvent.CLICK, onPrevBodyClick);
			_content.mc_nextCard.addEventListener(MouseEvent.CLICK, onNextCardClick);
			_content.mc_prevCard.addEventListener(MouseEvent.CLICK, onPrevCardClick);
			
			Global.isLocked = false;
			
			GraphUtils.setBtnEnabled(_content.mc_prevChat, (chatItems[findInArray(selectedChat, chatItems)-1] == "" || chatItems[findInArray(selectedChat, chatItems)-1] == null) ? false : true);
			GraphUtils.setBtnEnabled(_content.mc_nextChat, (chatItems[findInArray(selectedChat, chatItems)+1] == "" || chatItems[findInArray(selectedChat, chatItems)+1] == null) ? false : true);
			GraphUtils.setBtnEnabled(_content.mc_prevBody, (bodyItems[findInArray(selectedBody, bodyItems)-1] == "" || bodyItems[findInArray(selectedBody, bodyItems)-1] == null) ? false : true);
			GraphUtils.setBtnEnabled(_content.mc_nextBody, (bodyItems[findInArray(selectedBody, bodyItems)+1] == "" || bodyItems[findInArray(selectedBody, bodyItems)+1] == null) ? false : true);
			GraphUtils.setBtnEnabled(_content.mc_prevCard, (cardItems[findInArray(selectedCard, cardItems)-1] == "" || cardItems[findInArray(selectedCard, cardItems)-1] == null) ? false : true);
			GraphUtils.setBtnEnabled(_content.mc_nextCard, (cardItems[findInArray(selectedCard, cardItems)+1] == "" || cardItems[findInArray(selectedCard, cardItems)+1] == null) ? false : true);
		}

		private function onNextChatClick(event:MouseEvent):void
		{
			//Global.isLocked = true;
			var FindNextChat:int = findInArray(selectedChat, chatItems);
			if(chatItems[FindNextChat+1] != null) {
				selectedChat = chatItems[FindNextChat+1];
				_content.container_chats.gotoAndStop(selectedChat); 
				GraphUtils.setBtnEnabled(_content.mc_prevChat, true);
				if(chatItems[FindNextChat+2] == null) {
					GraphUtils.setBtnEnabled(_content.mc_nextChat, false);
				}
			}
		}
		
		private function onPrevChatClick(event:MouseEvent):void
		{
			//Global.isLocked = true;
			var FindNextChat:int = findInArray(selectedChat, chatItems);
			if(chatItems[FindNextChat-1] != null) {
				selectedChat = chatItems[FindNextChat-1];
				_content.container_chats.gotoAndStop(selectedChat); 
				GraphUtils.setBtnEnabled(_content.mc_nextChat, true);
				if(chatItems[FindNextChat-2] == null) {
					GraphUtils.setBtnEnabled(_content.mc_prevChat, false);
				}
			}
		}
		
		private function onNextBodyClick(event:MouseEvent):void
		{
			//Global.isLocked = true;
			var FindNextBody:int = findInArray(selectedBody, bodyItems);
			if(bodyItems[FindNextBody+1] != null) {
				selectedBody = bodyItems[FindNextBody+1];
				_content.container_bodies.gotoAndStop(selectedBody); 
				GraphUtils.setBtnEnabled(_content.mc_prevBody, true);
				if(bodyItems[FindNextBody+2] == null) {
					GraphUtils.setBtnEnabled(_content.mc_nextBody, false);
				}
			}
		}
		
		private function onPrevBodyClick(event:MouseEvent):void
		{
			//Global.isLocked = true;
			var FindNextBody:int = findInArray(selectedBody, bodyItems);
			if(bodyItems[FindNextBody-1] != null) {
				selectedBody = bodyItems[FindNextBody-1];
				_content.container_bodies.gotoAndStop(selectedBody); 
				GraphUtils.setBtnEnabled(_content.mc_nextBody, true);
				if(bodyItems[FindNextBody-2] == null) {
					GraphUtils.setBtnEnabled(_content.mc_prevBody, false);
				}
			}
		}
		
		private function onNextCardClick(event:MouseEvent):void
		{
			//Global.isLocked = true;
			var FindNextCard:int = findInArray(selectedCard, cardItems);
			if(cardItems[FindNextCard+1] != null) {
				selectedCard = cardItems[FindNextCard+1];
				playercard.gotoAndStop(selectedCard); 
				GraphUtils.setBtnEnabled(_content.mc_prevCard, true);
				if(cardItems[FindNextCard+2] == null) {
					GraphUtils.setBtnEnabled(_content.mc_nextCard, false);
				}
			}
		}
		
		private function onPrevCardClick(event:MouseEvent):void
		{
			//Global.isLocked = true;
			var FindNextCard:int = findInArray(selectedCard, cardItems);
			if(cardItems[FindNextCard-1] != null) {
				selectedCard = cardItems[FindNextCard-1];
				playercard.gotoAndStop(selectedCard); 
				GraphUtils.setBtnEnabled(_content.mc_nextCard, true);
				if(cardItems[FindNextCard-2] == null) {
					GraphUtils.setBtnEnabled(_content.mc_prevCard, false);
				}
			}
		}

		private function onClose(e:MouseEvent):void
		{
			if(selectedChat == "default") { 
				new CharService().setChatColorToDefault(Global.charManager.charId);
				Global.charManager.chatColor = "default";
			} else {
				new CharService(setIt).setChatColor(selectedChat, Global.charManager.charId);
				selectedChat = selectedChat.toString();
			}
			if(selectedBody == "default") {
				new CharService(onGetBody).saveBodyPanelToDefault(Global.charManager.color, Global.charManager.charId);
			} else {
				new CharService(onGetBody).saveBodyPanel(selectedBody, Global.charManager.color, Global.charManager.charId);
			}
			
			if(selectedCard == "chobot"){
				new CharService().savePlayerCardColorDefault();
			} else {
				new CharService().savePlayerCardColor(selectedCard);
			}
			
			closeModule();
		}
		
		private function setIt(result:Boolean):void
		{
            if(result == true){
				Global.charManager.chatColor = (selectedChat == "defaultChat") ? "default" : selectedChat;
			} else {
				Global.charManager.chatColor = "default";
			}
		}
		
		private function onGetBody(result:Boolean):void
		{
			if(result == true){
				Global.charManager.body = selectedBody;
			} else {
				Global.charManager.body = "default";
			}
			Global.charManager.refreshBody();
		}
	}
}
