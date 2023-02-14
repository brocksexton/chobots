/**
 * glaze - 2D rigid body dynamics & game engine
 * Copyright (c) 2008, Richard Jewson
 * 
 * This project also contains work derived from the Chipmunk & APE physics engines.  
 * Copyright (c) 2007 Scott Lembcke
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package org.rje.glaze.engine.collision.shapes {

	import flash.display.Graphics;
	
	import org.rje.glaze.engine.*;
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.dynamics.*;
	
	public class Circle extends GeometricShape {
		
		public var c:Vector2D;
		public var r:Number;
		
		public var tC:Vector2D;
		
		public function Circle( radius:Number , offset:Vector2D, material:Material = null) {
			super(GeometricShape.CIRCLE_SHAPE, material);
			InitShape(offset, radius);
		}
		
		public override function InitShape( offset:Vector2D, shapeData1:*, shapeData2:* = null, shapeData3:* = null ):* {
			this.offset = offset.clone();
			c = offset.clone();
			r = shapeData1 as Number;
			area = Math.PI * (r * r);
			tC = c.clone();
			//aabb.xExtent = aabb.yExtent = r;
		}
		
		public override function UpdateShape( p:Vector2D, rot:Vector2D ):void {
			//aabb.xCenter = 
			tC.x = p.x + (c.x * rot.x - c.y * rot.y);
			//aabb.yCenter = 
			tC.y = p.y + (c.x * rot.y + c.y * rot.x);
			aabb.l = tC.x - r;
			aabb.r = tC.x + r;
			aabb.t = tC.y - r;
			aabb.b = tC.y + r;
		}
		
		public override function ContainsPoint(point:Vector2D):Boolean {
			var x:Number = tC.x - point.x;
			var y:Number = tC.y - point.y;
			return (x * x + y * y) <= (r * r);
		}
		
		public override function IntersectRay( ray:Ray ):Boolean {
			var dist:Vector2D = ray.origin.minus(tC);
			var b:Number = dist.dot(ray.direction);					
			if (b > 0) return false;					//Circle is behind the origin
			var d:Number = (r * r) - (dist.dot(dist) - (b * b));
			if (d < 0) return false;   					//Ray is not pointing towards the origin
			d = -b-Math.sqrt(d);
			return ray.reportResult(this, d, ray.returnNormal ? new Vector2D((ray.origin.x + (ray.direction.x * d)) - tC.x, (ray.origin.y + (ray.direction.y * d)) - tC.y).normalizeEquals() : null);
		}
		
		
		public override function CalculateInertia( m:Number , offset:Vector2D ):Number {
			return (1 / 2) * m * (r * r) + m * offset.dot(offset);
		}
		
		public override function draw( g:Graphics , drawBB:Boolean , overrideColour:Boolean = false , overrideColourValue:uint = 0x000000 ):void {
			var v:Vector2D;
			g.lineStyle(1, 0x000000);
			if (drawBB) g.drawRect(aabb.l, aabb.t, aabb.r - aabb.l, aabb.b - aabb.t);
			if (drawBB&&body.isSleeping) 
				g.beginFill(0xE6DC64);
			else
				g.beginFill(overrideColour?overrideColourValue:fillColour);
			g.lineStyle(2, lineColour);
			g.drawCircle(tC.x, tC.y, r);
			g.endFill();
		}
	}
}
