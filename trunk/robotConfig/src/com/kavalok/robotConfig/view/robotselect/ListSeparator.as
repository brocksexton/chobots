package com.kavalok.robotConfig.view.robotselect
{
	import com.kavalok.gameplay.controls.IListItem;
	
	import flash.display.Sprite;
	
	import robotConfig.McListSeparator;
	
	public class ListSeparator implements IListItem
	{
		private var _content:McListSeparator = new McListSeparator();
		
		public function ListSeparator()
		{
			super();
		}
		
		public function get content():Sprite
		{
			 return _content;
		}

	}
}