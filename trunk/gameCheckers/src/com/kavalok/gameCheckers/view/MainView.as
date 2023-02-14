package com.kavalok.gameCheckers.view
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameCheckers.Controller;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.utils.DragManager;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import gameCheckers.McGameWindow;

	
	public class MainView extends Controller
	{
		private var _content:McGameWindow = new McGameWindow();
		private var _playersView:PlayersView = new PlayersView(_content);
		private var _deskView:DeskView = new DeskView(_content);
		private var _closeEvent:EventSender = new EventSender();
		
		public function MainView()
		{
			new DragManager(_content, _content.background, KavalokConstants.SCREEN_RECT);
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			_closeEvent.sendEvent();
		}
		
		public function get content():Sprite { return _content; }
		public function get closeEvent():EventSender { return _closeEvent; }
		
	}
	
}