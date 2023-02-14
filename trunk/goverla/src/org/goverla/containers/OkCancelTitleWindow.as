package org.goverla.containers {

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.TitleWindow;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.PopUpManager;
	
	import org.goverla.collections.HashMap;

	public class OkCancelTitleWindow extends TitleWindow implements IFocusManagerComponent {
		
		private static var _popUp : OkCancelTitleWindow;
		
		private static var _popUpsHashMap : HashMap = new HashMap();
		
		protected var okArguments : Array;
		
		protected var cancelArguments : Array;
		
		public function OkCancelTitleWindow() {
			super();

			showCloseButton = false;

			addEventListener(CloseEvent.CLOSE, onCancel);
		}
		
		public function get draggable() : Boolean {
			return _draggable;
		}

		public function set draggable(draggable : Boolean) : void {
			_draggable = draggable;
		}

		protected function get okCallback() : Function {
			return _okCallback;
		}
		
		protected function set okCallback(okCallback : Function) : void {
			_okCallback = okCallback;
		}
		
		protected function get cancelCallback() : Function {
			return _cancelCallback;
		}
		
		protected function set cancelCallback(cancelCallback : Function) : void {
			_cancelCallback = cancelCallback;
		}
		
		protected function get valid() : Boolean {
			return true;
		}
		
		protected function get modal() : Boolean {
			return _modal;
		}
		
		protected function set modal(value : Boolean) : void {
			_modal = value;
		}
		
		public static function showPopUp(popUpClass : Class,
			parent : DisplayObject = null,
			modal : Boolean = true,
			okCallback : Function = null,
			cancelCallback : Function = null) : OkCancelTitleWindow {
			
			if (!_popUpsHashMap.containsKey(popUpClass)) {
				_popUp = new popUpClass();
				_popUpsHashMap.addItem(popUpClass, _popUp);
			} else if (_popUp == null || !(_popUp is popUpClass)) {
				_popUp = OkCancelTitleWindow(_popUpsHashMap.getItem(popUpClass));
			}

			if (!_popUp.isPopUp) {
				var realParent : DisplayObject =
					(parent != null ? parent : DisplayObject(Application.application));
				PopUpManager.addPopUp(_popUp, realParent, modal);
			}
			
			_popUp.okArguments = [];
			_popUp.cancelArguments = [];
			_popUp.okCallback = okCallback;
			_popUp.cancelCallback = cancelCallback;
			_popUp.modal = modal;
			_popUp.locate();
			_popUp.show();
			
			return _popUp;
		}
		
		override protected function keyDownHandler(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.ESCAPE) {
                onCancel(event);
			}
			super.keyDownHandler(event);
		}

 		override protected function focusOutHandler(event : FocusEvent) : void {
			if (isPopUp && (event.relatedObject == null || !contains(event.relatedObject))) {
				onFocusOut();
			}
			super.focusOutHandler(event);
 		}
		
		override protected function startDragging(event : MouseEvent) : void {
			if (_draggable) {
				super.startDragging(event);
			}
		}
		
		protected function locate() : void {
			PopUpManager.centerPopUp(this);
		}
		
		protected function show() : void {
		}
		
		protected function hide() : void {
			if (isPopUp) {
				PopUpManager.removePopUp(this);
			}
		}
		
		protected function onFocusOut() : void {
			//// To prevent losing input data on focus lost (e.g. Alt-Tab in Windows)
		    //// we are calling hide() instead of onCancel(event);
		    //hide();
		}
		
		protected function onOk(event : Event) : void {
			if (valid) {
				if (_okCallback != null) {
					_okCallback.apply(this, okArguments);
				}
				hide();
			}
		}
		
		protected function onCancel(event : Event) : void {
			if (_cancelCallback != null) {
				_cancelCallback.apply(this, cancelArguments);
			}
			hide();
		}
		
		private var _okCallback : Function;
		
		private var _cancelCallback : Function;
		
		private var _draggable : Boolean;
		
		private var _modal : Boolean;
		
	}

}