package com.kavalok.security
{
	public class EncryptedValue
	{
		private var _encryptedValue : Array;
		private var _encryptor : SimpleEncryptor;
		
		public function EncryptedValue(value : int = 0)
		{
			_encryptor = new SimpleEncryptor(SimpleEncryptor.generateKey());
			this.value = value;
		}
		
		public function get value() : int
		{
			return int(_encryptor.decrypt(_encryptedValue));
		}
		public function set value(newValue : int) : void
		{
			//trace(this.value)
			_encryptedValue = _encryptor.encrypt(String(newValue));
		}

	}
}