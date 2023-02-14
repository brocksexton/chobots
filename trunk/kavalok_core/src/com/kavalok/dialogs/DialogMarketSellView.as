package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.Global;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import com.kavalok.utils.GraphUtils;
	import flash.text.TextField;
	import com.kavalok.events.EventSender;
	
	public class DialogMarketSellView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var exitButton:SimpleButton;
		public var prevButton:SimpleButton;
		public var nextButton:SimpleButton;
		public var invitedCheck:MovieClip;
		public var background:MovieClip;
		public var buyNowQ:TextField;
		public var buyNowText:TextField;
		public var buyNowPrice:TextField;
		public var startingPrice:TextField;
		public var amountOfDays:TextField;
		public var item:int;
		public var bNow:Boolean = false;
		private var _done : EventSender = new EventSender();
		public function DialogMarketSellView(itemId:int)
		{
			super(new DialogMarketSell(), null, false);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			exitButton.addEventListener(MouseEvent.CLICK, onExitClick);
			prevButton.addEventListener(MouseEvent.CLICK, onPrevClick);
			nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			invitedCheck.addEventListener(MouseEvent.CLICK, onCheckClick);
			invitedCheck.buttonMode = true;
			GraphUtils.setBtnEnabled(prevButton, false);
			item = itemId;
			buyNowText.visible = false;
			buyNowPrice.visible = false;
			background.height = 198.5;
			okButton.y = 157.7;
			invitedCheck.gotoAndStop(1);
		}
		
		private function onCheckClick(event:MouseEvent):void
		{
			bNow = !bNow;
			if(bNow) {
				buyNowText.visible = true;
				buyNowPrice.visible = true;
				invitedCheck.gotoAndStop(2);
				background.height = 236.75;
				okButton.y = 193.65;
			} else {
				buyNowText.visible = false;
				buyNowPrice.visible = false;
				invitedCheck.gotoAndStop(1);
				background.height = 198.5;
				okButton.y = 157.7;
			}
		}
		
		private function onOkClick(event:MouseEvent):void
		{
			var bugsAmount:int = parseInt(startingPrice.text);
			var buyNowPrice:int = parseInt(buyNowPrice.text);
			if(!bNow) {
				buyNowPrice = 0;
			}
			new AdminService().putItemOnMarket(item, parseInt(amountOfDays.text), bugsAmount, buyNowPrice);
			done.sendEvent();
			hide();
		}
		
		private function onPrevClick(event:MouseEvent):void
		{
			amountOfDays.text = "1";
			GraphUtils.setBtnEnabled(prevButton, false);
			GraphUtils.setBtnEnabled(nextButton, true);
		}
		
		private function onNextClick(event:MouseEvent):void
		{
			amountOfDays.text = "2";
			GraphUtils.setBtnEnabled(prevButton, true);
			GraphUtils.setBtnEnabled(nextButton, false);
		}
		
		public function get done() : EventSender
		{
			return _done;
		}
		
		private function onExitClick(event:MouseEvent):void
		{
			hide();
		}
	}
}