package com.kavalok.admin.statistics
{
	import com.kavalok.services.StatisticsService;
	
	import mx.containers.VBox;
	import mx.controls.DateChooser;
	
	import org.goverla.collections.ArrayList;

	public class StatisticsBase extends VBox
	{
		
		[Bindable]
		public var permissionLevel : int;

		public function StatisticsBase()
		{
			super();
		}
		
	}
}