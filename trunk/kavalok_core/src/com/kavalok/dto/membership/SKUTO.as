package com.kavalok.dto.membership
{
	import flash.net.registerClassAlias;

	public class SKUTO
	{

		public static function initialize():void
		{
			registerClassAlias("com.kavalok.dto.membership.SKUTO", SKUTO);
		}
		public var id:Number;

		public var price:Number;

		public var priceStr:String;

		public var term:Number;

		public var currency:Number;

		public var currencySign:String;

		public var currencyText:String;

		public var currencyCentsText:String;

		public var name:String;

		public var bugsBonus:Number;

		public var productId:String;

		public var specialOfferName:String;
		
		public var specialOffer:Boolean;
		

	}
}

