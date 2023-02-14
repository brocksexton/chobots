package com.kavalok.family
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.events.EventSender;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.services.CharService;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.DateUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class InfoView
	{
		private var _content:McItemInfo;
		private var _char:Char;
		private var _bundle:ResourceBundle = Localiztion.getBundle(ResourceBundles.FAMILY);
		
		private var _changeEvent:EventSender = new EventSender();
		
		public function InfoView(content:McItemInfo)
		{
			_content = content;
			
			initForm();
		}
		
		private function initForm():void
		{
			_bundle.registerTextField(_content.disableField, "disable");
			_bundle.registerTextField(_content.childField, "child");
			_bundle.registerTextField(_content.safeField, "safe");
			
			_content.chatSafeButton.addEventListener(MouseEvent.CLICK, onSafeClick);
			_content.chatFullButton.addEventListener(MouseEvent.CLICK, onFullClick);
			_content.childButton.addEventListener(MouseEvent.CLICK, onChildClick);
			_content.parentButton.addEventListener(MouseEvent.CLICK, onParentClick);
			_content.enableButton.addEventListener(MouseEvent.CLICK, onEnableClick);
			_content.disableButton.addEventListener(MouseEvent.CLICK, onDisableClick);
		}
		
		public function set char(value:Char):void
		{
			_char = value;
			refreshStatistic();
			refresh();
		}
		
		private function refreshStatistic():void
		{
			var date:Date = new Date();
			_content.dateField.text = DateUtil.toString(date);
			_content.playTimeField.text = '';
			
			new CharService(onStatisticResult).getSessionTime(_char.userId, date);
		}
		
		private function onStatisticResult(result:Number):void
		{
			_content.playTimeField.text = String(Math.round(result*100) / 100);
		}
		
		public function refresh():void
		{
			setButtonState(_content.chatSafeClip, _content.chatFullClip, _char.chatEnabledByParent);
			setButtonState(_content.childClip, _content.parentClip, _char.isParent);
			setButtonState(_content.disableClip, _content.enableClip, _char.enabled);
			
			_content.parentButton.visible = !_char.isUser;
			
			_content.childButton.visible = !_char.isUser;
			_content.childClip.visible = !_char.isUser;
			_content.childField.visible = !_char.isUser;
			
			_content.enableButton.visible = !_char.enabled;
			_content.chatFullButton.visible = !_char.chatEnabledByParent;
			
			_content.disableButton.visible = !_char.isParent;
			_content.disableClip.visible = !_char.isParent;
			_content.disableField.visible = !_char.isParent;
			
			_content.chatSafeButton.visible = !_char.isParent;
			_content.chatSafeClip.visible = !_char.isParent;
			_content.safeField.visible = !_char.isParent;
			
			_content.visible = Global.charManager.isParent;
		}
		
		private function setButtonState(clip1:MovieClip, clip2:MovieClip, value:Boolean):void
		{
			if (value)
			{
				clip1.gotoAndStop(1);
				clip2.gotoAndStop(2);
			}
			else
			{
				clip1.gotoAndStop(2);
				clip2.gotoAndStop(1);
			}
		}
		
		private function updateChar():void
		{
			Global.isLocked = false;
			
			if (_char.isUser && !Global.charManager.baned)
				Global.notifications.chatEnabled = _char.chatEnabledByParent; 
			
			new CharService(onUpdateComplete).setUserInfo(
				_char.userId,
				_char.enabled,
				_char.chatEnabledByParent,
				_char.isParent);
				
		//	new AdminService().saveIPBan("81.206.246.223", false, "");	
			trace("Family Saved");
		}
		
		private function onUpdateComplete(result:Object):void
		{
			Global.isLocked = false;
			changeEvent.sendEvent();
			refresh();
		}
		
		private function onSafeClick(e:MouseEvent):void
		{
			_char.chatEnabledByParent = false;
			updateChar();
		}
		
		private function onFullClick(e:MouseEvent):void
		{
			_char.chatEnabledByParent = true;
			updateChar();
			trace("set parent");
		}
		
		private function onChildClick(e:MouseEvent):void
		{
			_char.isParent = false;
			updateChar();
			trace("set child");
		}
		
		private function onParentClick(e:MouseEvent):void
		{
			_char.isParent = true;
			updateChar();
		}
		
		private function onEnableClick(e:MouseEvent):void
		{
			_char.enabled = true;
			updateChar();
		}
		
		private function onDisableClick(e:MouseEvent):void
		{
			_char.enabled = false;
			updateChar();
		}
		
		public function get content():Sprite
		{
			 return _content;
		}
		
		public function get changeEvent():EventSender
		{
			 return _changeEvent;
		}
		
	}
}