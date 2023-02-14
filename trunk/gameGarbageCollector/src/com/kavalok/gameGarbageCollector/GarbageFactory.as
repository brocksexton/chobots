package com.kavalok.gameGarbageCollector
{
	import com.kavalok.garbageCollector.Garbage1;
	import com.kavalok.garbageCollector.Garbage2;
	import com.kavalok.garbageCollector.Garbage3;
	import com.kavalok.garbageCollector.Garbage4;
	import com.kavalok.garbageCollector.Garbage5;
	
	import flash.display.MovieClip;
	
	public class GarbageFactory extends BulletsFactory
	{
		public function GarbageFactory()
		{
			classes = [Garbage1, Garbage2, Garbage3, Garbage4, Garbage5];
		}

		override public function createParticle(type : uint) : MovieClip
		{
			var result : MovieClip = super.createParticle(type);
			result.gotoAndStop(1);
			return result;
		}

	}
}