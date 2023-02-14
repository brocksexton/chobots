package com.kavalok.admin.graphity
{
	public class WallItem
	{
		[Bindable]
		public var server : Object;
		[Bindable]
		public var wallId : String;
		[Bindable]
		public var selected : Boolean = false;
		
		public function WallItem(server : Object, wallId : String)
		{
			this.server = server;
			this.wallId = wallId;
		}

	}
}