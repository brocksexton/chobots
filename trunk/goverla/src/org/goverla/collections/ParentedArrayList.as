package org.goverla.collections
{

	[RemoteClass(alias="org.goverla.collections.ParentedArrayList")]
	public class ParentedArrayList extends ArrayList
	{
		private var _parent : Object;
		private var _parentFiled : String;
		
		public function ParentedArrayList(parent : Object = null, parentField : String = "parent", list:Object=null)
		{
			super(list);
			_parent = parent == null ? this : parent;
			_parentFiled = parentField;
			if(list != null) {
				refreshParent();
			}
		}
		
		public function get parent() : Object {
			return _parent;
		}
		
		public function set parent(value : Object) : void {
			_parent = value;
			refreshParent();
		}
		
		public function get parentField() : String {
			return _parentFiled;
		}
		
		public function set parentField(value : String) : void {
			_parentFiled = value;
			refreshParent();
		}
		
		override public function addItemAt(item:Object, index:int):void {
			setParent(item);
			super.addItemAt(item, index);
		}
		
		override public function removeItemAt(index : int) : Object {
			if(_parentFiled != null) {
				removeParent(getItemAt(index));
			}
			return super.removeItemAt(index);
		}
		
		private function refreshParent() : void {
			if(_parentFiled == null)
				return;
				
			for each(var child : Object in this) {
				setParent(child);
			}
		}
		
		private function setParent(child : Object) : void {
			if(_parentFiled != null) {
				child[_parentFiled] = _parent;
			}
		}
		
		private function removeParent(child : Object) : void {
			child[_parentFiled] = null;
		}
		
		
	}
}