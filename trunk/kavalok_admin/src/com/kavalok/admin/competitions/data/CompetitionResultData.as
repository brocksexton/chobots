package com.kavalok.admin.competitions.data
{
	import com.kavalok.admin.statistics.data.PagedDataProvider;
	import com.kavalok.dto.CompetitionTO;
	import com.kavalok.services.CompetitionDataService;

	public class CompetitionResultData extends PagedDataProvider
	{
		public var competition : CompetitionTO;
		
		public function CompetitionResultData(itemsPerPage:uint=24)
		{
			super(itemsPerPage);
		}
		
		override public function reload():void
		{
			new CompetitionDataService(onGetData).getCompetitionResults(competition.name, currentIndex, itemsPerPage);
		}
		
	}
}