package com.kavalok.loc3
{
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.ModelsFactory;
	import com.kavalok.loc3.entryPoints.MoneyEntryPoint;
	
	import flash.display.MovieClip;

	public class Location extends LocationBase
	{
		public function Location(locId:String)
		{
			super(locId);
			_charModelsFactory = new ModelsFactory();
			setContent(new Background());
			addPoint(new MoneyEntryPoint(this));
		}
		
	}
}