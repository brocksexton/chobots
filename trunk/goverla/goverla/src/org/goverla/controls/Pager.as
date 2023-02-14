package org.goverla.controls {
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.LinkBar;
	import mx.controls.Spacer;
	import mx.events.ItemClickEvent;
	import mx.utils.StringUtil;
	
	import org.goverla.constants.Images;
	import org.goverla.constants.StyleNames;
	import org.goverla.events.MultipageEvent;
	import org.goverla.interfaces.IMultipage;
	import org.goverla.interfaces.INavigator;
	import org.goverla.utils.CSSUtils;
	import org.goverla.utils.TextFormatter;
	import org.goverla.utils.common.Pair;

	[Style(name="itemsTotalColor", type="uint", format="Color")]

	/**
	 * @author Tyutyunnyk Eugene
	 * @author Sergey Kovalyov
	 */
	public class Pager extends HBox implements INavigator {
		
		protected static const LEFT : Class = Images.LEFT;
		
		protected static const RIGHT : Class = Images.RIGHT;
		
		protected static const ELLIPSIS : String = "...";		
		
		protected static const COLORED_TEMPLATE : String = "<font color='{0}'>{1}</font> {2}";
		
		protected static const UNCOLORED_TEMPLATE : String = "{0} {1}";
		
		private static const CLASS_NAME : String = "Pager";
		
        private static var classConstructed : Boolean = staticConstructor();

		public var backButton : Button;
		
		public var leftEdgeLinkBar : LinkBar;
		
		public var leftEllipsisLabel : Label;
		
		public var corePagesLinkBar : ExtendedLinkBar;
		
		public var rightEllipsisLabel : Label;
		
		public var rightEdgeLinkBar : LinkBar;
		
		public var forwardButton : Button;
		
		public var spacer : Spacer;
		
		public var itemsTotalLabel : Label;
		
		public function Pager() {
			super();
		}
		
		private static function staticConstructor() : Boolean {
        	CSSUtils.setDefaultStyles(CLASS_NAME,
        		new Pair(StyleNames.HORIZONTAL_GAP, 0),
        		new Pair(StyleNames.VERTICAL_ALIGN, "middle"));

			return true;
		}
		
 		public function get neighbourhood() : int {
 			return _neighbourhood;
 		}

 		public function set neighbourhood(neighbourhood : int) : void {
 			_neighbourhood = neighbourhood;
 		}
 		
 		public function get minGap() : int {
 			return _minGap;
 		}

 		public function set minGap(minGap : int) : void {
 			_minGap = minGap;
 		}
 		
 		public function get edge() : int {
 			return _edge;
 		}
 		
 		public function set edge(edge : int) : void {
 			_edge = edge;
 		}
 		
		public function get dataProvider() : IMultipage {
			return _dataProvider;
		}
		
		public function set dataProvider(dataProvider : IMultipage) : void {
			if (_dataProvider != null) {
				_dataProvider.removeEventListener(MultipageEvent.CURRENT_PAGE_CHANGE, onCurrentPageChange);
				_dataProvider.removeEventListener(MultipageEvent.PAGES_TOTAL_CHANGE, onPagesTotalChange);
				_dataProvider.removeEventListener(MultipageEvent.ITEMS_TOTAL_CHANGE, onItemsTotalChange);
			}

			_dataProvider = dataProvider;

			_dataProvider.addEventListener(MultipageEvent.CURRENT_PAGE_CHANGE, onCurrentPageChange);
			_dataProvider.addEventListener(MultipageEvent.PAGES_TOTAL_CHANGE, onPagesTotalChange);
			_dataProvider.addEventListener(MultipageEvent.ITEMS_TOTAL_CHANGE, onItemsTotalChange);

			currentPage = _dataProvider.currentPage;
			pagesTotal = _dataProvider.pagesTotal;
			itemsTotal = _dataProvider.itemsTotal;
 		}
 		
 		public function get itemsTotalTemplate() : String {
 			return _itemsTotalTemplate;
 		}
 		
 		public function set itemsTotalTemplate(itemsTotalTemplate : String) : void {
 			_itemsTotalTemplate = itemsTotalTemplate;
 			_itemsTotalTemplateChanged = true;
 			invalidateProperties();
 		}
 		
 		public function get singularForm() : String {
 			return _singularForm;
 		}
 		
 		public function set singularForm(singularForm : String) : void {
 			_singularForm = singularForm;
 			_singularFormChanged = true;
 			invalidateProperties();
 		}
 		
 		public function get pluralForm() : String {
 			return _pluralForm;
 		}
 		
 		public function set pluralForm(pluralForm : String) : void {
 			_pluralForm = pluralForm;
 			_pluralFormChanged = true;
 			invalidateProperties();
 		}
 		
 		public function get noForm() : String {
 			return _noForm;
 		}
 		
 		public function set noForm(noForm : String) : void {
 			_noForm = noForm;
 			_noFormChanged = true;
 			invalidateProperties();
 		}
 		
 		public function get replaceZeroWithNo() : Boolean {
 			return _replaceZeroWithNo;
 		}
 		
 		public function set replaceZeroWithNo(replaceZeroWithNo : Boolean) : void {
 			_replaceZeroWithNo = replaceZeroWithNo;
 		}
 		
 		public function get hideEmpty() : Boolean {
 			return _hideEmpty;
 		}
 		
 		public function set hideEmpty(hideEmpty : Boolean) : void {
 			_hideEmpty = hideEmpty;
 		}
 		
 		protected function get currentPage() : int {
 			return _currentPage;
 		}
 		
 		protected function set currentPage(currentPage : int) : void {
 			_currentPage = currentPage;
 			_currentPageChanged = true;
 			invalidateProperties();
 		}
 		
 		protected function get pagesTotal() : int {
 			return _pagesTotal;
 		}
 		
 		protected function set pagesTotal(pagesTotal : int) : void {
 			_pagesTotal = pagesTotal;
 			_pagesTotalChanged = true;
 			invalidateProperties();
 		}
 		
 		protected function get itemsTotal() : int {
 			return _itemsTotal;
 		}
 		
 		protected function set itemsTotal(itemsTotal : int) : void {
 			_itemsTotal = itemsTotal;
 			_itemsTotalChanged = true;
 			invalidateProperties();
 		}
 		
 		public function get wing() : int {
 			return (edge + minGap + neighbourhood);
 		}

		public function get hasPrev() : Boolean {
			return (currentPage > 0);
		}

		public function get hasNext() : Boolean {
   	    	return (currentPage < pagesTotal - 1);
		}
		
		protected function get moreThanOnePage() : Boolean {
			return (pagesTotal > 1);
		}
		
		protected function get leftEdgeRequired() : Boolean {
			return (moreThanOnePage && currentPage >= wing);
		}

		protected function get rightEdgeRequired() : Boolean {
			return (moreThanOnePage && currentPage < pagesTotal - wing);
		}

		protected function get leftEdgePages() : Array {
			return getSeries(0, edge);
		}
		
		protected function get rightEdgePages() : Array {
			return getSeries(pagesTotal - edge, pagesTotal);
		}
		
		protected function get corePages() : Array {
			return getSeries(corePagesFirstIndex, corePagesLastIndex);
		}
		
		protected function get corePagesSelectedIndex() : int {
			return (currentPage - corePagesFirstIndex);
		}
		
		protected function get corePagesFirstIndex() : int {
			return (leftEdgeRequired ? currentPage - neighbourhood : 0);
		}
		
		protected function get corePagesLastIndex() : int {
			return (rightEdgeRequired ? currentPage + neighbourhood + 1 : pagesTotal);
		}
		
		protected function get itemsTotalContent() : String {
			var itemsTotalColor : uint =
				(getStyle(StyleNames.ITEMS_TOTAL_COLOR) != null ? 
					getStyle(StyleNames.ITEMS_TOTAL_COLOR) :
						getStyle(StyleNames.COLOR));
			var relevantForm : String = TextFormatter.getRelevantForm(itemsTotal, singularForm, pluralForm);
			if (itemsTotal == 0 && replaceZeroWithNo) {
				var transformedItemsTotal : String =
					StringUtil.substitute(UNCOLORED_TEMPLATE,
						noForm,
						relevantForm);
			} else {
				transformedItemsTotal =
					StringUtil.substitute(COLORED_TEMPLATE,
						"#" + itemsTotalColor.toString(16),
						itemsTotal,
						relevantForm);
			}
			var result : String = StringUtil.substitute(itemsTotalTemplate, transformedItemsTotal);
			return result;
		}

		override public function styleChanged(styleProp : String) : void {
			super.styleChanged(styleProp);
			
			var allStyles : Boolean = (styleProp == null || styleProp == "styleName");
			
			if (allStyles || styleProp == StyleNames.ITEMS_TOTAL_COLOR || styleProp == StyleNames.COLOR) {
				_itemsTotalColorChanged = true;
				invalidateProperties();
			}
		}
		
		public function moveFirst() : void {
			if (currentPage > 0) {
				dataProvider.changePage(0);
			}
		}
		
		public function moveLast() : void {
			if (currentPage < pagesTotal - 1) {
				dataProvider.changePage(pagesTotal - 1);
			}
		}
		
		public function movePrev() : void {
			if (hasPrev) {
				dataProvider.changePage(currentPage - 1);
			}
		}
		
		public function moveNext() : void {
			if (hasNext) {
				dataProvider.changePage(currentPage + 1);
			}
		}
		
		override protected function createChildren() : void {
			super.createChildren();
			
			backButton = new Button();
			backButton.visible = false;
			backButton.includeInLayout = false;
			backButton.buttonMode = true;
			backButton.setStyle(StyleNames.UP_SKIN, LEFT);
			backButton.setStyle(StyleNames.OVER_SKIN, LEFT);
			backButton.setStyle(StyleNames.DOWN_SKIN, LEFT);
			backButton.setStyle(StyleNames.DISABLED_SKIN, LEFT);
			backButton.addEventListener(MouseEvent.CLICK, onBackButtonClick);
			
			leftEdgeLinkBar = new ExtendedLinkBar();
			leftEdgeLinkBar.visible = false;
			leftEdgeLinkBar.includeInLayout = false;
			leftEdgeLinkBar.addEventListener(ItemClickEvent.ITEM_CLICK, onPagesLinkBarItemClick);
			
			leftEllipsisLabel = new Label();
			leftEllipsisLabel.visible = false;
			leftEllipsisLabel.includeInLayout = false;
			leftEllipsisLabel.text = ELLIPSIS;
			
			corePagesLinkBar = new ExtendedLinkBar();
			corePagesLinkBar.visible = false;
			corePagesLinkBar.includeInLayout = false;
			corePagesLinkBar.addEventListener(ItemClickEvent.ITEM_CLICK, onPagesLinkBarItemClick);
			
			rightEllipsisLabel = new Label();
			rightEllipsisLabel.visible = false;
			rightEllipsisLabel.includeInLayout = false;
			rightEllipsisLabel.text = ELLIPSIS;			

			rightEdgeLinkBar = new ExtendedLinkBar();
			rightEdgeLinkBar.visible = false;
			rightEdgeLinkBar.includeInLayout = false;
			rightEdgeLinkBar.addEventListener(ItemClickEvent.ITEM_CLICK, onPagesLinkBarItemClick);
			
			forwardButton = new Button();
			forwardButton.visible = false;
			forwardButton.includeInLayout = false;
			forwardButton.buttonMode = true;
			forwardButton.setStyle(StyleNames.UP_SKIN, RIGHT);
			forwardButton.setStyle(StyleNames.OVER_SKIN, RIGHT);
			forwardButton.setStyle(StyleNames.DOWN_SKIN, RIGHT);
			forwardButton.setStyle(StyleNames.DISABLED_SKIN, RIGHT);
			forwardButton.addEventListener(MouseEvent.CLICK, onForwardButtonClick);
			
			spacer = new Spacer();
			spacer.width = 10;
			
			itemsTotalLabel = new Label();

			addChild(backButton);
			addChild(leftEdgeLinkBar);
			addChild(leftEllipsisLabel);
			addChild(corePagesLinkBar);
			addChild(rightEllipsisLabel);
			addChild(rightEdgeLinkBar);
			addChild(forwardButton);
			addChild(spacer);
			addChild(itemsTotalLabel);
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();

			if (_itemsTotalChanged ||
				_itemsTotalColorChanged ||
				_itemsTotalTemplateChanged ||
				_noFormChanged ||
				_singularFormChanged ||
				_pluralFormChanged) {
				
				visible = includeInLayout = (!_hideEmpty || _itemsTotal != 0);
					
				itemsTotalLabel.htmlText = itemsTotalContent;
				_itemsTotalChanged = false;
				_itemsTotalColorChanged = false;
				_itemsTotalTemplateChanged = false;
				_noFormChanged = false;
				_singularFormChanged = false;
				_pluralFormChanged = false;
			}
			
			if (_currentPageChanged || _pagesTotalChanged) {
				backButton.visible = moreThanOnePage && hasPrev;
				backButton.includeInLayout = moreThanOnePage;
				leftEdgeLinkBar.dataProvider = leftEdgePages;
				leftEdgeLinkBar.visible = leftEdgeRequired;
				leftEdgeLinkBar.includeInLayout = leftEdgeRequired;
				leftEllipsisLabel.visible = leftEdgeRequired;
				leftEllipsisLabel.includeInLayout = leftEdgeRequired;
				corePagesLinkBar.dataProvider = corePages;
				corePagesLinkBar.visible = moreThanOnePage;
				corePagesLinkBar.includeInLayout = moreThanOnePage;
				rightEllipsisLabel.visible = rightEdgeRequired;
				rightEllipsisLabel.includeInLayout = rightEdgeRequired;
				rightEdgeLinkBar.dataProvider = rightEdgePages;
				rightEdgeLinkBar.visible = rightEdgeRequired;
				rightEdgeLinkBar.includeInLayout = rightEdgeRequired;
				forwardButton.visible = moreThanOnePage && hasNext;
				forwardButton.includeInLayout = moreThanOnePage;
				
				if (corePages.length > 0) {
					corePagesLinkBar.selectedIndex = corePagesSelectedIndex;
				}
				
				_currentPageChanged = false;
				_pagesTotalChanged = false;
			}
		}
		
		protected function onBackButtonClick(event : MouseEvent) : void {
			movePrev();
		}
		
		protected function onForwardButtonClick(event : MouseEvent) : void {
			moveNext();
		}
		
		protected function onPagesLinkBarItemClick(event : ItemClickEvent) : void {
			dataProvider.changePage(Number(event.label) - 1);
		}
		
		protected function onCurrentPageChange(event : MultipageEvent) : void {
			currentPage = dataProvider.currentPage;
		}
		
		protected function onPagesTotalChange(event : MultipageEvent) : void {
			pagesTotal = dataProvider.pagesTotal;
		}
		
		protected function onItemsTotalChange(event : MultipageEvent) : void {
			itemsTotal = dataProvider.itemsTotal;
		}
		
		protected function getSeries(startIndex : int, endIndex : int) : Array {
			var result : Array = [];
			for (var i : int = startIndex; i < endIndex; i++) {
				result.push((i + 1).toString());
			}
			return result;
		}
		
		private var _corePages : Array;
		
		private var _dataProvider : IMultipage;
		
		private var _neighbourhood : int = 5;
		
		private var _minGap : int = 1;
		
		private var _edge : int = 1;
		
		private var _currentPage : int;
		
		private var _currentPageChanged : Boolean;
		
		private var _pagesTotal : int;
		
		private var _pagesTotalChanged : Boolean;
		
		private var _itemsTotal : int;
		
		private var _itemsTotalChanged : Boolean;
		
		private var _itemsTotalTemplate : String = "{0} TOTAL";
		
		private var _itemsTotalTemplateChanged : Boolean;
		
		private var _itemsTotalColorChanged : Boolean;
		
		private var _singularForm : String = "ENTRY";
		
		private var _singularFormChanged : Boolean;
		
		private var _pluralForm : String = "ENTRIES";
		
		private var _pluralFormChanged : Boolean;
		
		private var _noForm : String = "NO";
		
		private var _noFormChanged : Boolean;
		
		private var _replaceZeroWithNo : Boolean = true;
		
		private var _hideEmpty : Boolean = true;
		
		private var _fontChanged : Boolean;
		
	}

}