package com.kavalok.admin.competitions
{
	import com.kavalok.admin.competitions.data.CompetitionResultData;
	import com.kavalok.admin.controls.DateTimeChooser;
	import com.kavalok.dto.CompetitionTO;
	import com.kavalok.services.CompetitionDataService;
	import com.kavalok.utils.Strings;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.CheckBox;
	import mx.formatters.DateFormatter;

	public class CompetitionsBase extends HBox
	{
		
		public var startChooser : DateTimeChooser;
		public var finishChooser : DateTimeChooser;
		[Bindable]
		protected var selectedCompetition : CompetitionTO;

		[Bindable]
		protected var results : Array;
		[Bindable]
		protected var competitions : Array;
		
		[Bindable]
		protected var resultsData : CompetitionResultData = new CompetitionResultData();
		
		[Bindable]
		internal var formatter : DateFormatter = new DateFormatter();
		public function CompetitionsBase()
		{
			super();
			formatter.formatString = "YYYY-MM-DD HH";		
		}
		
		protected function refresh() : void
		{
			new CompetitionDataService(onGetCompetitions).getCompetitions();
		}
		
		internal function formatDate(date : Date) : String
		{
			var format : String = "{0}-{1}-{2}:{3}h"
			return Strings.substitute(format, date.fullYearUTC, date.monthUTC + 1, date.dateUTC, date.hoursUTC);
		}
		
		internal function onStartedChange(event : Event) : void
		{
			var checkBox : CheckBox = CheckBox(event.target);
			var competition : CompetitionTO = CompetitionTO(checkBox.data);
			var start : Date = checkBox.selected ? toUTC(startChooser.value) : new Date(0);
			var finish : Date = checkBox.selected ? toUTC(finishChooser.value) : new Date(0);
			
			new CompetitionDataService().startCompetition(competition.name, start, finish);
			competition.open = checkBox.selected;
			competition.start = start;
			competition.finish = finish;
			var temp : CompetitionTO = competition;
			competition = null;
			competition = temp;
		}
		
		private function toUTC(value : Date) : Date
		{
			return new Date(value.time - value.timezoneOffset * 60 * 1000);
		}

		internal function onCompetitionClear(event : MouseEvent) : void
		{
			var data : CompetitionTO = event.target.data;
			new CompetitionDataService().clearCompetition(data.name);
		}
		internal function onCompetitionSelect(event : MouseEvent) : void
		{
			var data : CompetitionTO = event.target.data;
			selectedCompetition = data;
			resultsData.competition = selectedCompetition;
			resultsData.reload();
		}
		private function onGetCompetitions(result : Array) : void
		{
			competitions = result;
		}
		
		
	}
}