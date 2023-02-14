package com.kavalok.gameSweetBattle 
{
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Health 
	{
		private var _content:MovieClip;
		private var _x:Number;
		
		private var em:EventManager = GameSweetBattle.eventManager;
		
		public function Health(player:Player, value:int) 
		{
			var p:Point = new Point(0, -player.height);
			GraphUtils.transformCoords(p, player, player.parent);

			_x = p.x;
			
			_content = new McLife();
			_content.x = p.x;
			_content.y = p.y;
			_content.mc_text.text = value.toString();
			
			player.parent.addChild(_content);
			em.registerEvent(_content, Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void 
		{
			_content.y -= 1;
			_content.x = _x + 20 * Math.sin(_content.y * 0.1)
			_content.alpha -= 0.02;
			
			if (_content.alpha <= 0) 
			{
				em.removeEvent(_content, Event.ENTER_FRAME, onFrame)
				_content.parent.removeChild(_content);
			}
		}
		
	}
	
}