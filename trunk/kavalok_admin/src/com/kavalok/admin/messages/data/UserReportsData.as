package com.kavalok.admin.messages.data
{
	import com.kavalok.admin.statistics.data.PagedDataProvider;
	import com.kavalok.dto.UserReportTO;
	import com.kavalok.services.AdminService;

	public class UserReportsData extends PagedDataProvider
	{
		public function UserReportsData(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			super.reload();
			new AdminService(onGetData).getReports(currentPage * itemsPerPage, itemsPerPage);
		}
		
		override protected function onGetData(result:Object):void
		{
			var list : Array = result.data;
			for each(var report : UserReportTO in list)
			{
				report.text = report.text.replace(new RegExp(report.login, "gm"), "<b>" + report.login + "</b>");
			}
			super.onGetData(result);
		}
	}
}