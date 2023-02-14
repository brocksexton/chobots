package org.goverla.dragdrop {
	import org.goverla.dragdrop.common.DropAcceptance;
	import org.goverla.dragdrop.events.DirectDragEvent;
	import org.goverla.dragdrop.interfaces.IDirectDragSubject;
	import org.goverla.dragdrop.interfaces.IDragDropSubject;
	import org.goverla.dragdrop.interfaces.IDragView;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	

	internal class DragDropManager extends EventDispatcher {
		
		//private static const C_CODE : uint = 43;
		//private static const V_CODE : uint = 56;
		
		private static var _instance : DragDropManager;
		
		private var _dragTarget : IDragDropSubject;
		private var _dragInitiator : UIComponent;
		private var _dragInformation : Object;
		private var _dragView : IDragView;
		private var _directDragTarget : IDirectDragSubject;
		private var _directDragInitiator : IDirectDragSubject;
		private var _directDragSource : IDirectDragSubject;
		private var _directDragInformation : Object;
		
		private var _directDragInitialized : Boolean = false;
		
		public function DragDropManager() {
			Application.application.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function get dragInformation() : Object
		{
			return _dragInformation;
		}
		
		
		public function get isDragging() : Boolean
		{
			return _dragInformation != null;
		}
		
		public function drag() : void {
			if(_directDragSource != null) {
				_directDragInformation = _directDragSource.dragInformation;
				_directDragInitiator = _directDragSource;
			}
		}
		
		public function drop() : void {
			if(_directDragInitiator != null) {
				if(_directDragTarget.acceptDrop(_directDragInformation).dropAccepted) {
					_directDragInitiator.dropAccepted(_directDragInformation);
					_directDragTarget.doDrop(_directDragInformation);
				}
			}
		}
		
		public function addDirectDragSubject(subject : IDirectDragSubject) : void {
			subject.addEventListener(DirectDragEvent.SELECT_SOURCE, onSelectSource);
			subject.addEventListener(DirectDragEvent.SELECT_TARGET, onSelectTarget);
		}		

		public function addDragSubject(panel : IDragDropSubject) : void {
			panel.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			panel.addEventListener(DragEvent.DRAG_EXIT, onDragExit);
			panel.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
		}
		
		public function startDrag(dragInitiator : UIComponent, dragInformation : Object, mouseEvent : MouseEvent, dragView : IDragView = null) : void {
			var dragSource : DragSource = new DragSource();
//			mouseEvent.localY = 0;
//			mouseEvent.localY = 0;
			_dragInitiator = dragInitiator;
			_dragInformation = dragInformation;
			_dragView = dragView;
			DragManager.doDrag(dragInitiator, dragSource, mouseEvent, dragView, - mouseEvent.localX, - mouseEvent.localY);
		}
		
		private function onSelectSource(event : DirectDragEvent) : void {
			_directDragSource = IDirectDragSubject(event.target);
		}		
		
		private function onSelectTarget(event : DirectDragEvent) : void {
			_directDragTarget = IDirectDragSubject(event.target);
		}		
		
		private function onDragEnter(event : DragEvent) : void {
			if(_dragTarget == event.target) 
				return;
			
			_dragTarget = IDragDropSubject(event.target);
			if(_dragView != null) {
				_dragView.clearError();
			}
			var dragSource : DragSource = event.dragSource;
			 
			var dropAcceptance : DropAcceptance = _dragTarget.acceptDrop(_dragInformation); 
			if(dropAcceptance.dropAccepted) {
				DragManager.acceptDragDrop(_dragTarget);
			} else {
				if(_dragView != null) {
					_dragView.showError(dropAcceptance.errorMessage);
				}
			}
		}
		
		private function onDragExit(event : Object) : void {
			if(_dragView != null) {
				_dragView.clearError();
			}
			_dragTarget = null;
		}
		
		private function onDragDrop(event : DragEvent) : void {
			if(_dragInitiator is IDragDropSubject) {
				var dragInitiator : IDragDropSubject =  IDragDropSubject(_dragInitiator);
				dragInitiator.dropAccepted(_dragInformation);
			}
			IDragDropSubject(event.target).doDrop(_dragInformation);
			_dragTarget = null;
			_dragInformation = null;
		}
		
		private function onMouseUp(event : MouseEvent) : void
		{
			_dragInformation = null;
		}
		
	}
}