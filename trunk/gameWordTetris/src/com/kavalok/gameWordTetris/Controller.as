package com.kavalok.gameWordTetris
{
	
	public class Controller
	{
		
		public function Controller()
		{
			super();
		}
		
		protected function get module():GameWordTetris
		{
			return GameWordTetris.instance;
		}
		
		protected function handle(handler:Function):void
		{
			if (handler != null)
				handler();
		}
		
	}
	
}