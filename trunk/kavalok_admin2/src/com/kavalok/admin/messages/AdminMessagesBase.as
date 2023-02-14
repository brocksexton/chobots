package com.kavalok.admin.messages
{
	import com.kavalok.admin.messages.data.AdminMessagesData;
	import com.kavalok.admin.messages.events.ProcessedEvent;
	import com.kavalok.services.AdminService;
	
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	import org.goverla.controls.SizableTextArea;

	public class AdminMessagesBase extends VBox
	{
		
		public var dataGrid : DataGrid;
		[Bindable]
		protected var dataProvider : AdminMessagesData = new AdminMessagesData();

		[Bindable]
		protected var textFactory : ClassFactory = new ClassFactory(SizableTextArea);
		
		public function AdminMessagesBase()
		{
			super();
			textFactory.properties = {editable : false, verticalScrollPolicy:'on'};
		}
		
		protected function onInitialize(event : FlexEvent) : void
		{
			dataGrid.addEventListener(ProcessedEvent.PROCESSED, onItemProcessed);
		}
		
		private function onItemProcessed(event : ProcessedEvent) : void
		{
			new AdminService().setMessageProcessed(event.id);
		}
		
	}
}