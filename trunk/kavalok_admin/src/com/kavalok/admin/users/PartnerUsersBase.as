package com.kavalok.admin.users
{
	import com.kavalok.admin.controls.DateRangeChooser;
	import com.kavalok.admin.users.data.PartnerUsersData;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.VBox;
	import mx.controls.CheckBox;

	public class PartnerUsersBase extends VBox
	{
		[Bindable]
		public var dateRangeChooser : DateRangeChooser;
		[Bindable]
		public var useDatesCheckBox : CheckBox;
		
		[Bindable]
		protected var dataProvider : PartnerUsersData = new PartnerUsersData();
		
		public function PartnerUsersBase()
		{
			super();
			BindingUtils.bindProperty(dataProvider, "to", this, ["dateRangeChooser","to"]); 
			BindingUtils.bindProperty(dataProvider, "from", this, ["dateRangeChooser","from"]); 
			BindingUtils.bindProperty(dataProvider, "useDates", this, ["useDatesCheckBox","selected"]); 
			dataProvider.reload();
		}
		
	}
}