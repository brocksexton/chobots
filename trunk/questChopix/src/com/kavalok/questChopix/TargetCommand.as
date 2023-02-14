package com.kavalok.questChopix
{
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.LocationChar;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.MoveByPathAction;
	import com.kavalok.location.commands.LocationCommandBase;
	import com.kavalok.location.entryPoints.LocationEntryPoint;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	import com.kavalok.utils.TypeRequirement;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class TargetCommand extends LocationCommandBase
	{
		private var _targetSprite:McTarget;
		private var _exit:TargetEntry;
		private var _path:Array;
		private var _moveAction:MoveByPathAction;
		
		public function TargetCommand()
		{
		}
		
		override public function execute():void
		{
			findTargetExit();
			createTargetPath();
			createTarget();
			_targetSprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (!_targetSprite.stage)
			{
				_targetSprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else
			{
				if (!_moveAction && currentDistance < Quest.TARGET_DISTANCE_ACTIVATE)
					startMoveTarget();
				if (_moveAction && currentDistance < Quest.TARGET_DISTANCE_DEACTIVATE)
					stopMoveTarget();
			}
		}
		
		private function startMoveTarget():void
		{
			_targetSprite.gotoAndStop(2);
			_moveAction = new MoveByPathAction(_targetSprite, _path, LocationChar.DEFAULT_SPEED);
			_moveAction.onComplete = onMoveComplete;
			_moveAction.execute();
		}
		
		private function onMoveComplete(sender:MoveByPathAction):void
		{
			removeTarget();
			quest.targetLocation = _exit.locId;
		}
		
		private function stopMoveTarget():void
		{
			_targetSprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_targetSprite.gotoAndStop(3);
			_targetSprite.mouseEnabled = true;
			_moveAction.stopMoving();
			
			var entryPoint:SpriteEntryPoint = new SpriteEntryPoint(_targetSprite);
			entryPoint.goInEvent.addListener(takeTarget);
			location.addPoint(entryPoint);
			MousePointer.registerObject(_targetSprite, MousePointer.ACTION);
		}
		
		public function get currentDistance():int
		{
			 return GraphUtils.distance(location.user.position, _targetSprite);
		}
		
		private function findTargetExit():void
		{
			var entries:Array = Arrays.getByRequirement(location.entryPoints,
				new TypeRequirement(LocationEntryPoint));
			
			var exits:Array = [];
			for each (var entry:LocationEntryPoint in entries)
			{
				if (Quest.LOCATIONS.indexOf(entry.locId) >= 0)
				{
					var exit:TargetEntry = new TargetEntry();
					exit.locId = entry.locId;
					exit.position = entry.charPosition;
					exit.distance = GraphUtils.distance(location.user.position, entry.charPosition);
					exits.push(exit); 
				}
			}
			
			exits.sortOn('distance', Array.NUMERIC | Array.DESCENDING);
			_exit = exits[0];
		}
		
		private function createTargetPath():void
		{
			_path = location.pathBuilder.getPath(location.user.position, _exit.position);
			
			if (_path.length == 2)
			{
				_path[0].x = 0.5 * (_path[0].x + _path[1].x); 
				_path[0].y = 0.5 * (_path[0].y + _path[1].y);
			}
			else
			{
				_path.splice(0, int(0.5 * _path.length));
			}
		}
		
		private function createTarget():void
		{
			_targetSprite = new McTarget();
			_targetSprite.stop();
			location.charContainer.addChild(_targetSprite);
			GraphUtils.optimizeSprite(_targetSprite);
			GraphUtils.setCoords(_targetSprite, _path[0]);
		}
		
		private function takeTarget(sender:SpriteEntryPoint):void
		{
			Global.charManager.tool = Quest.TARGET_TOOL;
			location.sendUserModel(CharModels.TAKE, -1, Quest.TARGET_TOOL);
			Timers.callAfter(removeTarget, 400, this);
		}
		
		private function getFreeGroundPoint():Point
		{
			var ground:Sprite = location.ground;
			
			while(true)
			{
				var point:Point = GraphUtils.getRandomZonePoint(ground);
				var globalPoint:Point = location.ground.localToGlobal(point);
				var objects:Array = Global.root.getObjectsUnderPoint(globalPoint);
				
				if (objects.length > 0)
				{
					var topObject:DisplayObject = objects[objects.length - 1];
					
					if (ground.contains(topObject))
						break;
				}
			}
			
			return point;
		}
		
		private function removeTarget():void
		{
			GraphUtils.detachFromDisplay(_targetSprite);
		}
		
		protected function get quest():Quest
		{
			 return Quest.instance;
		}
		
	}
}