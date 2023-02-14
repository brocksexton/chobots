package com.kavalok.admin.statistics
{
	import com.kavalok.admin.statistics.data.MembersAgeItem;
	import com.kavalok.dto.statistics.MembersAgeTO;
	import com.kavalok.services.StatisticsService;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;
	
	import mx.charts.CategoryAxis;
	import mx.charts.HitData;
	import mx.charts.series.ColumnSeries;
	import mx.controls.ComboBox;

	public class MembersAgeBase extends StatisticsPageBase
	{
		private static const DATA_ITEM_FORMAT : String = "{0} month(es): {1} ({2})% \n";
		private static const DATA_TIP_FORMAT : String = "{0} total : {1} ({2})%";
		public var periodComboBox : ComboBox;

		[Bindable]
		protected var series : Array
		[Bindable]
		protected var periods : Array = [{period : 24*3600, label : "1 day"}, {period : 10*24*3600, label : "10 days"}
			, {period : 20*24*3600, label : "20 days"}, {period : 30*24*3600, label : "30 days"}];


		[Bindable]
		protected var dataProvider : Array

		
		public function MembersAgeBase()
		{
			super();
		}
		
		private function get totalMemberships() : int
		{
			var result : int = 0;
			for each(var item : MembersAgeItem in dataProvider)
				result += item.total;
			return result;
			
		}
		
		protected function getDataTip(hitData : HitData) : String
		{
			var item : MembersAgeItem = MembersAgeItem(hitData.item);
			var total : Number = item.total;
			var result : String = "";
			for(var prop : String in item)
			{
				result += Strings.substitute(DATA_ITEM_FORMAT, prop, item[prop], Math.floor(item[prop]/total * 100));
			}
			result = Strings.substitute(DATA_TIP_FORMAT, result, total, Math.floor(total/totalMemberships * 100));
			return result;
		}
		protected function getLabel(userAge : int,index : int, axis : CategoryAxis, item : MembersAgeItem) : String
		{
			return String((item.userAge + 1) * periodComboBox.selectedItem.period / 24 / 3600) ;
		}
		protected function onRefreshClick(event : MouseEvent) : void
		{
			new StatisticsService(onGetData).getMembersAge(minDate, maxDate, periodComboBox.selectedItem.period);
		}
		
		private function onGetData(result : Array) : void
		{
			var monthes : Array = [];
			var resultData : Array = [];
			var currentItem : MembersAgeItem;
			for each(var item : MembersAgeTO in result)
			{
				if(monthes.indexOf(item.periodMonth) == -1)
					monthes.push(item.periodMonth);
				if(currentItem == null || item.userAge != currentItem.userAge)
				{
					if(currentItem)
					{
						var age : int = currentItem.userAge;
						while(item.userAge > age + 1)
						{
							age++;
							currentItem = new MembersAgeItem();
							currentItem.userAge = age;
							resultData.push(currentItem);
						}
					}
					currentItem = new MembersAgeItem();
					resultData.push(currentItem);
					currentItem.userAge = item.userAge;
				}
				currentItem[item.periodMonth] = item.userCount;
			}
			monthes.sort(Array.NUMERIC);
			var newSeries : Array = [];
			for each(var monthCount : int in monthes)
			{
				var serie : ColumnSeries = new ColumnSeries();
				serie.yField = monthCount.toString();
				serie.xField = "userAge";
				serie.displayName = monthCount + " month citizenship purchsed";
				newSeries.push(serie);
			}
			series = newSeries;
			dataProvider = resultData;
		}
	}
}