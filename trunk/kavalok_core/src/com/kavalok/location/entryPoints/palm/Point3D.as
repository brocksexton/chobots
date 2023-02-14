package com.kavalok.location.entryPoints.palm
{
	import flash.geom.Point;
	
	public class Point3D extends Point
	{
		public var z : Number;
		
		public function Point3D(x: Number = 0, y : Number = 0, z : Number = 0)
		{
			super(x,y);
			this.z = z;
		}

	}
}