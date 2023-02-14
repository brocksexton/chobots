package com.kavalok.admin.users.data
{
	public class FilterConfig
	{
		private var _fieldName : String;
		private var _filterType : Class;
		private var _value : Object;
		
		public function FilterConfig(fieldName : String, filterType : Class, value:Object = null)
		{
			super();
			_filterType = filterType;
			_fieldName = fieldName;
			_value = value;
		}
		
		public function get fieldName() : String
		{
			return _fieldName;
		}

		public function get filterType() : Class
		{
			return _filterType;
		}
		
		public function get value():Object
		{
			 return _value;
		}

	}
}