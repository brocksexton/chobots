package com.kavalok.missionFarm
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.location.entryPoints.IEntryPoint;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Tool implements IEntryPoint
	{
		private var _farm:FarmStage;
		private var _content:InteractiveObject;
		private var _activateEvent:EventSender = new EventSender();
		private var _tool:String;
		private var _tip:String;
		
		public function Tool(farm:FarmStage, content:InteractiveObject, tool:String, bundle:String, tip:String)
		{
			_farm = farm;
			_content = content;
			_tool = tool;
			_tip = tip;
			_content.addEventListener(MouseEvent.CLICK, onClick);
			
			ToolTips.registerObject(_content, bundle, Modules.MISSION_FARM);
			MousePointer.registerObject(_content, MousePointer.HAND);
			
			_farm.addPoint(this);
		}
		
		private function onClick(e:MouseEvent):void
		{
			_activateEvent.sendEvent(this);
		}
		
		public function goIn():void
		{
			Global.playSound(F1_take);
			_farm.sendUserPos(charPosition);
			_farm.sendSelectTool(_tool);
			
			Global.frame.tips.addTip(_tip);
		}
		
		public function get charPosition():Point
		{
			return GraphUtils.objToPoint(_content);
		}
		
		public function get activateEvent():EventSender
		{
			 return _activateEvent;
		}
		
		public function goOut():void
		{
		}
		
		public function destroy():void
		{
		}

	}
}