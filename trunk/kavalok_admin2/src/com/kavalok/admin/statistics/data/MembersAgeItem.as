package com.kavalok.admin.statistics.data
{
	public dynamic class MembersAgeItem
	{
		[Bindable]
		public var userAge : int;
		
		public function MembersAgeItem()
		{
		}
		
		public function get total() : int
		{
			var sum : int = 0;
			for(var property : String in this)
				sum+=this[property];
			return sum;
		}

	}
}