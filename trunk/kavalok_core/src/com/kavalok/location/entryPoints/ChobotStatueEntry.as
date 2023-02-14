package com.kavalok.location.entryPoints
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.CharStates;
	import com.kavalok.char.Directions;
	import com.kavalok.char.Stuffs;
	import com.kavalok.constants.ClientIds;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.location.LocationBase;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	
	public class ChobotStatueEntry extends ClientBase
	{
		static public const CLIP_NAME:String = 'mcChobotStatue';
		
		static private const DEFAULT_COLOR:int = 0xFFDDBB;
		static private const MODEL_SCALE:Number = 1.5;
		static private const STATE_ID:String = 'data';
		
		private var _content:Sprite;
		private var _location:LocationBase;
		
		private var _entriePoint:SpectEntryPoint;
		private var _model:CharModel;
		
		public function ChobotStatueEntry(content:Sprite, location:LocationBase)
		{
			_content = content;
			_location = location;
			
			createEntryPoint();
			createModel();
			connect(_location.remoteId);
		}
		
		override public function get id():String
		{
			return ClientIds.CHOBOT_STATUE;
		}
		
		private function createEntryPoint():void
		{
			var button:InteractiveObject = _content['changeButton'];
			var position:Sprite = _content['charPosition'];
			_entriePoint = new SpectEntryPoint(button, position, _location.content);
			_entriePoint.goInEvent.addListener(onGoIn);
			_location.addPoint(_entriePoint);
		}
		
		private function createModel():void
		{
			var char:Char = getChar();
			_model = new CharModel(char);
			_model.setModel(CharModels.STAY, Directions.DOWN);
			_model.scale = MODEL_SCALE;
			_model.filters = [new DropShadowFilter(0)];
			var position:Sprite = _content['modelPosition'];
			position.visible = false;
			GraphUtils.setCoords(_model, position);
			_content.addChild(_model);
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			refresh();
		}
		
		private function refresh():void
		{
			_model.char = getChar();
			if (_model.char.id)
				ToolTips.registerObject(_model, _model.char.id);
		}
		
		private function onGoIn(entry:SpriteEntryPoint):void
		{
			var state:Object = {};
			state[CharStates.CHAR_ID] = Global.charManager.charId;
			state[CharStates.BODY] = Global.charManager.body;
			state[CharStates.CLOTHES] = Global.charManager.stuffs.getUsedClothesOptimized();
			state[CharStates.COLOR] = Global.charManager.color;
			
			sendState('rRefresh', STATE_ID, state);
		}
		
		public function rRefresh(stateId:String, state:Object):void
		{
			refresh();
		}
		
		private function getChar():Char
		{
			var char:Char = new Char();
			if (states && (STATE_ID in states))
			{
				var state:Object = states[STATE_ID];
				char.id = state[CharStates.CHAR_ID];
				char.body = state[CharStates.BODY];
				char.clothes = Stuffs.getClothesFromOptimized(state[CharStates.CLOTHES]);
				char.color = state[CharStates.COLOR];
			}
			else
			{
				char.color = DEFAULT_COLOR;
				char.id = null;
			}
			return char;
		}
		
	}
}