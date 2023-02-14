package org.goverla.collections {

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.goverla.constants.ListDataProviderPolicy;
	import org.goverla.events.ListDataProviderEvent;
	import org.goverla.events.MultipageEvent;
	import org.goverla.interfaces.IMultipage;
	import org.goverla.utils.common.FramedListResult;

	/**
	 * @author Tyutyunnyk Eugene
	 */
	public class AbstractListDataProvider extends ArrayList implements IMultipage {
		
		[Bindable(event="currentPageChange")]
		public function get currentPage() : Number {
			return _currentPage;
		}
	
		[Bindable(event="itemsTotalChange")]
		public function get itemsTotal() : Number {
			return _itemsTotal;
		}
		
		[Bindable]
		public function get itemsPerPage() : Number {
			return _itemsPerPage;
		}

		public function set itemsPerPage(itemsPerPage : Number) : void {
			// User can set -1 as itemsPerPage, in this case dataProvider returns all items
			_itemsPerPage = itemsPerPage;
			dispatchEvent(new MultipageEvent(MultipageEvent.PAGES_TOTAL_CHANGE));
		}
		
		[Bindable(event="pagesTotalChange")]
		public function get pagesTotal() : Number {
			return Math.ceil(itemsTotal / itemsPerPage);
		}
		
		[Bindable(event="pagesTotalChange")]
		public function get lastPage() : Number {
			return pagesTotal > 0 ? pagesTotal - 1 : 0;
		}
		
		[Bindable(event="currentPageChange")]
		public function get itemsOnCurrentPage() : Number {
			if (currentPage != lastPage) {
				return currentPage >=0 ? itemsPerPage : 0;
			} else {
				return (itemsTotal - itemsPerPage * lastPage);
			}
		}
		
		[Bindable(event="itemsLoadCompleteChange")]
		public function get itemsLoadComplete() : Boolean {
			return _itemsLoadComplete;
		}
		
		public function get addItemPolicy() : String {
			return _addItemPolicy;
		}
		
		public function set addItemPolicy(policy : String) : void {
			_addItemPolicy = policy;	
		}
		
		public function AbstractListDataProvider(itemsPerPage : Number) {
			super();
			this.itemsPerPage = itemsPerPage;
		}
	
		public function changePage(pageNumber : Number, eventType : String = null) : void {
			_currentPage = pageNumber;
			_currentEventType = (eventType == null) ? ListDataProviderEvent.REFRESH : eventType;
			refreshItems();
			////dispatchEvent(new MultipageEvent(MultipageEvent.CURRENT_PAGE_CHANGE));
		}
		
		public override function addItem(item : Object) : void {}
		
		public function editItem(item : Object) : void {}
		
		public override function removeItem(item : Object) : void {}
		
		public override function refresh() : Boolean {
			//super.refresh();
			if (_currentPage < 0) {
				_currentPage = 0;
				////dispatchEvent(new MultipageEvent(MultipageEvent.CURRENT_PAGE_CHANGE));
			}
			refreshItems();
			return false;
		}
		
		public override function removeAll() : void {
			super.removeAll();
			_currentPage = -1;
			_itemsTotal = 0;

			dispatchEvent(new MultipageEvent(MultipageEvent.ITEMS_TOTAL_CHANGE));
			dispatchEvent(new MultipageEvent(MultipageEvent.PAGES_TOTAL_CHANGE));
			
			dispatchEvent(new ListDataProviderEvent(ListDataProviderEvent.REFRESH));

			dispatchEvent(new MultipageEvent(MultipageEvent.CURRENT_PAGE_CHANGE));
			_prevActualCurrentPage = _currentPage;
		}
		
		protected function refreshItems() : void {
			if (currentPage < 0) {
				throw new IllegalOperationError("Can't refresh ListDataProvider when currentPage less of 0!");
			} else {
				_itemsLoadComplete = false;
				dispatchEvent(new Event("itemsLoadCompleteChange"));
			}
		}
		
		protected function onAddItem(result : Object) : void {
			_currentEventType = ListDataProviderEvent.ADD;
			switch (addItemPolicy) {
				case ListDataProviderPolicy.KEEP_CURRENT_PAGE :
					refreshItems(); 
					break;
					
				case ListDataProviderPolicy.GOTO_FIRST_PAGE :
					changePage(0, _currentEventType); 
					break;

				case ListDataProviderPolicy.KEEP_CURRENT_PAGE :
					changePage(lastPage, _currentEventType); 
					break;
			}
		}
		
		protected function onAddItemFault(result : Object) : void {
			_currentEventType = ListDataProviderEvent.ADD_FAULT;
			refreshItems();
		}
		
		protected function onEditItem(result : Object) : void {
			_currentEventType = ListDataProviderEvent.EDIT;
			refreshItems();
		}

		protected function onEditItemFault(result : Object) : void {
			_currentEventType = ListDataProviderEvent.EDIT_FAULT;
			refreshItems();
		}
		
		protected function onRemoveItem(result : Object) : void {
			_currentEventType = ListDataProviderEvent.REMOVE;
			refreshItems();
		}

		protected function onRemoveItemFault(result : Object) : void {
			_currentEventType = ListDataProviderEvent.REMOVE_FAULT;
			refreshItems();
		}
		
		protected function onRefreshItems(result : Object) : void {
			var newItemsTotal : Number = FramedListResult(result).totalCount;				
			
			if (_itemsTotal != newItemsTotal) {
				var oldPagesTotal : Number = pagesTotal;

 				_itemsTotal	= newItemsTotal;
                dispatchEvent(new MultipageEvent(MultipageEvent.ITEMS_TOTAL_CHANGE));
                
                var currentPageChanged : Boolean  = false;                
                if (_currentPage > lastPage) {
                    _currentPage = lastPage;
                    currentPageChanged = true;
                }                
                
       			if (oldPagesTotal != pagesTotal) {
       				dispatchEvent(new MultipageEvent(MultipageEvent.PAGES_TOTAL_CHANGE));				
       			}
   				
                if (currentPageChanged) {
    				////dispatchEvent(new MultipageEvent(MultipageEvent.CURRENT_PAGE_CHANGE));
                    refreshItems();
                    return;
                }
			}

   			initializeByArray(FramedListResult(result).frame);
   			
			dispatchEvent(new ListDataProviderEvent(_currentEventType));
			_currentEventType = ListDataProviderEvent.REFRESH;
			
			if (_prevActualCurrentPage != _currentPage) {
				dispatchEvent(new MultipageEvent(MultipageEvent.CURRENT_PAGE_CHANGE));
				_prevActualCurrentPage = _currentPage;
			}
			
			_itemsLoadComplete = true;
			dispatchEvent(new Event("itemsLoadCompleteChange"));
		}
		
		protected function onRefreshItemsFault(result : Object) : void {
			initializeByArrayCollection(new ArrayCollection());
			dispatchEvent(new ListDataProviderEvent(_currentEventType));
			dispatchEvent(new ListDataProviderEvent(ListDataProviderEvent.REFRESH_FAULT));			
			
			_itemsLoadComplete = true;
			dispatchEvent(new Event("itemsLoadCompleteChange"));
		}
		
        private var _currentEventType : String = ListDataProviderEvent.REFRESH;
		
		private var _currentPage : Number = -1;

		private var _prevActualCurrentPage : Number = -1;
		
		private var _itemsTotal : Number = 0;
		
		private var _itemsPerPage : Number;
		
		private var _addItemPolicy : String = ListDataProviderPolicy.GOTO_FIRST_PAGE;
	
		private var _itemsLoadComplete : Boolean;
		
	}

}