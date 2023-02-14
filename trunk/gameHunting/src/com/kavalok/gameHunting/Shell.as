package com.kavalok.gameHunting
{
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	public class Shell
	{
		public var onMaximum:Function;
		public var onFinish:Function;
		public var finished:Boolean = false;
		public var name:String;
		
		private var _content:Sprite;
		private var _clip:MovieClip;
		private var _info:ShellInfo;
		private var _vy:Number;
		private var _dr:Number;
		
		public function Shell(info:ShellInfo)
		{
			_info = info;
			_vy = -_info.startVy;
			_dr = Maths.randomRange( -5, 5);
			var shellClass:Class = info.classSpriteIn;
			_content = new shellClass();
			_clip = _content.getChildAt(0) as MovieClip;
			GraphUtils.stopAllChildren(_content);
		}
		
		public function move():void
		{
			if (_clip.currentFrame == 1)
			{
				content.y += _vy;
				_vy += _info.g;
				content.scaleX -= 0.02;
				content.scaleY -= 0.02;
				content.rotation += _dr;
				
				if (_vy > 0)
					content.alpha -= 0.05;
				
				if (_vy > 0 && _vy - _info.g < 0)
					onMaximum(this);
				
				if (_content.alpha < 0.1)
					onFinish(this);
			}
			else
			{
				if (_clip.currentFrame == _clip.totalFrames)
				{
					GraphUtils.stopAllChildren(_content);
					onFinish(this);
				}
			}
			
			_clip.filters = [new BlurFilter(0, Math.abs(_vy))]
		}
		
		public function playAnimation():void
		{
			_content.rotation = 0;
			_clip.play();
			_clip.filters = [];
		}
		
		public function get content():Sprite { return _content; }
		public function get info():ShellInfo { return _info; }
	}
	
}