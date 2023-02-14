package com.kavalok.gameChopaj
{
	
	public class Controller
	{
		public function get game():Game
		{
			return Game.instance;
		}
		
		public function get client():GameClient
		{
			return Game.instance.client;
		}
		
	}
	
}