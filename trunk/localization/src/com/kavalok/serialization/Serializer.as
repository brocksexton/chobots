package com.kavalok.serialization
{
	import com.dynamicflash.util.Base64;
	
	import flash.utils.ByteArray;
	
	public class Serializer
	{
		
		public static function fromAMFBase64(source : String) : Object {
			return fromAMF(fromBase64(source));
		}
		
		public static function toAMFBase64(object : Object) : String {
			var bytes : ByteArray = toAMF(object);
			return toBase64(bytes);
		}
		
		public static function fromBase64(source : String) : ByteArray {
			return Base64.decodeToByteArray(source);
		}
		public static function toBase64(source : ByteArray) : String {
			return Base64.encodeByteArray(source);
		}
		public static function toAMF(object : Object) : ByteArray {
			var result : ByteArray = new ByteArray();
			result.writeObject(object);
			result.position = 0;
			return result;
		}

		public static function toAMFString(object : Object) : String {
			var bytes : ByteArray = toAMF(object);
			var result : String = bytes.readUTFBytes(bytes.length);
			return result;
		}

		public static function fromAMF(source : ByteArray) : Object {
			source.position = 0;
			return source.readObject();
		}

		public static function fromAMFString(source : String) : Object {
			var bytes : ByteArray = new ByteArray();
			bytes.writeUTFBytes(source);
			return fromAMF(bytes);
		}
		
	}
}