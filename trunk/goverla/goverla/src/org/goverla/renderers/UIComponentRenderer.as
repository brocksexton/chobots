package org.goverla.renderers
{
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.formatters.Formatter;
	import mx.managers.IFocusManagerComponent;
	
	import org.goverla.constants.StyleNames;
	import org.goverla.events.RendererEvent;

	[Style(name="backgroundAlpha", type="uint", inherit="no")]

	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

	[Event(name="listDataChange", type="com.wideorbit.events.RendererEvent")]

	[Event(name="dataChange", type="com.wideorbit.events.RendererEvent")]

	public class UIComponentRenderer extends UIComponent
		implements IListItemRenderer, IDropInListItemRenderer, IFocusManagerComponent
	{
		public static var DEFAULT_BACKGROUND : uint = 0xffffff;

		protected var defaultBackground : Boolean = false;

		public function get listData() : BaseListData
		{
			return _listData;
		}

		public function set listData(value : BaseListData) : void
		{
			var event : RendererEvent = new RendererEvent(RendererEvent.LIST_DATA_CHANGE);
			event.oldValue = _listData;
			event.newValue = value;

		    _listData = value;

			dispatchEvent(event);
		}

		public function get data() : Object
		{
			return _data;
		}

		public function set data(value : Object) : void
		{
			var event : RendererEvent = new RendererEvent(RendererEvent.DATA_CHANGE);
			event.oldValue = _data;
			event.newValue = value;

			_data = value;

			dispatchEvent(event);
		}

		protected function get column() : AdvancedDataGridColumn
		{
			return AdvancedDataGrid(listData.owner).
				columns[listData.columnIndex];
		}

		protected function get formatter() : Formatter
		{
			return column.formatter;
		}

		protected function get labelFunction() : Function
		{
			return column.labelFunction;
		}

        public override function styleChanged(styleProp : String) : void
        {
            super.styleChanged(styleProp);

            if (styleProp == StyleNames.BACKGROUND_COLOR ||
            	styleProp == StyleNames.BACKGROUND_ALPHA)
            {
                invalidateDisplayList();
            }
        }

		protected function formatData(value : Object) : String
		{
			var result : String;

			if (labelFunction != null)
			{
				result = labelFunction(value, column);
			}
			else if (formatter != null)
			{
				result = formatter.format(value);
			}
			else
			{
				result = value.toString();
			}

			return result;
		}

		protected override function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			applyStyles();
		}

		protected function applyStyles() : void
		{
			var background : * = getStyle(StyleNames.BACKGROUND_COLOR);
			var alpha : * = getStyle(StyleNames.BACKGROUND_ALPHA);

			graphics.clear();

			if (defaultBackground && isEmpty(background))
			{
				background = DEFAULT_BACKGROUND;
				alpha = 0.00001;
			}

			if (!isEmpty(background))
			{
				if (isEmpty(alpha))
				{
					alpha = 1;
				}

	  	      	graphics.beginFill(background, alpha);
	    	    graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
	    	    graphics.endFill();
	  		}
		}

		protected function removeAllChildren() : void
		{
			var count : int = numChildren;
			for (var i : int = 0; i < count; i++)
			{
				removeChildAt(0);
			}
		}

		private function isEmpty(value : *) : Boolean
		{
			return value == null || isNaN(value);
		}

		private var _data : Object;

		private var _listData : BaseListData;

	}
}