package com.kavalok.gameRobots
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.SinglePlayerGame;
	import com.kavalok.security.EncryptedValue;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GameStage extends SinglePlayerGame
	{
		static private const READY:String = 'ready';
		static private const MOVE:String = 'move';
		static private const SHOW:String = 'show';
		
		public var path:/*Point*/Array;
		public var items:/*Item*/Array = [];
		public var itemDistance:int;
		
		private var _stage:McGameContent = new McGameContent();
		
		private var _levelNum:EncryptedValue = new EncryptedValue();
		private var _pathStep:int;
		private var _itemVarious:int = 3;
		private var _itemSpeed:Number;

		private var _newItemCounter:int;
		
		private var _gameActive:Boolean = false;
		
		private var _itemNum:int;
		private var _maxItems:int;
		private var _itemsContainer:Sprite = new Sprite();
		private var _fireContainer:Sprite = new Sprite();
		private var _fireSpeed:Number = Config.FIRE_SPEED_MIN;
		
		private var _showLevel:Boolean = false;
		private var _hideLevel:Boolean = false;
		private var _showFrames:int = 0;
		private var _garbage:Garbage;
		private var _paused:Boolean = false;
		
		public function GameStage()
		{
			initialize(_stage);
			
			GraphUtils.attachBefore(_itemsContainer, _stage.mouseArea);
			GraphUtils.attachBefore(_fireContainer, _stage.mouseArea);
			
			_itemsContainer.mask = _stage.itemsMask;
			
			_stage.mcFireZone.visible = false;
			_stage.mouseArea.alpha = 0;
			
			_garbage = new Garbage(_stage.garbage, events);
			
			_itemSpeed = Config.LEVEL_SPEED_START;
			_maxItems = Config.LEVEL_ITEMS_START;
			
			createLevel();
			
			_stage.addEventListener(Event.ACTIVATE, function(e:Event):void { _paused = false; });
			_stage.addEventListener(Event.DEACTIVATE, function(e:Event):void { _paused = true; })
		}
		
		override public function start():void
		{
			addFire();
			
			events.registerEvent(_stage, Event.ENTER_FRAME, processGame);
			events.registerEvent(Global.root, MouseEvent.MOUSE_MOVE, onMouseMove);
			events.registerEvent(_stage.mouseArea, MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (_gameActive || _paused)
				return;
				
			Global.playSound(SndFire);
			
			var fire:MovieClip = getLastFire();
			
			if (fire != null && fire.state == READY)
			{
				fire.state = MOVE;
				fire.filters = [new BlurFilter(0, 20)];
				addFire();
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (_gameActive || _paused)
				return;
				
			var fire:MovieClip = getLastFire();
			
			if (fire != null && fire.state == READY || fire.state == SHOW)
			{
				fire.x = getMouseX();
				e.updateAfterEvent();
			}
		}
		
		private function addFire():MovieClip
		{
			var fireItem:McItem = new McItem();
			fireItem.cacheAsBitmap = true;
			
			_fireContainer.addChild(fireItem);
			
			var frameNum:int;
			if (items.length > 0)
			{
				var randomItem:Item  = items[int(Math.random() * items.length)];
				frameNum = randomItem.currentFrame;
			}
			else
			{
				frameNum = int(Math.random() * _itemVarious) + 1;
			}
			
			fireItem.gotoAndStop(frameNum);
			fireItem.x = getMouseX();
			
			fireItem.y = _stage.mcFireZone.y + _stage.mcFireZone.height;
			fireItem.state = SHOW;
			
			return fireItem;
		}
		
		private function getMouseX():Number
		{
			var rect:Rectangle = _stage.mcFireZone.getBounds(_stage);
			return GraphUtils.claimRange(_stage.mouseX, rect.left, rect.right);
		}
		
		private function createLevel():void
		{
			_levelNum.value++;
			_itemNum = 0;
			_newItemCounter = 0;
			
			_fireSpeed = GraphUtils.claimRange(
				_fireSpeed + Config.FIRE_SPEED_INC,
				Config.FIRE_SPEED_MIN,
				Config.FIRE_SPEED_MAX);
			
			if (_maxItems >= Config.LEVEL_ITEMS_MAX)
			{
				if (_itemVarious < Config.ITEM_VARIOUS)
				{
					_itemVarious++;
					_itemSpeed = Config.LEVEL_SPEED_START;
					_maxItems = Config.LEVEL_ITEMS_START;
				}
				else
				{
					_maxItems = Config.LEVEL_ITEMS_MAX;
				}
			}
			
			createPath();
			
			_stage.levelField.text = _levelNum.value.toString();
		}
		
		private function addItem(index:int = 0, position:int = 0, frameNum:Number = -1):Item
		{
			var mc:MovieClip = new McItem();
			mc.cacheAsBitmap = true;
			
			if (frameNum == -1)
				frameNum = int(Math.random() * _itemVarious) + 1;
			
			mc.gotoAndStop(frameNum);
			
			_itemsContainer.addChild(mc);
			
			var item:Item = new Item();
			
			item.stage = this;
			item.position = position;
			item.movie = mc;
			items.splice(index, 0, item);
			item.refresh();
			
			return item;
		}
		
		private function processGame(e:Event):void
		{
			if (_gameActive || _paused)
				return;
				
			processItemCreation();
			processFireContainer();
			processItems();
			
			if (items.length > 0)
				checkGarbage();
		}
		
		private function processItems():void
		{
			if (items.length > 0)
			{
				items[0].move(1);
				updateFire();
			}
			
			for each (var item:Item in items)
			{
				item.refresh();
			}
		}
		
		private function processFireContainer():void
		{
			for (var i:int = 0; i < _fireContainer.numChildren; i++)
			{
				processFire(MovieClip(_fireContainer.getChildAt(i)));
			}
		}
		
		private function processItemCreation():void
		{
			if (_itemNum < _maxItems)
			{
				if (--_newItemCounter <= 0)
				{
					_itemNum++;
					addItem();
					_newItemCounter = itemDistance;
				}
			}
		}
		
		private function checkGarbage():Boolean
		{
			var headItem:Item = items[items.length - 1];
			
			_garbage.opened = (headItem.position > 0.8 * path.length)
			
			var isFinish:Boolean = headItem.position == path.length - 1;
				
			if (isFinish)
			{
				_gameActive = true;
				_garbage.opened = false;
				new SpriteTweaner(headItem.movie,  { alpha: 0 }, 7, events, finish);
			}
				
			return isFinish;
		}
		
		private function updateFire():void
		{
			var fire:MovieClip = getLastFire();
			
			var flag:Boolean = false;
			
			if (fire != null && fire.state != MOVE)
			{
				if (!isFrameExists(fire) && items.length > 0)
				{
					fire.gotoAndStop(items[0].currentFrame);
				}
			}
		}
		
		private function isFrameExists(fire:MovieClip):Boolean
		{
			for each (var item:Item in items)
			{
				if (item.currentFrame == fire.currentFrame)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function getLastFire():MovieClip
		{
			return (_fireContainer.numChildren > 0)
				? MovieClip(_fireContainer.getChildAt(_fireContainer.numChildren - 1))
				: null;
		}
		
		public function checkItem(item:Item):void
		{
			var a:/*Item*/Array = [item];
			
			var itemIndex:int = item.index;
			if (itemIndex < 0)
				return;
			
			var i:int;
			var distance:int;
			
			for (i = item.index - 1; i >= 0; i--)
			{
				distance = Math.abs(items[i + 1].position - items[i].position);
				
				if (items[i].currentFrame == item.currentFrame &&  distance <= itemDistance)
					a.push(items[i]);
				else
					break;
			}
			
			for (i = item.index + 1; i < items.length; i++)
			{
				distance = Math.abs(items[i - 1].position - items[i].position);
				
				if (items[i].currentFrame == item.currentFrame && distance <= itemDistance)
					a.push(items[i]);
				else
					break;
			}
			
			if (a.length >= 3)
			{
				Global.playSound(SndBonus);
				
				for each (var it:Item in a)
				{
					items.splice(items.indexOf(it), 1);
					it.movie.alpha = 0.3;
					it.destroy();
				}
			}
		}
		
		private function processFire(fireItem:MovieClip):void
		{
			if (fireItem.state == SHOW)
			{
				fireItem.y -= Config.FIRE_SHOW_SPEED;
				
				if (fireItem.y <= _stage.mcFireZone.y)
				{
					fireItem.y = _stage.mcFireZone.y;
					fireItem.state = READY;
				}
			}
			else if (fireItem.state == MOVE)
			{
				fireItem.y -= _fireSpeed;
				
				var p:Point = new Point(fireItem.x, fireItem.y);
				var r:Number = _pathStep * itemDistance;
				var r2:Number = r * r;
				
				for each (var item:Item in items)
				{
					var d2:Number = GraphUtils.distance2(item.coord, p);
					
					if (d2 < r2)
					{
						var newItem:Item = insertAtItem(item, fireItem);
						_fireContainer.removeChild(fireItem);
						checkItem(newItem);
						break;
					}
				}
				
				if (fireItem.y < -fireItem.height)
					fireItem.parent.removeChild(fireItem);
			}
		}
		
		private function insertAtItem(atItem:Item, fire:MovieClip):Item
		{
			Global.playSound(SndPop);
			
			var next:Item = atItem.getNextItem();
			var prev:Item = atItem.getPrevItem();
			var position:int;
			
			var index:int;
			
			if (next == null)
			{
				index = atItem.index + 1;
				position = atItem.position + int(0.5 * itemDistance);
			}
			else if (prev == null)
			{
				index = atItem.index;
				position = atItem.position + int(0.5 * itemDistance);
			}
			else
			{
				var d1:Number = GraphUtils.distance2(new Point(fire.x, fire.y), prev.coord);
				var d2:Number = GraphUtils.distance2(new Point(fire.x, fire.y), next.coord);
				
				if (d1 < d2)
				{
					index = atItem.index;
					position = atItem.position - int(0.5 * itemDistance);
				}
				else
				{
					index = atItem.index + 1;
					position = atItem.position + int(0.5 * itemDistance);
				}
			}
			
			position = GraphUtils.claimRange(position, 0, path.length - 1);
			
			return addItem(index, position, fire.currentFrame);
		}
		
		private function createPath():void
		{
			path = [];
			_pathStep = _itemSpeed;
			itemDistance = Config.ITEM_DISTANCE / _itemSpeed;
			
			var point0:Sprite = _stage.mcPath['t0'];
			path.push(new Point(point0.x, point0.y));
			point0.visible = false;
			
			var num:int = 1;
			
			while (_stage.mcPath['t' + num] != null)
			{
				var mcPoint:Sprite = _stage.mcPath['t' + num];
				var prev:Point = path[path.length - 1];
				var next:Point = GraphUtils.objToPoint(mcPoint);
				
				mcPoint.visible = false;
				
				var d:Number = GraphUtils.distance(prev, next);
				var numPoints:int = d / _itemSpeed;
				var dx:Number = (next.x - prev.x) / numPoints;
				var dy:Number = (next.y - prev.y) / numPoints;
				
				for (var i:int = 1; i < numPoints; i++)
				{
					path.push(new Point(prev.x + i*dx, prev.y + i*dy));
				}
				num++;
			}
		}
		
		public function checkForFinish():void
		{
			if (items.length == 0 && _itemNum == _maxItems)
			{
				_maxItems += Config.LEVEL_ITEMS_INC;
				_itemSpeed += Config.LEVEL_SPEED_INC;
				createLevel();
				
				new AddMoneyCommand(14, Competitions.ROBOTS, true).execute();
			    trace("robo level" + _levelNum.value);
			
			 if (_levelNum.value <= 3){
				
			} else if (_levelNum.value <= 5){
				Global.addExperience(1);
			} else if (_levelNum.value <= 9){
				Global.addExperience(2);
			} else if (_levelNum.value <= 14){
				Global.addExperience(2);
			} else if (_levelNum.value <= 19){
				Global.addExperience(3);
			} else if (_levelNum.value <= 24){
				Global.addExperience(3);
			} else {
				Global.addExperience(3);
				
			}
			}
		}
		
		private function finish(e:Object = null):void
		{
			Global.sendAchievement("ac22;","RoboFactory");
			_fireContainer.visible = false;
			scoreEvent.sendEvent(_levelNum.value);
			GraphUtils.stopAllChildren(_stage.mcAnimation);
		}
	}
	
}