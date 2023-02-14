package com.kavalok.utils
{
	public class KavalokUtil
	{
		static public function validatePassword(password:String):Boolean
		{
			return password.length >= 6;
		}

	}
}