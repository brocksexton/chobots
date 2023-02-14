package org.goverla.collections {
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.core.IMXMLObject;
	
	import org.goverla.events.EditableControlEvent;
	import org.goverla.events.FormDataProviderEvent;
	import org.goverla.interfaces.IBindable;
	import org.goverla.interfaces.IBindableList;
	import org.goverla.interfaces.IBindableMultipleSelectionList;
	import org.goverla.interfaces.IIterator;
	import org.goverla.interfaces.IStringMap;
	import org.goverla.utils.Arrays;
	
	public class AbstractFormDataProvider extends EventDispatcher implements IStringMap, IMXMLObject {
		
		protected static const NEXT_FRAME_TIME : Number = 1;
		
		protected var timer : Timer;
		
		public function get editable() : Boolean {
			return true;
		}
		
		public function get length() : int {
			return serverValuesMap.length;
		}
		
		protected function get serverValuesMap() : StringMap {
			return _serverValuesMap;
		}
		
		protected function get clientValuesMap() : StringMap {
			return _clientValuesMap;
		}
		
		public function AbstractFormDataProvider() {
			super();

			timer = new Timer(NEXT_FRAME_TIME, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		} 
		
		public function valueIterator() : IIterator	{
			return serverValuesMap.valueIterator();
		}
		
		public function keyIterator() : IIterator	{
			return serverValuesMap.keyIterator();
		}		
		
		/**
		 * Store client field value for next submiting
		 */
		public function put(key : String, value : Object) : void {
			clientValuesMap.put(key, value);
			if (!timer.running) {
				timer.start();
			}
		}
		
		/**
		 * Get server field value by key  
		 */
		public function get(key : String) : Object {
			return serverValuesMap.get(key);
		}

		public function getListDataProvider(fieldName : String) : ArrayCollection {
			return new ArrayCollection();
		}
		
		public function refresh() : void {}
		
		/**
		 * Remove all client field values 
		 */
		public function clear() : void {
			clientValuesMap.clear();
			serverValuesMap.clear();
			clearBindedInstances();
			dispatchEvent(new FormDataProviderEvent(FormDataProviderEvent.REFRESH));
		}
		
		public function initialized(document : Object, id : String) : void {
			_document = document ? IFlexDisplayObject(document) : IFlexDisplayObject(Application.application);
		}
		
		public function addInstance(instance : IBindable) : void {
			_bindedInstances.addItem(instance);
			setBindableInstanceData(instance);
			instance.addEventListener(EditableControlEvent.SUBMIT_EDITED_VALUE, onSubmitEditedValue);
		}
		
		public function removeInstance(instance : IBindable) : void {
			if (_bindedInstances.contains(instance)) {
				_bindedInstances.removeItemAt(_bindedInstances.getItemIndex(instance));
				instance.removeEventListener(EditableControlEvent.SUBMIT_EDITED_VALUE, onSubmitEditedValue);
			}
		}
		
		/**
		 * Initialize this instance by server data pairs (key - value)
		 */
		protected function initializeByArrayCollection(collection : ArrayCollection) : void {
			serverValuesMap.clear();
		}
		
		protected function initializeBindedInstances() : void {
			for each (var instance : IBindable in _bindedInstances) {
				setBindableInstanceData(instance);
			}
		}
		
		protected function initializeBindableInstance(instance : IBindable) : void {
			if (clientValuesMap.containsKey(instance.fieldName) || clientValuesMap.length == 0) { 
				instance.value = get(instance.fieldName);
			}
		}
		
		protected function initializeBindableListInstance(instance : IBindableList) : void {
			IBindableList(instance).dataProvider = getListDataProvider(IBindable(instance).fieldName);
			for each(var item : Object in IBindableList(instance).dataProvider) {
				if (Number(item.data) == Number(get(IBindable(instance).fieldName))) {
					IBindableList(instance).selectedItem = item;
					return;
				}
			}
		}

		protected function initializeBindableMultipleListInstance(instance : IBindableMultipleSelectionList) : void {
			IBindableList(instance).dataProvider = getListDataProvider(IBindable(instance).fieldName);
			var selectedIndicies : ArrayCollection = new ArrayCollection(Arrays.objectToArray(get(IBindable(instance).fieldName)));
			var result : ArrayCollection = new ArrayCollection();
			for each(var item : Object in IBindableList(instance).dataProvider) {
				if (selectedIndicies.contains(item.data)) {
					result.addItem(item);
				}
			}
			IBindableMultipleSelectionList(instance).selectedItems = result.toArray();
		}
		
		/**
		 * Executes on next frame after algorythms completed
		 */
		protected function onTimerComplete(event : TimerEvent) : void {}
		
		private function setBindableInstanceData(instance : IBindable) : void {
			if (length > 0) {
				if (instance is IBindableList) {
					if (instance is IBindableMultipleSelectionList) {
						initializeBindableMultipleListInstance(IBindableMultipleSelectionList(instance));
					} else {
						initializeBindableListInstance(IBindableList(instance));
					}
				} else {
					initializeBindableInstance(instance);
				}
			}
		}
		
		private function clearBindedInstances() : void {
			for each (var instance : IBindable in _bindedInstances) {
				if (instance is IBindableList) {
					if (instance is IBindableMultipleSelectionList) {
						IBindableMultipleSelectionList(instance).selectedItems = new Array();
						IBindableMultipleSelectionList(instance).dataProvider = new Array()
						IBindableMultipleSelectionList(instance).selectedIndices = new Array();
					} else {
						IBindableList(instance).dataProvider = new Array();
						IBindableList(instance).selectedIndex = -1;
					}
				} else { 
					instance.value = null;
				}
			}
		}
		
		private function onSubmitEditedValue(event : EditableControlEvent) : void {
			var instance : IBindable = IBindable(event.target);
			if (instance is IBindableList) {
				if (instance is IBindableMultipleSelectionList) {
					var result : ArrayCollection = new ArrayCollection();
					for each (var selectedItem : Object in IBindableMultipleSelectionList(instance).selectedItems) {
						if (Number(selectedItem.data) != -1) {
							result.addItem(selectedItem.data);
						}
					}
					put(instance.fieldName, result.toArray());
				} else {
					var selectedData : Number = Number(IBindableList(instance).selectedItem.data);
					if (selectedData != -1) {
						put(instance.fieldName, Number(IBindableList(instance).selectedItem.data));
					} else {
						put(instance.fieldName, null);
					}
				}
			} else {
				put(instance.fieldName, instance.value);
			}
		}
		
		private var _bindedInstances : ArrayCollection = new ArrayCollection();
		
		private var _serverValuesMap : StringMap = new StringMap();
		
		private var _clientValuesMap : StringMap = new StringMap();
		
		private var _document : IFlexDisplayObject;

	}

}