package com.kavalok.gameHunting
{
	import gameHunting.McShell0In;
	import gameHunting.McShell0Out;
	import gameHunting.McShell1In;
	import gameHunting.McShell1Out;
	import gameHunting.McShell2In;
	import gameHunting.McShell2Out;
	import gameHunting.McShell3In;
	import gameHunting.McShell3Out;
	import gameHunting.SndGo1;
	import gameHunting.SndGo3;
	import gameHunting.SndHit1;
	import gameHunting.SndHit2;
	import gameHunting.SndHit3;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class ShellFactory
	{
		static private var _shells:Object = {};
		
		static public function initialize():void
		{
			//_shells['shell0'] = new ShellInfo(McShell0In, McShell0Out);
			_shells['shell1'] = new ShellInfo(35, 2.1, 10, 0.75, McShell1In, McShell1Out, SndGo1, SndHit1);
			_shells['shell2'] = new ShellInfo(50, 4.3, 5, 0.5, McShell2In, McShell2Out, SndGo1, SndHit2);
			_shells['shell3'] = new ShellInfo(22, 0.8, 15, 1, McShell3In, McShell3Out, SndGo3, SndHit3);
		}
		
		static public function get shells():Object { return _shells; }
	}
	
}