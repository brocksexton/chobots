package com.kavalok.gameSpiceRacing
{
	import com.kavalok.games.GameObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Space
	{
		public static const OBJECTS:Array =
		[
			McSpaceObject1,
			McSpaceObject2,
			McSpaceObject3,
			McSpaceObject4,
			McFuelItem,
			McSlowItem,
			McBioItem,
			McSpeedItem,
		];
		
		public var pageWidth:int;
		public var pageHeight:int;
		public var spaceWidth:int;
		public var spaceHeight:int;
		
		public var content:Sprite = new Sprite();
		
		public var mcStart:McStart = new McStart();
		public var mcFinish:McFinish = new McFinish();
		
		public var items:Array = [];
		
		public function Space(bounds:Rectangle)
		{
			pageWidth = bounds.width;
			pageHeight = bounds.height;
			spaceWidth = pageWidth;
			spaceHeight = pageHeight * Config.PAGE_COUNT;
			
			content.addChild(mcStart);
			content.addChild(mcFinish);
			
			mcStart.y = 0;
			mcFinish.y = -spaceHeight;
		}
		
		public function build(map:Array):void
		{
			for each (var info:Object in map)
			{
				var objectClass:Class = OBJECTS[info.num];
				var sprite:MovieClip = new objectClass();
				sprite.x = info.x;
				sprite.y = info.y;
				sprite.mouseEnabled = false;
				sprite.mouseChildren = false;
				sprite.cacheAsBitmap = true;
				sprite.mcArea.visible = false;
				
				if (Math.random() < 0.5)
					sprite.scaleX = -sprite.scaleX;
				
				var body:GameObject = new GameObject(sprite);
				body.radius = 0.5 * sprite.mcArea.width;
				body.weight = 10 * body.radius;
				body.tag.used = false;
				body.content.visible = false;
				
				items.push(body);
				
				content.addChild(sprite);
			}
		}
		
		public function doStep():void
		{
			for each (var item:GameObject in items)
			{
				item.processMov();
				
				var y:Number = item.content.y + content.y;
				item.content.visible = (y > 0 && y < pageWidth)
			}
		}
		
	}
}
