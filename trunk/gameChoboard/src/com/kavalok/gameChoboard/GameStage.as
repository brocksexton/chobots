package com.kavalok.gameChoboard
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.SinglePlayerGame;
	import com.kavalok.security.EncryptedValue;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GameStage extends SinglePlayerGame
	{
		private var _stage:McGameContent = new McGameContent();
		private var _bounds:Rectangle = _stage.back.getRect(_stage);
		
		private var _bg0:Background;
		private var _bg1:Background;
		private var _bg2:Background;
		private var _itemContainer:Sprite = new Sprite();
		
		private var _player:Player;
		private var _items:Array = [];
		private var _itemCounter:int = 0;
		private var _points:EncryptedValue = new EncryptedValue();
		private var _paused:Boolean;
		
		public function GameStage()
		{
			initialize(_stage);
			_stage.health.stop();
			_stage.tube.stop();
			
			var bounds:Rectangle = _stage.back.getRect(_stage);
			_bg0 = new Background(_stage.back0, 1, bounds);
			_bg1 = new Background(_stage.back1, 4, bounds);
			_bg2 = new Background(_stage.back2, 20, bounds);
			
			_player = new Player(_stage.tube.player);
			_player.ready = false;
			
			GraphUtils.attachAfter(_itemContainer, _stage.back1);
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onModCheat);
			
			events.registerEvent(_stage, Event.ENTER_FRAME, processGame);
			events.registerEvent(_stage.tube, 'playerReady', onPlayerReady);
			events.registerEvent(_stage.tube, Event.COMPLETE, onTubeComplete);
		
			_stage.addEventListener(Event.ACTIVATE, function(e:Event):void { _paused = false; });
			_stage.addEventListener(Event.DEACTIVATE, function(e:Event):void { _paused = true; });
		}
		
		override public function start():void
		{
			_stage.tube.play();
		}
		
		private function onModCheat(e:MouseEvent):void
		{
			if (Global.charManager.isModerator && e.ctrlKey){
				_points.value++;
				_player.addLevel();
				refresh();
			}
		}
		private function onPlayerReady(e:Event):void
		{
			var tube:McTube = _stage.tube;
			var point:Point = GraphUtils.objToPoint(_player.content);
			point = GraphUtils.transformCoords(point, tube, _itemContainer);
			GraphUtils.setCoords(_player.content, point);
			_itemContainer.addChild(_player.content)
			_player.ready = true;
		}
		
		private function onTubeComplete(e:Event):void
		{
			_stage.tube.stop();
			_stage.removeChild(_stage.tube);
		}
		
		private function processGame(e:Event):void
		{
			if (_paused)
				return;
			
			_bg0.move();
			_bg1.move();
			_bg2.move();
			
			if (_player.ready)
			{
				moveItems();
				_player.control();
				_player.processMov();
			}
			
			makePerspective();
		}
		
		private function makePerspective():void
		{
			var k:Number = _player.content.y / _bounds.height;
			
			//_player.scale = 0.5 + 0.5 * k;
			_bg1.content.y = _bg1.y0 + (1-k) * 50;
			_bg2.content.y = _bg2.y0 + (1-k) * 80;
			
		}
		
		private function moveItems():void
		{
			if (++_itemCounter == Config.ITEM_DELAY)
			{
				createItem();
				_itemCounter = 0;
			}
			
			var i:int = 0;
			
			while (i < _items.length)
			{
				var item:Item = _items[i];
				
				item.processMov();
				
				checkCollisions(item);
				
				if (!item.content.hitTestObject(_stage.back))
				{
					GraphUtils.detachFromDisplay(item.content);
					_items.splice(i, 1);
				}
				else
				{
					i++;
				}
			}
			
		}
		
		private function checkCollisions(item:Item):void
		{
			if (item.active && item.collideWith(_player))
			{
				if (item.content is com.kavalok.gameChoboard.McBonus)
				{
					Global.playSound(SndTake);
					item.hide();
					makeBonus();
				}
				else
				{
					Global.playSound(SndCollideMetal);
					item.resolve(_player);
					makeDamage();
				}
			}
			
			for each (var item2:Item in _items)
			{
				if (item2 != item && item.collideWith(item2))
				{
					Global.playSound(SndCollideHeavy);
					item.resolve(item2);
				}
			}
		}
		
		private function createItem():void
		{
			var item:Item = new Item();
			var itemRect:Rectangle = item.content.getBounds(item.content);
			item.content.x = _bounds.right - itemRect.left - 1;
			item.content.y = Math.random() * _bounds.height;
			
			_items.push(item);
			_itemContainer.addChild(item.content);
		}
		
		private function makeDamage():void
		{
			var health:MovieClip = _stage.health;
			health.nextFrame();
			_player.blink();
			
			if (health.currentFrame == health.totalFrames)
			{
				Global.playSound(SndFlyOut);
				finish();
			}
		}
		
		private function makeBonus():void
		{
			_points.value++;
			_player.addLevel();
			refresh();
		}
		
		override public function refresh():void
		{
			_stage.pointsField.text = _points.value.toString();
		}
		
		private function finish():void
		{
			new AddMoneyCommand(_points.value * 3, Competitions.CHOBOARD, true).execute();
			trace("choboard points: " + _points.value);
			
			if (_points.value <= 9){
				
			} else if (_points.value <= 19){
				Global.addExperience(2);
			} else if (_points.value <= 29){
				Global.addExperience(4);
			} else if (_points.value <= 39){
				Global.addExperience(7);
			} else if (_points.value <= 49){
				Global.addExperience(12);
			} else {
				Global.addExperience(15);
			}
			
			scoreEvent.sendEvent(_points.value);
			events.clearEvents();
			Global.sendAchievement("ac24;","Choboard");
		}
	}
	
}