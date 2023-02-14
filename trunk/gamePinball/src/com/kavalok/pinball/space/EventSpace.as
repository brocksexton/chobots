package com.kavalok.pinball.space
{
	import com.kavalok.events.EventSender;
	import org.rje.glaze.engine.collision.shapes.AABB;
	import org.rje.glaze.engine.space.BruteForceSpace;

	public class EventSpace extends BruteForceSpace
	{
		private var _stoped : Boolean;
		private var _physicsStepEvent : EventSender = new EventSender();
		
		public function EventSpace(fps:int, pps:int, worldBoundary:AABB=null)
		{
			super(fps, pps, worldBoundary);
		}
		
		public function set stoped(value : Boolean) : void
		{
			_stoped = value;
		}
		
		public function get stoped() : Boolean
		{
			return _stoped;
		}
		
		public function get physicsStepEvent() : EventSender
		{
			return _physicsStepEvent;
		}
		
		override public function physicsStep():void
		{
			if(!stoped)
			{
				super.physicsStep();
				physicsStepEvent.sendEvent();
			}
		}
		
		
		
	}
}