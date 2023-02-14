package com.kavalok.gameHunting.data
{
	import com.kavalok.remoting.DataObject;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class HealthData extends DataObject
	{
		public var health:int;
		public var charId:String;
		public var shellName:String;
		
		public function HealthData(data:Object = null)
		{
			super(data);
		}
		
	}
	
}