package com.kavalok.missionFarm
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.entryPoints.IEntryPoint;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.remoting.RemoteObjects;
	import com.kavalok.utils.EventManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class FarmObject extends ClientBase implements IEntryPoint
	{
		protected var _farm:FarmStage;
		protected var _activateEvent:EventSender = new EventSender();
		protected var _position:Point;
		protected var _id:String;
		protected var _locked:Boolean;
		protected var _btn:Sprite;
		protected var _em:EventManager = MissionFarm.eventManager;
		protected var _enabled:Boolean = true;
		protected var _pointerClass:Class;
		protected var _state:Object = {};
		
		public function FarmObject(id:String, farm:FarmStage)
		{
			_id = id;
			_farm = farm;
			_farm.addPoint(this);
		}
		
		override public function restoreState(states:Object):void
		{
			super.restoreState(states);
			
			if (_btn)
			{
				_btn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				_btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			
			if (!states)
				return;
				
			if (! (id in states))
				return;
				
			var receivedState:Object = states[id];
			
			for (var stateName:String in receivedState)
			{
				_state[stateName] = receivedState[stateName];
			}
			
			refresh();
		}
		
		
		protected function attachToRemoteObject():void
		{
			connect(_farm.remoteId);
			
			if (_btn)
			{
				_btn.alpha = 0;
			}
			
			refresh();
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			refresh();
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			if (_enabled)
				_activateEvent.sendEvent(this);
		}
		
		override public function get id():String
		{
			return _id;
		}
		
		public function get charPosition():Point
		{
			return _position;
		}
		
		public function goIn():void
		{
			if (!_locked)
			{
				_locked = true;
				lockState('rLock', id);
			}
		}
		
		public function unlock():void
		{
			unlockState(id);
		}
		
		public function rLock(stateId:String, state:Object):void
		{
			if (state.owner == clientCharId)
			{
				onLock();
			}
			else
			{
				_locked = false;
			}
		}
		
		public function goOut():void
		{
			if (_locked)
			{
				unlockState(id);
				_locked = false;
				onUnlock();
			}
		}

		public function destroy():void{}
		
		protected function updatePointer():void
		{
			var pointerClass:Class = (_enabled)
				? _pointerClass
				: MousePointer.BLOCKED
				
			MousePointer.registerObject(_btn, pointerClass);
		}
		
		protected function onLock():void {}
		protected function onUnlock():void {}
		
		public function refresh():void { }
		
		public function get activateEvent():EventSender { return _activateEvent; }
		
	}
	
}