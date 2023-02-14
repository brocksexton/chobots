package com.kavalok.dto.admin
{
	[RemoteClass(alias="com.kavalok.dto.admin.FilterTO")]
	public class FilterTO
	{
		[Bindable]
		public var fieldName : String;
		[Bindable]
		public var operator : String = "=";
		[Bindable]
		public var value : Object;
		
		public var filterType : Class;
		
		public function FilterTO(fieldName : String, filterType : Class, value:Object)
		{
			super();
			this.filterType = filterType;
			this.fieldName = fieldName;
			this.value = value;
		}

	}
}