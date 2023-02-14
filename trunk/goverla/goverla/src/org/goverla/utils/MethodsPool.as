package org.goverla.utils {

	import mx.collections.ArrayCollection;
	
	import org.goverla.collections.ListCollectionViewIterator;
	import org.goverla.interfaces.IIterator;
	import org.goverla.utils.common.MethodCallInfo;
	
	/**
	 * @author Maxym Hryniv
	 */
	public class MethodsPool extends ArrayCollection {
		
		public function MethodsPool() {
			super();
		}
		
		public function insert(value : MethodCallInfo) : void {
			super.addItem(value);
		}
		
		public function execute() : void {
			for(var iterator : IIterator = new ListCollectionViewIterator(super); iterator.hasNext();) {
				var info : MethodCallInfo = MethodCallInfo(iterator.next());
				info.method.apply(info.object, info.arguments);
			}
		}
	
	}

}