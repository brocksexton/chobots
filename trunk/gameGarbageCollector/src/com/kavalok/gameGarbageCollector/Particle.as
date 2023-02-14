package com.kavalok.gameGarbageCollector
{
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.Strings;
	
	import flash.geom.Point;
	
	
	public class Particle
	{
		public static function fromObject(source : Object) : Particle
		{
			var result : Particle = new Particle();
			ReflectUtil.copyFieldsAndProperties(source, result);
			return result;
		}
		public var id : String;
		
		public var position : Object;
		public var type : uint;
		public var speed : Object;
		public var owner : String;
		
		
		public function Particle(position : Point = null, type : uint = 1, speed : Point = null) 
		{
			this.id = Strings.generateRandomId();
			this.position = position;
			this.type = type;
			this.speed = speed;
		}
	}
}