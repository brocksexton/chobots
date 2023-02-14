package com.kavalok.gameChess.view
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameChess.Controller;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.utils.DragManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import gameChess.McGameWindow;
	
	public class MainView extends Controller
	{
		private var _closeEvent:EventSender = new EventSender();
		
		public function MainView()
		{
			var content:McGameWindow = game.content;
			var dragArea:Sprite = content.background;
			
			ToolTips.registerObject(content.lostGameButton, 'lostGame', ResourceBundles.KAVALOK);
			content.lostGameButton.addEventListener(MouseEvent.CLICK, onLostClick);
			
			content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			new DragManager(content, dragArea, KavalokConstants.SCREEN_RECT);
		}
		
		private function onLostClick(e:MouseEvent):void
		{
			game.client.sendFinish(game.otherPlayerNum);
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			closeEvent.sendEvent();
		}
		
		public function get closeEvent():EventSender { return _closeEvent; }
	}
	
}