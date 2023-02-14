package com.kavalok.gameplay.frame.bag.dance
{
	import com.kavalok.dance.BonePartInfo;
	import com.kavalok.serialization.Serializer;
	import com.kavalok.utils.Strings;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import flash.utils.ByteArray;
	
	
	public class DanceSerializer
	{
		private const _mapping : Object = 
			{
				body : "b"
				, head : "h"
				, leftHandBottom : "lhb"
				, leftHandTop : "lht"
				, leftLeg : "ll"
				, neck : "n"
				, pimpa : "p"
				, rightHandBottom : "rhb"
				, rightHandTop : "rht"
				, rightLeg : "rl"
			}
		private var _inverseMapping : Object = {};
		public function DanceSerializer()
		{
			for(var property : String in _mapping)
			{
				_inverseMapping[_mapping[property]] = property;
			}
		}
		
		public function deserialize(source : String) : Array
		{
			if(Strings.isBlank(source))
				return null;
				
			var bytes : ByteArray = Serializer.fromBase64(source);
			var archiver : FZip = new FZip();
			archiver.loadBytes(bytes);
			var file : FZipFile = archiver.getFileByName("dance");
			var dance : Object = Serializer.fromAMF(file.content);
			
			var result : Array = [];
			for(var property : String in dance)
			{
				var positions : Array = dance[property];
				for(var i : int = 0; i < positions.length; i++)
				{
					addFrameValue(result, property, i, positions[i]);
				}
			}
			
			return result;
			
		}
		public function serialize(source : Array) : String
		{
			var result : Object = {};
			for each(var frame : Object in source)
			{
				for(var property : String in frame)
				{
					addValue(result, property, frame[property]);
				}
			}
			var archiver : FZip = new FZip();
			var file : FZipFile = archiver.addFile("dance", Serializer.toAMF(result));
			var resultArray : ByteArray = new ByteArray();
			archiver.serialize(resultArray, true);
			return Serializer.toBase64(resultArray);
		}
		
		private function addFrameValue(result : Array, property : String, index : int, value : Object) : void
		{
			if(result.length <= index)
				result.push({});
			var frame : Object = result[index];
			frame[_inverseMapping[property]] = new BonePartInfo(value.a, value.x, value.y);
		}
		
		private function addValue(result : Object, property : String, value : BonePartInfo) : void
		{
			var resultProperty : String = _mapping[property];
			if(result[resultProperty] == null)
				result[resultProperty] = [];
			result[resultProperty].push({a : int(value.a), x: int(value.x), y: int(value.y)});
		}

	}
}