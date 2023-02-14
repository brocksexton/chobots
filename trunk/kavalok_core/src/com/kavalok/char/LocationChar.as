package com.kavalok.char
{
	import com.kavalok.char.modifiers.CharModifierBase;
	import com.kavalok.dance.BoneParts;
	import com.kavalok.dance.BonePlayer;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTipText;
	import com.kavalok.gameplay.windows.CharWindowView;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.chat.IBubbleSource;
	import com.kavalok.location.LocationBase;
	import com.kavalok.Global;
	import com.kavalok.location.LocationPet;
	import com.kavalok.location.MoveByPathAction;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import com.kavalok.dialogs.Dialogs;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import gs.TweenLite;
	import gs.easing.Elastic;
	
	public class LocationChar implements IBubbleSource
	{
		static public const DEFAULT_SPEED:Number = 3;
		static public const CHAR_NAME_OFFSET:Number = 6;
		static public const CHAR_NAME_SIZE:Number = 10;
		static private const CHAR_WIDTH:int = 25;
		static private const CHAR_HEIGHT:int = 50;
		
		public var speed:Number = DEFAULT_SPEED;
		public var pet:LocationPet;
		public var moodId:String;
		public var showOptimization:Boolean = false;
		public var teleportMode:Boolean = false;
		public var moonwalkMode:Boolean = false;
		public var promotionChatMode:Boolean;
		public var bubbleStyleName:String;
		
		private var _moveCompleteEvent:EventSender = new EventSender();
		private var _moveStartEvent:EventSender = new EventSender();
		private var _clickEvent:EventSender = new EventSender();
		
		public var _char:Char;
		
		private var _content:Sprite = new Sprite();
		private var _nameTip:ToolTipText;
		private var _model:CharModel;
		private var _shadow:CharModel;
		private var _simpleShadow:Sprite;
		private var _headScale:Number = 1;
		
		private var _boundSprite:Sprite;
		private var _shadowEnabled:Boolean = true;
		private var _modifiers:Object = {};
		private var _lastModifier:CharModifierBase;
		private var _chatMessage:ChatMessage;
		private var _moveAction:MoveByPathAction;
		private var _flyMode:Boolean;
		private var _danceEnabled:Boolean = true;
		private var _animationCompleted:Boolean = false;
		private var _showName:Boolean = false;
		private var _scale:Number = 1;
		private var _scaleMult:Number = 1;
		
		private var _savedPosition:Point;
		private var _savedParent:Sprite;
		private var _savedShowName:Boolean;

		
		private var _bonePlayers:Array = [];
		
		public function LocationChar(char:Char)
		{
			_char = char;
			//Dialogs.showOkDialog("privKey: " + Global.charManager.privKey);
			
			_content.addEventListener("finish", onAnimationFinish, true);
			_model = new CharModel(_char);
			_model.refresh();
			
			createShadow();
			
			_boundSprite = GraphUtils.createRectSprite(CHAR_WIDTH, CHAR_HEIGHT, 0, 0);
			_boundSprite.y = -CHAR_HEIGHT;
			_boundSprite.x = -0.5 * CHAR_WIDTH;
			_boundSprite.addEventListener(MouseEvent.CLICK, onClick);
			
			 if(Global.charManager.isCitizen)
			 {
				Global.sendAchievement("ac1;","Citizen");
			 }
			 if(Global.charManager.isJournalist)
			 {
				Global.sendAchievement("ac2;","Journalist");
			 }
			 if(Global.charManager.isAgent)
			 {
				Global.sendAchievement("ac3;","Agent");
			 }
			/* if(Global.charManager.isElite)
			 {
				Global.sendAchievement("ac4;","Elite Agent");
			 }*/
			 if(Global.charManager.robotTeam.isMine)
			 {
				Global.sendAchievement("ac11;","Robot Team");
			 }
			 if(!Global.charManager.stuffs.stuffExists("brush") != true)
			 {
				Global.sendAchievement("ac5;","Brush");
			 }
			 if(!Global.charManager.stuffs.stuffExists("video_camera") != true)
			 {
				Global.sendAchievement("ac7;","Camera");
			 }
			 if(!Global.charManager.stuffs.stuffExists("medal_cholympics420") != true)
			 {
				Global.sendAchievement("ac6;","Cholympics Winner");
			 }
			 if(!Global.charManager.stuffs.stuffExists("remote_control") != true)
			 {
				Global.sendAchievement("ac33;","Remote Control");
			 }
			 if(!Global.charManager.stuffs.stuffExists("futbolka_10") != true && !Global.charManager.stuffs.stuffExists("futbolka_20") != true && !Global.charManager.stuffs.stuffExists("futbolka_30") != true)
			 {
				Global.sendAchievement("ac36;","All Three Shirts");
			 }
			 if(!Global.charManager.stuffs.stuffExists("foliant") != true)
			 {
				Global.sendAchievement("ac37;","Scroll");
			 }
			 if(!Global.charManager.stuffs.stuffExists("feather") != true)
			 {
				Global.sendAchievement("ac38;","Feather");
			 }
			 if(!Global.charManager.stuffs.stuffExists("microphone") != true)
			 {
				Global.sendAchievement("ac39;","Microphone");
			 }
			 if(!Global.charManager.stuffs.stuffExists("comix") != true)
			 {
				Global.sendAchievement("ac40;","Comic");
			 }
			 if(Global.charManager.money > 99999)
			 {
				Global.sendAchievement("ac28;","100,000 Bugs");
			 }
			 if(Global.charManager.money > 999999)
			 {
				Global.sendAchievement("ac29;","1,000,000 Bugs");
			 }
			 if(Global.charManager.money > 4999999)
			 {
				Global.sendAchievement("ac30;","5,000,000 Bugs");
			 }
			 if(Global.charManager.charLevel == 60)
			 {
				Global.sendAchievement("ac32;","Level 60");
			 }
			 if(Global.charManager.friends.length > 99)
			 {
				Global.sendAchievement("ac8;","100 Friends");
			 }
			
			if(!Global.isAgentGuest){
			_content.addChild(_model);
			_content.addChild(_boundSprite);
		}
			_chatMessage = new ChatMessage(this);
			
			_moveAction = new MoveByPathAction(_content);
			
			flyMode = false;
			showName=!_showName;
		}
		
		public function set body(value:String):void
		{
			_char.body = value;
			refreshModel();
		}
		
		public function set clothes(value:Array):void
		{
			_char.clothes = value;
			refreshModel();
		}
		
		public function set showName(value:Boolean):void
		{
			var bOrder:uint = 
			Global.charManager.moderatorList.indexOf(_char.id) != -1 ? 0xFF6600 : 
			Global.charManager.agentList.indexOf(_char.id) != -1 ? 0x0066FF : 
			Global.charManager.journalistList.indexOf(_char.id) != -1 ? 0x3D003D : 0x990000;
			
			var bAckground:uint = 
			Global.charManager.moderatorList.indexOf(_char.id) != -1 ? 0xFF9900 : 
			Global.charManager.agentList.indexOf(_char.id) != -1 ? 0x0066FF : 
			Global.charManager.journalistList.indexOf(_char.id) != -1 ? 0x660066 : 0xffffff;
			
			var fontColor:uint = 
			Global.charManager.moderatorList.indexOf(_char.id) != -1 ? 0x000000 : 
			Global.charManager.agentList.indexOf(_char.id) != -1 ? 0xffffff : 
			Global.charManager.journalistList.indexOf(_char.id) != -1 ? 0xffffff :  0x000000;

			if (_showName != value)
			{
				_showName = value;
				if (value)
				{
					_nameTip = new ToolTipText(CHAR_NAME_SIZE, bOrder, bAckground, fontColor);
					_nameTip.margin = 1;

					_nameTip.text = _char.id == "kingnicho" ? "Nicho King" : Global.upperCase(_char.id);

					_nameTip.y = CHAR_NAME_OFFSET;
					_content.addChild(_nameTip);
					updateNameTip();
					ToolTips.unRegisterObject(_boundSprite);
				}
				else
				{
					if(char.id == "kingnicho")
						ToolTips.registerObject(_boundSprite, "Nicho King");
					else
						ToolTips.registerObject(_boundSprite, Global.upperCase(_char.id));
						_content.removeChild(_nameTip);
						_nameTip = null;
				}
			}
		}
		
		private function onAnimationFinish(e:Event):void
		{
			_animationCompleted = true;
			
			MovieClip(e.target).stop();
			if (isIdle)
				setModel(CharModels.STAY);
			
			tunePerformance();
		}
		
		public function get bubblePosition():Point
		{
			var modelPosition:Point = GraphUtils.transformCoords(new Point(), model, content);
			return (_model.isReady) ? new Point(modelPosition.x, _model.getBounds(_content).top + 2) : new Point(modelPosition.x, _boundSprite.getBounds(_content).top + 2);
		}
		
		///////////////////////////////////////
		// moving
		///////////////////////////////////////
		public function set flyMode(value:Boolean):void
		{
			_flyMode = value;
			tunePerformance();
		}
		
		public function customDance(dance:Array):BonePlayer
		{
			for each (var player:BonePlayer in _bonePlayers)
				player.stop();
			setModel(CharModels.CUSTOM_DANCE);
			var parts:BoneParts = new BoneParts(_model.content);
			player = new BonePlayer(parts, _model.content);
			player.finishEvent.addListener(onFinishDance);
			player.play(dance);
			_bonePlayers.push(player);
			if (shadow)
			{
				player = new BonePlayer(parts, shadow.content);
				player.play(dance);
				_bonePlayers.push(player);
			}
			return player;
		}
		
		private function onFinishDance():void
		{
			if (_bonePlayers.length > 0)
				_bonePlayers[0].finishEvent.removeListener(onFinishDance);
			_bonePlayers = [];
		}
		
		public function moveByPath(path:Array):void
		{
			if (teleportMode && path.length > 0)
			{
				var newPosition:Point = path[path.length - 1];
				var newDirection:int = Directions.getDirection(newPosition.x - position.x, newPosition.y - position.y);
				
				position = newPosition;
				setModel(_model.modelName, newDirection);
				var oldScale:Number = _scale * _scaleMult;
				_content.scaleX = _content.scaleY = 0.1;
				TweenLite.to(_content, 1.0, {scaleX: oldScale, scaleY: oldScale, ease: Elastic.easeOut, onComplete: _moveCompleteEvent.sendEvent});
				_moveStartEvent.sendEvent();
			}
			else
			{
				_moveAction.initilize(path, speed);
				_moveAction.onComplete = onMoveComplete;
				_moveAction.onDirectionChange = onDirectionChange;
				_moveStartEvent.sendEvent();
				_moveAction.execute();
			}
		}
		
		private function onMoveComplete(action:MoveByPathAction):void
		{
			_moveCompleteEvent.sendEvent();
			setModel(CharModels.STAY);
		}
		
		private function onDirectionChange(newDirection:int):void
		{
			var directionNum:int = (moonwalkMode) ? Directions.invertDirections[newDirection] : newDirection;
			
			if (_flyMode)
				setModel(CharModels.STAY, directionNum);
			else
				setModel(CharModels.WALK, directionNum);
		}
		
		public function stopMoving():void
		{
			_moveAction.stopMoving();
			setModel(CharModels.STAY);
		}
		
		///////////////////////////////////////
		// modifiers
		///////////////////////////////////////
		
		public function addModifier(info:Object):void
		{
			var className:String = info.className;
			var modifierClass:Class = Class(getDefinitionByName(className));
			var modifier:CharModifierBase = new modifierClass();
			
			if (className in _modifiers)
				CharModifierBase(_modifiers[className]).destroy();
			
			_modifiers[className] = modifier;
			_lastModifier = modifier;
			modifier.char = this;
			modifier.parameter = info.parameter;
			modifier.execute();
		}
		
		public function hasModifier(className:String):Boolean
		{
			return (className in _modifiers);
		}
		
		public function removeModifier(className:String):void
		{
			if (className in _modifiers)
			{
				var modifier:CharModifierBase = _modifiers[className];
				modifier.destroy();
				delete _modifiers[className];
				
				if (_lastModifier == modifier)
					_lastModifier = null;
			}
		}
		
		///////////////////////////////////////
		// methods
		///////////////////////////////////////
		
		public function refreshModel():void
		{
			_model.reload();
			
			if (_shadow)
				_shadow.reload();
		}
		
		private function createFullShadow():void
		{
			removeShadow();
			
			_shadow = new CharModel(_char);
			_shadow.factory = _model.factory;
			_shadow.setModel(_model.modelName, _model.direction);
			_shadow.refresh();
			_shadow.transform.colorTransform = new ColorTransform(0, 0, 0, 0.2);
			_shadow.filters = [new BlurFilter(3, 3)];
			
			var matrix:Matrix = _shadow.transform.matrix;
			matrix.c = -0.5;
			matrix.scale(1, 0.5);
			
			_shadow.transform.matrix = matrix;
			_shadow.y = 3;
			
			_content.addChildAt(_shadow, 0);
		}
		
		private function createSimpleShadow():void
		{
			removeShadow();
			
			_simpleShadow = new Sprite();
			_simpleShadow.graphics.beginFill(0, 0.15);
			_simpleShadow.graphics.drawCircle(0, 0, 15);
			_simpleShadow.graphics.endFill();
			_simpleShadow.scaleY = 0.5;
			_simpleShadow.filters = [new BlurFilter()];
			_simpleShadow.cacheAsBitmap = true;
			_simpleShadow.y = -2;
			_simpleShadow.x = 2;
			_simpleShadow.rotation = -15;
			
			_content.addChildAt(_simpleShadow, 0);
		}
		
		private function removeShadow():void
		{
			if (_shadow)
			{
				_shadow.destroy();
				_content.removeChild(_shadow);
				_shadow = null;
			}
			
			if (_simpleShadow)
			{
				_content.removeChild(_simpleShadow);
				_simpleShadow = null;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			_clickEvent.sendEvent(this);
		}
		
		public function destroy():void
		{
			for each (var modifier:CharModifierBase in _modifiers)
			{
				modifier.destroy();
			}
			
			_moveAction.stopMoving();
			_chatMessage.hide();
			
			_model.destroy();
			if (_shadow)
				_shadow.destroy();
		}
		
		///////////////////////////////////////
		// get/set
		///////////////////////////////////////
		
		public function get lastModifier():CharModifierBase
		{
			return _lastModifier;
		}
		
		public function get id():String
		{
			return _char.id;
		}
		
		public function get userId():Number
		{
			return _char.userId;
		}
		
		public function get hasTool():Boolean
		{
			return (_char.tool != null);
		}
		
		public function set danceEnabled(value:Boolean):void
		{
			_danceEnabled = value;
		}
		
		public function get danceEnabled():Boolean
		{
			return (isStaing || isWalking || isDancing || isIdle) && _char.tool == null && _danceEnabled;
		}
		
		public function get idleEnabled():Boolean
		{
			return (isStaing || isIdle) && _char.tool == null && _content.parent && _content.parent.name == LocationBase.Z_SPRITE_NAME;
		}
		
		public function get isDancing():Boolean
		{
			return _model.modelName.indexOf(CharModels.DANCE) == 0 || _bonePlayers.length > 0;
		}
		
		public function get isIdle():Boolean
		{
			return _model.modelName.indexOf(CharModels.IDLE_PREFIX) == 0;
		}
		
		public function isWalking():Boolean
		{
			return _model.modelName == CharModels.WALK;
		}
		
		public function get isStaing():Boolean
		{
			return _model.modelName == CharModels.STAY;
		}
		
		public function get isPlaying():Boolean
		{
			return _model.modelName.indexOf('Play') == 0;
		}
		
		public function setModel(modelName:String, direction:int = -1):void
		{
			_animationCompleted = false;
			_model.setModel(modelName, direction);
			_model.headScale = _headScale;
			
			if (_shadow)
			{
				_shadow.setModel(modelName, direction);
				_shadow.headScale = _headScale;
			}
			tunePerformance();
		}
		
		private function tunePerformance():void
		{
			var bitmapEnabled:Boolean = (_model.modelName == CharModels.STAY || _animationCompleted) && !_flyMode || !_model.modelAnimation;
			
			_content.cacheAsBitmap = bitmapEnabled;
			if (_shadow)
				_shadow.cacheAsBitmap = bitmapEnabled;
			else
				_simpleShadow.cacheAsBitmap = bitmapEnabled;
			
			if (showOptimization)
				_model.alpha = (bitmapEnabled) ? 0.1 : 1;
		}
		
		public function set headScale(value:Number):void
		{
			_headScale = value;
			setModel(_model.modelName);
		}
		
		public function get isUser():Boolean
		{
			return _char.isUser;
		}
		
		public function get position():Point
		{
			return new Point(_content.x, _content.y);
		}
		
		public function set position(value:Point):void
		{
			_content.x = value.x;
			_content.y = value.y;
			stopMoving();
		}
		
		public function moveToObject(object:Object):void
		{
			_content.x = object.x;
			_content.y = object.y;
			stopMoving();
		}
		
		public function get totalFrames():int
		{
			return _model.content.totalFrames;
		}
		
		public function set currentFrame(value:int):void
		{
			if (_model && _model.content)
				_model.content.gotoAndStop(value);
			
			if (_shadow && _shadow.content)
				_shadow.content.gotoAndStop(value);
		}
		
		public function set shadowEnabled(value:Boolean):void
		{
			_shadowEnabled = value;
			createShadow();
		}
		
		private function createShadow():void
		{
			if (_shadowEnabled)
				createFullShadow();
			else
				createSimpleShadow();
		}
		
		public function set visible(value:Boolean):void
		{
			_content.visible = value;
		}
		
		public function set scale(value:Number):void
		{
			_scale = value;
			updateScale();
		}
		
		public function set scaleMult(value:Number):void
		{
			_scaleMult = value;
			updateScale();
		}
		
		private function updateScale():void
		{
			_content.scaleX = _content.scaleY = _scale * _scaleMult;
			updateNameTip();
		
		}
		
		private function updateNameTip():void
		{
			if (_nameTip)
			{
				_nameTip.scaleX = _nameTip.scaleY = 1 / _scale / _scaleMult;
				_nameTip.x = -_nameTip.width / 2;
			}
		}
		
		public function set modelsFactory(value:IModelsFactory):void
		{
			_model.factory = value;
			if (_shadow)
				_shadow.factory = value;
		}
		
		public function get modelsFactory():IModelsFactory
		{
			return _model.factory;
		}
		
		public function set modelAnimation(value:Boolean):void
		{
			if (value != _model.modelAnimation)
			{
				_model.modelAnimation = value;
				if (_shadow)
					_shadow.modelAnimation = value;
			}
		}
		
		public function get modelAnimation():Boolean
		{
			return _model.modelAnimation;
		}
		
		public function changeParent(newParent:Sprite):void
		{
			_savedPosition = position;
			_savedShowName = _showName;
			_savedParent = _content.parent as Sprite;
			newParent.addChild(content);
			position = new Point();
			showName = false;
		}
		
		public function restoreParent():void
		{
			_savedParent.addChild(content);
			position = _savedPosition;
			showName = _savedShowName;
		}
		
		public function get content():Sprite
		{
			return _content;
		}
		
		public function get char():Char
		{
			return _char;
		}
		
		public function get model():CharModel
		{
			return _model;
		}
		
		public function get shadow():CharModel
		{
			return _shadow;
		}
		
		public function get boundSprite():Sprite
		{
			return _boundSprite;
		}
		
		public function get chatMessage():ChatMessage
		{
			return _chatMessage;
		}
		
		public function get flyMode():Boolean
		{
			return _flyMode;
		}
		
		public function get clickEvent():EventSender
		{
			return _clickEvent;
		}
		
		public function get moveCompleteEvent():EventSender
		{
			return _moveCompleteEvent;
		}
		
		public function get moveStartEvent():EventSender
		{
			return _moveStartEvent;
		}
	}
}