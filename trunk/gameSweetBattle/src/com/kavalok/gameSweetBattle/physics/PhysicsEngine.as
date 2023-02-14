package com.kavalok.gameSweetBattle.physics
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import org.rje.glaze.engine.collision.shapes.AABB;
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.BodyContact;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.dynamics.joints.Joint;
	import org.rje.glaze.engine.math.Vector2D;
	import org.rje.glaze.engine.space.BruteForceSpace;
	import org.rje.glaze.engine.space.Space;

	public class PhysicsEngine
	{
		public static var gravity:Number=300;

		private const FPS:uint=30;
		private const PPS:uint=80;
		private const DEBUG_MODE:Boolean=false;
		private const OFFSET:Number=300;
		private const WIDTH:Number=10000;

		private const CIRCLE_CLASS:String='McShapeCircle';
		private const RECTANGLE_CLASS:String='McShapeRectangle';
		private const TRIANGLE_CLASS:String='McShapeTriangle';

		public var bounds:Rectangle=null;

		private var _space:Space;
		private var _stage:Sprite;
		private var _objects: /*PhysicsObject*/ Array;

		private var _stepEvent:EventSender=new EventSender();
		private var _finishEvent:EventSender=new EventSender();
		private var _actionEvent:EventSender=new EventSender();
		private var _em:EventManager;

		private var _debugSprite:Sprite;
		private var _land:MovieClip;
		private var _remoteId:String;

		public function PhysicsEngine(container:Sprite, em:EventManager, land:MovieClip, remoteId : String)
		{
			_remoteId = remoteId;
			if (container == null)
			{
				throw new Error('container cannot be null');
			}

			_land=land;
			_em=em;
			_stage=container;

			_space=new BruteForceSpace(FPS, PPS, new AABB(-OFFSET, -OFFSET, WIDTH, KavalokConstants.SCREEN_HEIGHT + OFFSET));
//			_space.masslessForce.setTo(0, PhysicsEngine.gravity);

			_objects=[];

			if (DEBUG_MODE)
			{
				_debugSprite=new Sprite();
				_debugSprite.mouseEnabled=false;
				_debugSprite.mouseChildren=false;
				_debugSprite.alpha=0.2;
				_stage.addChild(_debugSprite);
			}
		}

		//{ ##region process

		public function stop():void
		{
			_em.removeEvent(_stage, Event.ENTER_FRAME, processStep);
		}

		public function start():void
		{
			_em.registerEvent(_stage, Event.ENTER_FRAME, processStep);
		}

		public function invertGravity():void
		{
			gravity=-gravity;
			var body:RigidBody=space.activeBodies;
			while (body)
			{
				if ((!body.isSleeping) && (!body.isFixed))
					var masslessBody:MasslesForceBody=body as MasslesForceBody;
				if (masslessBody)
				{
					masslessBody.mf.setTo(masslessBody.mf.x, -masslessBody.mf.y);
				}
				body=body.next;
			}
		}

//		public function stop():void
//		{
//			_em.removeEvent(_stage, Event.ENTER_FRAME, processStep);
//		}

		private function processStep(e:Event):void
		{
			_space.step();
			// update objects
			for each (var object:PhysicsObject in _objects)
			{
				object.update();
			}

			checkCollisions();

			removeDeletedObjects();

			if (_objects.length == 0)
			{
//				stop();
			}
			else
			{
				sendStepEvents();
			}

			if (DEBUG_MODE)
			{
				drawShapes();
			}
		}

		private function sendStepEvents():void
		{
			_stepEvent.sendEvent();
			for each (var object:PhysicsObject in _objects)
			{
				if (object.stepHandler != null)
					object.stepHandler(object);
			}
		}

		private function checkCollisions():void
		{
			for each (var bodyContact:BodyContact in _space.bodyContactDict)
			{
				checkArbiter(bodyContact);
			}

		}

		private function checkArbiter(arbiter:BodyContact):void
		{
			var fo:PhysicsObject;
			var o1:*=arbiter.bodyA.memberShapes[0].data;
			var o2:*=arbiter.bodyB.memberShapes[0].data;

			if (o1 is PhysicsObject)
			{
				fo=PhysicsObject(o1);

				if (fo.collideHandler != null)
					fo.collideHandler(o1, o2);

				arbiter.bodyB.memberShapes[0].fillColour*=2;
			}
			if (o2 is PhysicsObject)
			{
				fo=PhysicsObject(o2);

				if (fo.collideHandler != null)
					fo.collideHandler(o2, o1);

				arbiter.bodyA.memberShapes[0].fillColour*=2;
			}
		}

		private function removeDeletedObjects():void
		{
			var i:int=0;

			while (i < _objects.length)
			{
				if (_objects[i].deleted)
				{
					removeObject(_objects[i]);
				}
				else
				{
					i++;
				}
			}
		}

		public function drawShapes():void
		{
			_debugSprite.graphics.clear();
			var shape:GeometricShape=_space.activeShapes;
			while (shape)
			{
				shape.draw(_debugSprite.graphics, false);
				shape=shape.next;
			}
			shape=_space.staticShapes;
			while (shape)
			{
				shape.draw(_debugSprite.graphics, false);
				shape=shape.next;
			}
			var joint:Joint=_space.joints;
			while (joint)
			{
				joint.draw(_debugSprite.graphics, false);
				joint=joint.next;
			}
		}

		//} #region process

		//{ #region create world

		public function createWorld(source:Sprite):void
		{
			for (var i:int=0; i < source.numChildren; i++)
			{
				var sprite:Sprite=source.getChildAt(i) as Sprite;

				if (sprite != null)
				{
					createShape(sprite);
				}
			}

			if (DEBUG_MODE)
			{
				drawShapes();
			}
		}

		private function createShape(sprite:Sprite):void
		{
			var name:String=getQualifiedClassName(sprite);
			var shape:Circle;
			var body:MasslesForceBody;
			if (name == "McGravityCircle")
			{
				shape=getCircleShape(sprite);
				body=new MasslesForceBody(RigidBody.STATIC_BODY);
				body.addShape(shape);
				var changer:GravityChanger=new GravityChanger(this, _remoteId, body, _land.gravity);
			}
			if (name == "McActionCircle")
			{
				shape=getCircleShape(sprite);
				body=new MasslesForceBody(RigidBody.STATIC_BODY);
				body.addShape(shape);
				var object:ActionObject=new ActionObject(body, sprite.name);
				object.collideHandler = onActionCollide;
				addObject(object);
			}
			else if (name == "McShapeCircle")
			{
				createCircleShape(sprite);
			}
			else if (name == "McShapeRectangle")
			{
				createPolygonShape(sprite, [new Point(-50, -50), new Point(-50, 50), new Point(50, 50), new Point(50, -50),])
			}
			else if (name == "McShapeTriangle")
			{
				createPolygonShape(sprite, [new Point(-50, 50), new Point(50, 50), new Point(0, -50),])
			}
		}

		private function onActionCollide(object1 : ActionObject, object2 : PhysicsObject):void
		{
			if(object2.owner.isUser)
				actionEvent.sendEvent(object1.actionId);
		}
		
		private function createPolygonShape(sprite:Sprite, points:Array):void
		{
			var c:Point=new Point(0, 0);
			GraphUtils.transformCoords(c, sprite, _stage);

			var verts:Array=[];

			for each (var p:Point in points)
			{
				GraphUtils.transformCoords(p, sprite, _stage);
				verts.push(new Vector2D(p.x - c.x, p.y - c.y));
			}

			var offset:Vector2D=new Vector2D(c.x, c.y);

			_space.defaultStaticBody.addShape(new Polygon(verts, offset, Config.DEFAULT_MATERIAL));
		}

		private function getCircleShape(sprite:Sprite):Circle
		{
			var p:Point=new Point(0, 0);
			GraphUtils.transformCoords(p, sprite, _stage);

			var c:Vector2D=new Vector2D(p.x, p.y);
			var r:Number=0.5 * sprite.width;
			return new Circle(r, c, Config.DEFAULT_MATERIAL);
		}

		private function createCircleShape(sprite:Sprite):void
		{
			_space.defaultStaticBody.addShape(getCircleShape(sprite));
		}

		//} #region create world

		public function addObject(object:PhysicsObject):void
		{
			if (_objects.indexOf(object) >= 0)
			{
				throw new Error('Object already added.')
				return;
			}

			object.engine=this;
			_objects.push(object);
			_stage.addChild(object.sprite);
			_space.addRigidBody(object.body);
		}

		public function removeObject(object:PhysicsObject):void
		{
			if (_objects.indexOf(object) == -1)
			{
				throw new Error('Object doesnt exist.')
				return;
			}

			_objects.splice(_objects.indexOf(object), 1);
			_stage.removeChild(object.sprite);
			_space.removeRigidBody(object.body);
		}

		public static function createRectangle(width:Number, height:Number, offset:Vector2D, elast:Number=0, friction:Number=0):Polygon
		{
			var vertList:Array=new Array();

			vertList.push(new Vector2D(-0.5 * width, -0.5 * height));
			vertList.push(new Vector2D(-0.5 * width, 0.5 * height));
			vertList.push(new Vector2D(0.5 * width, 0.5 * height));
			vertList.push(new Vector2D(0.5 * width, -0.5 * height));

			var polygon:Polygon=new Polygon(vertList, offset, new Material(elast, friction, Config.DEF_DENSITY));

			return polygon;
		}

		public function get stage():Sprite
		{
			return _stage;
		}

		public function get space():Space
		{
			return _space;
		}

		public function get actionEvent():EventSender
		{
			return _actionEvent;
		}
		public function get stepEvent():EventSender
		{
			return _stepEvent;
		}

		public function get objects():Array
		{
			return _objects;
		}

	}
}

