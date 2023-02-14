package com.kavalok.gameSweetBattle.physics
{
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.Player;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.math.Vector2D;
	import org.rje.glaze.engine.space.Space;

	public class PhysicsObject
	{
		
		//{ region members
		static private const IDLE_DX:Number = 3;
		static private const IDLE_DY:Number = 3;
		static private const IDLE_DR:Number = 2;
		
		public var collideHandler:Function;
		public var stepHandler:Function;
		
		public var deleted:Boolean = false;
		public var idle:Boolean = false;
		public var state:String;
		public var data:Object = {};
		
		public var body:MasslesForceBody;
		public var sprite:MovieClip;
		public var owner:Player;
		
		public var space:Space;
		public var engine:PhysicsEngine;
		
		public var elast:Number;
		public var friction:Number;
		
		protected var _model:MovieClip;
		
		//} region members
		
		//{ region init
		
		public function PhysicsObject(type : int = 1, body : MasslesForceBody = null) 
		{
			
			sprite = new MovieClip();
			
			if(body == null)
			{
				body = new MasslesForceBody(type);
			}
			this.body = body;
			mass = Config.DEF_MASS;
			inert = Config.DEF_INERT;
			elast = Config.DEF_ELAST;
			friction = Config.DEF_FRICTION;
			
			for each (var shape:GeometricShape in body.memberShapes)
			{
				shape.data = this;
			}
		}
		
		public function get mass() : Number
		{
			return body.m;
		}
		public function set mass(value : Number) : void
		{
			body.m = value;
		}
		public function get inert() : Number
		{
			return body.i;
		}
		public function set inert(value : Number) : void
		{
			body.i = value;
		}
		
		public function addCircle(r:Number, x:Number = 0, y:Number = 0, material : Material = null):void
		{
			var circle:GeometricShape = new Circle(r, new Vector2D(x, y), material || Config.DEFAULT_MATERIAL);
			circle.data = this;
			body.addShape(circle);
		}
		
		public function addRect(width:Number, height:Number, x:Number = 0, y:Number = 0):void
		{
			var rect:Polygon = PhysicsEngine.createRectangle(width, height, new Vector2D(x, y), elast, friction);
			rect.data = this;
			body.addShape(rect);
		}
		
		//} region init
		
		//{ region properties
		
		public function set rotationLocked(value:Boolean):void 
		{
			body.rotationLocked = value;
		}
		public function set position(value:Point):void 
		{
			body.p.x = value.x;
			body.p.y = value.y;
		}
		
		public function get position():Point
		{
			return new Point(body.p.x, body.p.y);
		}
		
		public function get masslessForce():Vector2D
		{
			return body.mf;
		}
		
		public function set visible(value:Boolean):void
		{
			sprite.visible = value;
		}
		
		public function get visible():Boolean
		{
			return sprite.visible;
		}
		
		public function get velocity():Vector2D
		{
			return body.v;
		}
		
		public function get angularVelocity():Number
		{
			return body.w;
		}
		
		public function set angularVelocity(value:Number):void
		{
			body.w = value;
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
				sprite.removeChild(_model);
			}
			
			_model = model;
			
			if (_model != null)
			{
				sprite.addChild(_model);
			}
		}
		
		public function update():void
		{
			var newRot:Number = body.a / Math.PI * 180;
			
			var dx:Number = body.p.x - sprite.x;
			var dy:Number = body.p.y - sprite.y;
			var dr:Number = newRot - sprite.rotation;
			
			idle = (dx > 0 ? dx : -dx) < IDLE_DX
				&& (dy > 0 ? dy : -dy) < IDLE_DY
				&& (dr > 0 ? dr : -dr) < IDLE_DR;
			
			sprite.x = body.p.x;
			sprite.y = body.p.y;
			sprite.rotation = newRot;
			
			if (sprite.x < -sprite.width
//				|| sprite.x > _stageWidth + sprite.width
				|| sprite.y > Config.STAGE_HEIGHT + sprite.height
				|| sprite.y < 0)
			{
				deleted = true;
			}
		}
		
		public function get rotation():Number 
		{
			return body.a;
		}
		
		public function set rotation(value:Number):void 
		{
			body.setAngle(value);
		}
		
		public function move(dx:Number, dy:Number):void
		{
			body.p.x += dx;
			body.p.y += dy;
		}
	}
}
