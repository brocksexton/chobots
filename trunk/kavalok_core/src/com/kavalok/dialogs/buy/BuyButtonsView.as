package com.kavalok.dialogs.buy
{
	import com.kavalok.Global;
	import com.kavalok.billing.BillingUtil;
	import com.kavalok.dto.membership.SKUTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.services.BillingTransactionService;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class BuyButtonsView extends FlashViewBase
	{
		private static var bc:ResourceBundle=Global.resourceBundles.becomeCitizenDialog;
		private static var currencies:ResourceBundle=Global.resourceBundles.currencies;
		private var _content:MovieClip;
		private var _finishEvent:EventSender=new EventSender();
		private var _source:String;
		private var _sku1Id:int;
		private var _sku6Id:int;
		private var _sku12Id:int;
		private var _b1visible:Boolean;
		private var _b6visible:Boolean;
		private var _b12visible:Boolean;

		public function BuyButtonsView(content:MovieClip, source:String, b1visible:Boolean=true, b6visible:Boolean=true, b12visible:Boolean=true)
		{
			_content=content;
			_source=source;
			_b1visible=b1visible;
			_b6visible=b6visible;
			_b12visible=b12visible;
			super(content);

			content.mc_buyNow1Months.addEventListener(MouseEvent.CLICK, onBuyNow1MonthClick);
			content.mc_buyNow6Months.addEventListener(MouseEvent.CLICK, onBuyNow6MonthsClick);
			content.mc_buyNow12Months.addEventListener(MouseEvent.CLICK, onBuyNow12MonthsClick);

			content.mc_buyNow1Months.visible=false;
			content.mc_buyNow6Months.visible=false;
			content.mc_buyNow12Months.visible=false;

			content.mc_buyNow1Months.enabled=false;
			content.mc_buyNow6Months.enabled=false;
			content.mc_buyNow12Months.enabled=false;

			content.mc_texts.mc_period1ButtonTexts.specialOffer1.visible=false;
			content.mc_texts.mc_period6ButtonTexts.specialOffer6.visible=false;
			content.mc_texts.mc_period12ButtonTexts.specialOffer12.visible=false;

			content.mc_texts.mc_period1ButtonTexts.bonus1.visible=false;
			content.mc_texts.mc_period6ButtonTexts.bonus6.visible=false;
			content.mc_texts.mc_period12ButtonTexts.bonus12.visible=false;

			content.mc_texts.mc_period1ButtonTexts.price1.visible=false;
			content.mc_texts.mc_period6ButtonTexts.price6.visible=false;
			content.mc_texts.mc_period12ButtonTexts.price12.visible=false;

			content.mc_texts.mc_period1ButtonTexts.offer1.visible=false;
			content.mc_texts.mc_period6ButtonTexts.offer6.visible=false;
			content.mc_texts.mc_period12ButtonTexts.offer12.visible=false;

			if(RemoteConnection.instance.connected){
				initButtons();
			}else{
				RemoteConnection.instance.connectEvent.addListener(initButtons);
			}
		}
		private function initButtons():void
		{
			new BillingTransactionService(onGetSKUs, onBillingTransactionServiceFault).getMembershipSKUs();
			RemoteConnection.instance.connectEvent.removeListenerIfHas(initButtons);
		}

		private function onBillingTransactionServiceFault(result:Object):void
		{
			trace("BillingTransactionService fault "+result);
		}


		public function get finishEvent():EventSender
		{
			return _finishEvent;
		}

		private function onGetSKUs(result:Object):void
		{
			var sku1:SKUTO=result[0];
			var sku6:SKUTO=result[1];
			var sku12:SKUTO=result[2];
			var skuOffer1:SKUTO=result[3];
			var skuOffer6:SKUTO=result[4];
			var skuOffer12:SKUTO=result[5];

			_sku1Id = skuOffer1 ? skuOffer1.id : (sku1 ? sku1.id : null);
			_sku6Id = skuOffer6 ? skuOffer6.id : (sku6 ? sku6.id : null);
			_sku12Id = skuOffer12 ? skuOffer12.id : (sku1 ? sku12.id : null);

			if (_b1visible && sku1)
				initSKUView(1, sku1, skuOffer1, false);
			if (_b6visible && sku6)
				initSKUView(6, sku6, skuOffer6, false);
			if (_b12visible && sku12)
				initSKUView(12, sku12, skuOffer12, true);

		}


		private function initSKUOffer(period:Number, sku:SKUTO, dayMonthSpecialPrice:Boolean):void
		{
			
		}

		private function initSKUView(period:Number, sku:SKUTO, offerSKU:SKUTO, dayMonthSpecialPrice:Boolean):void
		{
			_content["mc_buyNow" + period + "Months"].enabled=true;
			_content["mc_buyNow" + period + "Months"].visible=true;

			var bonusText:TextField=TextField(_content.mc_texts["mc_period" + period + "ButtonTexts"]["bonus" + period]);
			var priceText:TextField=TextField(_content.mc_texts["mc_period" + period + "ButtonTexts"]["price" + period]);
			var offerText:TextField=TextField(_content.mc_texts["mc_period" + period + "ButtonTexts"]["offer" + period]);

			var specialOffer:MovieClip=MovieClip(_content.mc_texts["mc_period" + period + "ButtonTexts"]["specialOffer" + period]);
			var specialOfferName:TextField=specialOffer["offerName"];

			

			bonusText.text=Strings.substitute(bc.messages.bonusBugs, sku.bugsBonus);
			priceText.htmlText=Strings.substitute(bc.messages.priceText, sku.priceStr + (offerSKU?(" <b>"+offerSKU.priceStr+"!</b>"):""), currencies.messages[sku.currencySign]);

			var specialPrice:Number;
			var specialPriceInt:int;
			var useCents:Boolean=false;

			var specialPriceOffer:Number;
			var specialPriceIntOffer:int;
			
			var specialPeriod : Number = dayMonthSpecialPrice ? period : period * 30.5 ;

			specialPrice=sku.price / specialPeriod;
			if(offerSKU){
				specialPriceOffer = offerSKU.price / specialPeriod;
			}
			if (specialPrice < 1)
			{
				useCents=true;
				specialPrice=specialPrice * 100;
				specialPriceInt=int(specialPrice + 1);

				if(offerSKU){
					specialPriceOffer=specialPriceOffer * 100;
					specialPriceIntOffer=int(specialPriceOffer + 1);
				}
			}
			else
			{
				specialPriceInt=int(specialPrice + 1);

				if(offerSKU){
					specialPriceIntOffer=int(specialPriceOffer + 1);
				}
			}
			
			offerText.htmlText=Strings.substitute(bc.messages["offer" + period], specialPriceInt + (offerSKU?(" <b>"+specialPriceIntOffer+"!</b>"):""), useCents ? currencies.messages[sku.currencyCentsText] : currencies.messages[sku.currencyText]);


			if(offerSKU){
				specialOfferName.text = offerSKU.specialOfferName;
				
				var canvas:Sprite = this.content;
				canvas.graphics.lineStyle(2,priceText.textColor,1);

				var tr : Rectangle = priceText.getBounds(_content);
				var trLocal : Rectangle = priceText.getBounds(priceText);

				var firstChar : Rectangle = priceText.getCharBoundaries(priceText.text.indexOf(sku.priceStr));
				var lastChar : Rectangle = priceText.getCharBoundaries(priceText.text.indexOf(sku.priceStr)+sku.priceStr.length-1);
				
				var xDiff : int = tr.x - trLocal.x;
				var yDiff : int = tr.y - trLocal.y;

				canvas.graphics.moveTo(firstChar.x+xDiff-2, firstChar.y + firstChar.height+yDiff-6);
				canvas.graphics.lineTo(lastChar.x+xDiff+lastChar.width, firstChar.y+yDiff+5);


				
				var priceIndex : int = offerText.text.indexOf(specialPriceInt+""); 
				if(priceIndex>=0){
					tr = offerText.getBounds(_content);
					trLocal = offerText.getBounds(offerText);

					firstChar = offerText.getCharBoundaries(priceIndex);
					lastChar = offerText.getCharBoundaries(priceIndex+(specialPriceInt+"").length-1);
					
					xDiff = tr.x - trLocal.x;
					yDiff = tr.y - trLocal.y;
	
					canvas.graphics.moveTo(firstChar.x+xDiff-3, firstChar.y + firstChar.height+yDiff-6);
					canvas.graphics.lineTo(lastChar.x+xDiff+lastChar.width, firstChar.y+yDiff+5);
				}
				specialOffer.visible = true;
			}

			offerText.visible=true;
			bonusText.visible=true;
			priceText.visible=true;
		}


		private function onBuyNow1MonthClick(event:MouseEvent):void
		{
			new BillingTransactionService(processBuyClick).requestMembership("Memberhsip for 1 month bought", _sku1Id, _source, Global.partnerUserId);
			finishEvent.sendEvent();
		}

		private function onBuyNow6MonthsClick(event:MouseEvent):void
		{
			new BillingTransactionService(processBuyClick).requestMembership("Memberhsip for 6 months bought", _sku6Id, _source, Global.partnerUserId);
			finishEvent.sendEvent();
		}

		private function onBuyNow12MonthsClick(event:MouseEvent):void
		{
			new BillingTransactionService(processBuyClick).requestMembership("Memberhsip for 12 months bought", _sku12Id, _source, Global.partnerUserId);
			finishEvent.sendEvent();
		}

		private function processBuyClick(result:Object):void
		{
			BillingUtil.processPaymentForm(result);
		}
	}
}





