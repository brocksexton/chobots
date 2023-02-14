package org.rje.glaze.util {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.text.TextField;

	public class FPSCounter extends Sprite {
		public var output:TextField;
		public var lastFrame:int = 0;
		public var fps:int = 0;
		public var runningCount:int = 0;
		public var userMessage:String = "";
		
		public function FPSCounter() {
			output = new TextField();
            output.selectable = false;
			output.width = 400;
            addChild(output);
			addEventListener(Event.ENTER_FRAME, tick);
		}
		
		public function tick(evt:Event):void {
			var thisFrame:int = getTimer();
			var d:int = thisFrame-lastFrame;
			fps = 1000/(d);
			runningCount += d;
			if (runningCount>1000) {
				refreshText();
				runningCount=0;
			}
			lastFrame = thisFrame;
		}
		
		public function refreshText():void {
			output.text = "FPS="+fps+" "+userMessage;
		}
	}
	
}