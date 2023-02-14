package org.goverla.utils.common
{
	public dynamic class TestClassDynamic
	{
		public var testField1 : String = "test1";
		
		public var testField2 : String = "test2";
		
		public function get testProperty() : String {
			return _testProperty;
		}
	
		public function setDefaultValue() : void {
			_testProperty = "Kovalyov - LOH!";
		}		
		
		private var _testProperty : String;
	}
}