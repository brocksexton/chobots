package com.kavalok.char.actions
{
	import com.kavalok.char.LocationChar;
	import com.kavalok.errors.NotImplementedError;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.EventManager;
	
	public class CharActionBase
	{
		protected var _char:LocationChar;
		protected var _location:LocationBase;
		protected var _parameters:Object;
		protected var _em:EventManager = new EventManager();
		
		public function set char(value:LocationChar):void
		{
			 _char = value;
		}
		
		public function set location(value:LocationBase):void
		{
			 _location = value;
		}
		
		public function set parameters(value:Object):void
		{
			 _parameters = value;
		}
		
		public function execute():void
		{
			// virtual method
			throw new NotImplementedError('Execute methot does not implemented.');
		}
		
		public function destroy():void
		{
			_em.clearEvents();
			onDestroy();
		}
		
		protected function onDestroy():void
		{
			// virtual method
		}
	}
}