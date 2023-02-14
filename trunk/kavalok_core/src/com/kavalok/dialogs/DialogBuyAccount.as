package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.buy.BuyButtonsView;
	import com.kavalok.dialogs.buy.ItemOfTheMonthView;
	import com.kavalok.events.EventSender;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.UserServiceNT;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class DialogBuyAccount extends DialogViewBase
	{
		private static var bc:ResourceBundle=Global.resourceBundles.becomeCitizenDialog;

		public var closeButton:SimpleButton;

		private var _closeEvent : EventSender=new EventSender();
		private var _controls:MCBuyCitizenship=new MCBuyCitizenship();
		private var _source:String;
		

		public function DialogBuyAccount(source : String, modal:Boolean=true)
		{
			_source = source;
			var content:MCCitizenshipBackground=new MCCitizenshipBackground();
			super(content, null);
			_controls.txt_extend_title.visible = false;
			_controls.txt_become_title.visible = true;
		//	content.McBuyCitizenship.visible = true;
			content.addChild(_controls);
			var buttons : BuyButtonsView = new BuyButtonsView(_controls, source);
			buttons.finishEvent.addListener(hide);
			
			new ItemOfTheMonthView(_controls);

			content.mc_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			closeButton = content.mc_closeButton;

//			_controls.mc_tryButton.visible=false;
//			_controls.mc_texts.mc_TryButtonTexts.visible=false;
//
//			if(!Global.charManager.isCitizen)
//				new UserService(canTryCitizenship).daysCanTryCitizenship();

		}
		
		override public function show(centerWindow : Boolean = true):void
		{
			Dialogs.showDialogWindow(content, true, Global.root, false);
			trackAnalytics();
		}

		private function trackAnalytics():void
		{
			Global.analyticsTracker.trackPageview("/f/membershipWindow/" + _source);
		}

//		private function canTryCitizenship(result:Object):void
//		{
//			var daysTry:int = int(result);
//			if(daysTry>0){
//				_controls.mc_tryButton.addEventListener(MouseEvent.CLICK, onTryClick);
//				_controls.mc_texts.mc_TryButtonTexts.txtFreePeriod.text = Strings.substitute(bc.messages.freePeriod, daysTry);
//			}else{
//				_controls.mc_tryButton.enabled=false;
//				_controls.mc_texts.mc_TryButtonTexts.txtFreePeriod.visible=false;
//				ToolTips.registerObject(_controls.mc_tryButton, "tryTooltip", "bc");
//			}
//			_controls.mc_tryButton.visible=true;
//			_controls.mc_texts.mc_TryButtonTexts.visible=true;
//
//		}

		public function get closeEvent() : EventSender
		{
			return _closeEvent;
		}
		
		private function onCloseClick(event:MouseEvent):void
		{
			closeEvent.sendEvent();
			hide();
			Dialogs.BUY_ACCOUNT_OPENED = false;
		}

		private function onTryClick(event:MouseEvent):void
		{
			new UserServiceNT().tryCitizenship();
			hide();
		}

		override public function hide() : void
		{
			if(closeButton.visible){
				Dialogs.BUY_ACCOUNT_OPENED = false;
				super.hide();
			}
		}


	}
}



