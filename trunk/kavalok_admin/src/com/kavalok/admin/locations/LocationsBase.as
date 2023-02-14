package com.kavalok.admin.locations
{
	import com.kavalok.admin.servers.ServersData;
	import com.kavalok.services.AdminService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.ComboBox;

	public class LocationsBase extends VBox
	{
		
		public var serversComboBox : ComboBox;
		
		[Bindable]
		protected var serversData : ServersData = new ServersData();
		[Bindable]
		protected var dataProvider : Array = [];
		
		public function LocationsBase()
		{
			super();
//			new AdminService(onGetSharedObjects).getSharedObjects();
			dataProvider.push(new LocationInfo("Sweet Battle", ["locationRope", "gameSweetBattle"]));
			dataProvider.push(new LocationInfo("Garbage Collector", ["loc1", "gameGarbageCollector"]));
			dataProvider.push(new LocationInfo("Space Racing", ["loc5", "gameSpaceRacing"]));
		}
		
		
//		private function onGetSharedObjects(result : Array) : void
//		{
//			var provider : Array = [];
//			for each(var location : String in result)
//				provider.push({location : location});
//				
//			dataProvider = provider;
//		}
		
		internal function onClearClick(event : MouseEvent) : void
		{
			var info : LocationInfo = event.target.data;
			for each(var id : String in info.locations)
				clearLocation(id);
		}
		
		protected function clearLocation(id : String) : void
		{
			new AdminService().clearSharedObject(serversComboBox.selectedItem.id, id);
		}
	}
}
	internal class LocationInfo
	{
		public var name : String;
		public var locations : Array;
		
		public function LocationInfo(name : String, locations : Array)
		{
			this.name = name;
			this.locations = locations;
		}
		
	}
