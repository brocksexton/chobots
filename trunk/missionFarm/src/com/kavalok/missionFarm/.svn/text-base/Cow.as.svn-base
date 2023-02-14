package com.kavalok.missionFarm
{
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	
	public class Cow extends FarmObject
	{
		private var _content:McCow;
		private var _isOwner:Boolean = false;
		
		public function Cow(content:McCow, farm:FarmStage)
		{
			super('cow', farm);
			
			_content = content;
			_content.btn.alpha = 0;
			
			_btn = _content.btn;
			_position =  GraphUtils.objToPoint(_farm.points.mcCowPoint);
			
			stopAnimation();
			
			_em.registerEvent(_content.mcAnim, Event.COMPLETE, onComplete);
			
			attachToRemoteObject();
		}
		
		override protected function onLock():void
		{
			_farm.sendUserPos(_position);
			_farm.sendSelectTool(null);
			_farm.sendBonus(FarmStage.COW_VALUE);
			_isOwner = true;
			
			unlock();
			send('rPlay');
		}
		
		public function rPlay():void
		{
			playAnimation();
			refresh();
		}
		
		private function onComplete(e:Event):void
		{
			stopAnimation();
			
			if (_isOwner)
			{
				_farm.milk.sendVolume();
				_isOwner = false;
			}
		}
		
		private function playAnimation():void
		{
			_content.mcAnim.gotoAndPlay(2);
		}
		
		private function stopAnimation():void
		{
			_content.mcAnim.gotoAndStop(1);
		}
		
		override public function refresh():void
		{
			_enabled = _farm.currentTool == Tools.GROW
				&& _content.mcAnim.currentFrame == 1
				&& !_farm.milk.isFull;
			
			var pointer:Class = (_enabled)
				? MousePointer.ACTION
				: MousePointer.BLOCKED;
			
			MousePointer.registerObject(_content.btn, pointer);
		}
		
	}
	
}