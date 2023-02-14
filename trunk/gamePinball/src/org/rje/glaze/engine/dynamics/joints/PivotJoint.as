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
	
	public class PivotJoint extends Joint {
		
		private var jAcc:Vector2D;
		private var jBias:Vector2D;
		private var bias:Vector2D;
		
		private var k1:Vector2D;
		private var k2:Vector2D;
		
		public function PivotJoint(a:RigidBody, b:RigidBody, pivot:Vector2D ) {
			super(a, b);
			
			anchr1 = pivot.minus(a.p).rotateByVector(a.rot);
			anchr2 = pivot.minus(b.p).rotateByVector(b.rot);		
			
			jAcc   = new Vector2D();
			jBias  = new Vector2D();
			bias   = new Vector2D();
		}

		public override function PreStep( dt_inv:Number ):void {
			r1 = anchr1.rotateByVector(a.rot);
			r2 = anchr2.rotateByVector(b.rot);

			// calculate mass matrix
			var k11:Number;
			var k12:Number;
			var k21:Number; 
			var k22:Number;

			var m_sum:Number = a.m_inv + b.m_inv;
			k11 = m_sum; 
			k12 = 0.0;
			k21 = 0.0;
			k22 = m_sum;

			var r1xsq:Number = r1.x * r1.x * a.i_inv;
			var r1ysq:Number = r1.y * r1.y * a.i_inv;
			var r1nxy:Number = -r1.x * r1.y * a.i_inv;
			k11 += r1ysq; k12 += r1nxy;
			k21 += r1nxy; k22 += r1xsq;

			var r2xsq:Number = r2.x * r2.x * b.i_inv;
			var r2ysq:Number = r2.y * r2.y * b.i_inv;
			var r2nxy:Number = -r2.x * r2.y * b.i_inv;
			k11 += r2ysq; k12 += r2nxy;
			k21 += r2nxy; k22 += r2xsq;

			var det_inv:Number = 1.0 / (k11 * k22 - k12 * k21);
			k1 = new Vector2D(k22 * det_inv, -k12 * det_inv);
			k2 = new Vector2D(-k21 * det_inv, k11 * det_inv);

			// calculate bias velocity
			var delta:Vector2D = b.p.plus(r2).minus(a.p.plus(r1));
			bias  = delta.mult(-joint_bias_coef * dt_inv);
			jBias = new Vector2D();

			// apply accumulated impulse
			a.ApplyImpulse(jAcc.mult(-1), r1);
			b.ApplyImpulse(jAcc, r2);
		}

		public override function ApplyImpuse():void {
			//calculate bias impulse
			var vb1:Vector2D = a.v_bias.plus(r1.rightHandNormal().mult(a.w_bias));
			var vb2:Vector2D = b.v_bias.plus(r2.rightHandNormal().mult(b.w_bias));
			var vbr:Vector2D = bias.minus(vb2.minus(vb1))

			var jb:Vector2D = new Vector2D(vbr.dot(k1), vbr.dot(k2));
			jBias = jBias.plus(jb);

			a.ApplyImpulse(jb.mult(-1), r1);
			b.ApplyImpulse(jb, r2);

			// compute relative velocity
			var v1:Vector2D = a.v.plus(r1.rightHandNormal().mult(a.w));
			var v2:Vector2D = b.v.plus(r2.rightHandNormal().mult(b.w));
			var vr:Vector2D = v2.minus(v1);

			// compute normal impulse
			var j:Vector2D = new Vector2D(-vr.dot(k1), -vr.dot(k2));
			jAcc = jAcc.plus(j);

			// apply impulse
			a.ApplyImpulse(j.mult(-1), r1);
			b.ApplyImpulse(j, r2);
		}
		
		public override function draw( g:Graphics , drawBB:Boolean ):void {

			g.lineStyle(2, 0x333333);
			g.moveTo(a.p.x , a.p.y );
			g.lineTo(b.p.x , b.p.y );

		}
	}
}