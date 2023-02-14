package com.kavalok.dto.infoPanel
{
	[RemoteClass(alias="com.kavalok.dto.infoPanel.InfoPanelAdminTO")]
	public class InfoPanelAdminTO
	{
		[Bindable]
		public var id:int=-1;
		
		[Bindable]
		public var created:Date
		
		[Bindable]
		public var caption:String;
		
		[Bindable]
		public var enabled:Boolean;
		
		[Bindable]
		public var data:String
		
		public function InfoPanelAdminTO()
		{
		}

	}
}