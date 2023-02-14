package com.kavalok.gameSweetBattle.physics
{
	public class ActionObject extends PhysicsObject
	{
		public var actionId : String;
		
		public function ActionObject(body:MasslesForceBody, actionId : String)
		{
			super(1, body);
			this.actionId = actionId;
		}
		
	}
}