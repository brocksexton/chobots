package com.kavalok.admin.messages
{
	import com.kavalok.admin.log.data.UserDataProvider;
	import com.kavalok.admin.messages.data.UserReportsData;
	import com.kavalok.admin.messages.events.ProcessedEvent;
	import com.kavalok.services.AdminService;
	
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;

	[Event(name="showFamily", type="com.kavalok.admin.users.events.ShowFamilyEvent")]
	public class UserReportsBase extends VBox
	{
		[Bindable]
		public var dataGrid : DataGrid;
		[Bindable]
		public var permissionLevel : int;

		[Bindable]
		protected var dataProvider : UserReportsData = new UserReportsData();

		[Bindable]
		protected var userDataProvider : UserDataProvider = new UserDataProvider();
		
		public function UserReportsBase()
		{
			super();
		}
		
		protected function onInitialize(event : FlexEvent) : void
		{
			dataGrid.addEventListener(ProcessedEvent.PROCESSED, onItemProcessed);
		}
		
		internal function onUserSelect(report : Object) : void
		{
			userDataProvider.load(report.userId)
		}

		internal function onItemProcessed(report : Object) : void
		{
			new AdminService().setReportsProcessed(report.userId);
		}
	}
}