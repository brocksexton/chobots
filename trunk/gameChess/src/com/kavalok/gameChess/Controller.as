package com.kavalok.gameChess
{
	
	public class Controller
	{
		public function get game():GameChess
		{
			return GameChess.instance;
		}
		
		public function get client():GameClient
		{
			return GameChess.instance.client;
		}
		
	}
	
}