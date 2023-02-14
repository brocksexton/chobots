package com.kavalok.admin.statistics.data
{
	import org.goverla.collections.ArrayList;
	import org.goverla.events.MultipageEvent;
	import org.goverla.interfaces.IMultipage;

	public class PagedDataProvider extends ArrayList implements IMultipage
	{
		private var _itemsPerPage : Number;
		private var _currentPage : Number = 0;
		private var _itemsTotal : Number = 0;
		private var _pagesTotal : Number = 0;

		public function PagedDataProvider(itemsPerPage : uint = 24)
		{
			super();
			_itemsPerPage = itemsPerPage;
		}
		
		public function get currentIndex():Number
		{
			return itemsPerPage * currentPage;
		}
		
		public function get itemsTotal():Number
		{
			return _itemsTotal;
		}
		
		public function set itemsTotal(value : Number) : void
		{
			if(itemsTotal != value)
			{
				_itemsTotal = value;
				dispatchEvent(new MultipageEvent(MultipageEvent.ITEMS_TOTAL_CHANGE));
				dispatchEvent(new MultipageEvent(MultipageEvent.PAGES_TOTAL_CHANGE));
			}
		}

		public function get currentPage():Number
		{
			return _currentPage;
		}
		
		public function get pagesTotal():Number
		{
			return Math.ceil(itemsTotal / itemsPerPage);
		}
		
		public function get itemsPerPage():Number
		{
			return _itemsPerPage;
		}
		
		public function changePage(pageNumber:Number, eventType:String=null):void
		{
			_currentPage = pageNumber;
			reload();
		}

		public function reload() : void{}
		
		protected function reset(data : Array) : void
		{
			removeAll();
			addItems(data);
			dispatchEvent(new MultipageEvent(MultipageEvent.CURRENT_PAGE_CHANGE));
		}
		protected function onGetData(result : Object) : void
		{
			reset(result.data);
			itemsTotal = result.totalItems;
		}
		
	}
}