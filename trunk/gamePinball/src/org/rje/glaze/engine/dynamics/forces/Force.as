package org.rje.glaze.engine.dynamics.forces {
	
	/**
	* ...
	* @author Default
	*/
	public class Force {
		
		public var active:Boolean;
		
		public var prev:Force;
		public var next:Force;
		
		public function Force() {
			init();
		}
		
		public virtual function init():void {
			active = true;
		}
		
		public virtual function eval():void {
		}
		
	}
	
}