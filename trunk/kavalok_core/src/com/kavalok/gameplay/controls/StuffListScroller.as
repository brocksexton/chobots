package com.kavalok.gameplay.controls
{
	import com.kavalok.gameplay.frame.bag.StuffList;
	
	import flash.display.Sprite;

	public class StuffListScroller extends Scroller
	{
		private var _stuffList : StuffList;
		public function StuffListScroller(container:Sprite, stuffList : StuffList)
		{
			super(container);
			_stuffList = stuffList;
			_stuffList.itemsChangeEvent.addListener(refresh);
			refresh();
			changeCompleteEvent.addListener(onChange);
		}
		
		private function onChange(scroller : Scroller) : void
		{
			_stuffList.pageIndex = position * (_stuffList.pagesCount - 1);
		}
		private function refresh() : void
		{
			if(_stuffList.pagesCount > 1)
			{
				_content.visible = true;
				scrollStep = 1 / (_stuffList.pagesCount - 1);
				position = 0;
			}
			else
			{
				_content.visible = false;
			}
		}
		
	}
}