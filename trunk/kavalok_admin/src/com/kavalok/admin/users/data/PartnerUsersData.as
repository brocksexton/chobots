package com.kavalok.admin.users.data
{
	import com.kavalok.admin.statistics.data.PagedDataProvider;
	import com.kavalok.services.PartnersService;

	public class PartnerUsersData extends PagedDataProvider
	{
		public var from : Date;
		public var to : Date;
		public var useDates : Boolean;
		
		public function PartnerUsersData(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			if(useDates)
			{
				new PartnersService(onGetData).getUsersByDates(from, to, currentIndex, itemsPerPage);
			}
			else
			{
				new PartnersService(onGetData).getUsers(currentIndex, itemsPerPage);
			}
		}
		
		
		
	}
}