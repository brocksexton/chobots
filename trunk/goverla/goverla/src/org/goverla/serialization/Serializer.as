package org.goverla.serialization
{
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	public class Serializer
	{
		
		public static function fromAMFBase64(source : String) : Object {
			var decoder : Base64Decoder = new Base64Decoder();
			decoder.decode(source);
			var bytes : ByteArray = decoder.toByteArray();
			return fromAMF(bytes);
		}
		
		public static function toAMFBase64(object : Object) : String {
			var bytes : ByteArray = toAMF(object);
			var encoder : Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(bytes, 0, bytes.length);
			return encoder.toString();
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