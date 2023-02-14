package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.billing.BillingUtil;
	import com.kavalok.dialogs.buy.BuyButtonsView;
	import com.kavalok.dialogs.buy.ItemOfTheMonthView;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.BillingTransactionService;
	import com.kavalok.services.SystemService;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class DialogProlongAccount extends DialogViewBase
	{
		private static var bc:ResourceBundle=Global.resourceBundles.becomeCitizenDialog;

		public var buyNow1Month:SimpleButton;
		public var buyNow6Months:SimpleButton;
		public var buyNow12Months:SimpleButton;
		public var closeButton:SimpleButton;

		private var _close:EventSender=new EventSender();
		private var _controls:MCBuyCitizenship=new MCBuyCitizenship();
		private var _useAdyen:Boolean;
		private var _source:String;

		public function DialogProlongAccount(source : String, modal:Boolean=true)
		{
			_source = source;
			var content:MCCitizenshipBackground=new MCCitizenshipBackground();
			_controls.mc_buyNow1Months.visible=false;
			_controls.mc_buyNow6Months.visible=false;
			_controls.mc_buyNow12Months.visible=false;
			_controls.itemOfTheMonth1Back.visible=false;
			_controls.itemOfTheMonth6Back.visible=false;
			_controls.itemOfTheMonth12Back.visible=false;

			_controls.itemOfTheMonth1Title.visible=false;
			_controls.itemOfTheMonth6Title.visible=false;
			_controls.itemOfTheMonth12Title.visible=false;
			
			_controls.mc_texts.mc_period1ButtonTexts.visible=false;
			_controls.mc_texts.mc_period6ButtonTexts.visible=false;
			_controls.mc_texts.mc_period12ButtonTexts.visible=false;

			_controls.txt_extend_title.visible = true;
			_controls.txt_become_title.visible = false;


			super(content, null);
			
			_controls.mc_buyNow1Months.enabled=false;
			_controls.mc_buyNow6Months.enabled=false;
			_controls.mc_buyNow12Months.enabled=false;

			content.addChild(_controls);

			content.mc_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			new SystemService(onGetSystemDate).getSystemDate();

		}

		override public function show(centerWindow : Boolean = true):void
		{
			trackAnalytics();
			super.show(centerWindow);
		}
		
		private function onGetSystemDate(result : Date):void{
			var days:Number=BillingUtil.getCitizenshipLeftDays(result, Global.charManager.citizenExpirationDate);
//			if(days<=700){
				_controls.mc_buyNow1Months.visible=true;
				_controls.mc_texts.mc_period1ButtonTexts.visible=true;
				_controls.itemOfTheMonth1Back.visible=true;
				_controls.itemOfTheMonth1Title.visible=true;
//			}
//
//			if(days<547){
				_controls.mc_buyNow6Months.visible=true;
				_controls.mc_texts.mc_period6ButtonTexts.visible=true;
				_controls.itemOfTheMonth6Back.visible=true;
				_controls.itemOfTheMonth6Title.visible=true;
//			}
//
//			if(days<365){
				_controls.mc_buyNow12Months.visible=true;
				_controls.mc_texts.mc_period12ButtonTexts.visible=true;
				_controls.itemOfTheMonth12Back.visible=true;
//			}
			
			new ItemOfTheMonthView(_controls, _controls.mc_buyNow1Months.visible, _controls.mc_buyNow6Months.visible, _controls.mc_buyNow12Months.visible);
			var buttons : BuyButtonsView = new BuyButtonsView(_controls, _source, _controls.mc_buyNow1Months.visible, _controls.mc_buyNow6Months.visible, _controls.mc_buyNow12Months.visible);
			buttons.finishEvent.addListener(hide);
		}
		
		
		private function onCloseClick(event:MouseEvent):void
		{
			Dialogs.BUY_ACCOUNT_OPENED = false;
			hide();
		}

		private function trackAnalytics():void
		{
			Global.analyticsTracker.trackPageview("/f/membershipWindow/" + _source);
		}
		
		override public function hide() : void
		{
			Dialogs.BUY_ACCOUNT_OPENED = false;
			super.hide();
		}
		

	}
}



