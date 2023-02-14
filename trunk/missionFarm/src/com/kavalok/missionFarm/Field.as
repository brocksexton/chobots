package com.kavalok.missionFarm
{
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.Directions;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Field extends FarmObject
	{
		public static const FADE_SPEED:Number = 10; // frames
		public static const ACTION_DURATION:int = 2; // seconds;
		
		public static const STATE_INITIAL	:String = 'initial';
		public static const STATE_PLOUGH	:String = 'plough';
		public static const STATE_SEED		:String = 'seed';
		public static const STATE_SPROUT	:String = 'sprout';
		public static const STATE_GROW		:String = 'grow';
		
		private var _completeEvent:EventSender = new EventSender();
		
		private var _content:McField;
		private var _time:Number;
		private var _stateList:Object = {};
		private var _fieldState:FieldState;
		
		private var _model:McFieldModel;
		private var _oldModel:MovieClip;
		
		private var _counter:int;
		
		public function Field(id:String, content:McField, farm:FarmStage)
		{
			super(id, farm);
			
			_content = content;
			
			_btn = _content.btn;
			
			_position = GraphUtils.transformCoords(new Point(), _content, _content.parent.parent);
			
			_model = GraphUtils.findInstance(_content, McFieldModel) as McFieldModel;
			_model.cacheAsBitmap = true;
			_model.mouseChildren = false;
			
			createStates();
			
			_state = { model : STATE_INITIAL };
			
			updateModel(false);
			
			attachToRemoteObject();
		}
		
		override public function restoreState(states:Object):void
		{
			super.restoreState(states);
			
			updateModel(false);
		}
		
		private function createStates():void
		{
			_stateList[STATE_INITIAL] =
				new FieldState(1, Models.LOPATA,	Tools.LOPATA,	STATE_PLOUGH,	STATE_INITIAL);
			
			_stateList[STATE_PLOUGH] =
				new FieldState(2, Models.GANJ, 		Tools.GANJ,		STATE_SPROUT,	STATE_INITIAL);
			
			/*_stateList[STATE_SEED] =
				new FieldState(3, null, 			null,			null,			STATE_SPROUT);*/
			
			_stateList[STATE_SPROUT] =
				new FieldState(4, Models.WATER,		Tools.WATER,	STATE_GROW,		STATE_PLOUGH);
			
			_stateList[STATE_GROW] =
				new FieldState(5, Models.KOSA,		Tools.KOSA,		STATE_INITIAL,	STATE_PLOUGH);
		}
		
		override protected function onLock():void
		{
			if (_enabled)
			{
				_farm.sendUserPos(_farm.user.position);
				_farm.sendUserModel(_fieldState.playerModel);
				_counter = ACTION_DURATION * Global.stage.frameRate;
				
				_em.registerEvent(_content, Event.ENTER_FRAME, onModelFrame);
			}
			else
			{
				goOut();
			}
		}
		
		override protected function onUnlock():void
		{
			_em.removeEvent(_content, Event.ENTER_FRAME, onModelFrame);
		}
		
		private function onModelFrame(e:Event):void
		{
			if (--_counter == 0)
			{
				sendState('rFieldModel', id, { model : _fieldState.onAction } );
				_farm.sendUserModel(CharModels.STAY, Directions.LEFT_DOWN);
				_farm.sendBonus(FarmStage.FIELD_VALUE);
				
				if (_fieldState.onAction == Field.STATE_INITIAL)
				{
					_completeEvent.sendEvent();
				}
				
				goOut();
			}
		}
		
		public function rFieldModel(stateId:String, state:Object):void
		{
			_state.model = state.model;
			updateModel();
		}
		
		public function updateModel(fade:Boolean = true):void
		{
			if (_stateList[_state.model] == _fieldState)
				return;
			
			_fieldState = _stateList[_state.model];
			
			changeModel(fade);
			
			refresh();
		}
		
		override protected function onMouseDown(e:MouseEvent):void
		{
			_activateEvent.sendEvent(this);
		}
		
		override public function refresh():void
		{
			_enabled = _fieldState.tool == _farm.currentTool;
			
			var pointer:Class = (_enabled)
				? MousePointer.ACTION
				: MousePointer.WALK;
			
			MousePointer.registerObject(_content, pointer);
		}
		
		private function changeModel(fade:Boolean):void
		{
			if (fade)
			{
				new SpriteTweaner(_model, { alpha : 0 }, 10, _em, onHideModel);
				_model = new McFieldModel();
				_model.cacheAsBitmap = true;
				_model.mouseChildren = false;
				_model.mouseEnabled = false;
				_model.alpha = 0;
				new SpriteTweaner(_model, { alpha : 1 }, 10, _em);
			}
			else
			{
				_content.removeChild(_model);
				_model = new McFieldModel();
			}
			
			_model.cacheAsBitmap = true;
			_model.gotoAndStop(_fieldState.modelFrame);
			_content.addChildAt(_model, 0);
		}
		
		private function onHideModel(oldModel:DisplayObject):void
		{
			_content.removeChild(oldModel);
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
	}
	
}

internal class FieldState
{
	public var onAction:String;
	public var onTimeout:String;
	public var tool:String;
	public var modelFrame:int;
	public var playerModel:String;
	
	public function FieldState(modelFrame:int, playerModel:String, tool:String, onAction:String, onTimeout:String):void
	{
		this.modelFrame = modelFrame;
		this.playerModel = playerModel;
		this.tool = tool;
		this.onAction = onAction;
		this.onTimeout = onTimeout;
	}
}
