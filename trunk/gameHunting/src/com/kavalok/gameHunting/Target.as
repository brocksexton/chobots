package com.kavalok.gameHunting
{
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.char.CharModels;
	import com.kavalok.gameHunting.data.PlayerData;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import gameHunting.McTarget;
	import gameHunting.McTargetItem;
	
	public class Target
	{
		static private const TOP_FRAME:int = 6;
		
		private var _content:McTarget;
		private var _item:McTargetItem;
		private var _model:CharModel;
		
		private var _delay:int;
		private var _pause:int;
		private var _counter:int;
		private var _frameNum:int;
		private var _bounds:Rectangle;
		private var _processFunction:Function;
		private var _x:int;
		private var _moveMode:Boolean = false;
		private var _idleTimer:Timer = new Timer(1000, 1);
		private var _isIdle:Boolean = false;;
		
		public function Target(content:McTarget)
		{
			_content = content;
			_item = _content.itemClip;
			_item.hitAreaClip.visible = false;
			_bounds = _content.targetBounds.getBounds(_content);
			_x = _item.x;
			_idleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onIdleTimerComplete);
			GraphUtils.detachFromDisplay(_content.targetBounds);
			GraphUtils.sendToBack(_item);
		}
		
		private function onIdleTimerComplete(e:Event):void
		{
			_isIdle = false;
		}
		
		public function set player(value:Player):void
		{
			_model = new CharModel(new Char(value.data));
			_model.refresh();
			_model.scale = Config.MODEL_SCALE;
			_item.addChild(_model);
		}
		
		public function get hitArea():Sprite
		{
			return _item.hitAreaClip;
		}
		
		public function hit():void
		{
			GraphUtils.stopAllChildren(_model);
			_isIdle = true;
			_idleTimer.reset();
			_idleTimer.start();
		}
		
		public function processFrame():void
		{
			var dx:int = (_x - _item.x) / Config.MOVE_SENS;
			
			if (_isIdle)
				dx *=0.5;
				
			_item.x += dx;
			
			dx = Math.abs(dx);
			
			if (dx > 5)
			{
				moveMode = true;
				_item.filters = [new BlurFilter(dx, 0)];
			}
			else
			{
				moveMode = false;
			}
		}
		
		private function set moveMode(value:Boolean):void
		{
			if (_moveMode != value)
			{
				_moveMode = value;
				if (_moveMode)
				{
					GraphUtils.stopAllChildren(_model);
					_model.cacheAsBitmap = true;
				}
				else
				{
					if (!_isIdle)
						_model.setModel(Arrays.randomItem(CharModels.DANCE_MODELS));
					_model.cacheAsBitmap = false;
					_item.filters = [];
				}
			}
		}
		
		public function set position(value:Number):void
		{
			_x = _bounds.left + value * _bounds.width;
		}
		
		public function get model():CharModel { return _model; }
		
	}
	
}