package com.kavalok.gameAsteroid
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.GameObject;
	import com.kavalok.games.SinglePlayerGame;
	import com.kavalok.security.EncryptedValue;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GameStage extends SinglePlayerGame
	{
		private var _player:Player;
		private var _shells:Array = [];
		private var _destroyedShells:Array = [];
		private var _items:Array = [];
		private var _destroyedItems:Array = [];
		private var _shellCounter:int;
		private var _itemContainer:Sprite = new Sprite();
		private var _points:EncryptedValue = new EncryptedValue();
		private var _itemsCount:int = Config.ITEM_COUNT_START;
		private var _stage:McGameStage;
		
		private var _shootSounds:Array = [SndShot1, SndShot2];
		private var _shellDelay:int = Config.SHELL_MAX_DELAY;
		private var _paused:Boolean = false;
		
		public function GameStage()
		{
			_stage = new McGameStage();
			_stage.mcPlayerZone.visible = false;
			initialize(_stage);
		}
		
		override public function start():void
		{
			GraphUtils.attachAfter(_itemContainer, _stage.player);
			_player = new Player(_stage.player, _stage.mcPlayerZone);
			
			createItems();
			
			events.registerEvent(_stage, Event.ENTER_FRAME, process);
			events.registerEvent(Global.root, MouseEvent.MOUSE_DOWN, onMouseDown);
			
			_stage.addEventListener(Event.ACTIVATE, function(e:Event):void { _paused = false; });
			_stage.addEventListener(Event.DEACTIVATE, function(e:Event):void { _paused = true; })
		}
		
		private function createItems():void
		{
			for (var i:int = 0; i < _itemsCount; i++)
			{
				addItem();
			}
		}

		private function process(e:Event = null):void
		{
			if (_paused)
				return;
			
			if (!_player.destroyed)
				_player.processMov();
			
			if (_shellCounter > 0)
				_shellCounter--;
			
			for each (var shell:Shell in _shells)
			{
				shell.processMov();
				processShell(shell);
				if (shell.destroyed)
					_destroyedShells.push(shell);
			}
			
			for each (var item:Item in _items)
			{
				item.processMov();
				processItem(item);
				if (item.destroyed)
					_destroyedItems.push(item);
			}
			
			removeDestroyed(_destroyedItems, _items);
			removeDestroyed(_destroyedShells, _shells);
			
			if (_items.length == 0)
			{
				_itemsCount++;
				_shellDelay = Math.max(Config.SHELL_MIN_DELAY, _shellDelay - 1);
				createItems();
			}
		}
		
		private function removeDestroyed(destroyed:Array, list:Array):void
		{
			for each (var d:GameObject in destroyed)
			{
				var index:int = list.indexOf(d);
				if (index >= 0)
				{
					var item:GameObject = list[index];
					item.content.parent.removeChild(item.content);
					list.splice(index, 1);
				}
			}
			
			destroyed = [];
		}
		
		private function addItem():void
		{
			var item:Item = new Item(_stage.mcBg, events);
			_itemContainer.addChild(item.content);
			_items.push(item);
		}
		
		private function processItem(item:Item):void
		{
			if (_player.state == Player.STATE_MOVE && !_player.destroyed && item.collideWith(_player))
			{
				Global.playSound(SndMoveRight);
				_player.resolve(item);
				item.deactivate();
				finish();
			}
			else
			{
				for each (var item1:GameObject in _items)
				{
					if (item1 != item && !item.destroyed && item1.collideWith(item))
						item1.resolve(item);
				}
			}
		}
		
		private function finish():void
		{
			_player.deactivate();
			scoreEvent.sendEvent(_points.value);
			
			new AddMoneyCommand(_points.value/2.5, Competitions.ASTEROID, true).execute();
			trace("asteroid points: " + _points.value);
			if (_points.value < 25){
				//Global.addExperience(0);
			} else if (_points.value <= 50){
				Global.addExperience(2);
			} else if (_points.value <= 75){
				Global.addExperience(5);
			} else {
				Global.addExperience (9);
			}
			Global.sendAchievement("ac25;","Asteroid");
		}
		
		private function processShell(shell:Shell):void
		{
			for each (var item:Item in _items)
			{
				if (item.collideWith(shell))
				{
					Global.playSound(SndHit);
					
					shell.destroyed = true;
					item.resolve(shell);
					item.deactivate();
					_points.value++;
					refresh();
				}
			}
		}
		
		override public function refresh():void
		{
			_stage.txtPoints.text = _points.value.toString();
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			
			if (Global.charManager.isModerator && e.ctrlKey){
              _points.value++;
              refresh();
              createShell();
			}
			if (_paused)
				return;
			
			if (_player.state != Player.STATE_MOVE)
				return;
			
			if (!_stage.hitTestPoint(Global.stage.mouseX, Global.stage.mouseY))
				return;
			
			if (_shellCounter == 0)
			{
				createShell();
				_shellCounter = _shellDelay;
			}
		}
		
		private function createShell():void
		{
			Global.playSound(GraphUtils.randomItem(_shootSounds) as Class);
			
			var shell:Shell = new Shell(_player, _stage.mcBg);
			_itemContainer.addChild(shell.content);
			_shells.push(shell);
		}
	}
	
}