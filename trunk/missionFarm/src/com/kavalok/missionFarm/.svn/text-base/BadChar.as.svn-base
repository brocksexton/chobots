package com.kavalok.missionFarm
{
	
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.EventManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.kavalok.events.EventSender;

	public class BadChar extends Sprite
	{
		public var model:MovieClip;
		public var id:String;
		public var growId:String;
		public var vx:Number;
		public var vy:Number;
		public var counter:int;
		public var state:String;
		public var enabled:Boolean;
		public var farm:FarmStage;
		public var em:EventManager;
		public var owner:String;
		
		private var _fightEvent:EventSender = new EventSender();
		private var _completeEvent:EventSender = new EventSender();
		
		public function setModel(modelClass:Class):void
		{
			clearModel();
			model = new modelClass();
			addChild(model);
			
			em.registerEvent(model, Event.COMPLETE, onModelComplete);
			em.registerEvent(model, MouseEvent.MOUSE_DOWN, onModelPress);
		}
		
		public function clearModel():void
		{
			if (model)
			{
				em.removeEvents(model);
				model.gotoAndStop(1);
				removeChild(model);
			}
		}
		
		private function onModelComplete(e:Event):void
		{
			_completeEvent.sendEvent(this);
		}
		
		private function onModelPress(e:MouseEvent):void 
		{
			if (enabled)
				_fightEvent.sendEvent(this);
		}
		
		public function refresh():void
		{
			enabled = (state == BadChars.STATE_MOVE && farm.currentTool == Tools.GUN);
			
			if (enabled)
				MousePointer.registerObject(this, McSight)
			else
				MousePointer.unRegisterObject(this);
			
		}
		
		public function get fightEvent():EventSender { return _fightEvent; }
		
		public function get completeEvent():EventSender { return _completeEvent; }
	}	
}