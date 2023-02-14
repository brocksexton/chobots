package com.kavalok.questNichos
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	
	import flash.display.MovieClip;
	
	public class Quest
	{
		static public const NPC_LOCATION:String = Locations.LOC_MISSIONS;
 		
		public function Quest()
		{
			if (Global.locationManager.locationExists)
				onLocationChange();
				
			addListeners();
		}
		
		public function destroy():void
		{
			removeListeners();
		}
		

		private function onLocationChange():void
		{
			var locId:String = Global.locationManager.locationId;
			
			if (locId == NPC_LOCATION){
				var cowScreen : MovieClip = MovieClip(Global.locationManager.location.content.cowScreen);
				var nichosScreen : MovieClip = MovieClip(Global.locationManager.location.content.nichosScreen);
				var nichosEntry : MovieClip = MovieClip(Global.locationManager.location.content.nichosEntry);
				var cow4Entry : MovieClip = MovieClip(Global.locationManager.location.content.cow4Entry);
				cowScreen.visible=false;
				cow4Entry.visible=false;
				nichosScreen.x = 790;
				nichosScreen.y = 125;
				nichosEntry.x = cow4Entry.x;
				nichosEntry.y = cow4Entry.y;
			}
			
		}
		
		public function addListeners():void
		{
			Global.locationManager.locationChange.addListener(onLocationChange);
		}

		public function removeListeners():void
		{
			Global.locationManager.locationChange.removeListener(onLocationChange);
		}
		
		
	}
}