package com.kavalok.location.entryPoints
{
	import com.kavalok.Global;
	import com.kavalok.char.Directions;
	import com.kavalok.char.LocationChar;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.ModelsFactory;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Timers;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.SmoothCurveRope;

	public class RopeEntryPointBase extends EntryPointBase
	{
		protected static var BONUS : int = 2;
		protected static var GIVE_BONUS_IF_ONE_TEAM : Boolean = false;
		protected static var CHAR_WIDTH : int = 20;
		protected static var ROPE_PLACE_OFFSET_X : int = 33;
		protected static var ROPE_PLACE_OFFSET_Y : int = 0;
		protected static var START_LEFT_POSITION_X : int = 465;
		protected static var START_LEFT_POSITION_Y : int = 307;
		protected static var START_RIGHT_POSITION_X : int = 675;
		protected static var START_RIGHT_POSITION_Y : int = 307;
		protected static var CENTER_POSITION_X : int = (START_LEFT_POSITION_X + START_RIGHT_POSITION_X) / 2;
		protected static var CENTER_POSITION_Y : int = 307;
		protected static var START_ROPE_POSITION_X : int = 441;
		protected static var START_ROPE_POSITION_Y : int = 307;
		protected static var END_LEFT_POSITION_X : int = 390;
		protected static var END_RIGHT_POSITION_X : int = 725;
		protected static var END_LEFT_POSITION_Y : int = 307;
		protected static var END_RIGHT_POSITION_Y : int = 307;
		protected static var RIGH_TEAM : String = "Right";
		protected static var LEFT_TEAM : String = "Left";
		protected static var ARROW_PREFIX : String = "arrow";
		protected static var MAX_CLICK_COUNT : Number = 6;
		protected static var ROPE_STEP : Number = 4;
		protected static var ROPE_COLOR : Number = 0xFF9900;
		protected static var MAX_CHARS : uint = 3;
		protected static var UPDATE_RIGHT_CURVE : Boolean = true;
		protected static var UPDATE_LEFT_CURVE : Boolean = true;
		
		private var _clickCount : uint = 0;
		private var _ropePlace : String;
		private var _isOut : Boolean;
		private var _curves : Array = [];
		private var _ropePositionX : Number = 0;
		private var _ropePositionY : Number = 0;
		private var _ropeStarts : Object = {Left : MAX_CHARS, Right : MAX_CHARS, minLeft : -1, minRight : -1};
		
		private var _ropeSuccessEvent : EventSender = new EventSender();

		private var _winer : String;

		public function RopeEntryPointBase(remoteId : String, location : LocationBase)
		{
			initCurves();
			super(location, "rope_", remoteId);
			_location.content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		protected function initCurves() : void 
		{
			_curves.push(new SmoothCurveRope(new Point(START_LEFT_POSITION_X, START_LEFT_POSITION_Y), new Point(END_LEFT_POSITION_X, END_LEFT_POSITION_Y)));
			_curves.push(new SmoothCurveRope(new Point(START_RIGHT_POSITION_X, START_RIGHT_POSITION_Y), new Point(END_RIGHT_POSITION_X, END_RIGHT_POSITION_Y)));
		}
		
		override public function get id() : String
		{
			return "RopeEntryPoint";
		}
		
		private function get arrow() : MovieClip
		{
			return MovieClip(_location.content[ARROW_PREFIX + team]);
		}
		private function get direction() : int
		{
			return getDirection(team);
		}
		private function get rope() : MovieClip
		{
			return MovieClip(_location.content).rope;
		}
		private function get ropePositionX() : Number
		{
			return _ropePositionX;
		}
		private function get ropePositionY() : Number
		{
			return _ropePositionY;
		}
		private function get team() : String
		{
			return _ropePlace == null ? null : getTeam(_ropePlace);
		}

		override public function initialize(mc:MovieClip):void
		{
			GraphUtils.removeChildren(rope[mc.name]);
			GraphUtils.removeChildren(rope.stick);
			mc.background.alpha = 0;
			MousePointer.registerObject(mc, MousePointer.ACTION);
		}
		
		
		override public function goIn():void
		{
			super.goIn();
			_winer = null;
			Global.charManager.removeStaticModifiers();
			lockState("rEnter", clickedClip.name);
		}
		
		override public function goOut():void
		{
			super.goOut();
			if(_ropePlace != null)
			{
				updateRopeStarts();
				var state : Object = {previousRopePlace : _ropePlace, fall : _winer != team};
				sendUserState("rUnplaceChar", state);
				states[_ropePlace].owner = null;
				if(!_isOut)
					unplaceChar(userStateId, state);
				arrow.gotoAndStop(1);
				arrow.removeEventListener(MouseEvent.CLICK, onArrowClick);
				MousePointer.unRegisterObject(arrow);
				MousePointer.registerObject(arrow, MousePointer.BLOCKED);
				removeState("rExit", _ropePlace);
				_ropePlace = null;
				_winer = null;
			}
		}
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			if(states.rope != undefined)
			{			
				rope.x = START_ROPE_POSITION_X + states.rope.positionX;
				rope.y = START_ROPE_POSITION_Y + states.rope.positionY;
			}
			for(var stateName : String in states)
			{
				var owner : String = states[stateName].owner;
				if(owner == clientCharId)
				{
					removeState("rExit", stateName);
				}
				else if(owner != null)
				{
					Timers.callAfter(placeCharByName, 1, this, [owner]);
				}
			}
			updateRopeStarts();
		}
		
		public function rExit(stateId : String) : void
		{
			updateRopeStarts();
			_location.user.danceEnabled = true;
		}
		
		public function rEnter(stateId : String, state : Object) : void
		{
			placeCharByName(state.owner);
			updateRopeStarts();
			if(state.owner == clientCharId)
			{
				_location.user.danceEnabled = false;
				Global.frame.tips.addTip("takeRope");
				_isOut = false;
				_ropePlace = stateId;
//				sendUserState("rPlaceChar", {ropePlace : stateId});
			}
		}
		
		private function unplaceChar(stateId : String, state : Object) : void
		{
			var charId : String = extractCharId(stateId);
			var locChar:LocationChar = _location.chars[charId];
			if(locChar != null)
			{
				_location.charContainer.addChild(locChar.content);
				var place : MovieClip = _location.content[state.previousRopePlace];
				var team : String = getTeam(state.previousRopePlace);
				locChar.moveToObject(place);
				if(state.fall)
				{
					locChar.setModel(ModelsFactory.MODEL_FALL, getDirection(team));
				}
				else
				{
					locChar.setModel('ModelDance0');
					if(locChar.isUser)
					{
						if(BONUS>0){
							
							var prevTeam : String = null;
							var giveBonus : Boolean = false;
							if(GIVE_BONUS_IF_ONE_TEAM){
								giveBonus = true;
							} else
							for(var stateName : String in states)
							{
								if(states[stateName] != null && states[stateName].owner != null){
									var cTeam:String = getTeam(stateName);
									if (prevTeam!=null && prevTeam!=cTeam){
									  	giveBonus = true;
									  	break;
									}
									prevTeam = cTeam;
								}
							}

							if(giveBonus){					
								_location.sendAddBonus(BONUS, Competitions.ROPE);
								new CompetitionService().addResult(Competitions.ROPE, 1);
							}
						}
						_ropeSuccessEvent.sendEvent();
					}
				}
				updateRopeStarts();
			}
		}
		public function rUnplaceChar(stateId : String, state : Object) : void
		{
			if(stateId != userStateId)
			{
				unplaceChar(stateId, state);
			}
			
		}

		
		private function updateRopeStarts() : void
		{
			_ropeStarts.Left = MAX_CHARS;
			_ropeStarts.Right = MAX_CHARS;
			_ropeStarts.minLeft = -1;
			_ropeStarts.minRight = -1;
			for(var stateName : String in states)
			{
				var state : Object = states[stateName];
				if(state != null
					&& remote.connectedChars.indexOf(state.owner) != -1)
				{
					var parts : Array = String(stateName).split("_");
					var direction : String = parts[1];
					_ropeStarts[direction] = Math.min(uint(parts[2]), _ropeStarts[direction]);
					_ropeStarts["min" + direction] = Math.max(uint(parts[2]), _ropeStarts["min" + direction])
				}
			}
			updateCurves();
		}
		
		private function placeCharByName(charName : String) : void
		{
			placeChar(_location.chars[charName]);
		}
		private function placeChar(locChar:LocationChar) : void
		{
			if(locChar != null && locChar.model && locChar.content)
			{
				var ropeId : String = getCharRope(locChar.id);
				locChar.position = new Point(0, 0);
				
				locChar.setModel(ModelsFactory.MODEL_DRAG, getDirection(getTeam(ropeId)));
				
				if(locChar.model && rope)
					locChar.currentFrame = getCharModelFrame(rope.x - START_ROPE_POSITION_X, locChar);
				
				var clip : MovieClip = MovieClip(_location.content).rope[ropeId];
				clip.addChild(locChar.content);
				if(locChar.isUser)
				{
					_ropePlace = ropeId;
					MousePointer.registerObject(arrow, MousePointer.ACTION);
					arrow.gotoAndStop(2);
					arrow.addEventListener(MouseEvent.CLICK, onArrowClick);
				}
				updateRopeStarts();
			}
		}
		
		public function rEndGame(team : String) : void
		{
			if(this.team != null)
			{
				endGame(team);
				return;
			}
		}
		public function rSetRopePosition(positionX : Number, positionY : Number = 0) : void
		{
			_ropePositionX = positionX;
			_ropePositionY = positionY;
			var positionX : Number = START_ROPE_POSITION_X + positionX;
			var positionY : Number = START_ROPE_POSITION_Y + positionY;
			updateCurves();
			
			MovieClip(_location.content).rope.x = positionX;
			MovieClip(_location.content).rope.y = positionY;
			var teams : ArrayList = new ArrayList();
			for(var stateName : String in states)
			{
				if(states[stateName] != null && states[stateName].owner != null)
				{
					var owner : String = states[stateName].owner;
					var locChar:LocationChar = _location.chars[owner];
					
					if(locChar)
					{
						locChar.currentFrame = getCharModelFrame(positionX, locChar);
						
						var team : String = getTeam(stateName);
						if(!teams.contains(team))
							teams.addItem(team);
					}
				}
			}
		}
		
		private function updateRightCurve() : void
		{
			_curves[1].start.x = START_RIGHT_POSITION_X + ropePositionX - ROPE_PLACE_OFFSET_X * _ropeStarts.Right;
			_curves[1].start.y = START_RIGHT_POSITION_Y + ropePositionY - ROPE_PLACE_OFFSET_Y * _ropeStarts.Right;
		}
		private function updateLeftCurve() : void
		{
			_curves[0].start.x = START_LEFT_POSITION_X + ropePositionX + ROPE_PLACE_OFFSET_X * _ropeStarts.Left;
			_curves[0].start.y = START_LEFT_POSITION_Y + ropePositionY + ROPE_PLACE_OFFSET_Y * _ropeStarts.Left;
		}
		private function updateCurves() : void
		{
			if(_ropeStarts.Left < MAX_CHARS && _ropeStarts.Right < MAX_CHARS)
			{
				updateLeftCurve();
				updateRightCurve();
				return;
			}
			if(_ropeStarts.Left < MAX_CHARS && _ropeStarts.Right == MAX_CHARS)
			{
				updateLeftCurve();
				if(UPDATE_RIGHT_CURVE){
					_curves[1].start.x = (_ropeStarts.minLeft == -1) 
						? _curves[0].start.x + CHAR_WIDTH
						: START_LEFT_POSITION_X + ropePositionX + ROPE_PLACE_OFFSET_X * _ropeStarts.minLeft + CHAR_WIDTH;
				}
//
//				_curves[1].start.y = (_ropeStarts.minRight == -1) 
//					? _curves[0].start.y + CHAR_WIDTH
//					: START_LEFT_POSITION_Y + ropePositionY + ROPE_PLACE_OFFSET_Y * _ropeStarts.minLeft + CHAR_WIDTH;
				return;
			}
			if(_ropeStarts.Left == MAX_CHARS && _ropeStarts.Right < MAX_CHARS)
			{
				updateRightCurve();
				_curves[0].start.x = (_ropeStarts.minRight == -1)
					? _curves[1].start.x - CHAR_WIDTH
					: START_RIGHT_POSITION_X + ropePositionX - ROPE_PLACE_OFFSET_X * _ropeStarts.minRight - CHAR_WIDTH;
//				_curves[0].start.y = (_ropeStarts.minLeft == -1)
//					? _curves[1].start.y - CHAR_WIDTH
//					: START_RIGHT_POSITION_Y + ropePositionY - ROPE_PLACE_OFFSET_Y * _ropeStarts.minRight - CHAR_WIDTH;
				return;
			}
			
			if(_ropeStarts.Left == MAX_CHARS && _ropeStarts.Right == MAX_CHARS)
			{
				_curves[0].start.x = _curves[1].start.x = CENTER_POSITION_X;
				_curves[0].start.y = _curves[1].start.y = CENTER_POSITION_Y;
			}
			
		}

		public function endGame(winer : String) : void
		{
			for(var stateName : String in states)
			{
				if(states[stateName] != null && states[stateName].owner != null)
				{
					var owner : String = states[stateName].owner;
					unplaceChar(getCharStateId(owner), {previousRopePlace : stateName, fall : team != winer});
					if(owner == clientCharId && !_isOut)
					{
						_winer = winer;
						_isOut = true;
						goOut();
						updateRopeStarts();						
					}
				}
			}
		}
		
		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			updateRopeStarts();
		}
		
		private function getCharModelFrame(ropePosition : Number, char:LocationChar) : uint
		{
			if(char.model == null || char.model.content == null)
				return 0;
				
			ropePosition *= 1.5;
			while(ropePosition > char.totalFrames)
			{
				ropePosition -= char.totalFrames;
			}
			while(ropePosition < 1)
			{
				ropePosition += char.totalFrames;
			}
			return ropePosition;
		}
		
		private function onEnterFrame(event : Event) : void
		{
			//updateRopeStarts();
			var changed : Boolean = false;
			var curve : SmoothCurveRope;
			for each(curve in _curves)
			{
				if(curve.updatePoints())
					changed = true;
			}
			if(changed)
			{
				var graphics : Graphics = _location.charContainer.graphics;
				graphics.clear();
				graphics.lineStyle(3,ROPE_COLOR,1);
				
				for each(curve in _curves)
					curve.draw(graphics);
			}
			var left : Point = new Point(_curves[0].start.x, _curves[0].start.y);
			var right : Point = new Point(_curves[1].start.x, _curves[1].start.y);
			var stick : MovieClip = MovieClip(rope.stick);
			
			left = GraphUtils.transformCoords(left, Global.root, stick);
			right = GraphUtils.transformCoords(right, Global.root, stick);
			
			stick.graphics.clear();
			stick.graphics.lineStyle(3,ROPE_COLOR,1);
			stick.graphics.moveTo(left.x, left.y);
			stick.graphics.lineTo(right.x, right.y);
			rope.setChildIndex(stick, 0);
		}
		
		private function onArrowClick(event : MouseEvent) : void
		{
			if(_isOut)
				return;
			_clickCount++;
			if(_clickCount > MAX_CLICK_COUNT)
			{
				_clickCount = 0;
				send("rMoveRope", (team == LEFT_TEAM) ? -ROPE_STEP : ROPE_STEP);
			}
		}
		
		private function getDirection(team : String) : int
		{
			return team == RIGH_TEAM ? Directions.LEFT : Directions.RIGHT;
		}
		private function getCharRope(char : String) : String
		{
			for(var stateName : String in states)
			{
				if(states[stateName] != null && states[stateName].owner == char)
					return stateName;
			}
			return null;
		}
		private function getTeam(point : String) : String
		{
			return point.split("_")[1];
		}

		public function get ropeSuccessEvent():EventSender { return _ropeSuccessEvent; }

		public function set bonus(bonus : int):void { BONUS = bonus; }
		
	}
}