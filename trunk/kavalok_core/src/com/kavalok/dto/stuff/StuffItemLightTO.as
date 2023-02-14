package com.kavalok.dto.stuff
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.gameplay.ColorResourceSprite;
	import com.kavalok.gameplay.ResourceSprite;
	
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	
	public class StuffItemLightTO extends StuffTOBase
	{

		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.stuff.StuffItemLightTO", StuffItemLightTO);
		}

		public var used : Boolean;
		public var placement : String;
		public var x : int;
		public var y : int;
		public var level : int;
		public var rotation : int;
		public var color : int;
		public var giftable : Boolean;
		public var shopName : String;
		public var info : String;
		public var colorSec:int;
		public var lolName:String;
		
		public function get position():Point { return new Point(x, y); }
		public function set position(value:Point):void
		{
			x = value.x;
			y = value.y;
		}
		
		public function StuffItemLightTO(stringPresentation : String = null)
		{
			if(stringPresentation==null)
				return;
			var infoArr:Array = stringPresentation.split('|');
			fileName = infoArr[0]; 
			type = infoArr[1]; 
			name = infoArr[2]; 
			id = int(infoArr[3]); 
        	price = int(infoArr[4]);
			emeralds = int(infoArr[5]);
        	hasColor = ("t"== infoArr[6]);
        	placement = infoArr[7];
	        used = ("t"== infoArr[8]); 
	        x = int(infoArr[9]); 
	        y = int(infoArr[10]); 
	        level = infoArr[11]; 
	        color = int(infoArr[12]); 
	        rotation = infoArr[13]; 
	        giftable = ("t"== infoArr[14]); 
	        shopName = infoArr[15]; 
	        premium = ("t"== infoArr[16]); 
	        info = infoArr[17]; 
	        colorSec = infoArr[18];
	        doubleColor = ("t"== infoArr[19]);
	    }
		
		override public function createModel():ResourceSprite
		{
			if(hasColor && color >= 0)
				return new ColorResourceSprite(url, MODEL_CLASS_NAME, color, false, true, colorSec);
			else
				return super.createModel();
		}
		
		public function get backPrice():int
		{
			var price:int = Stuffs.RECYCLE_KOEF * price;
			if (Global.charManager.isCitizen)
				price *= 2;
				
			return int(price);
		}
		
		public function get backEmeralds():int
		{
			var emeralds:int = Stuffs.RECYCLE_KOEF * emeralds;
			
			return int(emeralds);
		}
	}
}