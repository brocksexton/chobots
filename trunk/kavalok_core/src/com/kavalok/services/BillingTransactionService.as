package com.kavalok.services
{
	public class BillingTransactionService extends Red5ServiceBase
	{
		public function BillingTransactionService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function requestStuff(successMessage : String, countryId : String, providerId : String, stuffId : int, count : int, color : int) : void
		{
			doCall("requestStuff", arguments);
		}

		public function paypalRequestStuff(successMessage : String, stuffId : int, count : int, color : int) : void
		{
			doCall("paypalRequestStuff", arguments);
		}

		public function adyenRequestStuff(successMessage : String, stuffId : int, count : int, color : int) : void
		{
			doCall("adyenRequestStuff", arguments);
		}

		public function adyenRequestMembership(successMessage : String, month : int, productName : String, source : String) : void
		{
			doCall("adyenRequestMembership", arguments);
		}

		public function requestMembership(successMessage : String, skuId : int, source : String, partnerUserId : int) : void
		{
			doCall("requestMembership", arguments);
		}

		public function adyenRequestMembershipProlong(successMessage : String, month : int, productName : String, source : String) : void
		{
			doCall("adyenRequestMembershipProlong", arguments);
		}

		public function requestMembershipProlong(successMessage : String, skuId : int, source : String) : void
		{
			doCall("requestMembership", arguments);
		}

		public function getMembershipSKUs() : void
		{
			doCall("getMembershipSKUs", arguments);
		}

		public function getRobotsSKU(itemId : int) : void
		{
			doCall("getRobotsSKU", arguments);
		}

		public function requestRobotsItem(skuId : int, source : String) : void
		{
			doCall("requestRobotsItem", arguments);
		}
		
		public function requestPayedItem(skuId : int, source : String) : void
		{
			doCall("requestPayedItem", arguments);
		}

	}
}