package org.goverla.interfaces {

    import flash.events.IEventDispatcher;
    
    import mx.collections.ICollectionView;

	[Event(name="itemsTotalChange", type="com.tearaway.controls.pager.events.MultipageEvent")]
	
	[Event(name="pagesTotalChange", type="com.tearaway.controls.pager.events.MultipageEvent")]
	
	[Event(name="currentPageChange", type="com.tearaway.controls.pager.events.MultipageEvent")]

	/**
	 * @author Tyutyunnyk Eugene
	 */
	public interface IMultipage extends IEventDispatcher, ICollectionView {

		function get itemsTotal() : Number;

		function get currentPage() : Number;
		
		function get pagesTotal() : Number;
		
		function get itemsPerPage() : Number;
		
		function changePage(pageNumber : Number, eventType : String = null) : void;

	}
}