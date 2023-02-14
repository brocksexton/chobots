package com.kavalok.gameplay.frame.safeChat
{
	import com.kavalok.gameplay.controls.RectangleSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.kavalok.events.EventSender;
	
	public class SafeChatGroupView extends SafeChatListView
	{
		private static const MAX_ITEMS : Number = 7;
		private static const MARGINS : Number = 20;
		
		
		public function SafeChatGroupView(items : Array)
		{
			super(null, items, MAX_ITEMS)
			var background : RectangleSprite = new RectangleSprite(content.width + MARGINS, content.height + MARGINS);
			background.x = - MARGINS/2;
			background.y = - MARGINS/2;
			content.addChildAt(background, 0);
		}
		

	}
}