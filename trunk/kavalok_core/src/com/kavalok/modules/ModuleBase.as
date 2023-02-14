package com.kavalok.modules
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.IFlashView;
	import com.kavalok.utils.EventManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ModuleBase extends Sprite implements IModule
	{
		private var _parameters:Object = {};
		private var _eventManager:EventManager = new EventManager(); 
		private var _destroyEvent:EventSender = new EventSender();
		private var _readyEvent:EventSender = new EventSender();
		
		private var _currentView:DisplayObject;
		private var _id:String;
		
		public function ModuleBase()
		{
			super();
		}
		
		public function get id() : String
		{
			return _id;
		}
		public function set id(value : String) : void
		{
			_id = value;
		}
		
		public function initialize():void
		{
		}
		
		public function closeModule():void
		{
			_eventManager.clearEvents();
			destroyEvent.sendEvent(this);
			destroyEvent.removeListeners();
		}
		
		public function changeView(content:Object):void
		{
			var newContent:DisplayObject = (content is IFlashView)
				? IFlashView(content).content
				: DisplayObject(content);
			
			if (_currentView)
				removeChild(_currentView);
				
			_currentView = newContent;
			
			if (_currentView)
				addChild(_currentView);
		}
		
		public function get destroyEvent():EventSender { return _destroyEvent; }
		
		public function get parameters():Object { return _parameters; }
		
		public function set parameters(value:Object):void { _parameters = value; }
		
		public function get eventManager():EventManager
		{
			 return _eventManager;
		}
		
		public function get readyEvent():EventSender
		{
			 return _readyEvent;
		}

	}
}