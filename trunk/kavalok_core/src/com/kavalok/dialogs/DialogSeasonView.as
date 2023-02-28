	package com.kavalok.dialogs
	{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.services.CharService;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;

	public class DialogSeasonView extends DialogViewBase
	{
		public var tierPage:int;
		public var currentTier:int;
		
		public var crownText:TextField;
		public var tierText:TextField;
		public var emeraldsText:TextField;
		
		public var tier1:TextField;
		public var tier2:TextField;
		public var tier3:TextField;
		public var tier4:TextField;
		public var tier5:TextField;
		
		public var ItemFrames:MovieClip;
		public var buyPass:MovieClip;
		
		public var Emerald:MovieClip;
		public var Citizen:MovieClip;
		public var Crown:MovieClip;
		public var CompletedTiers:MovieClip;
		
		public var EmeraldTile:EmeraldReward = new EmeraldReward();
		public var CitizenTile:CitizenReward = new CitizenReward();
		public var CrownTile:CrownReward = new CrownReward();
		
		public var nextButton:SimpleButton;
		public var closingButton:SimpleButton;
		public var shopButton:SimpleButton;
		public var helpButton:SimpleButton;
		public var buyButton:SimpleButton;
		public var backButton:SimpleButton;
		
		public var Items:Array = new Array();
		
		public function DialogSeasonView(text:String, modal:Boolean = true)
		{
			super(new DialogSeason(),text,modal);
			backButton.addEventListener(MouseEvent.CLICK,onBackClick);
			nextButton.addEventListener(MouseEvent.CLICK,onNextClick);
			closingButton.addEventListener(MouseEvent.CLICK,onOkClick);
			helpButton.addEventListener(MouseEvent.CLICK,onHelpClick);
			buyButton.addEventListener(MouseEvent.CLICK,onBuyClick);
			shopButton.addEventListener(MouseEvent.CLICK,onShopClick);
			
			if(Global.charManager.permissions.indexOf("season1Pass;") != -1){
				buyPass.visible = false;
			}
			
			CompletedTiers.visible = false;
			CompletedTiers.cover1.visible = false;
			CompletedTiers.cover2.visible = false;
			CompletedTiers.cover3.visible = false;
			CompletedTiers.cover4.visible = false;
			CompletedTiers.cover5.visible = false;
			Crown.visible = false;
			Citizen.visible = false;
			Emerald.visible = false;
			new CharService(function(setAmount:int):void { crownText.text = String(setAmount); }).getCrowns();
			//new CharService(function(setAmount:int):void { currentTier = setAmount; tierText.text = String(setAmount); tierPage = setAmount-(tierPage-1); selectPage(tierPage); }).getTier();
			new CharService(function(setAmount:int):void { currentTier = setAmount; tierText.text = String(setAmount); tierPage = 1; selectPage(1); }).getTier();
			if(Global.charManager.emeralds > 9999) {
				emeraldsText.text = "9999+";
			} else {
				emeraldsText.text = String(Global.charManager.emeralds);
			}
			
		}

		protected function onBuyClick(event:MouseEvent) : void
		{
			//navigateToURL(new URLRequest("/management/emeralds"),"_blank");
			if(Global.charManager.permissions.indexOf("season1Pass;") != -1){
				Dialogs.showOkDialog("You already own this battle pass");
			} else {
				var dialog:DialogYesNoView = Dialogs.showYesNoDialog("Do you want to buy the Golden Pass ? It will cost 50 Emeralds.");
				dialog.yes.addListener(doBuy);
			}
		}

		private function doBuy():void
		{
			new CharService(onUpdateP).purchaseSeasonPass();
		}
		
		private function onUpdateP(result:Boolean):void
		{
			if(result) {
				hide();
			}
		}

		protected function onHelpClick(event:MouseEvent) : void
		{
			navigateToURL(new URLRequest("https://play.chobots.wiki/battlepass/spring2023.html"),"_blank");
		}

		public function selectPage(page:int) : void
		{
			clearFrames();
			new AdminService(onLoaded).getSeasonItems(page);
			var currentFrame:int = currentTier-(page-1);
			if(currentFrame > 0) {
				CompletedTiers.visible = true;
				if(currentFrame >= 1) {
					CompletedTiers.cover1.visible = true;
				}
				if(currentFrame >= 2) {
					CompletedTiers.cover2.visible = true;
				}
				if(currentFrame >= 3) {
					CompletedTiers.cover3.visible = true;
				}
				if(currentFrame >= 4) {
					CompletedTiers.cover4.visible = true;
				}
				if(currentFrame >= 5) {
					CompletedTiers.cover5.visible = true;
				}
				CompletedTiers.visible = true;
			}
				//var Frame:MovieClip = ItemFrames.getChildByName("mc_item" + tierNumber.toString() + "0" + slotNumber.toString()) as MovieClip;
			tier1.text = (page).toString();
			tier2.text = (page+1).toString();
			tier3.text = (page+2).toString();
			tier4.text = (page+3).toString();
			tier5.text = (page+4).toString();
			tierPage = page;
			if(tierPage == 1) {
				GraphUtils.setBtnEnabled(backButton,false);
			} else {
				GraphUtils.setBtnEnabled(backButton,true);
			}
			if(tierPage == 16) {
				GraphUtils.setBtnEnabled(nextButton,false);
			} else {
				GraphUtils.setBtnEnabled(nextButton,true);
			}
		}
		
		public function onLoaded(result:Array):void
		{
			for each(var item:Object in result)
			{
				showItem(item.rewardType, item.reward, item.tier, item.slot);
			}
			Global.isLocked=false;
		}

		protected function onNextClick(event:MouseEvent) : void
		{
			Global.isLocked=true;
			selectPage(tierPage + 5);
		}

		public function showItem(reward:String, itemName:String, itemNumber:int, slotNumber:int) : void
		{
			var tierNumber:int = itemNumber-(tierPage-1);
			var Frame:MovieClip = ItemFrames.getChildByName("mc_item" + tierNumber.toString() + "0" + slotNumber.toString()) as MovieClip;
			if(reward == "item") {
				new StuffServiceNT(function(result:StuffTypeTO):void{
					var info:StuffTypeTO = result
					var _stuff:ResourceSprite = info.createModel();
					_stuff.name = "ItemModel";
					_stuff.loadContent();
					Frame.addChild(_stuff);
					Frame.visible = true;
					Items.push(_stuff);
				}).getStuffTypeFromId(parseInt(itemName));
				
			} else if(reward == "citizen") {
				var citizenMovie:MovieClip = new CitizenReward();
				citizenMovie.name = "ItemModel";
				citizenMovie.CitizenNumber.text = "+" + itemName;
				citizenMovie.visible = true;
				Frame.addChild(citizenMovie);
				Frame.visible = true;
				Items.push(citizenMovie);
			} else if(reward == "crown") {
				var crownMovie:MovieClip = new CrownReward();
				crownMovie.name = "ItemModel";
				crownMovie.CrownNumber.text = "+" + itemName;
				crownMovie.visible = true;
				Frame.addChild(crownMovie);
				Frame.visible = true;
				Items.push(crownMovie);
			} else if(reward == "emerald") {
				var emeraldMovie:MovieClip = new EmeraldReward();
				emeraldMovie.name = "ItemModel";
				emeraldMovie.EmeraldNumber.text = "+" + itemName;
				emeraldMovie.visible = true;
				Frame.addChild(emeraldMovie);
				Frame.visible = true;
				Items.push(emeraldMovie);
			}
		}

		protected function onBackClick(event:MouseEvent) : void
		{
			Global.isLocked=true;
			selectPage(tierPage - 5);
		}

		protected function onShopClick(event:MouseEvent) : void
		{
			Global.moduleManager.loadModule(Modules.STUFF_CATALOG,{
			"shop":"shopItems",
			"countVisible":false
			});
			hide();
		}

		public function clearFrames() : void
		{
			CompletedTiers.visible = false;
			CompletedTiers.cover1.visible = false;
			CompletedTiers.cover2.visible = false;
			CompletedTiers.cover3.visible = false;
			CompletedTiers.cover4.visible = false;
			CompletedTiers.cover5.visible = false;
			for(var i:int = 0; i < ItemFrames.numChildren; i++)
			{
				var child:MovieClip = ItemFrames.getChildAt(i) as MovieClip;
				if(child is MovieClip) 
				{
					child.visible = false;
					var getItemModel:DisplayObject = child.getChildByName("ItemModel");
					if(getItemModel != null) {
						child.removeChild(getItemModel);
					}
					var getItemModel2:DisplayObject = child.getChildByName("ItemModel");
					if(getItemModel2 != null) {
						child.removeChild(getItemModel2);
					}
				}
			}
		}
		
		protected function onOkClick(event:MouseEvent) : void
		{
			hide();
		}
		
	}
}