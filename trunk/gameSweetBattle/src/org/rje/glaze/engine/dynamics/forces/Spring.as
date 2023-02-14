package org.rje.glaze.engine.dynamics.forces {
	
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.math.Vector2D;
	
	/**
	* ...
	* @author Default
	*/
	public class Spring extends Force{
		
		public var body:RigidBody;
		public var anchor:Vector2D;
		public var stiffness:Number;
		public var restLength:Number;
		public var damping:Number;
		private const f:Vector2D = new Vector2D();
		
		public function Spring( body:RigidBody, anchor:Vector2D, stiffness:Number, restLength:Number = 0, damping:Number = 0 ) {
			super();
			this.body = body;
			this.anchor = anchor;
			this.stiffness = stiffness;
			this.restLength = restLength;
			this.damping = damping;
		}
		
		public override function eval():void {
			
			if (body.isFixed || body.isStatic) return;
			
			var dx:Number, rx:Number;
			var dy:Number, ry:Number;		
			var k:Number, bv:Number;
			
			f.x = f.y = 0;
			
			dx = body.p.x - anchor.x;
			dy = body.p.y - anchor.y;
			
			var l:Number = Math.sqrt(dx * dx + dy * dy) + 1e-6;
			k = -stiffness * (l - restLength);
			f.x = k * (dx / l);
			f.y = k * (dy / l);
			
			if (damping > 0) {
				bv = -damping * (body.v.x * f.x + body.v.y * f.y) /  (f.x * f.x + f.y * f.y);
				f.x += f.x * bv;
				f.y += f.y * bv;
			}
			body.ApplyForces(f, Vector2D.zeroVect);
		}
		
	}
	
}