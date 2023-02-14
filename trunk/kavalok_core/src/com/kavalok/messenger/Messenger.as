package com.kavalok.messenger
{
	import com.kavalok.Global;
	import com.kavalok.char.Friends;
	import com.kavalok.char.Crew;
	import com.kavalok.char.RobotTeam;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.friend.FriendTO;
		import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.controls.CheckBox;
	import com.kavalok.gameplay.controls.IListItem;
		import com.kavalok.messenger.McInputMessage;
		import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.gameplay.controls.ListBox;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.gameplay.controls.RadioGroup;
	import com.kavalok.gameplay.controls.ScrollBox;
	import com.kavalok.services.AdminService;
	import com.kavalok.gameplay.controls.Scroller;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.gameplay.windows.ShowCharViewCommand;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.commands.SendMessageCommand;
	import com.kavalok.messenger.commands.TeleportMessage;
	import com.kavalok.services.MessageService;
	import com.kavalok.ui.Window;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldType;
	
	public class Messenger extends Window
	{
		
		static public const ID:String = 'friends';
		static public const MARGIN:int = 10;
		
		private var _content:McMessenger;
		private var _radioGroup:RadioGroup;
		private var _checkButton:StateButton;
		private var _listBox:ListBox;
		private var _scroller:Scroller;
		private var _scrollBox:ScrollBox;
		private var _dialog:Sprite;
		private var _selection:Array = [];
		private var _dialog2:McInputMessage;
		private var _inviteMessage:String = "#null#";
		
		private var _bundle:ResourceBundle = Global.resourceBundles.kavalok;
		
		public function Messenger()
		{
			super(createContent());
			initButtons();
			friends.refreshEvent.addListener(rebuild);
			robotTeam.refreshEvent.addListener(rebuild);
			crew.refreshEvent.addListener(rebuild);
			Global.notifications.chatEnabledChange.addListener(refresh);
			rebuild();
			friends.refresh();
			robotTeam.refresh();
			crew.refresh();
		}
		
		override public function onClose():void
		{
			friends.refreshEvent.removeListener(rebuild);
			robotTeam.refreshEvent.removeListener(rebuild);
			crew.refreshEvent.removeListener(rebuild);
			Global.notifications.chatEnabledChange.removeListener(refresh);
			Global.localSettings.messengerPosition = new Point(_content.x, _content.y);
		}
		
		private function createContent():Sprite
		{
			var position:Point = Global.localSettings.messengerPosition;
			
			_content = new McMessenger();
			_content.x = position.x;
			_content.y = position.y;
			_content.friendsField.text = Global.messages.friends + ': ' + friends.length;
			_content.scrollRect = _content.getBounds(_content);
			
			_listBox = new ListBox();
			_content.addChild(_listBox.content);
			
			_scroller = new Scroller(_content.scroller);
			_scrollBox = new ScrollBox(_listBox.content, _content.mcMask, _scroller);
			
			_radioGroup = new RadioGroup();
			_radioGroup.addButton(new CheckBox(_content.onlineButton));
			_radioGroup.addButton(new CheckBox(_content.offlineButton));
			_radioGroup.addButton(new CheckBox(_content.teamButton));
			_radioGroup.addButton(new CheckBox(_content.crewButton));
			_radioGroup.selectedIndex = 0;
			_radioGroup.clickEvent.addListener(rebuild);
			
			_checkButton = new StateButton(_content.checkButton);
			_checkButton.stateEvent.addListener(onCheck);
			
			return _content;
		}
		
		private function initButtons():void
		{
			ToolTips.registerObject(_content.messageButton, 'sendMessage', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.teleportButton, 'inviteToPlace', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.removeButton, 'removeFriend', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.inviteButton, 'Share on Twitter', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.charButton, 'charWindow', ResourceBundles.KAVALOK);
			
			_content.messageButton.addEventListener(MouseEvent.CLICK, onMessageClick);
			_content.teleportButton.addEventListener(MouseEvent.CLICK, onTeleportClick);
			_content.removeButton.addEventListener(MouseEvent.CLICK, onRemoveClick);
			//	_content.inviteButton.addEventListener(MouseEvent.CLICK, onInviteClick);
			_content.inviteButton.visible = (Global.charManager.accessToken != "notoken");
			_content.inviteButton.addEventListener(MouseEvent.CLICK, onTwitClick);
			_content.charButton.addEventListener(MouseEvent.CLICK, onCharClick);
			
			ToolTips.registerObject(_content.onlineButton, 'friendsOnline', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.offlineButton, 'friendsOffline', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.teamButton, 'teamList', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.crewButton, 'Crew', ResourceBundles.KAVALOK);
			
			ToolTips.registerObject(_content.charButton, 'charWindow', ResourceBundles.KAVALOK);
			ToolTips.registerObject(_content.checkButton, 'checkAll', ResourceBundles.KAVALOK);
		}
		
		private function rebuild(sender:Object = null):void
		{
			var online:Array = [];
			var offline:Array = [];
			var others:Array = [];
			
			var friendsList:Array;
			if (_radioGroup.selectedIndex == 0 || _radioGroup.selectedIndex == 1)
				friendsList = friends.list;
			else if (_radioGroup.selectedIndex == 2)
				friendsList = robotTeam.list;
			else
				friendsList = crew.list;
			
			var serverName:String = Global.loginManager.server;
			
			for each (var friend:FriendTO in friendsList)
			{
				if (friend.server == serverName)
					online.push(friend);
				else if (friend.server == null)
					offline.push(friend);
				else
					others.push(friend);
			}
			
			_listBox.clear();
			
			if (_radioGroup.selectedIndex == 0)
			{
				createListGroup(online, McOnlineHeader, McOnlineItem, 'online');
				createListGroup(others, McOthersHeader, McOthersItem, 'onlineServer');
			}
			else if (_radioGroup.selectedIndex == 1)
			{
				createListGroup(offline, McOfflineHeader, McOfflineItem, 'offline');
			}
			else if (_radioGroup.selectedIndex == 2 || _radioGroup.selectedIndex == 3)
			{
				createListGroup(online, McOnlineHeader, McOnlineItem, 'online');
				createListGroup(others, McOthersHeader, McOthersItem, 'onlineServer');
				createListGroup(offline, McOfflineHeader, McOfflineItem, 'offline');
			}
			
			_listBox.refresh();
			_scrollBox.refresh();
			refresh();
		}
		
		private function refresh(sender:Object = null):void
		{
			var items:Array = _listBox.items;
			
			_selection = Arrays.getByRequirement(items, new CheckedRequirement());
			
			var checkedExists:Boolean = (_selection.length > 0);
			
			var unCheckedExists:Boolean = Arrays.containsByRequirement(items, new UnCheckedRequirement());
			
			var onlineExists:Boolean = Arrays.containsByRequirement(items, new OnlineRequirement());
			
			var offlineItems:Array = Arrays.getByRequirement(items, new OfflineRequirement());
			
			GraphUtils.setBtnEnabled(_content.teleportButton, onlineExists);
			GraphUtils.setBtnEnabled(_content.messageButton, checkedExists && Global.notifications.chatEnabled && offlineItems.length < 8);
			GraphUtils.setBtnEnabled(_content.removeButton, checkedExists && _radioGroup.selectedIndex != 2);
			GraphUtils.setBtnEnabled(_content.charButton, _selection.length == 1);
			
			if (checkedExists && unCheckedExists)
				_checkButton.state = 3;
			else if (checkedExists && !unCheckedExists)
				_checkButton.state = 2;
			else
				_checkButton.state = 1;

			_content.crewButton.visible = Global.charManager.crew.teamExists;
		}
		
		private function createListGroup(items:Array, headerClass:Class, itemClass:Class, caption:String):void
		{
			if (items.length == 0)
				return;
			
			items.sortOn('login');
			
			_listBox.addItem(new GroupHeader(headerClass, caption));
			
			for each (var friend:FriendTO in items)
			{
				var item:ListItem = new ListItem(itemClass, friend);
				item.checkBox.stateEvent.addListener(refresh);
				item.doubleClickEvent.addListener(onDoubleClick);
				item.checked = Arrays.containsByRequirement(_selection, new PropertyCompareRequirement('name', friend.login));
				
				_listBox.addItem(item);
			}
		}
		
		private function onDoubleClick(sender:ListItem):void
		{
			var charId:String = ListItem(sender).name;
			var userId:Number = ListItem(sender).userId;
			var command:ShowCharViewCommand = new ShowCharViewCommand(charId, userId);
			command.execute();
			clearSelection();
		}
		
		private function onInviteClick(e:MouseEvent):void
		{
			Dialogs.showInviteDialog();
		}
		
		private function onTwitClick(e:MouseEvent):void
		{
			Global.newTweet("Join me, " + Global.charManager.charId + ", on #chobots! I'm at " + Localiztion.getBundle("kavalok").messages[Global.locationManager.locationId] + " on " + Localiztion.getBundle("serverSelect").messages[Global.loginManager.server] + ".");
		}
		
		private function onCharClick(e:MouseEvent):void
		{
			var charId:String = ListItem(_selection[0]).name;
			var userId:Number = ListItem(_selection[0]).userId;
			var command:ShowCharViewCommand = new ShowCharViewCommand(charId, userId);
			command.execute();
			clearSelection();
		}
		
		private function onMessageClick(e:Event):void
		{
			var recipients:Array = []
			for each (var item:ListItem in _selection)
			{
				recipients.push(item.userId);
			}
			new SendMessageCommand(recipients).execute();
		}
		
		private function onTeleportClick(e:Event):void
		{
			_dialog2 = new McInputMessage();
			_dialog2.messageField.maxChars = KavalokConstants.MAX_CHAT_CHARS;
			_dialog2.messageField.restrict = Global.serverProperties.charSet;
			_dialog2.messageField.text = '';
			_dialog2.commitButton.addEventListener(MouseEvent.CLICK, onCommit);
			_dialog2.closeButton.addEventListener(MouseEvent.CLICK, sendTeleport);
			
			new TextScroller(_dialog2.scroller, _dialog2.messageField);
			
			_bundle.registerTextField(_dialog2.captionField, 'inviteMessage');
			_bundle.registerButton(_dialog2.commitButton, 'send');
			
			Dialogs.showDialogWindow(_dialog2);
			
			Global.stage.focus = _dialog2.messageField;
			
			if (!Global.notifications.chatEnabled)			
				_dialog2.messageField.type = TextFieldType.DYNAMIC;
		}


		private function onCommit(e:MouseEvent):void
		{
			_inviteMessage = (_dialog2.messageField.text.length > 2) ? _dialog2.messageField.text : "#null#";
			sendTeleport();
		}
		
		private function sendTeleport(e:Object = null):void
		{
			for each (var item:ListItem in _selection)
			{
				var command:TeleportMessage = new TeleportMessage();
				if(_inviteMessage != "#null#")
			command.text = _inviteMessage;
				new MessageService().sendCommand(item.userId, command, false);
			}
			Dialogs.hideDialogWindow(_dialog2);
		}
		
		private function onRemoveClick(e:Event):void
		{
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog(Global.messages.removeFriendsConf);
			dialog.yes.addListener(removeSelectedFriends);
		}
		
		private function removeSelectedFriends():void
		{
			var friendsList:Array = [];
			
			for each (var item:ListItem in _selection)
			{
				friendsList.push(item.userId);
			}
			
			friends.removeFriends(friendsList);
		}
		
		private function onCheck(sender:StateButton):void
		{
			if (_checkButton.state == 3)
				_checkButton.state = 1;
			
			for each (var item:IListItem in _listBox.items)
			{
				if (item is ListItem)
					ListItem(item).checked = (_checkButton.state == 2);
			}
			
			refresh();
		}
		
		private function clearSelection():void
		{
			for each (var item:IListItem in _listBox.items)
			{
				if (item is ListItem)
					ListItem(item).checked = false;
			}
			refresh();
		}
		
		override public function get windowId():String
		{
			return ID;
		}
		
		override public function get dragArea():InteractiveObject
		{
			return _content.header;
		}
		
		public function get friends():Friends
		{
			return Global.charManager.friends;
		}
		
		public function get robotTeam():RobotTeam
		{
			return Global.charManager.robotTeam;
		}

		public function get crew():Crew
		{
			return Global.charManager.crew;
		}
	}
}

import com.kavalok.interfaces.IRequirement;
import com.kavalok.messenger.ListItem;
import com.kavalok.messenger.McOfflineItem;

internal class CheckedRequirement implements IRequirement
{
	public function meet(object:Object):Boolean
	{
		return (object is ListItem && ListItem(object).checked);
	}
}

internal class UnCheckedRequirement implements IRequirement
{
	public function meet(object:Object):Boolean
	{
		return (object is ListItem && !ListItem(object).checked);
	}
}

internal class OnlineRequirement implements IRequirement
{
	public function meet(object:Object):Boolean
	{
		var item:ListItem = object as ListItem;
		
		if (item)
			return (item.checked && !(item.content is McOfflineItem));
		else
			return false;
	}
}

internal class OfflineRequirement implements IRequirement
{
	public function meet(object:Object):Boolean
	{
		var item:ListItem = object as ListItem;
		
		if (item)
			return (item.checked && (item.content is McOfflineItem));
		else
			return false;
	}
}