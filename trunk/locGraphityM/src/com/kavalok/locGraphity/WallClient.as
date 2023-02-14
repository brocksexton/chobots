package com.kavalok.locGraphity
{
	import com.kavalok.constants.Locations;
	import com.kavalok.events.EventSender;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.services.GraphityService;
	
	public class WallClient extends ClientBase
	{
		static private const STATE_SHAPE:String = "shape";
		static private const STATE_INFO:String = "wallInfo";
		
		private var _addLineEvent:EventSender = new EventSender();
		private var _clearEvent:EventSender = new EventSender();
		private var _removeLineEvent:EventSender = new EventSender();
		private var _wallId:String;
		
		public function WallClient(wallId:String)
		{
			_wallId = wallId;
			new GraphityService(onShapesResult).getShapes(_wallId);
			connect(_wallId);			
		}
		
		override public function restoreState(states:Object):void
		{
 			super.restoreState(states);
		}
		
		private function onShapesResult(result:Array):void
		{
			for each (var state:Object in result)
			{
				rShape(state);
			}
		}
		
		public function addLine(state:Object):void
		{
			state.charId = clientCharId;
			new GraphityService().sendShape(_wallId, state);
		}
		
		public function rShape(state:Object):void
		{
			addLineEvent.sendEvent(state);
		}
		
		public function sendClear():void
		{
			new GraphityService().clear(_wallId);
		}
		
		public function rClear(parameter:Object):void
		{
			_clearEvent.sendEvent();
		}
		
		public function get clearEvent():EventSender
		{
			 return _clearEvent;
		}
		
		public function get addLineEvent():EventSender
		{
			 return _addLineEvent;
		}

		public function get removeLineEvent():EventSender
		{
			 return _removeLineEvent;
		}
	}
}