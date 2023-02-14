package com.kavalok.location
{
	import com.kavalok.char.ChatMessage;
	import com.kavalok.dto.pet.PetTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.chat.IBubbleSource;
	import com.kavalok.pets.PetModel;
	import com.kavalok.pets.PetModels;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class LocationPet implements IBubbleSource
	{
		static private const DEFAULT_SPEED:Number = 3;
		static private const PET_WIDTH:int = 25;
		static private const PET_HEIGHT:int = 25;
		
		public var speed:Number = DEFAULT_SPEED;
		public var animationEnabled:Boolean = true;
		
		private var _clickEvent:EventSender = new EventSender(LocationPet);
		
		private var _content:Sprite = new Sprite();
		private var _pet:PetTO;
		private var _model:PetModel;
		private var _shadow:PetModel;
		private var _boundSprite:Sprite;
		private var _direction:int;
		
		private var _actions:Array = [];
		private var _maxActions:int = 2;
		private var _chatMessage:ChatMessage;
		
		private var _shadowEnabled:Boolean = true;
		
		public function LocationPet(pet:PetTO)
		{
			_pet = pet;
			
			_boundSprite = GraphUtils.createRectSprite(PET_WIDTH, PET_HEIGHT, 0, 0);
			_boundSprite.x = -0.5 * PET_WIDTH;
			_boundSprite.addEventListener(MouseEvent.CLICK, onClick);
			
			_chatMessage = new ChatMessage(this);
			
			_model = new PetModel(_pet);
			_model.readyEvent.addListener(refresh);
			_model.updateModel();
			
			_content.addChild(_model);
			_content.addChild(_boundSprite);
		}
		
		private function onClick(e:MouseEvent):void
		{
			_clickEvent.sendEvent(this);
		}
		
		public function get bubblePosition():Point
		{
			 return new Point(0, _model.getBounds(_content).top);
		}
		
		public function setModel(modelName:String, direction:int = -1):void
		{
			if (direction != -1)
				_direction = direction;
			
			_model.setModel(modelName, _direction);
			_content.cacheAsBitmap = (_model.modelName == PetModels.STAY);
			
			refresh();
		}
		
		public function moveByPath(path:Array):void
		{
			if (_actions.length == _maxActions)
				return;
				
			var action:MoveByPathAction = new MoveByPathAction(_content, path, speed);
			_actions.push(action);
			action.onComplete = onMoveComplete; 
			action.onDirectionChange = onDirectionChange; 
			action.execute();
		}
		
		private function onMoveComplete(action:MoveByPathAction):void
		{
			Arrays.removeItem(action, _actions);
			if (_actions.length == 0)
				stop();
		}
		
		private	function onDirectionChange(newDirection:int):void
		{
			if (animationEnabled)
				setModel(PetModels.WALK, newDirection);
			else
				setModel(PetModels.STAY, newDirection);
		}
		
		public function stop():void
		{
			for each (var action:MoveByPathAction in _actions)
			{
				action.stopMoving();
			}
			_actions = [];
			setModel(PetModels.STAY);
		}
		
		private function refresh():void
		{
			_model.y -= _model.getBounds(_content).bottom;
			_boundSprite.y = _model.y - 0.5 * PET_HEIGHT;
			
			if (_shadow)
			{
				_shadow.destroy();
				_content.removeChild(_shadow);
			}
				
			if (_shadowEnabled)
				createShadow();
		}
		
		private function createShadow():void
		{
			_shadow = new PetModel(_pet);
			_shadow.setModel(_model.modelName, _direction);
			_shadow.transform.colorTransform = new ColorTransform(0, 0, 0, 0.2);
			_shadow.filters = [new BlurFilter(3, 3)];
			_shadow.mouseEnabled = false;
			_shadow.mouseChildren = false;
			
			var matrix:Matrix = _shadow.transform.matrix;
			matrix.c = -0.2;
			matrix.scale(0.8, 0.5);
			
			_shadow.transform.matrix = matrix;
			
			_content.addChildAt(_shadow, 0);
		}
		
		public function destroy():void
		{
			_model.destroy();
			_chatMessage.hide();
			
			if (_shadow)
				_shadow.destroy();
		}
		
		public function get id():int
		{
			 return _pet.id;
		}
		
		public function get position():Point
		{
			return new Point(_content.x, _content.y);
		}
		
		public function set position(value:Point):void
		{
			 _content.x = value.x;
			 _content.y = value.y;
		}
		
		public function set shadowEnabled(value:Boolean):void
		{
			 _shadowEnabled = value;
			 refresh();
		}
		
		public function set scale(value:Number):void
		{
			_content.scaleX = _content.scaleY = value;
		}
		
		public function get currentFrame():int
		{
			 return (_model.content) ? _model.content.currentFrame : 0; 
		}		
		
		public function get totalFrames():int
		{
			 return (_model.content) ? _model.content.totalFrames : 0; 
		}		
		
		public function get clickEvent():EventSender { return _clickEvent; }
		public function get content():Sprite { return _content; }
		public function get boundSprite():Sprite { return _boundSprite; }
		public function get shadowEnabled():Boolean { return _shadowEnabled; }
		public function get model():PetModel { return _model; }
		public function get pet():PetTO { return _pet; }
		public function get chatMessage():ChatMessage { return _chatMessage; }
	}
}