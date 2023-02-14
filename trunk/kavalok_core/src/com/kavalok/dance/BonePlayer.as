package com.kavalok.dance
{
	import com.kavalok.events.EventSender;
	import com.kavalok.kinematics.IKMember;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class BonePlayer
	{
		private static const FRAMES_PER_POSITION : Number = 7;

		private var _bone : BoneParts;
		private var _framesPositions : Array = [];
		private var _dispatcher : DisplayObject;
		private var _finishEvent : EventSender = new EventSender();
		public function BonePlayer(bone : BoneParts, dispatcher : DisplayObject)
		{
			_bone = bone;
			_dispatcher = dispatcher;
		}
		public function get finishEvent() : EventSender
		{
			return _finishEvent;
		}
		public function play(frames : Array) : void
		{
			_framesPositions = [];
			for(var i : int = 0; i < frames.length; i++)
			{
				var current : Object = frames[i];
				var next : Object = i < frames.length - 1 ? frames[i + 1] : frames[i];
//				_framesPositions.push(current);
				for(var j : int = 0; j < FRAMES_PER_POSITION; j++)
				{
					_framesPositions.push(getFrame(current, next, j));
				}
			}
			_dispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		public function stop() : void
		{
			_dispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event : Event) : void
		{
			if(_framesPositions.length == 0)
			{
				stop();
				finishEvent.sendEvent();
			}
			else
			{
				_bone.coords = _framesPositions.shift();
			} 
		}
		private function getFrame(current : Object, next : Object, index : int) : Object
		{
			var result : Object = {};
			for(var name : String in current)
			{
				var currentPart : Object = current[name];
				var nextPart : Object = next[name];
				
				var newPart : BonePartInfo = new BonePartInfo();
				newPart.a = getAngleValue(currentPart.a, nextPart.a, index);
				
				newPart.x = getValue(currentPart.x, nextPart.x, index);
				newPart.y = getValue(currentPart.y, nextPart.y, index);
				result[name] = newPart;
			}
			return result;
		}
		
		private function getAngleValue(current : Number, next : Number, index : int) : Number
		{
			current = GraphUtils.simplifyAngle(current);
			next = GraphUtils.simplifyAngle(next);
			if(next < current)
				next += 360;

			if(next - current < 180)
				return getValue(current, next, index);
			else 
				return getValue(current + 360, next, index);
		}
		
		private function getValue(current : Number, next : Number, index : int) : Number
		{
			return current + (next - current)/FRAMES_PER_POSITION*index;
		}

	}
}