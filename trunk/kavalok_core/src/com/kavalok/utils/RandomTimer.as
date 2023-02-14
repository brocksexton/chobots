package com.kavalok.utils
{
	import flash.display.DisplayObject;
	
	import com.kavalok.flash.process.EnterFrameTimer;

	public class RandomTimer extends EnterFrameTimer
	{
		private var _quantity : Number;
		
		public function RandomTimer(dispatcher:DisplayObject=null, quantity : Number = 0.1, framesPerTick:uint=1)
		{
			super(framesPerTick, dispatcher);
			_quantity = quantity;
		}
		
		override protected function sendTick():void
		{
			if(Math.random() < _quantity)
			{
				super.sendTick();
			}
		}
		
	}
}