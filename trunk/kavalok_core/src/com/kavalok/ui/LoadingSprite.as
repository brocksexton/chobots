package com.kavalok.ui
{
	import com.kavalok.loaders.McLoading;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class LoadingSprite extends Sprite
	{
		static private const ROTATION_SPEED:Number = 10;
		
		private var _content:McLoading;
		
		public function LoadingSprite(bounds:Rectangle = null)
		{
			_content = new McLoading;
			_content.alpha = 0.8;
			
			if (bounds)
			{
				_content.x = 0.5 * (bounds.left + bounds.right);
				_content.y = 0.5 * (bounds.top + bounds.bottom);
			}
			
			addChild(_content);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_content.rotation += ROTATION_SPEED;
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			GraphUtils.stopAllChildren(_content);
		}

	}
}