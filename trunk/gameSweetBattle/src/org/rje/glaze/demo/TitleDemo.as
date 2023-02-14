/**
 * glaze - 2D rigid body dynamics & game engine
 * Copyright (c) 2008, Richard Jewson
 * 
 * This project also contains work derived from the Chipmunk & APE physics engines.  
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

package org.rje.glaze.demo {

	import org.rje.glaze.engine.*;
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.dynamics.*;
	import org.rje.glaze.engine.collision.shapes.*;
	
	import org.rje.glaze.util.*;
	
	public class TitleDemo extends Demo {
		
		public function TitleDemo(fps:int, dim:Vector2D, bfAlgo:String) {
			super(dim,bfAlgo,5,fps,60);
			space.masslessForce.setTo(0, 0);
			title = "Title Demo";
		}
				
		public override function initSpace():void {

			createWord("glaze", 80, 180, 20, 0);
			//createWord("actionscript dynamics", 80,350, 8, 1); 
			
			var material:Material = new Material(0.1, 0.7, 3);
			
			var stick1:RigidBody = addPolyAsNewBody( -100 , 0 , 0 , Polygon.createRectangle(100, 20) , material );
			stick1.v.setTo( 80, 40);
			stick1.w = 3;
	
			var stick2:RigidBody = addPolyAsNewBody( 700 , 600 , 0 , Polygon.createRectangle(100, 20) , material  );
			stick2.v.setTo( -80, -40);
			stick2.w = -1;
			
			var stick3:RigidBody = addPolyAsNewBody( 290 , 750 , 0 , Polygon.createBlobConvexPoly(3,30) , material );
			stick3.v.setTo( 10, -50);
			stick3.w = .2;
	
		}
		
		public function createWord(str:String,xStart:Number, yStart:Number , pixelSize:int = 10 , pixelSpace:int = 2):void {
			var startpos:int = 0;
			for (var i:int = 0; i < str.length; i++) {
				var v:int = str.charCodeAt(i) - 97;
				
				startpos += createLetter(  v, xStart + startpos, 	yStart, pixelSize, pixelSpace);
				//startpos += createBodyFromLetter(  v, xStart + startpos, 	yStart, pixelSize, pixelSpace);
			}

		}
		
		public function createLetter( letter:int , xStart:Number, yStart:Number , pixelSize:int = 10 , pixelSpace:int = 2 ):int {
			if (letter == 32) { 
				return 2 * pixelSize;
			}
			var letterArray:Array = FontArray.lowerCase[letter];
			if (letterArray == null) return 0;
			
			var maxX:int = 0;
			for (var y:int = 0; y < FontArray.height ; y++) {
				for (var x:int = 0; x < FontArray.width ; x++) {
					if (letterArray[ y * FontArray.width + x] == 1) {
						if (maxX < x) maxX = x;
						var body:RigidBody = addPolyAsNewBody( xStart + x * (pixelSize + pixelSpace) , yStart + y * (pixelSize + pixelSpace) , 0 , Polygon.createRectangle(pixelSize, pixelSize) );
						body.memberShapes[0].fillColour = 0xA0B4ED;
						//body.rotationLocked = true;
					}
					
				}
			}
			return (maxX+2) * (pixelSize + pixelSpace);
		}
		
		public function createBodyFromLetter( letter:int , xStart:Number, yStart:Number , pixelSize:int = 10 , pixelSpace:int = 2 ):int {

			var letterArray:Array = FontArray.lowerCase[letter];
			
			var maxX:int = 0;
			for (var y:int = 0; y < FontArray.height ; y++) {
				for (var x:int = 0; x < FontArray.width ; x++) {
					if (letterArray[ y * FontArray.width + x] == 1) {
						if (maxX < x) maxX = x;
						addPolyAsNewBody( xStart + x * (pixelSize + pixelSpace) , yStart + y * (pixelSize + pixelSpace) , 0 , Polygon.createRectangle(pixelSize, pixelSize) );
					}
					
				}
			}
			return (maxX+2) * (pixelSize + pixelSpace);
		}
		
	}
	
}
