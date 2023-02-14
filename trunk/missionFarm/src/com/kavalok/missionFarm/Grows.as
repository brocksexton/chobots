package com.kavalok.missionFarm
{
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.geom.Point;
	
	public class Grows extends FarmObject
	{
		static public const MAX_COUNT:int = 10;
		
		private var _content:McGrowZone;
		private var _list:Object = { };
		private var _currentGrow:Grow;
		private var _growCount:int = 0;
		
		public function Grows(farm:FarmStage)
		{
			super('grow', farm);
			
			_content = _farm.location.mcGrowZone;
			_content.mcArea.visible = false;
			
			attachToRemoteObject();
		}
		
		override public function refresh():void
		{
			for each (var grow:Grow in _list)
			{
				grow.enabled = (_farm.currentTool != Tools.GROW);
			}
		}
		
		override public function restoreState(states:Object):void 
		{
			super.restoreState(states);
			
			for (var stateId:String in states)
			{
				rAddGrow(stateId, states[stateId], false);
			}
		}
		
		override public function goIn():void 
		{
			if (!_currentGrow.busy && _currentGrow.enabled) 
			{
				_currentGrow.lockEvent.setListener(removeByChar)
				sendRemoveGrow(_currentGrow);
			}
		}
		
		public function sendRemoveGrow(grow:Grow):void
		{
			grow.busy = true;
			lockState('rLock', grow.id);
		}
		
		override public function rLock(stateId:String, state:Object):void 
		{
			if (!(stateId in _list))
				return;
				
			var grow:Grow = _list[stateId];
			
			if (state.owner == clientCharId)
			{
				removeState('rRemove', stateId);
				grow.locked = true;
			}
			else 
			{
				grow.busy = false;
			}
			
			grow.lockEvent.sendEvent(grow);
		}
		
		private function removeByChar(grow:Grow):void
		{
			if (grow.locked)
			{
				_farm.sendUserPos(GraphUtils.objToPoint(grow.model));
				_farm.sendSelectTool(Tools.GROW);
			}
		}
		
		public function rRemove(stateId:String):void
		{
			if (stateId in _list)
			{
				var grow:Grow = _list[stateId];
				delete _list[stateId];
				
				_growCount--;
				_content.removeChild(grow.model);
			}
		}
		
		public function sendAddGrow():void
		{
			var p:Point = GraphUtils.getRandomZonePoint(_content.mcArea, _farm.location);
			var id:String = Strings.generateRandomId();
			
			var growState:Object = 
			{
				x : p.x,
				y : p.y,
				owner : clientCharId				
			}
			
			if (p.x > 0 && p.y > 0)
				sendState('rAddGrow', id, growState );
			else
				Global.handleError(new Error('Farm:\n' + p));
		}
		
		public function rAddGrow(stateId:String, state:Object, fade:Boolean = true):void
		{
			if (state.x > 0 && state.y > 0)
			{
				Global.frame.tips.addTip('toPick');
				
				var grow:Grow = new Grow(stateId, fade);
				
				_growCount++;
				
				grow.model.x = state.x;
				grow.model.y = state.y;
				grow.pressEvent.addListener(onGrowPress);
				
				_content.addChild(grow.model);
				_list[stateId] = grow;
				
				refresh();
				
				if (fade && state.owner == clientCharId)
					_farm.badChars.sendCreateBadChar(grow);
			}
		}
		
		private function onGrowPress(grow:Grow):void 
		{
			if (_enabled)
			{
				_currentGrow = grow;
				_activateEvent.sendEvent(this);
			}
		}
		
		override public function get charPosition():Point
		{
			return GraphUtils.objToPoint(_currentGrow.model);
		}
		
		public function get list():Object { return _list; }
		public function get growCount():int { return _growCount; }
	}
	
}
