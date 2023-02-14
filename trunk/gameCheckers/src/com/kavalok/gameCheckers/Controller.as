package com.kavalok.gameCheckers
{
	
	public class Controller
	{
		public function get game():GameCheckers
		{
			return GameCheckers.instance;
		}
		
		public function get client():GameClient
		{
			return GameCheckers.instance.client;
		}
		
	}
	
}