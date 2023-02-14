package com.kavalok.dance
{
	import com.kavalok.serialization.Serializer;
	
	public class MovementSerializer
	{
		public function MovementSerializer()
		{
		}
		
//		public function toString(frames : Array) : void
//		{
//			var result : Object = {};
//			for each(var frame : Object in frames)
//			{
//				for(var part : String in frame)
//					addPartInfo(result, part, frame[part]);
//			}
//			return Serializer.toAMFBase64(result);
//		}
		
		private function addPartInfo(result : Object, part : String, info : BonePartInfo) : void
		{
			if(result.part == null)
				result.part = {x : [], y : [], rotation : []};
			
			result.part.x.push(info.x);
			result.part.y.push(info.y);
			result.part.rotation.push(info.a);
		}

	}
}