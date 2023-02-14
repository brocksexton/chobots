package com.kavalok.gameCrab
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.SinglePlayerGame;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TaskCounter;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GameStage extends SinglePlayerGame
	{
		static private const SOUND_SAFE_DELAY:int = 20; //frames
		static private const SOUND_BALL_DELAY:int = 20; //frames
		
		private var _player:Player;
		private var _bot:Bot;
		private var _ball:Ball;
		private var _resetHandler:TaskCounter = new TaskCounter();
		private var _stage:McGameContent;
		private var _paused:Boolean = false;
		
		private var _soundCounter:int = 0;
		private var _soundBallCounter:int = 0;
		
		public function GameStage()
		{
			_stage = new McGameContent();
			_stage.field.visible = false;
			_stage.playerGate.visible = false;
			_stage.botGate.visible = false;
			_stage.tabEnabled = false;
			_stage.tabChildren = false;
			_stage.focus.visible = false;
			_stage.focusRect = false;
			_stage.goal.visible = false;
			_stage.goal.stop();
			
			events.registerEvent(_stage.goal, Event.COMPLETE, prepareRound);
			_stage.addEventListener(Event.ACTIVATE, function(e:Event):void { _paused = false; });
			_stage.addEventListener(Event.DEACTIVATE, function(e:Event):void { _paused = true; })
			
			initialize(_stage);
			
			_player = createObject(Player, _stage.player) as Player;
			_bot = createObject(Bot, _stage.bot) as Bot;
			_ball = createObject(Ball, _stage.ball) as Ball;
			
			_resetHandler.completeEvent.addListener(startRound);
		}
		
		override public function start():void
		{
			Global.stage.focus = _stage.focus;
			prepareRound();
		}
		
		public function createObject(objectClass:Class, content:MovieClip):ObjectBase
		{
			var o:ObjectBase = new objectClass();
			o.content = content;
			o.field = _stage.field;
			o.events = events;
			o.readyEvent.addListener(_resetHandler.completeTask);
			o.initialzie();
			
			return o;
		}
		
		private function prepareRound(event:Object = null):void
		{
			_stage.goal.visible = false;
			_resetHandler.numTasks = 3;
			_player.reset();
			_bot.reset();
			_ball.reset();
		}
		
		private function startRound():void
		{
			events.registerEvent(_stage, Event.ENTER_FRAME, processGame);
		}
		
		private function processGame(e:Event):void
		{
			if (_paused)
				return;
			
			if (_soundCounter > 0)
				_soundCounter--;
			
			if (_soundBallCounter > 0)
				_soundBallCounter--;
			
			processBot();
			
			_player.control();
			_player.move();
			_bot.move();
			_ball.move();
			
			checkPlayersCollisions();
			checkGoal();
			
			if (_player.atBorder)
				playSoundSafe(SndHit1);
			if (_bot.atBorder)
				playSoundSafe(SndHit1);
			if (_ball.atBorder)
				Global.playSound(SndBall1);
			
		}
		
		public function playSoundSafe(soundClass:Class):void
		{
			if (_soundCounter == 0)
			{
				Global.playSound(soundClass);
				_soundCounter = SOUND_SAFE_DELAY;
			}
		}
		
		public function playBallSound(soundClass:Class):void
		{
			if (_soundBallCounter == 0)
			{
				Global.playSound(soundClass);
				_soundBallCounter = SOUND_BALL_DELAY;
			}
		}
		
		private function checkPlayersCollisions():void
		{
			if (_player.collide(_bot))
			{
				playSoundSafe(SndHit2);
				_bot.speed *= -1.1;
				_bot.move();
				_player.speed *= -1.1;
				_player.move();
			}
			
			if (_player.collide(_ball))
			{
				playBallSound(SndBall1);
				_ball.content.play();
				_ball.speed = _player.speed + Config.BALL_ELASTITY;
				_ball.content.rotation = _player.content.rotation;
			}
			
		}
		
		private function checkGoal():void
		{
			var isGoal:Boolean = false;
			
			if (_ball.content.hitTestObject(_stage.playerGate))
			{
				Global.playSound(SndFinish);
				isGoal = true;
				_ball.content.x = _stage.playerLine.x;
				_bot.points++;
			}
			else if (_ball.content.hitTestObject(_stage.botGate))
			{
				Global.playSound(SndFinish);
				isGoal = true;
				_ball.content.x = _stage.botLine.x;
				_player.points++;
			}
			else
			{
			}
			
			if (isGoal)
			{
				refresh();
				finishRound();
			}
		}
		
		override public function refresh():void
		{
			_stage.pointsField.text = '' + _player.points + ':' + _bot.points;
			trace(_stage.pointsField.text);
		}
		
		private function processBot():void
		{
			if (_bot.speed < _bot.maxV)
				_bot.speed += _bot.accV;
				
			var bot:Sprite = _bot.content;
			var ball:Sprite = _ball.content;
			
			var direction:Number;
			
			if (_bot.collide(_ball))
				direction = Math.atan2(_stage.playerLine.y - bot.y, _stage.playerLine.x - bot.x);
			else
				direction = Math.atan2(ball.y - bot.y, ball.x - bot.x);
			
			var r:Number = bot.rotation / 180 * Math.PI;
			var dr:Number = GraphUtils.angleDiff(r, direction);
			
			if (Math.abs(dr / Math.PI * 180) > _bot.accR)
			{
				_bot.content.rotation += (dr > 0)
					? _bot.accR
					: -_bot.accR;
			}
			else
			{
				_bot.content.rotation = direction / Math.PI * 180;
			}
			
			if (_bot.collide(_ball))
			{
				playBallSound(SndBall2);
				
				_ball.content.play();
				_ball.speed = _bot.speed + Config.BALL_ELASTITY;
				_ball.content.rotation = _bot.content.rotation;
				
				if (Math.abs(ball.rotation) < 90 || _bot.atBorder)
				{
					ball.rotation += 180;
					_ball.speed *= 0.5;
				}
			}
			
		}

		private function finishRound():void
		{
			events.removeEvent(_stage, Event.ENTER_FRAME, processGame);
			if (_player.points == Config.MAX_POINTS || _bot.points == Config.MAX_POINTS)
				finish();
			
			_bot.maxV += 1;
			_player.maxV + 0.5;
			_stage.goal.visible = true;
			_stage.goal.play();
		}
		
		private function finish():void
		{
			var money:int = _player.points * 10;
			if (_player.points > _bot.points)
				money += 10;
				
			new AddMoneyCommand(money, Competitions.CRAB, true).execute();
		    if (_player.points > _bot.points){
		       Global.addExperience(5);
			}
			Global.sendAchievement("ac23;","Mechanical Crab");
			events.clearEvents();
		}
	}
	
}