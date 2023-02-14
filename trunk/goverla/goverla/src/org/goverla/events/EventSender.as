package org.goverla.events 
{
	
	import org.goverla.utils.Objects;
	
	/**
	 * @author Maxym Hryniv
	 */
	public class EventSender {

		public static var errorHandler:Function;
		
		private var _listeners : Array = [];
		
		private var _type : Class;
		
		public function EventSender(type : Class = null) {
			_type = type;
		}
		
		public function addListener(listener : Function) : void {
			_listeners.push(listener);
		}
		
		public function addListenerIfHasNot(listener : Function) : void {
			if(!hasListener(listener)) {
				addListener(listener);
			}
		}
	
		public function removeListener(listener : Function) : void {
			if(_listeners.indexOf(listener) == -1) {
				throw new Error("List doesn't contain such listener");
			}
			_listeners.splice(_listeners.indexOf(listener), 1);
		}
		
		public function removeListeners() : void {
			_listeners = new Array();
		}

		public function setListener(listener : Function) : void {
			removeListeners();
			_listeners.push(listener);
		}
		
		public function sendEvent(eventObject : * = undefined) : void {
			var listenersCopy:Array = _listeners.slice();
			if (_type == null || (_type != null && eventObject is _type)) {
				for(var i : int = 0; i < listenersCopy.length; i++) {
					var listener : Function = Objects.castToFunction(listenersCopy[i]);
					if(eventObject == undefined)
					{
						if (errorHandler != null) {
							try {
								listener();
							} catch (e:Error) {
								errorHandler(e);
							}
						} else {
								listener();
						}
					}
					else
					{
						if (errorHandler != null) {
							try {
								listener(eventObject);
							} catch (e:Error) {
								errorHandler(e);
							}
						} else {
							listener(eventObject);
						}
					}
				}
			} else {
				throw new TypeError("The eventObject has incorrect event type!");
			}
		}

		public function hasListeners() : Boolean {
			return _listeners.length > 0;
		}
		
		public function hasListener(func : Function) : Boolean {
			return _listeners.indexOf(func) != -1;
		}
	}
}