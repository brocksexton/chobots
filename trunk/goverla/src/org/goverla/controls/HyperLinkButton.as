package org.goverla.controls {
	
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.Application;

	public class HyperLinkButton extends ExtendedLinkButton	{
		
		public function get url() : String {
			return _url;
		}
		
		public function set url(value : String) : void {
			_url = value;
			_urlChanged = true;
			invalidateProperties();
		}
		
		protected function get parsedUrl() : String {
			if (url != null) {
				return url.indexOf("@") > 0 ? "mailto:" + url : url;
			} else {
				return null;
			}
		}
		
		public function HyperLinkButton() {
			super();
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			_menu = new ContextMenu();
			_menu.hideBuiltInItems();
			
			var item : ContextMenuItem = new ContextMenuItem("Open link");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onOpenSelect);
			_menu.customItems.push(item);
			
			 item = new ContextMenuItem("Open in new tab");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onOpenInTabSelect);
			_menu.customItems.push(item);
			
			 item = new ContextMenuItem("Copy link address");
			 item.separatorBefore = true;
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onOpenCopyAddressSelect);
			_menu.customItems.push(item);
			
			 item = new ContextMenuItem("Copy link text");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onOpenCopyTextSelect);
			_menu.customItems.push(item);
		}
		
		protected override function commitProperties() : void {
			super.commitProperties();
			
			if (_urlChanged) {
				_urlChanged = false;
				toolTip = url;
				
				if (url == null || url == "") {
					styleName = "LinkBlank";
					buttonMode = false;
				} else {
					buttonMode = true;
				}
			}
		}
		
		private function onClick(event : MouseEvent) : void {
			if (url != null) {
				if (event.shiftKey) {
					navigateToURL(new URLRequest(parsedUrl), "_blank");
				} else {
					navigateToURL(new URLRequest(parsedUrl), "_self");
				}
			}
		}
		
		private function onOver(event : MouseEvent) : void {
			if (buttonMode) {
				_originalMenu = Application.application.contextMenu;
				Application.application.contextMenu = _menu;
			}
		}
		
		private function onOut(event : MouseEvent) : void {
			if (buttonMode) {
				Application.application.contextMenu = _originalMenu;
			}
		}
		
		private function onOpenSelect(event : ContextMenuEvent) : void {
			if (url != null) {
				navigateToURL(new URLRequest(parsedUrl), "_self");
			}
		}
		
		private function onOpenInTabSelect(event : ContextMenuEvent) : void {
			if (url != null) {
				navigateToURL(new URLRequest(parsedUrl), "_blank");
			}
		}
		
		private function onOpenCopyAddressSelect(event : ContextMenuEvent) : void {
			System.setClipboard(url);
		}
		
		private function onOpenCopyTextSelect(event : ContextMenuEvent) : void {
			System.setClipboard(label);
		}
		
		private var _url : String;
		
		private var _urlChanged : Boolean;
		
		private var _menu : ContextMenu;
		
		private var _originalMenu : ContextMenu;
		
	}
	
}