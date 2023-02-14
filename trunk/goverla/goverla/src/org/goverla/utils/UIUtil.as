package org.goverla.utils {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.UIComponentDescriptor;
	
	import org.goverla.errors.IllegalArgumentError;
	import org.goverla.reflection.Overload;
	import org.goverla.utils.ui.UIComponentSize;

	public class UIUtil {
		
		public static function findInstance(container:DisplayObjectContainer, instanceClass:Class):DisplayObject
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

		public static function setButtonText(button : SimpleButton, text : String = null) : void
		{
			var states : Array = [button.upState, button.downState, button.overState];
			for each(var state : DisplayObject in states)
			{
				if(state is Sprite)
				{
					var textField : TextField = TextField(findInstance(Sprite(state), TextField));
					if(textField != null)
						textField.text = text;
				} else if(state is TextField)
				{
					TextField(state).text = text;
				}
			}
			
		}		

		public static function scale(component : DisplayObject, maxHeight: Number, maxWidth : Number) : Number {
			var scale : Number = Math.min(maxHeight / component.height, maxWidth / component.width);
			component.height *= scale;
			component.width *= scale;
			return scale;
		}
		public static function removeChildren(parent : DisplayObjectContainer) : void {
			while(parent.numChildren > 0)
			{
				parent.removeChildAt(0);
			}
		}
		public static function getApplicationMousePosition() : Point {
			return new Point(Application.application.mouseX,
				Application.application.mouseY);
		}
		
		public static function getApplicationMouseShift(startPosition : Point) : Point {
			return subtractPoints(getApplicationMousePosition(), startPosition);
		}
	
		public static function sumPoints(point1 : Point, point2 : Point) : Point {
			return new Point(point1.x + point2.x, point1.y + point2.y);
		}
		
		public static function subtractPoints(point1 : Point, point2 : Point) : Point {
			return new Point(point1.x - point2.x, point1.y - point2.y);
		}
		
		public static function getPointByObject(object : DisplayObject) : Point {
			return new Point(object.x, object.y);
		}
		
		public static function convertToZoom(point : Point, zoom : Number) : Point {
			var result : Point = new Point();
			result.x = (point.x * 100) / zoom;
			result.y = (point.y * 100) / zoom;
			return result;
		}

		public static function getZoomDelta(relative : Point, zoom : Number) : Point {
			var deltaX : Number = (relative.x  * (zoom - 100)) / 100;
			var deltaY : Number = (relative.y * (zoom - 100)) / 100;
			var result : Point = convertToZoom(new Point(deltaX, deltaY), zoom);
			return result;
		}
		
		public static function roundPoint(point : Point) : Point {
			var result : Point = new Point();
			result.x = Math.round(point.x);
			result.y = Math.round(point.y);
			return result;
		}
		
		public static function isMouseOut(component : DisplayObject) : Boolean {
			if (component.mouseX < 0)
				return true;
			if (component.mouseY < 0)
				return true;
			if (component.mouseX > component.width)
				return true;
			if (component.mouseY > component.height)
				return true;
				
			return false;
		}
		
		public static function fitToScreen(component : UIComponent) : void {
			var position : Point = component.parent.localToGlobal(new Point(component.x, component.y));
			var screenSize : Point = component.systemManager.screen.size;
			
			if (position.x + component.width > screenSize.x) {
				position.x -= position.x + component.width - screenSize.x;
			}

			if (position.y + component.height > screenSize.y) {
				position.y -= position.y + component.height - screenSize.y;
			}
			
			if (position.x < 0) {
				position.x = 0;
			}
			
			if (position.y < 0) {
				position.y = 0;
			}
			
			var localPosition : Point = component.parent.globalToLocal(position);
			component.x = localPosition.x;
			component.y = localPosition.y;
		}
		
		public static function addIfHasNot(parent : UIComponent, child : UIComponent) : void {
			if (!hasChild(parent, child)) {
				parent.addChild(child);
			}
		}
		
		public static function removeIfHas(parent : UIComponent, child : UIComponent) : void {
			if (hasChild(parent, child)) {
				parent.removeChild(child);
			}
		} 
		
		public static function hasChild(parent : UIComponent, child : UIComponent) : Boolean {
			try {
				parent.getChildIndex(child);
				return true;
			} catch(e : ArgumentError) {
				return false;
			}
			
			return false;
		}
		
		public static function applyStyles(target : UIComponent, stylesDescriptor : Object) : void {
			for (var style : String in stylesDescriptor) {
				target.setStyle(style, stylesDescriptor[style]);
			}
		}	
		
		public static function setChildrenVisibility(view : DisplayObjectContainer, value : Boolean) : void {
			for (var index : Number = 0; index < Container(view).numChildren; index++) {
				var child : DisplayObject = Container(view).getChildAt(index);
				child.visible = value;			
			
				if (child is DisplayObjectContainer) {
					setChildrenVisibility(DisplayObjectContainer(child), value);	
				}
			}		
		}
		
		public static function setWidth(target : UIComponent, value : Object) : void {
			var o : Overload = new Overload(UIUtil);
			o.addHandler([UIComponent, Number], setWidthByNumber);
			o.addHandler([UIComponent, String], setWidthByString);
			o.forward(arguments);
		}
		
		private static function setWidthByNumber(target : UIComponent, value : Number) : void {
			target.width = value;
		}
		
		private static function setWidthByString(target : UIComponent, value : String) : void {
			var percentWidth : Number = Number(percentSizeRegExp.exec(value)[1]);
			target.percentWidth = percentWidth;
		}
	
		public static function setHeight(target : UIComponent, value : Object) : void {
			var o : Overload = new Overload(UIUtil);
			o.addHandler([UIComponent, Number], setHeightByNumber);
			o.addHandler([UIComponent, String], setWidthByString);
			o.forward(arguments);
		}
		
		private static function setHeightByNumber(target : UIComponent, value : Number) : void {
			target.height = value;
		}
		
		private static function setHeightByString(target : UIComponent, value : String) : void {
			var percentHeight : Number = Number(percentSizeRegExp.exec(value)[1]);
			target.percentHeight = percentHeight;
		}
	
		public static function squareContainsPoint(startPoint : Point, size : UIComponentSize, point : Point) : Boolean {
			var result : Boolean = (startPoint.x < point.x) 
									&& (startPoint.x + size.width > point.x)
									&& (startPoint.y < point.y) 
									&& (startPoint.y + size.height > point.y);
			return result;
		}
		
		public static function setSelectedItem(dataProviderObject : Object, item : Object) : int {
			var dataProvider : ArrayCollection = ArrayCollection(dataProviderObject.dataProvider);
			
			if (dataProvider.contains(item)) {
				dataProviderObject.selectedIndex = dataProvider.getItemIndex(item); 
			} else {
				throw new IllegalArgumentError("dataProvider doesn't contain such item: " + item);
			}

			return dataProviderObject.selectedIndex;
		}
		
		public static function rotateComponent(target : UIComponent, angle : Number, startingPoint : Point) : void {
			var globalStartPoint : Point = target.localToGlobal(startingPoint);
			target.rotation -= angle;
			var globalEndPoint : Point = target.localToGlobal(startingPoint);
			target.x += globalStartPoint.x - globalEndPoint.x;
			target.y += globalStartPoint.y - globalEndPoint.y;
		}
		
		public static function setComponentsVisibility(components : ArrayCollection, visible : Boolean) : void {
			for each (var component : UIComponent in components) {
				component.visible = visible;
			}
		}
		
		private static function updateAnchor(component : UIComponent, anchorSet : Boolean, styleName : String, 
				value : Number) : void {
			if (anchorSet) {
				component.setStyle(styleName, value);
			} else {
				component.setStyle(styleName, undefined);
			}
		}
		
		private static function get percentSizeRegExp() : RegExp {
			var result : RegExp = /(d+)%/;
			return result;
		}
		
		private static function applyAllStyles(object : UIComponent, childDescriptor : UIComponentDescriptor) : void {
			applyStyles(object, childDescriptor.stylesFactory());
		}

		private static function applyEvents(target : UIComponent, document : UIComponent, childDescriptor : UIComponentDescriptor) : void {
			for (var eventName : String in childDescriptor.events) {
				target.addEventListener(eventName, childDescriptor.events[eventName]);
			}
		}
		
	}

}