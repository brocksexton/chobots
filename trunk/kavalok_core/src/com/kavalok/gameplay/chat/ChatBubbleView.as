package com.kavalok.gameplay.chat
{
	import com.kavalok.McChatBubble;
	import com.kavalok.gameplay.frame.safeChat.SafeChatListView;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Objects;
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	
	public class ChatBubbleView extends Sprite
	{
		static private const ALPHA:Number = 0.9;
		
		private static const MARGINS:Number = 5;
		private static const DELIMITER:String = " ";
		private static const TEXT_MARGINS:Number = 4;
		private static const MESSAGE_FORMAT:String = "<p align='center'><b>{0}</b> {1}</p>";
		private static const MAX_ITEMS:uint = 3;
		
		private var _field:TextField = new TextField();
		private var _format:TextFormat = new TextFormat();
	//	private var _fontColor:String;
		private var _bubble:McChatBubble = new McChatBubble();
		private	var _glowFilter:GlowFilter = new GlowFilter(0xFF0000, 50, 3, 3, 2, 50, false, false);
		
		public function ChatBubbleView()
		{
			this.cacheAsBitmap = true;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			_format.font = "Tahoma";
			_field.wordWrap = true;
			_field.multiline = true;
			_field.selectable = false;
			_field.autoSize = TextFieldAutoSize.CENTER;
			
			_bubble.stop();
			_bubble.alpha = ALPHA;
			_bubble.x = int(-0.5 * MARGINS);
			_bubble.y = int(-0.5 * MARGINS);
		}
		
		public function showMessage(to:String, message:Object, style:BubbleStyle = null):void
		{
			if (!style)
				style = BubbleStyles.defaultStyle;
			
			if (to == null)
				to = "";
			
			GraphUtils.removeChildren(this);
			
			if (message is String)
			{
				var text:String = Strings.substitute(MESSAGE_FORMAT, to, message);
				
				if(style.fontColor)
				_format.color = style.fontColor;

				_format.size = style.fontSize;
			
				_field.htmlText = Strings.trim(text);
				_field.setTextFormat(_format);
				if(style.Filter)
				_field.filters = [style.Filter];
				_field.width = style.maxWidth;
				_field.height = _field.textHeight;
				_field.width = Math.min(style.maxWidth, _field.textWidth + MARGINS);
				this.addChild(_field);
			}
			else
			{
				var itemsList:SafeChatListView = new SafeChatListView(null, Objects.castToArray(message), MAX_ITEMS);
				itemsList.content.y = 0.5 * MARGINS;
				this.addChild(itemsList.content);
			}
			
			var bottomHeight:int = 7;
			_bubble.gotoAndStop(style.frameNum);
			_bubble.width = int(this.width / this.scaleX + MARGINS + 2);
			_bubble.height = int(this.height / this.scaleY + MARGINS + bottomHeight);
			this.addChildAt(_bubble, 0);
		}
	
	}
}