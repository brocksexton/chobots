package org.rje.glaze.engine.dynamics {

	
	/**
	* ...
	* @author Default
	*/
	public class BodyContact {
		
		public var contactCount:int;
		
		public var bodyA:RigidBody;
		public var bodyB:RigidBody;
		
		public var stamp:int;
		
		public var startContact:Boolean;
		public var endContact:Boolean;
		
		public var next:BodyContact;
		public var prev:BodyContact;
		public var sentinel:Boolean;
		
		public static var bodyContactPool:BodyContact;
		//public static var  c:int = 0 ;

		public function BodyContact( ) {
			//trace("new"+(c++));
			this.stamp = 0;
			contactCount = 0;
			startContact = true;
			endContact = false;
		}
		
	}
	
}