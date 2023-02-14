package com.kavalok.dance
{
	public class BonePartInfo
	{
		public var a : Number;
		public var x : Number;
		public var y : Number;
		public function BonePartInfo(rotation : Number = 0, x : Number = 0, y : Number = 0)
		{
			this.a = rotation;
			this.x = x;
			this.y = y;
		}
		
		public function clone() : BonePartInfo
		{
			return new BonePartInfo(a,x,y);
		}

	}
}