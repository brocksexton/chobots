
package com.kavalok.gameChoboard
{
	import com.kavalok.games.GameObject;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.MovieClip;

	public class Item extends GameObject
	{
		public var destroyed:Boolean = false;
		public var active:Boolean = true;
		public var events:EventManager;
		
		private var _types:Array =
		[
			com.kavalok.gameChoboard.McItem0,
			com.kavalok.gameChoboard.McItem1,
			com.kavalok.gameChoboard.McBonus,
		];
		
		public function Item()
		{
			var contentClass:Class = Arrays.randomItem(_types);
			var content:MovieClip = new contentClass();
			super(content);
			
			v.x = -Config.ITEM_SPEED_MIN -
				Math.random() * (Config.ITEM_SPEED_MAX - Config.ITEM_SPEED_MIN);
			
			content.cacheAsBitmap = true;
		}
		
		public function hide():void
		{
			active = false;
			var twean:Object =
			{
				scaleX: 0,
				scaleY: 0
			}
			
			new SpriteTweaner(content, twean, 5, events, onHideComplete);
		}
		
		private function onHideComplete(sender:Object = null):void
		{
			destroyed = true;
		}
		
	}
	
}
