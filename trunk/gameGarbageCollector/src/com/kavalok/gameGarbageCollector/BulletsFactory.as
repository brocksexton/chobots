package com.kavalok.gameGarbageCollector
{
	import com.kavalok.garbageCollector.Bullet1;
	import com.kavalok.garbageCollector.Bullet2;
	import com.kavalok.garbageCollector.Bullet3;
	import com.kavalok.garbageCollector.Bullet4;
	import com.kavalok.garbageCollector.Bullet5;
	
	import flash.display.MovieClip;
	
	public class BulletsFactory
	{
		protected var classes : Array = [Bullet1, Bullet2, Bullet3, Bullet4, Bullet5];
		
		
		public function BulletsFactory()
		{
		}
		
		public function createParticle(type : uint) : MovieClip
		{
			var classObject : Class = classes[type - 1];
			var result : MovieClip = new classObject();
			result.cacheAsBitmap = true;
			return result;
		}
		

	}
}