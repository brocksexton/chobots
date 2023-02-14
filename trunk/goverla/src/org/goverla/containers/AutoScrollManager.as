package org.goverla.containers {
	
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IFlexDisplayObject;
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	import mx.core.UITextField;

	public class AutoScrollManager extends EventDispatcher implements IMXMLObject {
		
		protected static const NEXT_FRAME_TIME : Number = 1;

		public function AutoScrollManager(target : IFlexDisplayObject = null) {
			super();

			_timer = new Timer(NEXT_FRAME_TIME, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		public function initialized(document : Object, id : String) : void {
			_document = document ? IFlexDisplayObject(document) : IFlexDisplayObject(Application.application);
		}
		
		public function addInstance(container : Container) : void {
			if (!_containers.contains(container)) {
				container.addEventListener(FocusEvent.FOCUS_IN, onContainerFocusIn);
				_containers.addItem(container);
			}
		}
		
		public function removeInstance(container : Container) : void {
			if (_containers.contains(container)) {
				container.removeEventListener(FocusEvent.FOCUS_IN, onContainerFocusIn);
				_containers.removeItemAt(_containers.getItemIndex(container));
			}
		}
		
		protected function onContainerFocusIn(event : FocusEvent) : void {
			var target : InteractiveObject = InteractiveObject(event.target);
			_container = Container(event.currentTarget);

			if (_container.contains(target)) {
				_focused = (target is UITextField ? target.parent : target);
				_focusedChanged = true;
				if (!_timer.running) {
					_timer.start();
				}
			}
		}
		
		protected function onTimerComplete(event : TimerEvent) : void {
			if (_focusedChanged) {
				var focusThickness : Number =
					(_focused is UIComponent ?
						UIComponent(_focused).getStyle("focusThickness") : 0);
	
				var viewMetricsAndPadding : EdgeMetrics = _container.viewMetricsAndPadding;
	
				var localPosition : Point = new Point(_focused.x, _focused.y);
				var globalPosition : Point = _focused.parent.localToGlobal(localPosition);
				var containerPosition : Point = _container.globalToLocal(globalPosition);

				var focusedBottom : Number = containerPosition.y + _focused.height + focusThickness;
				var containerBottom : Number = _container.height - viewMetricsAndPadding.bottom;
				if (focusedBottom > containerBottom) {
					_container.verticalScrollPosition += (focusedBottom - containerBottom);
				}
				
				var focusedTop : Number = containerPosition.y - focusThickness;
				var containerTop : Number = viewMetricsAndPadding.top;
				if (focusedTop < containerTop) {
					_container.verticalScrollPosition -= (containerTop - focusedTop);
				}
				
				var focusedRight : Number = containerPosition.x + _focused.width + focusThickness;
				var containerRight : Number = _container.width - viewMetricsAndPadding.right;
				if (focusedRight > containerRight) {
					_container.horizontalScrollPosition += (focusedRight - containerRight);
				}
				
				var focusedLeft : Number = containerPosition.x - focusThickness;
				var containerLeft : Number = viewMetricsAndPadding.left;
				if (focusedLeft < containerLeft) {
					_container.horizontalScrollPosition -= (containerLeft - focusedLeft);
				}
				
				_focusedChanged = false;
			}
		}
		
		private var _document : IFlexDisplayObject;
		
		private var _containers : ArrayCollection /* of containers */ = new ArrayCollection();
		
		private var _timer : Timer;
		
		private var _container : Container;
		
		private var _focused : InteractiveObject;
		
		private var _focusedChanged : Boolean;
		
	}

}