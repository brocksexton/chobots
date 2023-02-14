package com.kavalok.games
{
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.kavalok.events.EventSender;
	
	public class SinglePlayerGame
	{
		private var _closeEvent:EventSender = new EventSender();
		private var _replayEvent:EventSender = new EventSender();
		private var _scoreEvent:EventSender = new EventSender();
		private var _events:EventManager = new EventManager();
		private var _content:MovieClip;
		
		public function initialize(content:MovieClip):void
		{
			_content = content;
			new ResourceScanner().apply(_content);
			
			if (content.getChildByName('closeButton'))
				_content.closeButton.addEventListener(MouseEvent.CLICK, _closeEvent.sendEvent);
				
			if (content.getChildByName('replayButton'))
				_content.replayButton.addEventListener(MouseEvent.CLICK, _replayEvent.sendEvent);
		}
		
		public function start():void
		{
			// virtual function
		}
		
		public function refresh():void
		{
			// virtual function
		}

		public function get closeEvent():EventSender { return _closeEvent; }
		
		public function get replayEvent():EventSender { return _replayEvent; }
		
		public function get scoreEvent():EventSender { return _scoreEvent; }
		
		public function get events():EventManager { return _events; }
		
		public function get content():MovieClip { return _content; }
	}
}