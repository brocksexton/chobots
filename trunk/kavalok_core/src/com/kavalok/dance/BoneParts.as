package com.kavalok.dance
{
	import com.kavalok.events.EventSender;
	import com.kavalok.kinematics.AngleConstraint;
	import com.kavalok.kinematics.IKMember;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BoneParts
	{
		private static const DRAG_OFFSET:Number=5;
		public var head:IKMember;
		public var pimpa:IKMember;
		public var body:IKMember;
		public var leftHandTop:IKMember;
		public var leftHandBottom:IKMember;
		public var rightHandTop:IKMember;
		public var rightHandBottom:IKMember;
		public var leftLeg:IKMember;
		public var rightLeg:IKMember;
		public var neck:IKMember;

		private var _jointBody:ModelJoints=new ModelJoints();
		private var _changeEvent:EventSender=new EventSender();

		private var _mappingDirection:Array=["body", "head", "pimpa", "neck"
			, "leftHandTop", "leftHandBottom", "rightHandTop", "rightHandBottom", "leftLeg", "rightLeg"];
		
		private var _mapping:Object=
			{
			body: "_ChBody2"
			, head: "_ChHead2"
			, pimpa: "_ChPimpa"
			, neck: "_ChUpper2"
			, leftHandTop: "_ChArmTop_left"
			, rightHandTop: "_ChArmTop_right"
			, leftHandBottom: "_ChArmBottom_left"
			, rightHandBottom: "_ChArmBottom_right"
			, leftLeg: "_ChLeg2_left"
			, rightLeg: "_ChLeg2_right"}

		public function BoneParts(content:MovieClip)
		{
			for (var name:String in _mapping)
			{
				var member:IKMember=new IKMember(content[_mapping[name]]);
				this[name]=member;
				member.changeEvent.addListener(changeEvent.sendEvent);
			}
			body.dragRect=new Rectangle(body.skin.x - DRAG_OFFSET, body.skin.y - DRAG_OFFSET, DRAG_OFFSET * 2, DRAG_OFFSET);
			addJoint(head, body, 0, new AngleConstraint(-30, 30));
			addJoint(pimpa, head, 0);
			addJoint(neck, body, Math.PI, new AngleConstraint(-20, 20));
			addJoint(leftHandTop, body, Math.PI, new AngleConstraint(-90, 30));
			addJoint(rightHandTop, body, 0, new AngleConstraint(150, 270));
			addJoint(leftHandBottom, leftHandTop, -Math.PI/2, new AngleConstraint(0, 120));
			addJoint(rightHandBottom, rightHandTop, -Math.PI/2, new AngleConstraint(-120, 0));
			addJoint(leftLeg, body, 0, new AngleConstraint(-270, -150));
			addJoint(rightLeg, body, Math.PI, new AngleConstraint(-30, 90));
		}

		public function get changeEvent():EventSender
		{
			return _changeEvent;
		}

		public function get coords():Object
		{
			var result:Object={};
			for (var name:String in _mapping)
			{
				var part:IKMember=this[name];
				result[name]=new BonePartInfo(part.skin.rotation, part.skin.x, part.skin.y);
			}
			return result;
		}

		public function set coords(value:Object):void
		{
			for each(var name:String in _mappingDirection)
			{
				var info:BonePartInfo=value[name];
				var part:IKMember=this[name];
				part.skin.x=info.x;
				part.skin.y=info.y;
				part.skin.rotation=info.a;
				part.fixAll();
			}
		}

		private function addJoint(child:IKMember, parent:IKMember, rotationOffset:Number=0, constraints:AngleConstraint=null):void
		{
			var joint:MovieClip=_jointBody[child.skin.name].joint;
			var point:Point=new Point(joint.x, joint.y);
			child.rotationOffset=rotationOffset;
			child.setParent(parent, GraphUtils.transformCoords(point, child.skin, parent.skin), constraints); //
		}

	}
}