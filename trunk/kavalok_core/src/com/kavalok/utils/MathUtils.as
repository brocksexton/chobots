package com.kavalok.utils
{
	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		public static function randomNumberRange(minNum:int, maxNum:int):int 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1) ) + minNum );
		}
		
		// taken from: http://uihacker.blogspot.com.au/2009/09/actionscript-3-choose-random-item-from.html
		public static function randomIndexByWeights( weights:Array ) : int
		{
			// add weights
			var weightsTotal:Number = 0;
			for( var i:int = 0; i < weights.length; i++ ) weightsTotal += weights[i];
			// pick a random number in the total range
			var rand:Number = Math.random() * weightsTotal;
			// step through array to find where that would be 
			weightsTotal = 0;
			for( i = 0; i < weights.length; i++ )
			{
				weightsTotal += weights[i];
				if( rand < weightsTotal ) return i;
			}
			// if random num is exactly = weightsTotal
			return weights.length - 1;
		}
	}
}