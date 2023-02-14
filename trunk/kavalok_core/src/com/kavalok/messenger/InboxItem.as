package com.kavalok.messenger
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.controls.IListItem;
	import com.kavalok.messeger.McInboxItem;
	import com.kavalok.messenger.commands.MessageBase;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class InboxItem implements IListItem
	{
		private var _content:McInboxItem = new McInboxItem();
		private var _message:MessageBase;
		
		private var _openEvent:EventSender = new EventSender(InboxItem);
		private var _removeEvent:EventSender = new EventSender();
		
		public function InboxItem(message:MessageBase)
		{
			_message = message;
			
			createIcon();
			
			_content.openButton.addEventListener(MouseEvent.CLICK, onOpenClick);
			_content.removeButton.addEventListener(MouseEvent.CLICK, onRemoveClick);
			
			if (_message.getTooltip() && _message.getTooltip().length > 0)
				ToolTips.registerObject(_content, _message.getTooltip());
			
			refresh();
		}
		
		private function createIcon():void
		{
			var iconClass:Class = _message.getIcon(); 
			if (iconClass)
			{
				GraphUtils.removeChildren(_content.iconClip);
				_content.iconClip.addChild(new iconClass());
			}
		}
		
		public function refresh():void
		{
			_content.txtCaption.text = _message.getCaption();
			
			var format:TextFormat = _content.txtCaption.getTextFormat();
			format.bold = !_message.readed;
			_content.txtCaption.setTextFormat(format);
		}
		
		private function onRemoveClick(e:MouseEvent):void
		{
			_removeEvent.sendEvent(this);
		}
		
		private function onOpenClick(e:MouseEvent):void
		{
			_openEvent.sendEvent(this);
		}
		
		public function get content():Sprite { return _content; }
		
		public function get message():MessageBase { return _message; }
		
		public function get openEvent():EventSender { return _openEvent; }
		public function get removeEvent():EventSender { return _removeEvent; }
		
	}
}