package com.kavalok.security
{
	import com.kavalok.errors.IllegalArgumentError;
	import com.kavalok.utils.Maths;
	
	import flash.utils.ByteArray;
	
	public class SimpleEncryptor
	{
		private static const KEY_LENGTH : int = 16;
		
		public static function generateKey() : Array
		{
		    var result : Array = [];
		    while(result.length < KEY_LENGTH)
		    {
		       result.push(Maths.random(256));
		    }
		    return result;
		}
		
		private var _key : Array;
		
		
		
		public function SimpleEncryptor(key : Array)
		{
			_key = key;
		}
		
		public function decrypt(value : Array) : String
		{
			var decrypted : ByteArray = new ByteArray();
			for(var i : int = 0; i < value.length; i++)
			{
				decrypted[i] = value[i]^_key[i % _key.length]; 
			}
			var string : String = decrypted.readUTFBytes(decrypted.length);
			var parts : Array = [string.substring(0, string.length / 2), string.substring(string.length / 2, string.length)];
			if(parts[0] == parts[1])
				return parts[0];
			throw new IllegalArgumentError("invalid value");
		}
		public function encrypt(value : String) : Array
		{
		//	generateKey();
			var bytes : ByteArray = new ByteArray();
			bytes.writeUTFBytes(value + value);
			var result : Array = [];
			for(var i : int = 0; i < bytes.length; i++)
			{
				result[i] = bytes[i]^_key[i % _key.length]; 
			}
			return result;
		}

	}
}