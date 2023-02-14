package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.billing.BillingUtil;
	import com.kavalok.events.EventSender;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.SystemService;
	import com.kavalok.utils.Strings;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class DialogCitizenStatus extends DialogViewBase
	{
		private static var bc:ResourceBundle=Global.resourceBundles.becomeCitizenDialog;

		public var buyNow1Month:SimpleButton;
		public var buyNow6Months:SimpleButton;
		public var buyNow12Months:SimpleButton;
		public var closeButton:SimpleButton;

		private var _close:EventSender=new EventSender();
		private var _controls:MCStatusUpgrade=new MCStatusUpgrade();
		private var _source:String;

		public function DialogCitizenStatus(source : String, modal:Boolean=true)
		{
			_source = source;
			var content:MCCitizenshipBackground=new MCCitizenshipBackground();
			content.addChild(_controls);
			super(content, null);

			new SystemService(onGetSystemDate).getSystemDate();
			content.mc_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);

				
		}

		private function onGetSystemDate(result:Date):void
		{
			var daysLeft:Number=BillingUtil.getCitizenshipLeftDays(result, Global.charManager.citizenExpirationDate);
			_controls.statusUpgradeText.text=Strings.substitute(Global.resourceBundles.becomeCitizenDialog.messages.statusUpgradeText, daysLeft);

//			if (daysLeft > 700)
//			{
//				_controls.prolongButton.visible=false;
//				_controls.statusCannotUpgradeText.text=Global.resourceBundles.becomeCitizenDialog.messages.statusCannotUpgradeText;
//				_controls.statusCannotUpgradeText.visible=true;
//			}
//			else
//			{
				_controls.prolongButton.visible=true;
				_controls.prolongButton.addEventListener(MouseEvent.CLICK, onProlongAccountClick);
				_controls.statusCannotUpgradeText.visible=false;
//			}

		}

		private function onProlongAccountClick(event:MouseEvent):void
		{
			hide();
			//Dialogs.showProlongAccountDialog(_source);
			Global.frame.openCitizenshipPage();
			//navigateToURL(new URLRequest("http://chobots.net/citizenship"), "_blank");
		}

		private function onCloseClick(event:MouseEvent):void
		{
			hide();
			Dialogs.BUY_ACCOUNT_OPENED = false;
		}

	}
}



