package com.kavalok.messenger
{
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.McMailAnimation;
	import com.kavalok.gameplay.controls.ListBox;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.interfaces.IRequirement;
	import com.kavalok.messenger.commands.CitizenMembershipEndMessage;
	import com.kavalok.messenger.commands.CitizenMembershipMessage;
	import com.kavalok.messenger.commands.MailMessage;
	import com.kavalok.messenger.commands.MessageBase;
	import com.kavalok.services.MessageService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.TypeRequirement;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MessageInbox
	{
		static private const MAX_HISTORY:int=10;

		private var _messages:Array=[];
		private var _messageEvent:EventSender=new EventSender();

		private var _content:McInboxView=new McInboxView();
		private var _scroller:Scroller=new Scroller(_content.mcVertScroll);
		private var _listBox:ListBox=new ListBox();
		private var _scrollBox:ScrollBox=new ScrollBox(_listBox.content, _content.mcMask, _scroller);

		public function MessageInbox()
		{
			_content.visible=false;
			_content.addChild(_listBox.content);
		}

		public function get messages():Array
		{
			return _messages;
		}

		public function get content():Sprite
		{
			return _content;
		}

		public function get hasNewMessages():Boolean
		{
			return Arrays.containsByRequirement(_messages, new PropertyCompareRequirement('readed', false));
		}

		public function addMessage(msg:MessageBase):void
		{
			_messages.push(msg);
			rebuild();
			refresh();
			_messageEvent.sendEvent();


			// Ticket #3934
			if (Global.locationManager.locationExists && Global.performanceManager.quality != 0 && msg.sender == null)
				showAnimation();
		}

		private function showAnimation():void
		{
			var clip:MovieClip=new McMailAnimation();
			clip.addEventListener(Event.COMPLETE, onAnimationComplete);
			Global.stage.addChild(clip);
		}

		private function onAnimationComplete(e:Event):void
		{
			var clip:MovieClip=e.target as MovieClip;
			clip.stop();
			GraphUtils.detachFromDisplay(clip);
		}

		public function removeMessage(msg:MessageBase):void
		{
			_messages.splice(_messages.indexOf(msg), 1);
			rebuild();
			refresh();

			if (_messages.length == 0)
				_content.visible=false;
		}

		public function get visible():Boolean
		{
			return _content.visible;
		}

		public function set visible(value:Boolean):void
		{
			_content.visible=value;

			if (value)
				Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, onPressOutside);
			else
				Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onPressOutside);
		}

		private function onPressOutside(e:MouseEvent):void
		{
			var x:int=Global.stage.mouseX;
			var y:int=Global.stage.mouseY;

			if (!_content.hitTestPoint(x, y, true))
				visible=false;
		}

		private function rebuild():void
		{
			_listBox.clear();

			for(var i:int=_messages.length - 1; i >= 0; i--)
			{
				var message:MessageBase=_messages[i];
				var item:InboxItem=new InboxItem(message);
				item.openEvent.addListener(onMessageOpen);
				item.removeEvent.addListener(onMessageRemove);
				_listBox.addItem(item);
			}

		}
		
		private function onMessageRemove(item:InboxItem):void
		{
			processMessage(item.message);
			removeMessage(item.message);
			_messageEvent.sendEvent();
		}

		private function onMessageOpen(item:InboxItem):void
		{
			var message:MessageBase=item.message;
			processMessage(message);

			if (message is MailMessage || message is CitizenMembershipMessage || message is CitizenMembershipEndMessage)
				removeLastMessage();
			else
				removeMessage(message);

			item.refresh();
			message.show();

			_messageEvent.sendEvent();
			Global.locationManager.stopUser();
			visible=false;
		}
		
		private function processMessage(message:MessageBase):void
		{
			message.readed=true;
			if (message.id >= 0)
			{
				new MessageService().deleteCommand(message.id);
				message.id=-1;
			}
		}

		private function removeLastMessage():void
		{
			var req:IRequirement=new TypeRequirement(MailMessage);
			var history:Array=Arrays.getByRequirement(_messages, req);

			if (history.length > MAX_HISTORY)
				removeMessage(history[0]);
		}

		public function refresh():void
		{
			_listBox.refresh();
			_scrollBox.refresh();
		}

		public function get count():int
		{
			return _messages.length;
		}

		public function get messageEvent():EventSender
		{
			return _messageEvent;
		}
	}
}


