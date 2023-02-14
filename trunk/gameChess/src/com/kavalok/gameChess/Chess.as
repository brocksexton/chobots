package com.kavalok.gameChess
{
	import gameChess.McBishop;
	import gameChess.McKing;
	import gameChess.McKnight;
	import gameChess.McPawn;
	import gameChess.McQueen;
	import gameChess.McRook;
	
	public class Chess
	{
		static public const SIZE:int = 8;
		
		static public const PAWN:String = 'pawn';
		static public const ROOK:String = 'rook';
		static public const KNIGHT:String = 'knight';
		static public const BISHOP:String = 'bishop';
		static public const KING:String = 'king';
		static public const QUEEN:String = 'queen';
		
		static private var _factory:Object = {};
		
		static public function initFactory():void
		{
			_factory[PAWN] = McPawn;
			_factory[ROOK] = McRook;
			_factory[KNIGHT] = McKnight;
			_factory[BISHOP] = McBishop;
			_factory[KING] = McKing;
			_factory[QUEEN] = McQueen;
		}
		
		static public function getClass(figureType:String):Class
		{
			return _factory[figureType];
		}
		
		static public function getDisposition():Array
		{
			var result:Array =
			[
				[ROOK,	KNIGHT,	BISHOP,	QUEEN,	KING,	BISHOP,	KNIGHT,	ROOK],
				[PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN],
				[ROOK,	KNIGHT,	BISHOP,	QUEEN,	KING,	BISHOP,	KNIGHT,	ROOK],
			];
			
			/*result =
			[
				[ROOK,	KNIGHT,	BISHOP,	QUEEN,	KING,	BISHOP,	KNIGHT,	ROOK],
				[PAWN,	null,	null,	null,	PAWN,	null,	PAWN,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	PAWN,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	PAWN,	null,	PAWN],
				[ROOK,	null,	null,	null,	KING,	null,	null,	ROOK],
			];
			
			result =
			[
				[ROOK,	KNIGHT,	BISHOP,	QUEEN,	KING,	BISHOP,	KNIGHT,	ROOK],
				[PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	PAWN],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[null,	null,	null,	null,	null,	QUEEN,	null,	null],
				[null,	null,	null,	null,	null,	null,	null,	null],
				[PAWN,	PAWN,	PAWN,	PAWN,	PAWN,	ROOK,	PAWN,	PAWN],
				[ROOK,	KNIGHT,	BISHOP,	null,	KING,	BISHOP,	KNIGHT,	null],
			];*/
			
			return result;
		}
		
	}
	
}