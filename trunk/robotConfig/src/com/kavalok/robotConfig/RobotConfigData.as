package com.kavalok.robotConfig
{
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.robots.Robot;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.Sprite;
	import com.kavalok.utils.comparing.RequirementsCollection;
	import com.google.analytics.core.RequestObject;
	
	public class RobotConfigData
	{
		static private var _instance:RobotConfigData;
		
		private var _changeEvent:EventSender = new EventSender();
		
		private var _root:Sprite;
		
		private var _robots:Array = [];
		private var _items:Array = [];
		private var _currentRobot:Robot;
		private var _changed:Boolean = false;
		
		static public function get instance():RobotConfigData
		{
			if (!_instance)
				_instance = new RobotConfigData(new Singleton());
				
			return _instance;
		}
		
		public function RobotConfigData(oblect:Singleton)
		{
		}
		
		public function updateRobot():void
		{
			currentRobot.items = getUsedItems();
	 		_changed = true;
			dispatchChange();
		}
		
		public function getUsedItems():Array
		{
			var result:Array = [];
			for each (var item:RobotItemTO in _items)
			{
				if (item.robotId == _currentRobot.id)
					result.push(item);
			}
			return result;
		}
		
		public function getUsedBaseItems():Array
		{
			var result:Array = [];
			for each (var item:RobotItemTO in _items)
			{
				if (item.isBaseItem && item.robotId == _currentRobot.id)
					result.push(item);
			}
			return result;
		}
		
		public function getUsedSpecialItems():Array
		{
			var result:Array = [];
			for each (var item:RobotItemTO in _items)
			{
				if (item.isSpecialItem && item.robotId == _currentRobot.id)
					result.push(item);
			}
			return result;
		}
		
		public function getUsedArtifacts():Array
		{
			var result:Array = [];
			for each (var item:RobotItemTO in _items)
			{
				if (item.isArtifact && item.robotId == _currentRobot.id)
					result.push(item);
			}
			return result;
		}
		
		public function getFreeBaseItems():Array
		{
			var result:Array = [];
			for each (var item:RobotItemTO in _items)
			{
				if (item.isBaseItem && !item.used && item.acceptsRobot(_currentRobot.name) && item.level <= _currentRobot.level)
					result.push(item);
			}
			return result;
		}
		
		public function getFreeSpecialItems():Array
		{
			var result:Array = [];
			for each (var item:RobotItemTO in _items)
			{
				if (item.isSpecialItem && !item.used && item.acceptsRobot(_currentRobot.name) && item.level <= _currentRobot.level)
					result.push(item);
			}
			return result;
		}
		
		public function getFreeArtifacts():Array
		{
			var result:Array = [];
			for each (var item:RobotItemTO in _items)
			{
				if (item.isArtifact && !item.used && item.acceptsRobot(_currentRobot.name) && item.level <= _currentRobot.level)
					result.push(item);
			}
			return result;
		}
		
		public function get activeRobot():Robot
		{
			return Arrays.firstByRequirement(_robots,
				 new PropertyCompareRequirement('active', true)) as Robot
		}
		public function set activeRobot(value:Robot):void
		{
			for each (var robot:Robot in _robots)
			{
				robot.active = (robot.id == value.id);
			}
	 		_changed = true;
			dispatchChange();
		}
		
		
		public function get robots():Array { return _robots; }
		public function set robots(value:Array):void
		{
			 _robots = value;
		}
		
		public function get items():Array { return _items; }
		public function set items(value:Array):void
		{
			 _items = value;
		}
		
		public function get currentRobot():Robot { return _currentRobot; }
		public function set currentRobot(value:Robot):void
		{
			 _currentRobot = value;
			 updateRobot();
			 dispatchChange();
		}
		
		public function get root():Sprite { return _root; }
		public function set root(value:Sprite):void
		{
			 _root = value;
		}
		
		public function get changed():Boolean { return _changed; }
		public function set changed(value:Boolean):void
		{
		 	_changed = value;
		}
		
		public function dispatchChange():void
		{
	 		_changeEvent.sendEvent();
		}
		
		public function get changeEvent():EventSender { return _changeEvent; }
		
	}
}

internal class Singleton
{
}