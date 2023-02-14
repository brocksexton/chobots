package com.kavalok.gameWordTetris.startScreen
{
	import com.kavalok.gameplay.controls.IListItem;
	import com.kavalok.gameWordTetris.McListItem;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import com.kavalok.events.EventSender;
	
	public class LevelListItem implements IListItem
	{
		private var _content:McListItem = new McListItem();
		private var _clickEvent:EventSender = new EventSender();
		
		public function LevelListItem(caption:String)
		{
			this.caption = caption;
			
			_content.button.addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			_clickEvent.sendEvent(this);
		}
		
		public function set caption(value:String):void
		{
			_content.captionField.text = value;
		}
		
		public function set selected(value:Boolean):void
		{
			var format:TextFormat = _content.captionField.getTextFormat();
			format.bold = value;
			format.underline = value;
			_content.captionField.setTextFormat(format);
		}
		
		public function get content():Sprite { return _content; }
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
	}
	
}