package com.kavalok.location.commands
{
	import com.kavalok.McFlyingPromo;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	public class PopopopsdasdnfdFRSACommand extends RemoteLocationCommand
	{
		public var text:String;
		
		private var _content:McFlyingPromo;
		private var _speed:Number = 2;
		
		override public function execute():void
		{
			createContent();
			_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_content.x -= _speed;
			_content.cacheAsBitmap = true;
			
			if (_content.x < -_content.width)
			{
				_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				GraphUtils.detachFromDisplay(_content);
			}
		}
		
		private function createContent():void
		{
			_content = new McFlyingPromo();
			_content.messageField.htmlText = text;
			_content.messageField.width = _content.messageField.textWidth + 10;
			_content.x = KavalokConstants.SCREEN_WIDTH;
			location.content.addChild(_content);
		}
	
	}
}