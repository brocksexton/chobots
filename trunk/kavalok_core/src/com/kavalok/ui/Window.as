package com.kavalok.ui
{
	import com.kavalok.Global;
	import com.kavalok.char.CharManager;
	import com.kavalok.char.Stuffs;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	public class Window
	{
		private var _windowId:String;
		private var _content:Sprite;
		private var _closeEvent:EventSender = new EventSender();
		
		public function Window(content:Sprite)
		{
			_content = content;
			
			new ResourceScanner().apply(_content);
			
			if (closeButton)
				closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		public function get windowId():String
		{
			if (!_windowId)
				_windowId = getQualifiedClassName(this);
				
			return _windowId;
		}
		
		public function onClose():void {}
		public function onActivate():void {}
		
		private function onCloseClick(e:MouseEvent):void
		{
	        Global.windowManager.closeWindow(this);
			closeEvent.sendEvent(this);
		}
		
		protected function get closeButton():InteractiveObject
		{
			return _content.getChildByName('closeButton') as InteractiveObject;
		}
		
		public function get visible():Boolean
		{
			 return _content.visible && content.stage;
		}
		
		public function get dragArea():InteractiveObject
		{
			 return null;
		}
		
		public function set alpha(value:Number):void
		{
			_content.alpha = value;
		}
		
		protected function initButton(button:InteractiveObject, handler:Function,
			toolTip:String, bundle:String = ResourceBundles.KAVALOK):void
		{
			//if(button.visible){ WTF ???
				button.addEventListener(MouseEvent.CLICK, handler);
				ToolTips.registerObject(button, toolTip, bundle);
			//}
		}
		
		public function closeWindow():void
		{
			Global.windowManager.closeWindow(this);
		}
		
		public function get closeEvent():EventSender { return _closeEvent; }
		
		public function get content():Sprite { return _content; }

	}
}