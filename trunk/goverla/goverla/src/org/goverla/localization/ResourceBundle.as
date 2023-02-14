package org.goverla.localization
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import org.goverla.events.EventSender;
	import org.goverla.interfaces.IConverter;
	import org.goverla.utils.Objects;
	import org.goverla.utils.WeakReference;
	
	public class ResourceBundle
	{
		
		protected var id : String;
		
		private var _locale : String;
		private var _messageObjects : Object = new Object();
		private var _loaded : Boolean;
	
		private var _load:EventSender = new EventSender();
		private var _loadError:EventSender = new EventSender();

		public var messages : Object = new Object();
		
		public var textConverter : IConverter = new MessageConverter();
		
		public function ResourceBundle(id : String)
		{
			this.id = id;
		}
		
		public function get load():EventSender
		{
			return _load;
		}
	
		public function get loadError():EventSender
		{
			return _loadError;
		}
		
		public function get locale():String
		{
			return _locale;
		}

		public function set locale(value:String):void
		{
			if(_locale != value)
			{
				_loaded = false;
				_locale = value;
				loadLocale();
			}
		}
		
		public function registerButton(button : SimpleButton, messageId : String = null) : void
		{
			var states : Array = [button.upState, button.downState, button.overState];
			for each(var state : Sprite in states)
			{
				var textField : TextField = TextField(findInstance(state, TextField));
				if(textField != null)
					registerTextField(textField, messageId);
			}
			
		}
		public function registerTextField(field : TextField, messageId : String = null) : void
		{
			if(messageId == null)
			{
				messageId = field.text.replace('\r', '');
				field.text = "";
			}
			registerMessage(field, "text", messageId);
		}
		public function registerMessage(obj : Object, property : String, messageId : String) : void
		{
			if(_messageObjects[messageId] == null)
			{
				_messageObjects[messageId] = [];
			}
			var list : Array = _messageObjects[messageId];
			var reference : WeakReference = new WeakReference(obj, property);
			list.push(reference);
			if(_loaded)
			{
				update(messageId, obj, property);
			}
		}
		
		public function destroy() : void
		{
			_messageObjects = new Object();
		}
		
		protected function loadLocale() : void
		{
			if(locale == null)
				return;
			loadFromUrl(Localiztion.getUrl(id, locale));
		}
		
		protected function loadFromUrl(url : String) : void
		{
			var action : LoadMessagesAction = new LoadMessagesAction(url, this);
			action.loaded.addListener(onLoaded);
			action.failed.addListener(onLoadError);
			action.execute();
		}
		
		private function onLoadError() : void
		{
			_loaded = true;
			loadError.sendEvent();
		}
		private function onLoaded() : void
		{
			_loaded = true;
			updateAll();
			load.sendEvent();
		}

		private function updateAll() : void
		{
			for(var key : String in _messageObjects)
			{
				var list : Array = _messageObjects[key];
				for each(var reference : WeakReference in list)
				{
					if(!reference.alive)
					{
						list.splice(list.indexOf(reference), 1);
					}
					else
					{
						update(key, reference.value, Objects.castToString(reference.data));
					}
				}
				if(list.length == 0)
				{
					delete _messageObjects[key];
				}
			}
		}
		private function update(messageId : String, object : Object, property : String) : void
		{
			object[property] = messages[messageId] == null ? messageId : messages[messageId];
		}
		
		public function get loaded():Boolean
		{
			 return _loaded;
		}
		
		//Copypasted from UIUtil to optimize Localization weight
		private static function findInstance(container:DisplayObjectContainer, instanceClass:Class):DisplayObject
		{
			var result:DisplayObject = null;
			
			for (var i:int = 0; i < container.numChildren; i++)
			{
				result = container.getChildAt(i);
				
				if (result is instanceClass)
					return result;
				
				if (result is DisplayObjectContainer)
				{
					result = findInstance(DisplayObjectContainer(result), instanceClass);
					if (result != null)
						return result;
				}
			}
			
			return null;
		}
	}
}

