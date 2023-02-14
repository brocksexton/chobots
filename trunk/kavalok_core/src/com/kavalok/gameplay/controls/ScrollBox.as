package com.kavalok.gameplay.controls
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ScrollBox
	{
		private var _content:Sprite;
		private var _scroller:Scroller;
		private var _wheelDistance:int = 20;
		
		public function ScrollBox(content:Sprite, mask:Sprite, scroller:Scroller)
		{
			_content = content;
			
			_content.cacheAsBitmap = true;
			_content.x = mask.x;
			_content.y = mask.y;
			
			_scroller = scroller;
			
			mask.parent.removeChild(mask);
			_content.scrollRect = new Rectangle(0, 0, mask.width, mask.height);
			
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			_scroller.changeEvent.addListener(onScroll);
			
			refresh();
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		private function onScroll(sender:Scroller = null):void
		{
			var size : Rectangle = GraphUtils.getChildrenRect(_content);
			var newRect : Rectangle = _content.scrollRect;
			newRect.y = size.height > newRect.height ? _scroller.position * (size.height - newRect.height) : 0;
			_content.scrollRect = newRect;
			_scroller.scrollerVisible = (size.height > newRect.height); 
		}
		
		private function onWheel(e:MouseEvent):void
		{
			var size : Rectangle = GraphUtils.getChildrenRect(_content);
			var distance:Number = (e.delta > 0)
				? +_wheelDistance / (_content.height - size.height)
				: -_wheelDistance / (_content.height - size.height);
			
			_scroller.position = GraphUtils.claimRange(
				_scroller.position + distance, 0, 1);
				
			onScroll();
		}
		
		public function refresh():void
		{
			var size : Rectangle = GraphUtils.getChildrenRect(_content);
			_scroller.scrollStep = _wheelDistance / (size.height);
			onScroll();
		}

	}
}