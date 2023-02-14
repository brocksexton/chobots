package com.kavalok.gameSweetBattle.physics
{
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.math.Vector2D;

	public class MasslesForceBody extends RigidBody
	{
		private var _mf : Vector2D = new Vector2D();
		
		public function MasslesForceBody(type:int=DYNAMIC_BODY, m:Number = -1, i:Number = -1)
		{
			super(type, m, i);
		}
		
		public function get mf() : Vector2D
		{
			return _mf;
		}
		
		override public function UpdateVelocity(persistantMasslessForce:Vector2D, force:Vector2D, damping:Number, dt:Number):void
		{
			v.x = (v.x * damping) + ( (persistantMasslessForce.x + mf.x +((force.x + f.x) * m_inv) ) * dt);
			v.y = (v.y * damping) + ( (persistantMasslessForce.y + mf.y + ((force.y + f.y) * m_inv) ) * dt);
			w = (w * damping) + (t * i_inv * dt);
			
			canSleep = true;
		}
		
	}
}