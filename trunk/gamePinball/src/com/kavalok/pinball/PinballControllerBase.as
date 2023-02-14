package com.kavalok.pinball
{
	public class PinballControllerBase
	{
		protected var pinball : GamePinball;
		
		public function PinballControllerBase(pinball : GamePinball)
		{
			this.pinball = pinball;
		}

	}
}