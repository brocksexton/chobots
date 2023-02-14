package com.kavalok.admin.users.filters
{
	import com.kavalok.admin.users.data.FilterConfig;
	import com.kavalok.dto.admin.FilterTO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Box;
	import mx.controls.ComboBox;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.events.TargetEvent;

	[Event(name="change", type="flash.events.Event")]
	public class FiltersListBase extends Box
	{
		
		[Bindable]
		public var selectFilterComboBox : ComboBox;

		[Bindable]
		public var filtersConfig : ArrayList;
		
		private var _dataProvider : ArrayList = new ArrayList();
		
		public function FiltersListBase()
		{
			super();
		}
		[Bindable]
		public function set dataProvider(value: ArrayList) : void
		{
			_dataProvider = value;
			dispatchChange();
		}
		public function get dataProvider() : ArrayList
		{
			return _dataProvider;
		}
		
		protected function onAddFilterClick(event : MouseEvent) : void
		{
			var config : FilterConfig = FilterConfig(selectFilterComboBox.selectedItem);
			dataProvider.addItem(new FilterTO(config.fieldName, config.filterType, config.value));
			dispatchChange();
		}
		
		protected function createFilter(filterData : FilterTO) : FilterBase
		{
			var filter : FilterBase = new filterData.filterType();
			filter.filterData = filterData;
			filter.change.addListener(onFilterChange);
			filter.remove.addListener(onFilterRemove);
			return filter;
		}
		
		private function dispatchChange() : void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onFilterChange() : void
		{
			dispatchChange();
		}
		
		private function onFilterRemove(event : TargetEvent) : void
		{
			var data : FilterTO = FilterBase(event.target).filterData;
			dataProvider.removeItem(data);
			dispatchChange();
		}
		
	}
}