package com.kavalok.admin.log.data
{
	import com.kavalok.services.AdminService;
	
	public class UserReport extends UserMessage
	{
		public var id : int;
		
		public function UserReport(login:String, userId : int, message:String, id : int)
		{
			super(login, userId, message, "process", "");
			this.id = id;
			info = "report";
			height=300;
		}

		override public function process():void
		{
			super.process();
			new AdminService().setReportProcessed(id);
			
		}
		
	}
}