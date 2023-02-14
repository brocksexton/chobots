package com.kavalok.gameSweetBattle.physics
{
	import flash.geom.Point;
	
	import com.kavalok.interfaces.IConverter;

	public class DisplayObjectToPoint implements IConverter
	{
		public function DisplayObjectToPoint()
		{
		}

		public function convert(source:Object):Object
		{
			return new Point(source.x, source.y);
		}
		
	}
}