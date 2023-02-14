package com.kavalok.admin.statistics
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.StringUtil;
	
	import org.goverla.utils.TimeUtils;
	
	public class StatisticsUtil
	{
		public static function dateToString(data : Object, column : DataGridColumn) : String
		{
			var date : Date = data.secondsInGame || new Date(0);
			return TimeUtils.getTimeString(date.time);
		}
		public static function toTimeString(data : Object, column : DataGridColumn) : String
		{
			return TimeUtils.getTimeString(data.secondsInGame * 1000);
		}

		public static function dateLabel(chartData : Object, data : Object) : String
		{
			var date : Date = data.date as Date;
   			return StringUtil.substitute("{0}/{1}/{2}", date.date, date.month + 1, date.fullYear);
		}

		public static function toChartTimeString(chartData : Object, data : Number) : String
		{
			return TimeUtils.getTimeString(data * 1000);
		}

	}
}