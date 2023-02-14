package org.goverla.collections {

	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	
	import org.goverla.errors.IllegalArgumentError;

	public class TypedArrayCollection extends ArrayCollection {
		
		private var _type : Class;
		
		public function TypedArrayCollection(type : Class, source : Array = null) {
			_type = type;
			var isGoodType : Boolean = true;
			
			if (source != null) {
				for (var i : int = 0; i < source.length; i++) {
					if (!(source[i] is type)) {
						isGoodType = false;
						break;
					}
				}
			}
			
			if (isGoodType) {
				super(source);
			}
			else {
				throw new IllegalArgumentError(getSourceErrorMessage(source, source[i]));
			}
		}
		
		public function get type() : Class {
			return _type;
		}
		
		public function get typeName() : String {
			return getQualifiedClassName(type);
		}
		
		public override function addItem(item : Object) : void {
			if (item is type) {
				super.addItem(item);
			} else {
				throw new IllegalArgumentError(getItemErrorMessage(item));
			}
		}
		
		public override function addItemAt(item : Object, index : int) : void {
			if (item is type) {
				super.addItemAt(item, index);
			} else {
				throw new IllegalArgumentError(getItemErrorMessage(item));
			}
		}
		
		public override function setItemAt(item : Object, index : int) : Object {
			if (item is type) {
				return super.setItemAt(item, index);
			} else {
				throw new IllegalArgumentError(getItemErrorMessage(item));
			}
		}
		
		private function getSourceErrorMessage(source : Array, item : Object) : String {
			return "Argument " + item.toString() + " of source array " + source.toString() + " must be instance of " + typeName;
		}
		
		private function getItemErrorMessage(item : Object) : String {
			return "Argument " + item.toString() + " must be instance of " + typeName;
		}
				
	}

}