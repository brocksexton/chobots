package com.kavalok.admin.errors
{
	import com.kavalok.admin.errors.data.ErrorsDataProvider;
	
	import mx.containers.VBox;

	public class ErrorsBase extends VBox
	{
		[Bindable]
		protected var dataProvider : ErrorsDataProvider = new ErrorsDataProvider();
		
		public function ErrorsBase()
		{
			super();
		}
		
	}
}