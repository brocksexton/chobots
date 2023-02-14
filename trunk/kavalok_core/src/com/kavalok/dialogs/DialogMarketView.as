package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import com.kavalok.services.CharService;
	import flash.net.URLLoader;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.controls.ProgressBar;
    import com.kavalok.constants.ResourceBundles;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.localization.Localiztion;
	import flash.net.navigateToURL;
	import com.kavalok.utils.Strings;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.services.AdminService;
	import com.kavalok.events.EventSender;
	import com.kavalok.services.StuffServiceNT;
	import flash.geom.Rectangle;
	import com.kavalok.utils.GraphUtils;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import com.kavalok.utils.GraphUtils;
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import com.kavalok.dialogs.DialogYesNoView;
	
	public class DialogMarketView extends DialogViewBase
	{
		public var exitButton : SimpleButton;
		public var myAuctionsButton : SimpleButton;
		public var homeButton : SimpleButton;
		public var checkBiddingButton : SimpleButton;
		public var marketItems:MovieClip;
		public var BidOnItem:MovieClip;
		public var TitleText:TextField;
		public var listOfItems:Array = new Array();
		public var clipNum:int=1;
		public var currentPage:int=0;
		public var viewingItem:Object;

		public function DialogMarketView(text:String, modal : Boolean = true)
		{
			super(new DialogMarket(), text, modal);
			TitleText.visible = false;
			marketItems.marketHolder_1.visible = false;
			marketItems.marketHolder_2.visible = false;
			marketItems.marketHolder_3.visible = false;
			marketItems.marketHolder_4.visible = false;
			marketItems.marketHolder_5.visible = false;
			marketItems.marketHolder_6.visible = false;
			marketItems.marketHolder_7.visible = false;
			marketItems.marketHolder_8.visible = false;
		    exitButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		    homeButton.addEventListener(MouseEvent.CLICK, onHomeClick);
		    myAuctionsButton.addEventListener(MouseEvent.CLICK, onMyAuctionsClick);
		    checkBiddingButton.addEventListener(MouseEvent.CLICK, onCheckBiddingClick);
		    marketItems.prevButton.addEventListener(MouseEvent.CLICK, onPrevClick);
			marketItems.nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			BidOnItem.claimButton.addEventListener(MouseEvent.CLICK, onClaimItem);
			BidOnItem.bidButton.addEventListener(MouseEvent.CLICK, onBid);
			BidOnItem.buyNowButton.addEventListener(MouseEvent.CLICK, onBuyNowClick);
			GraphUtils.setBtnEnabled(marketItems.prevButton, false);
			GraphUtils.setBtnEnabled(marketItems.nextButton, false);
			new AdminService(onGetInformation).getNextMarketItems(0);
			BidOnItem.visible = false;
		}
		
		private function onPrevClick(e:MouseEvent):void
		{
			Global.isLocked = true;
			currentPage = currentPage-8;
			if(currentPage == 0) {
				GraphUtils.setBtnEnabled(marketItems.prevButton, false);
			}
			GraphUtils.setBtnEnabled(marketItems.nextButton, true);
			clipNum=1;
			if(TitleText.text == "Market") {
				new AdminService(onGetInformation).getNextMarketItems(currentPage);
			} else if(TitleText.text == "My Auctions") {
				new AdminService(onGetInformation).getMyAuctions(currentPage);
			} else if(TitleText.text == "Winning items") {
				new AdminService(onGetInformation).getByBuyerId(currentPage);
			}
		}
		
		private function onNextClick(e:MouseEvent):void
		{
			Global.isLocked = true;
			currentPage = currentPage+8;
			GraphUtils.setBtnEnabled(marketItems.prevButton, true);
			clipNum=1;
			if(TitleText.text == "Market") {
				new AdminService(onGetInformation).getNextMarketItems(currentPage);
			} else if(TitleText.text == "My Auctions") {
				new AdminService(onGetInformation).getMyAuctions(currentPage);
			} else if(TitleText.text == "Winning items") {
				new AdminService(onGetInformation).getByBuyerId(currentPage);
			}
		}
		
		private function onCancelFreeClick(e:MouseEvent):void
		{
			new AdminService(onHomeClick).cancelMarket(viewingItem.id, false);
		}
		
		private function onConfirmCancel():void
		{
			new AdminService(onHomeClick).cancelMarket(viewingItem.id, true);
		}
		
		private function onCancelClick(e:MouseEvent):void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog("Are you sure you want to cancel this auction? You will be charged 5000 bugs.");
			dialog.yes.addListener(onConfirmCancel);
		}
		
		private function onMyAuctionsClick(e:MouseEvent = null):void
		{
			TitleText.text = "My Auctions";
			BidOnItem.visible = false;
			currentPage = 0;
			GraphUtils.setBtnEnabled(marketItems.prevButton, false);
			new AdminService(onGetInformation).getMyAuctions(currentPage);
		}
		
		private function onCheckBiddingClick(e:MouseEvent = null):void
		{
			TitleText.text = "Winning items";
			BidOnItem.visible = false;
			currentPage = 0;
			GraphUtils.setBtnEnabled(marketItems.prevButton, false);
			new AdminService(onGetInformation).getByBuyerId(currentPage);
		}
		
		private function onHomeClick(e:MouseEvent = null):void
		{
			TitleText.text = "Market";
			BidOnItem.visible = false;
			currentPage = 0;
			GraphUtils.setBtnEnabled(marketItems.prevButton, false);
			new AdminService(onGetInformation).getNextMarketItems(currentPage);
		}
		
		private function onGetInformation(result:Array):void
		{
			Global.isLocked = false;
			clipNum=1;
			marketItems.marketHolder_1.visible = false;
			marketItems.marketHolder_2.visible = false;
			marketItems.marketHolder_3.visible = false;
			marketItems.marketHolder_4.visible = false;
			marketItems.marketHolder_5.visible = false;
			marketItems.marketHolder_6.visible = false;
			marketItems.marketHolder_7.visible = false;
			marketItems.marketHolder_8.visible = false;
			//result.sortOn( ["id"], [Array.NUMERIC]); 
			listOfItems = result;
			marketItems.visible = true;
			if(result.length == 8) {
				GraphUtils.setBtnEnabled(marketItems.nextButton, true);
			} else {
				GraphUtils.setBtnEnabled(marketItems.nextButton, false);
			}
			for each(var item:Object in result)
			{
				new StuffServiceNT(onGetItem).getItem(item.itemId);
			}
		}
		
		private function hasFinished(checkingDate:Date) : Boolean
		{
			var currentDate:Date = new Date();
			var localTimezoneOffset:Number = currentDate.getTimezoneOffset() * 60 * 1000;
			currentDate.setTime(currentDate.getTime() + localTimezoneOffset);

			var localTimezoneOffset2:Number = checkingDate.getTimezoneOffset() * 60 * 1000;
			var checkingDate2:Date = new Date(checkingDate.getTime() + localTimezoneOffset2);
			
			if(checkingDate2.getTime() < currentDate.getTime()) {
				return true;
			}
			return false;
		}
		
		private function getTimeRemaining(checkingDate:Date) : String
		{
			var currentDate:Date = new Date();
			var localTimezoneOffset:Number = currentDate.getTimezoneOffset() * 60 * 1000;
			currentDate.setTime(currentDate.getTime() + localTimezoneOffset);
			//ExternalInterface.call("console.log", "now in UTC: " + currentDate);
			
			var localTimezoneOffset2:Number = checkingDate.getTimezoneOffset() * 60 * 1000;
			var checkingDate2:Date = new Date(checkingDate.getTime() + localTimezoneOffset2);
			//ExternalInterface.call("console.log", "checkingDate: " + checkingDate2);
			var timeLeft:Number = checkingDate2.getTime() - currentDate.getTime();
			var seconds:Number = Math.floor(timeLeft / 1000);
			var minutes:Number = Math.floor(seconds / 60);
			var hours:Number = Math.floor(minutes / 60);
			var days:Number = Math.floor(hours / 24);
			seconds %= 60;
			minutes %= 60;
			hours %= 24;
			var sec:String = seconds.toString();
			var min:String = minutes.toString();
			var hrs:String = hours.toString();
			var d:String = days.toString();
			var timey:String = days > 0 ? d + " days, " : "";
			if(hours == 0 && days == 0) {
				return min + " minutes, " + sec + " seconds";
			} else {
				return timey = timey + hrs + " hours, " + min + " minutes";
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			var numberPressed:int = e.currentTarget.name != null ? e.currentTarget.name.split('_')[1] : -1;
			viewingItem = numberPressed != -1 ? listOfItems[numberPressed-1] : viewingItem;
			marketItems.visible = false;
			BidOnItem.visible = true;
			
			var getItemModel:DisplayObject = BidOnItem.getChildByName("itemModel");
			if(getItemModel != null) {
				BidOnItem.removeChild(getItemModel);
			}
			
			var ItemViewer:MovieClip = BidOnItem.itemViewer;
			ItemViewer.visible = false;
			var model:ResourceSprite = viewingItem.StuffItem.createModel();
			model.loadContent();
			model.name = "itemModel";
			GraphUtils.scale(model, ItemViewer.height, ItemViewer.width)
			BidOnItem.addChild(model);
			var modelRect:Rectangle = model.getBounds(BidOnItem);
			var positionRect:Rectangle = ItemViewer.getBounds(BidOnItem);
			model.x += (positionRect.x + 0.5 * positionRect.width)
				- (modelRect.x + 0.5 * modelRect.width)
			model.y += (positionRect.y + 0.5 * positionRect.height)
				- (modelRect.y + 0.5 * modelRect.height);

			BidOnItem.yourBidInput.visible = true;
			BidOnItem.yourBidInput.text = viewingItem.currentBid+1000;
			BidOnItem.yourBidText.visible = true;
			BidOnItem.buyNowButton.visible = false;
			BidOnItem.claimButton.visible = false;
			BidOnItem.cancelButton.visible = false;
			BidOnItem.bidButton.visible = true;
			BidOnItem.winningText.visible = false;
			BidOnItem.buyPrice.visible = false;
			BidOnItem.timeRemaining.text = "Time left: " + getTimeRemaining(viewingItem.endDate);
			BidOnItem.currentBid.text = "Current bid: " + viewingItem.currentBid;
			BidOnItem.bidNumber.text = "Number of bids: " + viewingItem.bidNumber;
			BidOnItem.itemName.text = "Item Name: " + viewingItem.StuffItem.fileName;
			BidOnItem.bidButton.x = 123.15;
			if(viewingItem.buyNowPrice > 0) {
				if(viewingItem.createdBy != Global.charManager.userId) {
					if(viewingItem.buyerId != Global.charManager.userId) {
						BidOnItem.buyPrice.visible = true;
						BidOnItem.buyPrice.text = "Buy now price: " + viewingItem.buyNowPrice;
						BidOnItem.buyNowButton.visible = true;
						BidOnItem.bidButton.x = 21.9;
					}
				}
			}
			BidOnItem.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
			BidOnItem.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelFreeClick);
			if(viewingItem.createdBy == Global.charManager.userId) { // CHECK IF IS CREATOR
				if(viewingItem.buyerId != 0) { // IF HAS A BIDDER
					new AdminService(function(username:String):void { BidOnItem.listedBy.text = "Highest bidder is currently " + Global.upperCase(username); } ).getUsernameFromId(viewingItem.buyerId);
				} else {
					BidOnItem.listedBy.text = "No Bids";
				}
				if(hasFinished(viewingItem.endDate)) { //HAS FINISHED
					if(viewingItem.bidNumber == 0) {
						BidOnItem.cancelButton.visible = true;
						BidOnItem.cancelButton.addEventListener(MouseEvent.CLICK, onCancelFreeClick);
						ToolTips.registerObject(BidOnItem.cancelButton,"Claim back your item for free.");
					} else {
						BidOnItem.winningText.visible = true;
						BidOnItem.winningText.text = "Waiting for payment!";
					}
				} else {
					BidOnItem.cancelButton.visible = true;
					BidOnItem.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
					ToolTips.registerObject(BidOnItem.cancelButton,"Cancelling an auction costs 5000 bugs.");
				}
				BidOnItem.yourBidInput.visible = false;
				BidOnItem.yourBidText.visible = false;
				BidOnItem.bidButton.visible = false;
			} else {
				new AdminService(function(username:String):void { BidOnItem.listedBy.text = "This item was listed by " + Global.upperCase(username); } ).getUsernameFromId(viewingItem.createdBy);
			}
			
			if(viewingItem.buyerId == Global.charManager.userId) {
				BidOnItem.yourBidInput.visible = false;
				BidOnItem.yourBidText.visible = false;
				BidOnItem.bidButton.visible = false;
				if(!hasFinished(viewingItem.endDate)) { //STILL ON SALE
					BidOnItem.winningText.text = "You are winning this auction";
				} else {
					BidOnItem.winningText.text = "You have won this auction!";
					BidOnItem.claimButton.visible = true;
				}
				BidOnItem.winningText.visible = true;
			}
			
			if(hasFinished(viewingItem.endDate)) {
				BidOnItem.yourBidInput.visible = false;
				BidOnItem.yourBidText.visible = false;
				BidOnItem.bidButton.visible = false;
				BidOnItem.timeRemaining.text = "Auction has ended";
			}
		}
		
		private function onClaimItem(e:MouseEvent):void
		{
			new AdminService(onVerified).claimItemFromMarket(viewingItem.id)
		}
		
		public function onVerified(value:Boolean):void
		{
			if(value) {
				Dialogs.showOkDialog("Claimed item. Congratulations on your purchase!");
				onHomeClick();
			} else {
				Dialogs.showOkDialog("Error, could not claim item. Please contact support!");
			}
		}
		
		private function onBuyNowClick(e:MouseEvent):void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog("Are you sure you want to buy this item?");
			dialog.yes.addListener(onBuyNow);
		}
		
		private function onBuyNow():void
		{
			new AdminService(onBuyNow).buyNowItem(viewingItem.id);
			onHomeClick()
		}
		
		
		private function onBid(e:MouseEvent):void
		{
			new AdminService().bidOnItem(viewingItem.id, BidOnItem.yourBidInput.text);
			onCheckBiddingClick()
		}

		private function onGetItem(result:StuffItemLightTO):void
		{
			var currentItem:Object = listOfItems[clipNum-1];
			currentItem.StuffItem = result;
			var currentHolder:MovieClip = marketItems.getChildByName("marketHolder_" + clipNum) as MovieClip;
			var getItemModel:DisplayObject = currentHolder.getChildByName("itemModel");
			if(getItemModel != null) {
				currentHolder.removeChild(getItemModel);
			}
			currentHolder.buttonMode = true;
			currentHolder.mouseEnabled=true;
			currentHolder.addEventListener(MouseEvent.CLICK, onClick);
			
			var ItemViewer:MovieClip = currentHolder.itemViewer;
			ItemViewer.visible = false;
			var model:ResourceSprite = result.createModel();
			model.name = "itemModel";
			model.loadContent();
			GraphUtils.scale(model, ItemViewer.height, ItemViewer.width)
			currentHolder.addChild(model);
			
			var modelRect:Rectangle = model.getBounds(marketItems);
			var positionRect:Rectangle = ItemViewer.getBounds(marketItems);
			model.x += (positionRect.x + 0.5 * positionRect.width)
				- (modelRect.x + 0.5 * modelRect.width)
			model.y += (positionRect.y + 0.5 * positionRect.height)
				- (modelRect.y + 0.5 * modelRect.height);
				
			if(TitleText.text == "My Auctions") {
				new AdminService(function(username:String):void {
					if(username != null) {
						currentHolder.sellerName.text = "Top bidder " + Global.upperCase(username); 
					} else { 
						currentHolder.sellerName.text =  "No bids";
					}
				}).getUsernameFromId(currentItem.buyerId);
			} else {
				new AdminService(function(username:String):void { currentHolder.sellerName.text = "Seller " + Global.upperCase(username); } ).getUsernameFromId(currentItem.createdBy);
			}
			currentHolder.bugsAmount.text = currentItem.currentBid;
			currentHolder.timeRemaining.text = getTimeRemaining(currentItem.endDate);
			if(hasFinished(currentItem.endDate)) {
				if(currentItem.buyerId == Global.charManager.userId) {
					currentHolder.timeRemaining.text = "You won this item!";
				} else {
					currentHolder.timeRemaining.text = "This item has ended!";
				}
			}
			if(hasFinished(currentItem.endDate)) {
				currentHolder.background.gotoAndStop(2);
			} else if(currentItem.buyerId == Global.charManager.userId) {
				currentHolder.background.gotoAndStop(4);
			} else if(currentItem.createdBy == Global.charManager.userId) {
				currentHolder.background.gotoAndStop(3);
			} else {
				currentHolder.background.gotoAndStop(1);
			}
			currentHolder.visible = true;
			clipNum = clipNum+1;
		}
		
		private function onCloseClick(event : MouseEvent) : void
		{
			Global.charManager.stuffs.refresh();
			hide();
		}
	}
}