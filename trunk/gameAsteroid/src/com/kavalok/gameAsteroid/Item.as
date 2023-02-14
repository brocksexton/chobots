package com.kavalok.gameAsteroid
{
	import com.kavalok.games.GameObject;
	import com.kavalok.utils.EventManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Item extends GameObject
	{
		public var destroyed:Boolean;
		public var active:Boolean = true;
		
		private var _events:EventManager;
		private var _zone:Sprite;
		
		public function Item(zone:Sprite, events:EventManager)
		{
			super(new McItem());
			
			_zone = zone;
			_events = events;
			initialize();
		}
		
		public function initialize():void
		{
			content.stop();
			
			var x1:Number = Math.random() * Config.BOUNDS.width;
			var y1:Number = -content.width;
			var x2:Number = content.width + Math.random() * (Config.BOUNDS.width - content.width * 2);
			var y2:Number = Config.BOUNDS.height + content.height;
			
			var velocity:Number = Config.ITEM_MIN_V + Math.random() *
				(Config.ITEM_MAX_V - Config.ITEM_MIN_V);
				
			var r:Number = Math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
			
			content.x = x1;
			content.y = y1;
			scale = 0.5 + Math.random() * 0.5;
			radius = 0.3 * content.width;
			
			v.setMembers(x2 - x1, y2 - y1);
			v = v.getUnitVector();
			v.mulScalar(velocity);
			
			vrot = Math.random() < 0.5 ? 1 : -1;
			vrot *= (1 + Math.random() * 8);
		}
		
		override public function processMov():void
		{
			super.processMov();
			
			if (active && !content.hitTestObject(_zone))
				initialize();
		}
		
		public function deactivate():void
		{
			active = false;
			content.play();
			
			_events.registerEvent(content, Event.ENTER_FRAME, onDeactivate);
		}
		
		private function onDeactivate(e:Event):void
		{
			if (content.currentFrame == content.totalFrames)
			{
				_events.removeEvents(content);
				destroyed = true;
			}
		}
		
	}
	
}
