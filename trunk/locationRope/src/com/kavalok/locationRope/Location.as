package com.kavalok.locationRope
{
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.ModelsFactory;
	import com.kavalok.locationRope.entryPoints.RopeEntryPoint;
	
	import flash.display.MovieClip;

	public class Location extends LocationBase
	{
		public function Location(locId:String)
		{
			super(locId);
			_charModelsFactory = new ModelsFactory();
			setContent(new Background());
			
			MousePointer.registerObject(MovieClip(content).arrowLeft, MousePointer.BLOCKED);
			MousePointer.registerObject(MovieClip(content).arrowRight, MousePointer.BLOCKED);

			addPoint(new RopeEntryPoint(remoteId, this));
		}
		
	}
}