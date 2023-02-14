package common.utils
{
	import common.comparing.IRequirement;
	import common.comparing.TypeRequirement;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	* ...
	* @author Canab
	*/
	public class GraphUtil
	{
		static public function transformCoords(point:Point, source:DisplayObject,
			target:DisplayObject):Point
		{
			return target.globalToLocal(source.localToGlobal(point));
		}

		static public function bringToFront(object:DisplayObject):void
		{
			var parent:DisplayObjectContainer = object.parent;
			parent.setChildIndex(object, parent.numChildren - 1);
		}
		
		static public function sendToBack(object:DisplayObject):void
		{
			var parent:DisplayObjectContainer = object.parent;
			parent.setChildIndex(object, 0);
		}
		
		static public function setScale(object:DisplayObject, scale:Number):void
		{
			object.scaleX = object.scaleY = scale;
		}
		
		static public function createRectSprite(width:Number, height:Number,
			color:int = 0x000000, alpha:Number = 1):Sprite
		{
			var sprite:Sprite = new Sprite();
			
			sprite.graphics.beginFill(color, alpha);
			sprite.graphics.drawRect(0, 0, width, height);
			sprite.graphics.endFill();
			
			return sprite;
		}
		
		static public function getChildren(
			object:DisplayObjectContainer,
			requirement:IRequirement = null):Array
		{
			var result:Array = [];
			for (var i:int = 0; i < object.numChildren; i++)
			{
				var child:DisplayObject = object.getChildAt(i);
				if (requirement == null || requirement.accept(child))
					result.push(child)
			}
			return result;
		}

		static public function getAllChildren(
			object:DisplayObjectContainer,
			requirement:IRequirement = null):Array
		{
			var result:Array = getChildren(object, requirement);
			for each (var item:DisplayObject in result)
			{
				if (item is DisplayObjectContainer)
					result = result.concat(
						getAllChildren(DisplayObjectContainer(item), requirement));
				
			}
			return result;
		}
		
		static public function findObject(container:DisplayObjectContainer,
			requirement:IRequirement, recursive:Boolean = true):DisplayObject
		{
			if (recursive)
				return getChildren(container, requirement)[0];
			else
				return getAllChildren(container, requirement)[0];
		}
		
		static public function removeChildren(container:DisplayObjectContainer):void
		{
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
		}
		
		static public function addBoundsRect(object:Sprite, color:int = 0, alpha:Number = 0):void
		{
			var bounds:Rectangle = object.getBounds(object);
			var rect:Sprite = createRectSprite(bounds.width, bounds.height, color, alpha);
			object.addChild(rect);
			rect.x = bounds.x;
			rect.y = bounds.y;
		}
		
		static public function detachFromDisplay(displyObject:DisplayObject):void
		{
			displyObject.parent.removeChild(displyObject);
		}
		
		static public function getPixel(item:DisplayObject, x:int, y:int):int
		{
			var bitmapData:BitmapData = new BitmapData(4, 4);
			var matrix:Matrix = new Matrix();
			matrix.tx = -x;
			matrix.ty = -y;
			
			bitmapData.draw(item, matrix,
				item.transform.colorTransform,
				item.blendMode);
			
			return bitmapData.getPixel(1, 1);
		}
		
		static public function stopAllChildren(clip:MovieClip):void
		{
			clip.stop();
			
			var children:Array = getAllChildren(clip, new TypeRequirement(MovieClip));
			
			for each (var child:MovieClip in children)
			{
				if (child.totalFrames > 1)
					child.stop();
			}
		}
		
		static public function playAllChildren(clip:MovieClip):void
		{
			clip.play();
			
			var children:Array = getAllChildren(clip, new TypeRequirement(MovieClip));
			
			for each (var child:MovieClip in children)
			{
				if (child.totalFrames > 1)
					child.play();
			}
		}
		
		public static function claimBounds(object:DisplayObject, bounds:Rectangle):void
		{
			var rect:Rectangle = object.getBounds(object.parent);
			
			if (rect.left < bounds.left)
				object.x += bounds.left - rect.left;
			else if (rect.right > bounds.right)
				object.x += bounds.right - rect.right;
				
			if (rect.top < bounds.top)
				object.y += bounds.top - rect.top;
			else if (rect.bottom > bounds.bottom)
				object.y += bounds.bottom - rect.bottom;
		}
		
		static public function attachAfter(sprite:DisplayObject, after:DisplayObject):void
		{
			after.parent.addChildAt(sprite, after.parent.getChildIndex(after) + 1);
		}
		
		static public function attachBefore(sprite:DisplayObject, before:DisplayObject):void
		{
			before.parent.addChildAt(sprite, before.parent.getChildIndex(before));
		}
		
		static public function fromRGB(r:uint, g:uint, b:uint):uint
		{
			return r << 16 | g << 8 | b;
		}
		
		static public function toRGB(color:uint):Object
		{
			return { r: color >> 16, g: color >> 8 & 0x0000FF, b: color & 0x0000FF };
		}
		
		static public function getChildrenBounds(container:DisplayObjectContainer):Rectangle
		{
			var minX : Number = Number.MAX_VALUE;
			var maxX : Number = Number.MIN_VALUE;
			var minY : Number = Number.MAX_VALUE;
			var maxY : Number = Number.MIN_VALUE;
			
			for (var i:int = 0; i < container.numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				var bounds:Rectangle = child.getBounds(container);
				
				minX = Math.min(minX, bounds.x);
				minY = Math.min(minY, bounds.y);
				maxX = Math.max(maxX, bounds.right);
				maxY = Math.max(maxY, bounds.bottom);
			}
			
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}
		
		static public function setFontSize(field:TextField, size:int):void
		{
			var format:TextFormat = field.getTextFormat();
			format.size = size;
			field.setTextFormat(format);
		}
	
	}
	
}