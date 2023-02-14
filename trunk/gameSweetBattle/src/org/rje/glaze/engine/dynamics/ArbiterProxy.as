package org.rje.glaze.engine.dynamics 
{
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class ArbiterProxy {
		
		public static var arbiterProxyPool:ArbiterProxy;
		
		public var arbiter:Arbiter;
		
		public var next:ArbiterProxy;
		public var prev:ArbiterProxy;
		
		public var sentinel:Boolean;
		
		public static var c:int = 0;
		
		public function ArbiterProxy() {
			//trace("new " + c++);
		}
		
	}
	
}