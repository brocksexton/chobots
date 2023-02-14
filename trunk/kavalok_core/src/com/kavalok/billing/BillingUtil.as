package com.kavalok.billing
{
	import com.kavalok.constants.BrowserConstants;
	import com.kavalok.login.LoginManager;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	public class BillingUtil
	{
		public static function processPaypalPayment(productName:String, price:String, transactionId:int):void
		{
			var request:URLRequest=new URLRequest("https://www.paypal.com/cgi-bin/webscr");
			//var request : URLRequest = new URLRequest("https://www.sandbox.paypal.com/cgi-bin/webscr");
			request.method=URLRequestMethod.POST;

			var variables:URLVariables=new URLVariables();
			variables.cmd="_xclick";
			variables.business="HB5VQLZG4UEPC";
			//prod
			//variables.business="HJTEQ4QQKZWXC";//test
			//variables.business="yaroslav.lazor@sm-it.biz";
			variables.lc="GB";
			variables.item_name=productName;
			variables.amount=price;
			variables.currency_code="USD";
			variables.no_note="1";
			variables.no_shipping="1";
			variables.bn="PP-BuyNowBF:btn_buynowCC_LG_global.gif:NonHosted";
			variables.notify_url="http://chobots.com/kavalok/paypalipn";

			variables.custom=transactionId;
			request.data=variables;
			navigateToURL(request, BrowserConstants.SELF);
		}

		public static function processPaymentForm(result:Object):void
		{
			if( result == null){
				LoginManager.showError();
			}
			
			var request:URLRequest=new URLRequest(result.url);
			request.method=URLRequestMethod.POST;

			var variables:URLVariables=new URLVariables();

			var parameters:Object = result.parameters;
			
			for (var paramName:String in parameters){
				variables[paramName]=parameters[paramName];
			}

//			variables.merchantReference=result.merchantReference;
//			variables.paymentAmount=result.paymentAmount;
//			variables.currencyCode=result.currencyCode;
//			variables.skinCode=result.skinCode;
//			variables.merchantAccount=result.merchantAccount;
//			variables.shopperLocale=result.shopperLocale;
//			variables.orderData=result.orderData;
//			variables.shipBeforeDate=result.shipBeforeDate;
//			variables.sessionValidity=result.sessionValidity;
//			variables.shopperEmail=result.shopperEmail;
//			variables.shopperReference=result.shopperReference;
//			variables.merchantSig=result.merchantSig;

			request.data=variables;
			navigateToURL(request, BrowserConstants.BLANK);
			
		}

		public static function processAdyenPayment(result:Object):void
		{
			var request:URLRequest=new URLRequest(result.url);
			request.method=URLRequestMethod.GET;

			var variables:URLVariables=new URLVariables();


			variables.merchantReference=result.merchantReference;
			variables.paymentAmount=result.paymentAmount;
			variables.currencyCode=result.currencyCode;
			variables.skinCode=result.skinCode;
			variables.merchantAccount=result.merchantAccount;
			variables.shopperLocale=result.shopperLocale;
			variables.orderData=result.orderData;
			variables.shipBeforeDate=result.shipBeforeDate;
			variables.sessionValidity=result.sessionValidity;
			variables.shopperEmail=result.shopperEmail;
			variables.shopperReference=result.shopperReference;
			variables.merchantSig=result.merchantSig;

			request.data=variables;
			navigateToURL(request, BrowserConstants.BLANK);
		}
		
		
		private var now : Number;
		
		
		public static function getCitizenshipLeftDays(now : Date, citizenExpirationDate: Date):Number
		{
			var citizenShipExpire:Number= citizenExpirationDate!= null ? citizenExpirationDate.getTime() : 0;

			var days:Number=0;
			citizenShipExpire=citizenShipExpire - now.getTime();
			if (citizenShipExpire > 0)
			{
				days=Math.round(citizenShipExpire / 1000 / 60 / 60 / 24);
			}
			return days;
		}

	}
}