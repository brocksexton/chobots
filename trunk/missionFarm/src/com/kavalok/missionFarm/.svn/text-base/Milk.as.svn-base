package com.kavalok.missionFarm
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Milk extends FarmObject
	{
		private static const COUNT_MAX:int = 3;
		
		private var _content:McMilk;
		private var _busy:Boolean = false;
		private var _newVolume:int;
		
		public function Milk(content:McMilk, farm:FarmStage)
		{
			super('milk', farm);
			
			_content = content;
			_content.mcTube.stop();
			_content.mcKran.stop();
			_content.mcFlag.stop();
			
			hideAnim(_content.mcAnim1);
			hideAnim(_content.mcAnim2);
			hideAnim(_content.mcAnim3);
			
			_em.registerEvent(_content.mcAnim1, Event.COMPLETE, onAnim1Complete);
			_em.registerEvent(_content.mcAnim2, Event.COMPLETE, onAnim2Complete);
			_em.registerEvent(_content.mcAnim3, Event.COMPLETE, onAnim3Complete);
			
			_btn = _content.btn;
			_pointerClass = MousePointer.ACTION;
			_position = GraphUtils.objToPoint(_farm.points.mcRightPoint);
			
			_em.registerEvent(_content.mcTube, Event.COMPLETE, onTubeComplete);
			
			_state = { volume: 0 };
			
			stopLines();
			attachToRemoteObject();
		}
		
		
		//{ #region tube
		
		public function sendVolume():void
		{
			var newVolume:int = Math.min(_state.volume + 1, maxVolume);
			sendState('rVolume', id, { volume : newVolume } );
		}
		
		public function rVolume(stateId:String, state:Object):void
		{
			Global.playSound(F1_milk_boble);
			
			_state.volume = state.volume;
			
			if (_state.volume > 0)
				_content.mcTube.play();
		}
		
		private function onTubeComplete(e:Event):void
		{
			_content.mcTube.gotoAndStop(1);
			
			if (isFull)
			{
				Global.playSound(F1_cow);
				Global.frame.tips.addTip('fullBottle');
			}
			
			refresh();
		}
		
		
		//} #region tube
		
		//{ #region anim
		
		override protected function onLock():void
		{
			_farm.sendUserPos(_position);
			_farm.sendSelectTool(null);
			
			var newVolume:int = _state.volume;
			
			if (newVolume == maxVolume)
				newVolume = 0;
			
			sendState('rPlayAnim1', id, { volume: newVolume });
		}
		
		public function rPlayAnim1(stateId:String, state:Object):void
		{
			_newVolume = state.volume;
			_busy = true;
			Global.playSound(F1_put);
			playAnim(_content.mcAnim1);
			_content.mcLine1.play();
		}
		
		private function onAnim1Complete(e:Event):void
		{
			if (isFull)
			{
				Global.playSound(F1_milk_pour);
				_content.mcFlag.gotoAndStop(2);
				_content.mcKran.play();
				hideAnim(_content.mcAnim1);
				playAnim(_content.mcAnim2);
				_content.mcReceiver.mcLine2.play();
				_farm.onMilk();
			}
			else
			{
				_content.mcFlag.gotoAndStop(1);
				hideAnim(_content.mcAnim1);
				playAnim(_content.mcAnim3);
			}
			
			_state.volume = _newVolume;
			refresh();
		}
		
		private function onAnim2Complete(e:Event):void
		{
			_busy = false;
			refresh();
			hideAnim(_content.mcAnim2);
			stopLines();
		}
		
		private function onAnim3Complete(e:Event):void
		{
			_busy = false;
			hideAnim(_content.mcAnim3);
			stopLines();
			refresh();
		}
		
		private function playAnim(anim:MovieClip):void
		{
			anim.visible = true;
			anim.gotoAndPlay(1);
		}
		
		private function hideAnim(anim:MovieClip):void
		{
			anim.visible = false;
			anim.gotoAndStop(1);
		}
		
		private function stopLines():void
		{
			_content.mcLine1.stop();
			_content.mcReceiver.mcLine2.stop();
		}
		
		//} #region anim
		
		override public function refresh():void
		{
			_content.mcVolume.gotoAndStop(_state.volume + 1);
			_enabled = _farm.currentTool == Tools.VIDRO && !_busy;
			updatePointer();
		}
		
		public function get isFull():Boolean
		{
			 return _state.volume == maxVolume;
		}
		
		public function get maxVolume():int
		{
			return _content.mcVolume.totalFrames - 1;
		}
		
	}
	
}