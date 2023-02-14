package com.kavalok.gameSweetBattle
{
	import com.kavalok.Global;
	import com.kavalok.char.Directions;
	import com.kavalok.gameSweetBattle.physics.MoveInfo;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.gameSweetBattle.physics.Surface;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.math.Vector2D;
	
	public class Player extends Sprite
	{
		static private const BUBBLE_Y:Number = -30;
		static private const SHAPE_WIDTH:Number = 16;
		static private const SHAPE_HEIGHT:Number = 40;
		static private const MIN_DEMAGE_TIME:Number = 1500;
		
		public var healthHandler:Function;
		public var destroyHandler:Function;
		
		public var speed:int;
		public var rate:int = 0;
		public var destroyed:Boolean = false;
		
		private var _health:int = Config.PLAYER_HEALTH;
		private var _id:String;
		private var _engine:PhysicsEngine;
		private var _model:MovieClip = null;
		private var _direction:int = Directions.RIGHT;
		private var _moveInfo:MoveInfo;
		private var _surface:Surface;
		private var _shape:Polygon = null;
		private var _modelPosition:Point = new Point(0, 2);
		private var _vy:Number;
		private var _gameStage:GameStage;
		private var _bubble:WPlayerBubble;
		
		private var em:EventManager = GameSweetBattle.eventManager;
		
		public function Player(gameStage : GameStage, engine:PhysicsEngine, id:String)
		{
			_id = id;
			_engine = engine;
			_gameStage = gameStage;
			scaleX = scaleY = Config.PLAYER_SCALE;
			_engine.stage.addChild(this);
			
			setModelClass(PlayerModelStay);
			
			em.registerEvent(this, Event.ADDED, onAdded);
			em.registerEvent(this, MouseEvent.MOUSE_OVER, onMouseOver);
			em.registerEvent(this, MouseEvent.MOUSE_OUT, onMouseOut);
		}

		public function sendRemoveBubble() : void
		{
			_gameStage.sendRemoveBubble();
			_gameStage.selectDefaultAction();
			removeBubble();
		}
		public function sendAddBubble(position : Point) : void
		{
			if(!isUser)
				return;
			_gameStage.lockActions();
			removeBubble();
			rAddBubble();
			var localPosition : Point = GraphUtils.transformCoords(position, _gameStage.field, this);
			_bubble.x = localPosition.x;
			_bubble.y = localPosition.y;
			new SpriteTweaner(_bubble, {x : 0, y : BUBBLE_Y}, 10, em);
			
			_gameStage.sendAddUserBubble();
		}
		
		public function rAddBubble() : void
		{
			removeBubble();
			_bubble = new WPlayerBubble();
			_bubble.y = BUBBLE_Y
			addChild(_bubble);
		}
		public function removeBubble() : void
		{
			if(_bubble != null)
			{
				removeChild(_bubble);
				_bubble = null;
			}
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			var icon:IconPlayer = new IconPlayer();
			icon.txtName.text = _id;
			icon.txtHealth.text = health.toString();
			MousePointer.setIcon(icon, false);
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			MousePointer.resetIcon();
		}
		
		public function destroy():void
		{
			destroyed = true;
			_vy = -5;
			
			if (_shape)
			{
				_engine.space.removeRigidBody(_shape.body);
//				_engine.space.defaultStaticBody.removeShape(_shape);
			}
			
			em.registerEvent(this, Event.ENTER_FRAME, onRemoveFrame);
		}
		
		private function onRemoveFrame(e:Event):void
		{
			y += _vy;
			rotation += 5;
			
			if (y < -height)
			{
				em.removeEvent(this, Event.ENTER_FRAME, onRemoveFrame);
				parent.removeChild(this);
			}
		}
		
		public function update():void
		{
			var pos:Vector2D = new Vector2D(x, y);
			var rot:Vector2D = new Vector2D(
				Math.cos(rotation/180*Math.PI),
				Math.sin(rotation/180*Math.PI)
			)
			
			if (_shape == null)
			{
	//			_engine.space.defaultStaticBody.removeShape(_shape);
				createShape(pos);
			}
			_shape.UpdateShape(pos, rot);
			
		}
		
		private function createShape(offset : Vector2D):void
		{
			_shape = PhysicsEngine.createRectangle(
				SHAPE_WIDTH,
				SHAPE_HEIGHT,
				new Vector2D(0, -0.45*SHAPE_HEIGHT),
				Config.DEF_ELAST,
				Config.DEF_FRICTION
			)
			var body : RigidBody = new RigidBody(RigidBody.STATIC_BODY, 0, 0);
			body.addShape(_shape);
			_engine.space.addRigidBody(body);
//			_engine.space.defaultStaticBody.addShape(_shape);
			_shape.data = this;
		}
		public function makeDamage(fo:PhysicsObject):void
		{
			if (_health <= 0)
				return;
				
			if (_id in fo.data.times && getTimer() - fo.data.times[_id] < MIN_DEMAGE_TIME)
				return;
				
			fo.data.times[_id] = getTimer();
				
			var damage:int = fo.data.damage;
			
			if (damage == 0)
				return;
			
			var p:Point = new Point(0, 0);
			GraphUtils.transformCoords(p, fo.sprite, this);
			
			if(_model is PlayerModelStay)
			{
				if (p.x > 0)
				{
					setModelClass(PlayerDamageRight);
				}
				else
				{
					setModelClass(PlayerDamageLeft);
				}
			}

			if(isUser)
			{
				if(_bubble != null)
				{
					sendRemoveBubble();
				}
				_gameStage.sendUserHealth(damage);
			}
		}
		
		private function onAdded(event : Event) : void
		{
			var object:DisplayObject = DisplayObject(event.target)
			if (object is StopMarker)
			{
				if(isUser)
				{
					_gameStage.selectDefaultAction();
				}
				else
				{
					setModelClass(PlayerModelStay);
				}
			}
		}
		public function updateHealth(damage : Number) : void
		{
			_health -= damage;
			new Health(this, damage)
			
			if(isUser)
				healthHandler();
				
				
			if (_health <= 0)
				destroyHandler(this);
		}
		
		public function moveOnSurface(surface:Surface, finishPoint:Point):Boolean
		{
			_surface = surface;
			
			_moveInfo = surface.getMoveInfo(position, finishPoint);
			
			if (_moveInfo.index1 == _moveInfo.index2)
			{
				stopMove();
				return false;
			}
			
			direction = (_moveInfo.direction == 1)
				? Directions.LEFT
				: Directions.RIGHT;
			
			em.registerEvent(this, Event.ENTER_FRAME, onMoveFrame);
			
			return true;
		}
		
		private function handle(handler:Function):void
		{
			if (handler != null)
			{
				handler();
			}
		}

		private function onMoveFrame(e:Event):void
		{
			if(!(_model is PlayerModelWalk))
				setModelClass(PlayerModelWalk);
				
			if (_moveInfo.counter == _moveInfo.stepsCount)
			{
				var nextPoint:Point = _surface.getPoint(_moveInfo.index + _moveInfo.direction);
				var prevPoint:Point = position;
				var d:Number = GraphUtils.distance(prevPoint, nextPoint);
				
				_moveInfo.stepsCount = d / speed;
				_moveInfo.counter = 0;
			
				_moveInfo.dx = (nextPoint.x - prevPoint.x) / _moveInfo.stepsCount;
				_moveInfo.dy = (nextPoint.y - prevPoint.y) / _moveInfo.stepsCount;
				
				var rot1:Number = _surface.getNormal(_moveInfo.index);
				var rot2:Number = _surface.getNormal(_moveInfo.index + _moveInfo.direction);
				_moveInfo.drot = GraphUtils.angleDiff(rot1, rot2) / _moveInfo.stepsCount;
			}
			
			x += _moveInfo.dx;
			y += _moveInfo.dy;
			rotation += _moveInfo.drot / Math.PI * 180;
			
			_moveInfo.counter++;
			
			if (_moveInfo.counter == _moveInfo.stepsCount)
			{
				_moveInfo.index += _moveInfo.direction;
				if (_moveInfo.index == _moveInfo.index2)
				{
					stopMove();
				}
			}
			update();
		}

		public function stopMove():void
		{
			if(_surface == null)
				return;
			var index : int = _surface.getNearestIndex(new Point(x, y));
			rotation = Maths.radiansToDegrees(_surface.getAngle(index));
			update();
			setModelClass(PlayerModelStay);
			em.removeEvent(this, Event.ENTER_FRAME, onMoveFrame);
		}
		
		public function setModelClass(modelClass:Class):void
		{
			var model:MovieClip = MovieClip(new modelClass());
			setModel(model);
		}
		
		public function setModel(model:MovieClip):void
		{
			if (_model != null)
			{
				removeChild(_model);
			}
			
			_model = model;
			
			if (_model != null)
			{
				addChild(_model);
				_model.x = _modelPosition.x;
				_model.y = _modelPosition.y;
			}
		}
		
		public function get isWalk():Boolean
		{
			return hasEventListener(Event.ENTER_FRAME);
		}
		
		public function get position():Point
		{
			return new Point(x, y);
		}
		
		public function set position(point:Point):void
		{
			x = point.x;
			y = point.y;
		}
		
		public function get direction():int { return _direction; }
		
		public function set direction(value:int):void
		{
			_direction = value;
			
			scaleX = (_direction == Directions.RIGHT)
				? Math.abs(scaleX)
				: -Math.abs(scaleX);
			
		}
		
		public function get isUser():Boolean
		{
			return (_id == Global.charManager.charId);
		}
		
		public function get health():int { return _health; }
		
		public function get id():String { return _id; }
	}
}

