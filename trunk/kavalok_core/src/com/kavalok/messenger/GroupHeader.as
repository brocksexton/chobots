package com.kavalok.messenger
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.controls.IListItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GroupHeader implements IListItem
	{
		private var _content:MovieClip;
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		public function GroupHeader(contentClass:Class, caption:String)
		{
			_content = new contentClass();
			Global.resourceBundles.kavalok.registerTextField(_content.txtCaption, caption);
		}
	}
}