
package com.kavalok.gameSpiceRacing
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.kavalok.events.EventSender;

	public class ControlView
	{
		private var _content:McGameContent;
		private var _closeEvent:EventSender = new EventSender();
		
		public function ControlView(content:McGameContent)
		{
			_content = content;
			_content.btnClose.addEventListener(MouseEvent.CLICK, _closeEvent.sendEvent);
			fuel = 1;
		}
		
		public function set fuel(value:Number):void
		{
			setProgressBar(_content.mcFuelBar, value)
		}
		
		public function set time(value:Number):void
		{
			var date:Date = new Date();
			date.time = value;
			
			_content.txtTime.text = ''
				+ date.minutes
				+ ':' + (date.seconds < 10 ? '0' : '') + date.seconds
				+ '.' + date.milliseconds.toString().charAt(0);
		}
		
		public function addPlayer(player:Player):void
		{
			_content.mcMap.addChild(player.marker);
			refreshPlayer(player);
		}
		
		public function refreshPlayer(player:Player):void
		{
			player.marker.x = player.model.x / player.space.spaceWidth * _content.mcMap.mcZone.width;
			player.marker.y = _content.mcMap.mcZone.height
				+ player.model.y / player.space.spaceHeight * _content.mcMap.mcZone.height;
		}
		
		private function setProgressBar(mc:MovieClip, value:Number):void
		{
			var frameNum:int = int(mc.totalFrames * value);
			mc.gotoAndStop(mc.totalFrames - frameNum);
		}
		
		public function get closeEvent():EventSender { return _closeEvent; }
	}
	
}
