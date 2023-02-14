package com.kavalok.gameMoney
{
	import com.kavalok.utils.GraphUtils;
	import flash.events.MouseEvent;
	import com.kavalok.events.EventSender;
	
	public class PanelView 
	{
		private var _content:McControlPanel;
		
		private var _dropEvent:EventSender = new EventSender();
		
		public function PanelView(content:McControlPanel)
		{
			_content = content;
			_content.btnDrop.addEventListener(MouseEvent.CLICK, _dropEvent.sendEvent);
		}
		
		public function set time(numFrames:int):void 
		{
			var time:Date = GraphUtils.framesToTime(numFrames);
			
			_content.txtTime.text = ''
				+ (time.minutes < 10 ? '0' : '') + time.minutes.toString() + ':'
				+ (time.seconds < 10 ? '0' : '') + time.seconds.toString() + '.'
				+ time.milliseconds.toString().charAt(0);
		}
		
		public function set progress(value:Number):void 
		{
			var frameNum:int = 2 + Math.round((_content.mcProgressBar.totalFrames - 1) * value);
			_content.mcProgressBar.gotoAndStop(frameNum);
		}
		
		public function set dropEnabled(value:Boolean):void 
		{
			_content.btnDrop.enabled = value;
			_content.btnDrop.mouseEnabled = value;
			_content.btnDrop.alpha = value ? 1 : 0.5;
		}
		
		public function get dropEvent():EventSender { return _dropEvent; }
	}
	
}