package org.goverla.css {

	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import mx.utils.StringUtil;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.interfaces.IRequirement;
	import org.goverla.utils.Arrays;
	import org.goverla.utils.comparing.PropertyCompareRequirement;
	
	[RemoteClass(alias="org.goverla.css.CSSStylesGroup")]
	public class CSSStylesGroup	{
		
		protected static const FORMAT : String = "{0} { {1} }";
		
		public function CSSStylesGroup(name : String) {
			_name = name;
//			_styles.addEventListener(CollectionEvent.COLLECTION_CHANGE, onStylesChange);
		}
		
		public function get name() : String {
			return _name;
		}

		public function set name(value : String) : void {
			_name = value;
		}

		public function get styles() : ArrayList {
			return _styles;
		}
		
		public function apply() : void {
			_declaration = StyleManager.getStyleDeclaration(name);
			if(_declaration == null) {
				_declaration = new CSSStyleDeclaration(name);
				StyleManager.setStyleDeclaration(name, _declaration, true);
			}
			
			for each(var style : CSSStyle in _styles) {
				updateStyle(style);
			}
		}

		public function toString() : String {
			var stylesString : String = "";
			for(var i : int = 0; i < styles.length; i++) {
				stylesString += styles.getItemAt(i).toString(); 
			}
			return StringUtil.substitute(FORMAT, name, stylesString);
		}		
		
		public function getStyle(name : String) : CSSStyle {
			var requirement : IRequirement = new PropertyCompareRequirement("name", name);
			var result : CSSStyle;
			try {
				result = CSSStyle(Arrays.firstByRequirement(styles, requirement));
			} catch (error : RangeError){
				result = null;
			}
			return result;
		}

		private function onStylesChange(event : CollectionEvent) : void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
					onAdd(event);
					break;
				case CollectionEventKind.REPLACE:
					onReplace(event);
					break;
			}  
		}
		
		private function updateStyle(style : CSSStyle) : void {
			if(style.value != null) {
				_declaration.setStyle(style.name, style.value);
			} else {
				style.value = _declaration.getStyle(style.name);  
			}
		}
		
		private function onAdd(event : CollectionEvent) : void {
			for(var i : int = 0; i < event.items.length; i++) {
				var style : CSSStyle = CSSStyle(event.items[i]);
				updateStyle(style);
			}
			
		}

		private function onReplace(event : CollectionEvent) : void {
			for(var i : int = 0; i < event.items.length; i++) {
				var propertyEvent : PropertyChangeEvent = PropertyChangeEvent(event.items[i]); 
				var style : CSSStyle = CSSStyle(propertyEvent.newValue);
				updateStyle(style);
			}
			
		}
		
		private var _styles : ArrayList = new ArrayList();

		private var _name : String;

		private var _declaration : CSSStyleDeclaration;
		
	}

}