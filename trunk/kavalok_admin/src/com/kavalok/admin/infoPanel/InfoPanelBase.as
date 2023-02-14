package com.kavalok.admin.infoPanel
{
	import com.kavalok.dto.infoPanel.InfoPanelAdminTO;
	import com.kavalok.services.InfoPanelService;
	import mx.containers.Box;
	import mx.events.ListEvent;
	import org.goverla.collections.ArrayList;
	
	public class InfoPanelBase extends Box
	{
		[Bindable]
		public var infoList:ArrayList;
		
		[Bindable]
		public var infoItem:InfoItem;
		
		[Bindable]
		public var selectedItem:InfoPanelAdminTO;
		
		public function InfoPanelBase()
		{
			refresh();
		}
		
		protected function refresh():void
		{
			new InfoPanelService(onGetData).getEntities();
		}
		
		private function onGetData(result:Array):void
		{
			infoList = new ArrayList(result);
		}
		
		protected function onAddClick():void
		{
			 selectedItem = new InfoPanelAdminTO()
		}
		
		protected function onItemClick(e:ListEvent):void
		{
			 selectedItem = InfoPanelAdminTO(e.itemRenderer.data);
		}
	}
	
}