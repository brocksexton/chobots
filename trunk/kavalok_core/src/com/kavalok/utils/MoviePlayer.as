package com.kavalok.utils
{
	import com.kavalok.commands.ICancelableCommand;
	import com.kavalok.events.EventSender;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author Canab
	 */
	public class MoviePlayer implements ICancelableCommand
	{
		public var clip:MovieClip;
		public var toFrame:int;
		public var fromFrame:int;
		
		private var _completeEvent:EventSender;
		
		public function MoviePlayer(clip:MovieClip = null, fromFrame:int = 1, toFrame:int = 0) 
		{
			this.clip = clip;
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
		}
		
		public function play(fromFrame:int = 1, toFrame:int = 0):void 
		{
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
			
			execute();
		}
		
		public function playToEnd():void
		{
			this.fromFrame = clip.currentFrame;
			this.toFrame = clip.totalFrames;
			execute();
		}
		
		public function playTo(toFrame:int):void 
		{
			play(clip.currentFrame, toFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (clip.currentFrame == toFrame)
			{
				clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				if (_completeEvent)
					_completeEvent.sendEvent(this);
			}
			else if (clip.currentFrame < toFrame)
			{
				clip.nextFrame();
			}
			else
			{
				clip.prevFrame();
			}
		}
		
		/* INTERFACE common.commands.IAsincCommand */
		
		public function get completeEvent():EventSender
		{
			if (!_completeEvent)
				_completeEvent = new EventSender(MoviePlayer);
			return _completeEvent;
		}
		
		public function execute():void
		{
			clip.gotoAndStop(fromFrame);
			clip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/* INTERFACE common.commands.ICancelableCommand */
		
		public function cancel():void
		{
			clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
	}

}