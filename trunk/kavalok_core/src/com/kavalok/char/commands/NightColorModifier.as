package com.kavalok.char.commands
{
	import com.kavalok.Global;
	import com.kavalok.location.LocationBase;
		import com.gskinner.geom.ColorMatrix;
	import flash.display.MovieClip;
	import com.kavalok.services.AdminService;
	import flash.display.Sprite;
		import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	public class NightColorModifier extends StuffCommandBase
	{
		public var color:int;
		public var outsideLocations:Array = new Array("loc3", "locEco", "loc1", "loc0", 
			"locBeach", "loc2", "loc5", "locationRope", 
			"locRobots", "locMusic", "locForest", "locPark",
			 "locAcademyStreet");
		public var decoratedLocations:Array = new Array("loc3");
		
		override public function apply():void
		{
		
		}

		private function gotDarkness(result:Boolean):void
		{
			
             if(result){
             Global.locationManager.locationChange.addListener(setColor);
			if (Global.locationManager.locationExists){

				setColor();
			}
				} else {
					restore();
				}
		}
		
		private function setColor():void
		{
			if(outsideLocations.indexOf(Global.charManager.location) != -1){
			
			if(decoratedLocations.indexOf(Global.charManager.location) != -1)
			{
				decor.alpha = 100;
			}
		   var b:Number = parseFloat("10") / 100;
		 allContent.transform.colorTransform =	new ColorTransform(0.9, 0.9, 1);
			trace("changedloc");
		  var matrix:ColorMatrix = new ColorMatrix();
		  matrix.adjustColor(-70, 0, -20, 0);
		  allContent.filters = [new ColorMatrixFilter(matrix)];
		}
		}
	
		
		override public function restore():void
		{
	//		Global.locationManager.locationChange.addListener(setColor);
			//if (Global.locationManager.locationExists)
			//	resetColor();
		}
		
		private function resetColor():void
		{
		   var matrix:ColorMatrix = new ColorMatrix();
		   matrix.adjustColor(0, 0, 0, 0);
		   allContent.filters = [new ColorMatrixFilter(matrix)];
		   allContent.transform.colorTransform = new ColorTransform(1,1,1);
		   if(decoratedLocations.indexOf(Global.charManager.location) != -1)
			{
				decor.alpha = 0;
			}
		}
		
		public function get content():Sprite
		{
			return MovieClip(location.content)['background'] as Sprite;
		}
		
		public function get allContent():Sprite
		{
			return location.content;
		}
		
		public function get darkness():Sprite
		{
			return MovieClip(location.content)['darkness'] as Sprite;
		}

		public function get decor():Sprite
		{
			return MovieClip(location.content)['decor'] as Sprite;
		}
		
		private function get location():LocationBase
		{
			return Global.locationManager.location;
		}
	
	}
}