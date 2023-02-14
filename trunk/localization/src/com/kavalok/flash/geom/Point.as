package com.kavalok.flash.geom {
	
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	
	[RemoteClass(alias="com.kavalok.flash.geom")]
	public class Point extends flash.geom.Point {
		
		public static function initialize() : void {
			registerClassAlias("com.kavalok.flash.geom.Point", com.kavalok.flash.geom.Point);
		}
		
		public static function fromPoint(point : flash.geom.Point) : com.kavalok.flash.geom.Point {
			return new com.kavalok.flash.geom.Point(point.x, point.y);
		}
		
		public function Point(x : Number = 0.0, y : Number = 0.0) {
			super(x, y);
		}
		
	}
	
}