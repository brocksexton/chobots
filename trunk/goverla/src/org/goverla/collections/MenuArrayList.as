package org.goverla.collections
{
	import mx.collections.IViewCursor;
	
	public class MenuArrayList extends ParentedArrayList
	{
		public function MenuArrayList(parent:Object=null, parentField:String=null, list:Object=null)
		{
			super(parent, parentField, list);
		}
		
		override public function createCursor():IViewCursor {
			return new MenuCollectionCursor(this);
		}
		
	}
}