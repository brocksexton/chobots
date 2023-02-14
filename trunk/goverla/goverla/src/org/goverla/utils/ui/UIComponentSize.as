package org.goverla.utils.ui {
	
	import org.goverla.utils.UIUtil;
	
	import mx.core.IUIComponent;

	/**
	 * @author Maxym Hryniv
	 */
	[RemoteClass(alias="org.goverla.web.flex.vo.UIComponentSize")]
	public class UIComponentSize {
	
		private var _width : int; 
		private var _widthInPercents : Boolean = false; 
		
		private var _height : int;
		private var _heightInPercents : Boolean = false; 
	
		public function UIComponentSize(source : IUIComponent = null, fixedWidth : Boolean = false, fixedHeight : Boolean = false) {
			if(source != null) {
				if(!isNaN(source.percentWidth) && !fixedWidth) {
					_width = source.percentWidth;
					_widthInPercents = true;
				} else {
					_width = source.width;
				}
	
				if(!isNaN(source.percentHeight) && !fixedHeight) {
					_height = source.percentHeight;
					_heightInPercents = true;
				} else {
					_height = source.height;
				}
			}
		}
		
		public function get width() : int {
			return _width;
		}
	
		public function set width(width : int) : void {
			_width = width;
		}
		
		public function get widthInPercents() : Boolean {
			return _widthInPercents;
		}

		public function set widthInPercents(value : Boolean) : void {
			_widthInPercents = value;
		}
		
		public function get height() : int {
			return _height;
		}
	
		public function set height(height : int) : void {
			_height = height;
		}

		public function get heightInPercents() : Boolean {
			return _heightInPercents;
		}

		public function set heightInPercents(value : Boolean) : void {
			_heightInPercents = value;
		}
		
		public function apply(target : IUIComponent) : void {
			if(widthInPercents) {
				target.percentWidth = width;
			} else {
				target.width = width;
			}

			if(heightInPercents) {
				target.percentHeight = height;
			} else {
				target.height = height;
			}
		}
		
	}
}