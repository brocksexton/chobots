package com.kavalok.messenger
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.friend.FriendTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.IListItem;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ListItem implements IListItem
	{
		private var _content:MovieClip;
		private var _checkBox:StateButton;
		private var _doubleClickEvent:EventSender = new EventSender();
		private var _userId:Number;
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		public function ListItem(contentClass:Class, friend:FriendTO)
		{
			_content = new contentClass();
			_content.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			_checkBox = new StateButton(_content.mcCheck);
			name = friend.login;
				
			if (_content.getChildByName('txtServer'))
				Localiztion.getBundle(ResourceBundles.SERVER_SELECT).registerTextField(
					_content.txtServer, friend.server);
				
			GraphUtils.enableDoubleClick(_content);
			_userId = friend.userId;
		}
		
		private function onDoubleClick(e:MouseEvent):void
		{
			_doubleClickEvent.sendEvent(this);
		}
		
		public function get userId():Number
		{
			return _userId;
		}

		public function get name():String
		{
			return _content.txtName.text;
		}
		
		public function set name(value:String):void
		{
			_content.txtName.text = value;
		}
		
		public function get checked():Boolean
		{
			 return _checkBox.state == 2;
		}
		
		public function set checked(value:Boolean):void
		{
			 _checkBox.state = (value) ? 2 : 1;
		}
		
		public function get checkBox():StateButton
		{
			 return _checkBox;
		}
		
		public function get doubleClickEvent():EventSender { return _doubleClickEvent; }
	}
}