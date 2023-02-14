package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.location.LocationBase;
	
	public class StuffCommandBase
	{
		public var stuff:StuffItemLightTO;
		public var parameters:Object;
		
		public function StuffCommandBase()
		{
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