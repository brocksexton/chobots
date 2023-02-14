package com.kavalok.newsPaper
{
	import com.kavalok.services.PaperService;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import com.kavalok.events.EventSender;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.GraphUtils;
	
	public class TitleView
	{
		private static const TITLES_COUNT : uint = 6;
		private static const MARGINS : Point = new Point(200, 20);
		private static const ROWS_COUNT : uint = 3;
		
		private static var resourceBundle : ResourceBundle = Localiztion.getBundle("newsPaper");


		
		public var content : Title;
		
		private var _pageChange : EventSender = new EventSender();
		
		public function TitleView(size : uint)
		{
			content = new Title();
			new PaperService(onGetTitles).getMessages(Math.min(TITLES_COUNT, size));
			GraphUtils.removeChildren(content.buttons);
		}
		
		public function get pageChange() : EventSender
		{
			return _pageChange;
		}
		
		private function onGetTitles(result : Array) : void
		{
			for(var i : int = 0; i < result.length; i++)
			{
				var button : SimpleButton = uint(i / ROWS_COUNT) == 0 ? new NewsButton() : new NewsButtonRight();
				content.buttons.addChild(button);
				button.x = (button.width + MARGINS.x)* uint(i / ROWS_COUNT);
				button.y = (button.height + MARGINS.y) * (i % ROWS_COUNT);
				var locTitleKey : String = result[result.length - i - 1].content;
				resourceBundle.registerButton(button, locTitleKey);
				button.addEventListener(MouseEvent.CLICK, onButtonClick);
			}
		}
		
		private function onButtonClick(event : MouseEvent) : void
		{
			pageChange.sendEvent(- (content.buttons.getChildIndex(DisplayObject(event.currentTarget)) + 1));
		}
		
		
		
		
		
		

	}
}