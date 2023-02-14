package com.kavalok.quest
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	
	
	public class LocationQuestBase
	{

 		static public const LOCATIONS:Array =
 		[
	 		Locations.LOC_0,
	 		Locations.LOC_1,
	 		Locations.LOC_2,
	 		Locations.LOC_3,
	 		Locations.LOC_5,
	 		//Locations.LOC_ROPE,
	 		Locations.LOC_ACC_SHOP,
	 		Locations.LOC_CAFE,
			Locations.LOC_GRAPHITY,
			Locations.LOC_MAGIC_SHOP,
			Locations.LOC_ACADEMY,
			Locations.LOC_ACADEMY_ROOM,
			Locations.LOC_GAMES,
			Locations.LOC_ECO,
			Locations.LOC_ECO_SHOP
		/*	Locations.LOC_NICHOS,
			Locations.LOC_NICHOS1,
			Locations.LOC_NICHOS2,
			Locations.LOC_NICHOS3,
			Locations.LOC_NICHOS4,
			Locations.LOC_NICHOS5,
			Locations.LOC_NICHOS6,
			Locations.LOC_NICHOS7,
			Locations.LOC_NICHOS8,
			Locations.LOC_ACADEMY*/
			
		]

		private var _locationId : String;

		public function LocationQuestBase(locationId : String)
		{
			_locationId = locationId;
			Global.locationManager.locationChange.addListener(onLocationChange);
			
			onLocationChange();
		}

		public function destroy():void
		{
			Global.locationManager.locationChange.removeListener(onLocationChange);
		}
		
		protected function processTargetLocation() : void
		{
			
		}

		protected function processLocation(locationId : String) : void
		{
			
		}

		private function onLocationChange():void
		{
			var locId:String = Global.locationManager.locationId;
			
			if (locId == _locationId)
				processTargetLocation();
			
			processLocation(locId);
			
		}
		
	}
}