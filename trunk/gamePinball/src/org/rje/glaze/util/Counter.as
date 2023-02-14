/**
* ...
* @author Default
* @version 0.1
*/

package org.rje.glaze.util {

	public class Counter {
	
		public var counter:int;
		
		public var totalcounter:int;
		
		public var cycleCount:int;
		
		public var min:Number = 0;
		public var max:Number= 0;
		public var mean:Number= 0;
		
		public var name:String;
		
		public function Counter( name:String ) {
			this.name = name;
			reset();
		}
		
		public function endCycle():void {
			cycleCount++;
			if (counter < min) min = counter;
			if (counter > max) max = counter;
			totalcounter += counter;
			//mean = totalcounter / cycleCount;
			mean = (0.5 * mean) + ((1 - 0.5) * (counter));
			counter = 0;
		}
		
		public function reset():void {
			counter = 0;
			totalcounter = 0;
			cycleCount = 0;
			min = Number.MAX_VALUE;
			max = Number.MIN_VALUE;
			mean = 0;
		}
		
		public function toString():String {
			var result:String = name +":  min=" + min + "  max=" + max + "  mean=" + int(mean) + "  totalcycles=" + cycleCount+"\n";
			return result;
		}
		
	}
	
}
