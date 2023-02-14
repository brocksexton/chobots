package com.kavalok.location.modifiers
{
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.location.LocationBase;
	
	public class LocationModifierBase
	{
		public var location:LocationBase
		public var parameters:Object;
		
		public function LocationModifierBase()
		{
			super();
		}
		
		public function apply():void
		{
			throw new NotImplementedError();
		}
		
		public function restore():void
		{
			throw new NotImplementedError();
		}
	}
}