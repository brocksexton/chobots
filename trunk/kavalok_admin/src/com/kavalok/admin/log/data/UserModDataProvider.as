package com.kavalok.admin.log.data
{
    import com.kavalok.admin.statistics.data.PagedDataProvider;
	import com.kavalok.services.AdminService;
	
	import mx.controls.Text;
	
	public class UserModDataProvider extends PagedDataProvider
	{
		[Bindable]
		public var text : String;
		
		
		public function UserModDataProvider()
		{
		  super(20);
		}
		
		override public function reload() : void
		{
		    super.reload();
			new AdminService(onGetData).getModMessages(currentPage * itemsPerPage, itemsPerPage);
		}
		
		/*private function onGetData(result : String):void
		{
		   text = result;
		}*/

	}
}