package com.kavalok.remoting.commands
{
   import com.gskinner.geom.ColorMatrix;
   import com.kavalok.Global;
   import com.kavalok.location.LocationBase;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   
   public class NightOffMode extends ServerCommandBase
   {
      public var outsideLocations:Array;
      public var color:int;
      public var decoratedLocations:Array;
      
      public function NightOffMode()
      {
         outsideLocations = new Array("loc3","locEco","loc1","loc0","locBeach","loc2","loc5","locationRope","locRobots","locMusic","locBackyard","locWinterPark","locForest","locPark","locAcademy");
         decoratedLocations = new Array("");
         super();
      }
      
      private function setColor() : void
      {
         var b:Number = NaN;
         var matrix:ColorMatrix = null;
         if(outsideLocations.indexOf(Global.charManager.location) != -1)
         {
            if(decoratedLocations.indexOf(Global.charManager.location) != -1)
            {
               decor.alpha = 0;
            }
            b = parseFloat("10") / 100;
            allContent.transform.colorTransform = new ColorTransform(1,1,1);
            matrix = new ColorMatrix();
            matrix.adjustColor(0,0,0,0);
            allContent.filters = [new ColorMatrixFilter(matrix)];
         }
      }
      
      public function get decor() : Sprite
      {
         return MovieClip(location.content)["decor"] as Sprite;
      }
      
      public function get darkness() : Sprite
      {
         return MovieClip(location.content)["darkness"] as Sprite;
      }
      
      override public function execute() : void
      {
         if(!Global.acceptNight)
         {
			if(Global.locationManager.locationExists)
			{
				setColor();
			}
         }
      }
      
      public function get allContent() : Sprite
      {
         return location.content;
      }
      
      public function get content() : Sprite
      {
         return MovieClip(location.content)["background"] as Sprite;
      }
      
      private function get location() : LocationBase
      {
         return Global.locationManager.location;
      }
   }
}
