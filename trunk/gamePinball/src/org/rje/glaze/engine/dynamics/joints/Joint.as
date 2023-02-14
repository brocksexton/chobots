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
	
	public class Joint {
		
		public const joint_bias_coef:Number = 0.1;
		
		public var a:RigidBody;
		public var b:RigidBody;

		public var anchr1:Vector2D;
		public var anchr2:Vector2D;
		
		public var r1:Vector2D;
		public var r2:Vector2D;
		
		public var n:Vector2D;
		public var nMass:Number;
		
		public var prev:Joint;
		public var next:Joint;
		
		public function Joint( a:RigidBody , b:RigidBody ) {
			this.a = a;
			this.b = b;
			
			r1 = new Vector2D();
			r2 = new Vector2D();
			
			n = new Vector2D();
		}
		
		public virtual function PreStep( dt_inv:Number ):void {
		
		}
		
		public virtual function ApplyImpuse():void {
			
		}

		/** 
		 * Draws the joint to the supplied graphics context
		 */			
		public virtual function draw( g:Graphics , drawBB:Boolean ):void {
		}		
		
	}
	
}
