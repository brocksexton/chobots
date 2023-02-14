/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package org.rje.glaze.engine.dynamics.joints {

	import flash.display.Graphics;	
	
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.dynamics.*;
	
	public class PinJoint extends Joint {
		
		public var dist:Number;
		
		public var jnAcc:Number;		
		public var jBias:Number;
		public var bias:Number;
		
		public function PinJoint(a:RigidBody , b:RigidBody , anchr1:Vector2D, anchr2:Vector2D) {
			super(a, b);
		
			jnAcc = jBias = bias = 0;
			
			this.anchr1 = anchr1.clone();
			this.anchr2 = anchr2.clone();
			
			var p1:Vector2D = new Vector2D(anchr1.x * a.rot.x - anchr1.y * a.rot.y, anchr1.x * a.rot.y + anchr1.y * a.rot.x);
			var p2:Vector2D = new Vector2D(anchr2.x * b.rot.x - anchr2.y * b.rot.y, anchr2.x * b.rot.y + anchr2.y * b.rot.x);
			
			p1.plusEquals(a.p);
			p2.plusEquals(b.p);
			
			dist = p2.minus(p1).magnitude();
			
		}
		
		public override function PreStep( dt_inv:Number ):void {
			r1.x = anchr1.x * a.rot.x - anchr1.y * a.rot.y;
			r1.y = anchr1.x * a.rot.y + anchr1.y * a.rot.x;
			r2.x = anchr2.x * b.rot.x - anchr2.y * b.rot.y;
			r2.y = anchr2.x * b.rot.y + anchr2.y * b.rot.x;
			
			var dX:Number = (b.p.x + r2.x) - (a.p.x + r1.x);
			var dY:Number = (b.p.y + r2.y) - (a.p.y + r1.y);
			
			var ldist:Number = Math.sqrt(dX * dX + dY * dY);

			var nzldist:Number = (ldist == 0 ) ? Number.POSITIVE_INFINITY : ldist;

			n.x = dX * (1 / nzldist);
			n.y = dY * (1 / nzldist);

			var mass_sum:Number = a.m_inv + b.m_inv;
			var r1cn:Number = r1.x * n.y - r1.y * n.x;
			var r2cn:Number = r2.x * n.y - r2.y * n.x;
			nMass = 1 / ( mass_sum + (a.i_inv * r1cn * r1cn) + (b.i_inv * r2cn * r2cn));
			
			bias = -joint_bias_coef * dt_inv * (ldist - dist);
			jBias = 0;

			var jx:Number = (n.x * jnAcc);
			var jy:Number = (n.y * jnAcc);

			//INLINE Function
			//a.body.ApplyImpulse( j1.mult(-1), contact.r1);
			a.v.x += (-jx * a.m_inv);
			a.v.y += (-jy * a.m_inv);
			a.w += a.i_inv * (r1.x * -jy - r1.y * -jx);								
			
			//INLINE Function
			//b.body.ApplyImpulse( j1, contact.r2);
			b.v.x += (jx * b.m_inv);
			b.v.y += (jy * b.m_inv);
			b.w += b.i_inv * (r2.x * jy - r2.y * jx);
		
		}
		
		public override function ApplyImpuse():void {
			
			var vbrX:Number = (b.v_bias.x + ( -r2.y * b.w_bias)) - (a.v_bias.x + ( -r1.y * a.w_bias));
			var vbrY:Number = (b.v_bias.y + ( r2.x * b.w_bias)) - (a.v_bias.y + ( r1.x * a.w_bias));
			
			var vbn:Number = vbrX * n.x + vbrY * n.y;
			
			var jbn:Number = (bias - vbn) * nMass;
			var jbnOld:Number = jBias;
			//jBias = Math.min((jbnOld + jbn), 0);
			jBias = jbnOld + jbn;
			if (jBias > 0) jBias = 0;
			jbn = jBias - jbnOld;
			
			//var jb:Vector2D = n.mult(jbn);
			var jbx:Number = (n.x * jbn);
			var jby:Number = (n.y * jbn);

			//INLINE Function
			//a.body.ApplyBiasImpulse(cjT, contact.r1);
			a.v_bias.x += (-jbx * a.m_inv);
			a.v_bias.y += (-jby * a.m_inv);
			a.w_bias   += a.i_inv * (r1.x * -jby - r1.y * -jbx);				
			
			//INLINE Function
			//b.body.ApplyBiasImpulse(cjT, contact.r2);
			b.v_bias.x += (jbx * b.m_inv);
			b.v_bias.y += (jby * b.m_inv);
			b.w_bias   += b.i_inv * (r2.x * jby - r2.y * jbx);
			
			var vrX:Number = (b.v.x + ( -r2.y * b.w)) - (a.v.x + ( -r1.y * a.w));
			var vrY:Number = (b.v.y + ( r2.x * b.w)) - (a.v.y + ( r1.x * a.w));
			
			var vrn:Number = vrX * n.x + vrY * n.y;			
			
			var jn:Number = -vrn * nMass;
			
			jnAcc =+ jn;
	
			//var j:Vector2D = n.mult(jn);
			var jx:Number = (n.x * jn);
			var jy:Number = (n.y * jn);
			
			//INLINE Function
			//a.body.ApplyImpulse( j1.mult(-1), contact.r1);
			a.v.x += (-jx * a.m_inv);
			a.v.y += (-jy * a.m_inv);
			a.w += a.i_inv * (r1.x * -jy - r1.y * -jx);								
			
			//INLINE Function
			//b.body.ApplyImpulse( j1, contact.r2);
			b.v.x += (jx * b.m_inv);
			b.v.y += (jy * b.m_inv);
			b.w += b.i_inv * (r2.x * jy - r2.y * jx);	
	
		}
		
		public override function draw( g:Graphics , drawBB:Boolean ):void {

			g.lineStyle(2, 0x333333);
			g.moveTo(a.p.x + r1.x , a.p.y + r1.y);
			g.lineTo(b.p.x + r2.x , b.p.y + r2.y);

		}
		
	}
	
}
