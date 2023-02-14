package com.kavalok.gameCrab
{
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.SpriteTweaner;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import com.kavalok.events.EventSender;

	public class ObjectBase
	{
		public var bounds:Rectangle;
		public var content:MovieClip;
		public var field:Sprite;
		
		public var speed:Number;
		public var dcc:Number = 1;
		
		public var startX:Number;
		public var startY:Number;
		public var startRot:Number;
		public var events:EventManager;
		public var size:Number;
		public var atBorder:Boolean;
		public var borderReverse:Boolean = false;
		
		public var vx:Number;
		public var vy:Number;
		
		
		public var readyEvent:EventSender = new EventSender();
		
		public function ObjectBase()
		{
		}
		
		public function initialzie():void
		{
			bounds = field.getBounds(content.parent);
			
			size = 0.5 * content.mcZone.width;
			
			bounds.left += size;
			bounds.top += size;
			bounds.right -= size;
			bounds.bottom -= size;
			
			startX = content.x;
			startY = content.y;
			startRot = content.rotation
			
			content.mcZone.visible = false;
			content.stop();
		}
		
		public function collide(o:ObjectBase):Boolean
		{
			var dx:Number = content.x - o.content.x;
			var dy:Number = content.y - o.content.y;
			var d2:Number = dx * dx + dy * dy;
			var r2:Number = (size +o.size) * (size +o.size);
			
			return d2 < r2;
		}
		
		public function move():void
		{
			vx = speed * Math.cos(content.rotation / 180 * Math.PI);
			vy = speed * Math.sin(content.rotation / 180 * Math.PI);
			
			content.x += vx;
			content.y += vy;
			speed *= dcc;
			
			checkBorder();
		}
		
		protected function checkBorder():void
		{
			atBorder = false;
			
			if (content.x < bounds.left && vx < 0)
			{
				content.x = bounds.left;
				vx = -vx * Config.BORDER_ELASTITY;
				atBorder  = true;
				
				if (borderReverse)
					content.rotation = 180 - content.rotation;
			}
			else if (content.x > bounds.right && vx > 0)
			{
				content.x = bounds.right;
				vx = -vx * Config.BORDER_ELASTITY;
				atBorder  = true;
				
				if (borderReverse)
					content.rotation = 180 - content.rotation;
			}
			
			if (content.y < bounds.top && vy < 0)
			{
				content.y = bounds.top;
				vy = -vy * Config.BORDER_ELASTITY;
				atBorder  = true;
				
				if (borderReverse)
					content.rotation = -content.rotation;
			}
			else if (content.y > bounds.bottom && vy > 0)
			{
				content.y = bounds.bottom;
				vy = -vy * Config.BORDER_ELASTITY;
				atBorder  = true;
				
				if (borderReverse)
					content.rotation = -content.rotation;
			}
		}
		
		public function reset():void
		{
			speed = 0;
			
			var twean:Object =
			{
				x : startX,
				y : startY,
				rotation : startRot
			}
			
			new SpriteTweaner(content, twean, 30, events, readyEvent.sendEvent);
		}
	}
	
}
