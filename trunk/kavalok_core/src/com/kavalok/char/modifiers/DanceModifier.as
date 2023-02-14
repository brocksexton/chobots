package com.kavalok.char.modifiers
{
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.dance.BonePlayer;
	import com.kavalok.gameplay.frame.bag.dance.DanceSerializer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DanceModifier extends CharModifierBase
	{
		static private const TIMEOUT:int = 60;
		
		private var _dances:Array;
		private var _danceIndex:int = 0;
		private var _stoped:Boolean = true;
		
		override public function get timeout():int
		{
			return TIMEOUT;
		}
		
		override protected function apply():void
		{
			_stoped = false;
			_char.stopMoving();
			_dances = _parameter as Array;
			_danceIndex = 0;
			nextDance();
		}
		
		private function onFrame(e:Event):void
		{
			var model:MovieClip = _char.model.content;
			
			if (!model)
				return;
			
			if (model.currentFrame == model.totalFrames)
			{
				_char.content.removeEventListener(Event.ENTER_FRAME, onFrame);
				nextDance();
			}
		}
		
		private function nextDance():void
		{
			if(_stoped)
				return;
			
			if(_danceIndex == _dances.length)
				_danceIndex = 0;
				
			var dance : String = _dances[_danceIndex];
			_danceIndex++;
			
			if(CharModels.DANCE_MODELS.indexOf(dance) != -1)
			{
				_char.content.addEventListener(Event.ENTER_FRAME, onFrame);
				_char.setModel(String(dance));
			}
			else
			{
				var danceValue : Array = new DanceSerializer().deserialize(dance)
				var player : BonePlayer = _char.customDance(danceValue);
				player.finishEvent.addListener(nextDance);
			}
		}
		
		override protected function restore():void
		{
			if (_char.isDancing)
				_char.setModel(CharModels.STAY, Directions.DOWN);
			_stoped = true;
			_char.content.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
	}
}