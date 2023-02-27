package com.kavalok.dto.pet	
{	
	import flash.net.registerClassAlias;	
		
	public class PetTO	
	{	
		public static function initialize() : void	
		{	
			registerClassAlias("com.kavalok.dto.pet.PetTO", PetTO);	
		}	
			
		public var id:int = -1;	
			
		public var body:String = 'body1';	
		public var face:String = 'face0';	
		public var top:String = 'top0';	
		public var side:String = 'side0';	
		public var bottom:String = 'bottom0';	
			
		public var bodyColor:int = 0xFFFFFF; 	
		public var faceColor:int = 0xFFFFFF; 	
		public var topColor:int = 0xFFFFFF; 	
		public var sideColor:int = 0xFFFFFF; 	
		public var bottomColor:int = 0xFFFFFF;	
			
		public var name:String;	
		public var health:int = 50;	
		public var food:int = 50;	
		public var loyality:int = 1;	
		public var lAge:Number;	
		public var age:int = 240;	
		public var sit:Boolean = false;	
		public var atHome:Boolean;	
			
		public function getOptimized():Object	
		{	
			var result:Object =	
			{	
				id: id,	
				n: name,	
				i: items,	
				c: colors	
			}	
			return result;	
		}	
			
		public function setOptimized(value:Object):void	
		{	
			name = value.n;	
			id = value.id;	
				
			body = value.i[0];	
			face = value.i[1];	
			top = value.i[2];	
			side = value.i[3];	
			bottom = value.i[4];	
				
			bodyColor = value.c[0];  	
			faceColor = value.c[1];	
			topColor = value.c[2];	
			sideColor = value.c[3];	
			bottomColor = value.c[4];	
		}	
			
		public function get items():Array	
		{	
			 return [body, face, top, side, bottom];	
		}	
			
		public function get colors():Array	
		{	
			 return [bodyColor, faceColor, topColor, sideColor, bottomColor];	
		}	
	}	
}