package com.kavalok.layout
{
	import flash.display.DisplayObjectContainer;
	
	import com.kavalok.errors.NotImplementedError;
	
	public class LayoutBase
	{
		protected var container:DisplayObjectContainer;
		
		public function LayoutBase(container:DisplayObjectContainer)
		{
			this.container = container;
		}
		
		public function apply():void
		{
			throw new NotImplementedError();
		}
	
	}
}