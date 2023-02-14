package org.goverla.flash.geom {
	
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	
	[RemoteClass(alias="org.goverla.flash.geom")]
	public class Point extends flash.geom.Point {
		
		public static function initialize() : void {
			registerClassAlias("org.goverla.flash.geom.Point", org.goverla.flash.geom.Point);
		}
		
		public static function fromPoint(point : flash.geom.Point) : org.goverla.flash.geom.Point {
			return new org.goverla.flash.geom.Point(point.x, point.y);
		}
		
		public function Point(x : Number = 0.0, y : Number = 0.0) {
			super(x, y);
		}
		
	}
	
}