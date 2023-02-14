package com.kavalok.kinematics
{

	import com.kavalok.collections.ArrayList;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class IKMember
	{

		public var skin:MovieClip;
		public var distance:Number;
		public var dragRect:Rectangle;
		public var rotationOffset:Number=0;

		private var _parent:IKMember=null;
		private var _offset:Point;
		private var _children:ArrayList;
		private var _rotationDiff:Number;
		private var _localOffset:Point;
		private var _mousePosition:Point;
		private var _angleConstraint:AngleConstraint;
		private var _changeEvent:EventSender=new EventSender();

		public function IKMember(sprite:MovieClip, angleOffset:int=0)
		{
			skin=sprite;
			_children=new ArrayList()
			skin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
		}

		public function get changeEvent():EventSender
		{
			return _changeEvent;
		}

		private function get offsetInParent():Point
		{
			return GraphUtils.transformCoords(_offset.clone(), _parent.skin, _parent.skin.parent);
		}

		public function setParent(parent:IKMember, offset:Point, constraints:AngleConstraint=null):void
		{
			_angleConstraint=constraints;
			_parent=parent;
			_offset=offset;
			_localOffset=GraphUtils.transformCoords(_offset.clone(), _parent.skin, skin);
//			skin.rotation = 0;
			var distancePoint:Point=new Point(offsetInParent.x - skin.x, offsetInParent.y - skin.y);
			distance=distancePoint.length;
			parent.addChild(this);
		}

		internal function addChild(child:IKMember):void
		{
			_children.push(child)
		}

//        public function addAngleConstrain(n1:IKMember,angle1:Number,n2:IKMember,angle2:Number){
//            fpr=new Array(n1,n2,angle1,angle2);
//        }

		private function onMouseDown(ev:MouseEvent):void
		{
			if (_parent)
			{
				var offset:Point=offsetInParent;
				var dx:Number=offset.x - skin.parent.mouseX;
				var dy:Number=offset.y - skin.parent.mouseY;
				var angle:Number=Math.atan2(dy, dx);
				var zeroPoint:Point=GraphUtils.transformCoords(new Point(), skin, skin.parent);
				dx=offset.x - zeroPoint.x;
				dy=offset.y - zeroPoint.y;
				var angleZero:Number=Math.atan2(dy, dx);
				_rotationDiff=angleZero - angle;
			}
			else
			{
				_mousePosition = new Point(skin.mouseX, skin.mouseY);
			}
			skin.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove)
			skin.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
		}

		private function onMouseUp(ev:MouseEvent):void
		{
			skin.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			skin.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove)
		}

		private function onMouseMove(ev:MouseEvent):void
		{
			move(skin.parent.mouseX, skin.parent.mouseY);
			changeEvent.sendEvent();
		}

		public function move(x:Number, y:Number):void
		{
			var childrenCoords:Array=getChildrenLocalCoords();
			var angleDiff:Number=0;
			if (_parent == null)
			{
				if (dragRect)
				{
					x=Maths.normalizeValue(x - _mousePosition.x, dragRect.left, dragRect.right);
					y=Maths.normalizeValue(y - _mousePosition.y, dragRect.top, dragRect.bottom);
				}
				skin.x=x
				skin.y=y
				angleDiff=0;
			}
			else
			{
				fixPosition();
				var offset:Point=offsetInParent;
				var dx:Number=offset.x - skin.parent.mouseX;
				var dy:Number=offset.y - skin.parent.mouseY;
				var angle:Number=Math.atan2(dy, dx) + Math.PI / 2 + _rotationDiff + rotationOffset;
				var rotation:Number=Maths.radiansToDegrees(angle); // - Math.PI/2 + angleOffset * Math.PI);
				if(validAngle(rotation))
				{
					angleDiff=rotation - skin.rotation;
					skin.rotation=rotation;
				}
			}
			moveChildren(childrenCoords, angleDiff);
		}

		private function simplifyAngle(value:Number):Number
		{
			return GraphUtils.simplifyAngle(value);
		}
		private function normalizeAngle(value:Number):Number
		{
			var result:Number=simplifyAngle(value);
			if (_angleConstraint)
			{
				var min:Number=simplifyAngle(_angleConstraint.min + _parent.skin.rotation);
				var max:Number=simplifyAngle(_angleConstraint.max + _parent.skin.rotation);
				if(max > min)
				{
					result = Maths.normalizeValue(simplifyAngle(value), min, max); 
				} 
				else if(result > max && result < min)
				{
					result = Math.abs(result - max) < Math.abs(result - min) ? max : min;
				}
			}
			return result;
		}

		public function validAngle(value:Number):Boolean
		{
			return normalizeAngle(value) == simplifyAngle(value);
		}

		public function fixAll():void
		{
			fixPosition();
			skin.rotation=normalizeAngle(skin.rotation);
		}

		public function fixPosition():void
		{
			if (_parent)
			{
				var localOffsetInParent:Point=GraphUtils.transformCoords(_localOffset.clone(), skin, skin.parent);
				skin.x+=offsetInParent.x - localOffsetInParent.x;
				skin.y+=offsetInParent.y - localOffsetInParent.y;
			}
		}

		public function moveWithChildren(newCoords:Point, angleDiff:Number):void
		{
			var childrenCoords:Array=getChildrenLocalCoords();
			skin.rotation+=angleDiff;
			skin.x=newCoords.x;
			skin.y=newCoords.y;
			fixPosition();
			moveChildren(childrenCoords, angleDiff);
		}

		private function moveChildren(coords:Array, angleDiff:Number):void
		{
			for (var i:int=0; i < coords.length; i++)
			{
				var oldPosition:Point=coords[i];
				var child:IKMember=_children[i];
				var newPosition:Point=GraphUtils.transformCoords(oldPosition, skin, child.skin.parent);
				child.moveWithChildren(newPosition, angleDiff);
			}
		}

		private function getChildrenLocalCoords():Array
		{
			var result:Array=[];
			for each (var child:IKMember in _children)
			{
				var localCoords:Point=GraphUtils.transformCoords(new Point(child.skin.x, child.skin.y), child.skin.parent, skin);
				result.push(localCoords);
			}
			return result;
		}

	}
}