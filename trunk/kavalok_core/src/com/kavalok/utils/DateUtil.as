package com.kavalok.utils
{
	public class DateUtil
	{
		static public function toString(date:Date):String
		{
			var day:String = (date.date < 10)
				? '0' + date.date
				: '' + date.date;
				
			var month:String = (date.month + 1 < 10)
				? '0' + (date.month + 1)
				: '' + (date.month + 1);
				
			var year:String = date.fullYear.toString();
			
			return day + '.' + month + '.' + year; 
		}
		
		static public function insertDate(insertIntoText:String, date:Date):String
		{
			var month:String =  date.getMonth()+1<10?"0"+(date.getMonth()+1):""+(date.getMonth()+1);
			var hours:String = date.getHours()<10?"0"+date.getHours():""+date.getHours();
			var mins:String = date.getMinutes()<10?"0"+date.getMinutes():""+date.getMinutes();
			
			return Strings.substitute(insertIntoText, 
									date.getDate(), 
									month,
									date.getFullYear(), 
									hours, 
									mins
								);
			
		}
	}
}