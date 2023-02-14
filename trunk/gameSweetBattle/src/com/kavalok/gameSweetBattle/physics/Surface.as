package com.kavalok.gameSweetBattle.physics
{
	import com.kavalok.collections.ArrayList;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	import flash.display.*;
	import flash.geom.Point;
	import flash.text.TextField;

	public class Surface
	{
		public static const STEP_SIZE:int=20;
		private static const MARGIN:int=50;
		private static const POINT_NAME:String="mc_point0";
		private static const CYCLED_DISTANCE:Number=50;

		private static const DEBUG:Boolean=false;

		private var _points:ArrayList;
		private var _ground:Sprite;
		private var _walkArea:Sprite;
		private var _drawSprite:Sprite;
		private var _cycled:Boolean;

		public function Surface(ground:Sprite, walkArea:Sprite)
		{
			_ground=ground;
			_walkArea=walkArea;
			var stage:Stage=ground.stage;
			stage.addChild(_ground);
			if (DEBUG)
			{
				_drawSprite=new Sprite();
				stage.addChild(_drawSprite);
			}
			rebuild();

			stage.removeChild(_ground);

		/*for (var i:int = 0; i < _points.length; i++)
		   {
		   var p:Point = _points[i];
		   GraphUtils.transformCoords(p, Global.root, _ground);
		   Debug.drawPoint(Global.root, p);
		 }*/

		}

		public function getPoint(index : int) : Point
		{
			index %= _points.length;
			if(index < 0)
				index += _points.length;
			return _points[index];
		}
		
		public function getMoveInfo(from:Point, to:Point):MoveInfo
		{
			var moveInfo:MoveInfo=new MoveInfo();
			moveInfo.index1=getNearestIndex(from);
			moveInfo.index2=getNearestIndex(to);

			moveInfo.direction=(moveInfo.index1 < moveInfo.index2) ? 1 : -1;
			if (_cycled)
			{
				var straightDistance:Number=Math.abs(moveInfo.index1 - moveInfo.index2);
				var cycledDistance:Number=Math.abs(_points.length - Math.max(moveInfo.index1, moveInfo.index2) 
					+ Math.min(moveInfo.index1, moveInfo.index2));
				if (cycledDistance < straightDistance)
					moveInfo.direction*=-1;
			}

			moveInfo.index=moveInfo.index1;
			moveInfo.counter=0;
			moveInfo.stepsCount=0;
			return moveInfo;


		}

		public function getNearestIndex(point:Point):int
		{
			return getNearestIndexByPoints(point, _points);
		}

		private function getNearestIndexByPoints(point:Point, points:Array):int
		{
			var index:int=-1;
			var minDistance:Number;

			for (var i:int=0; i < points.length; i++)
			{
				var newDistance:Number=GraphUtils.distance2(point, points[i]);

				if (index == -1 || newDistance < minDistance)
				{
					index=i;
					minDistance=newDistance;
				}
			}
			return index;
		}

		public function getNearestVertIndex(point:Point):int
		{
			var index:int=-1;
			var minDistance2:Number;

			for (var i:int=0; i < _points.length; i++)
			{
				var d2:Number=GraphUtils.distance2(point, _points[i]);
				var vd:Number=Math.abs(point.x - _points[i].x);

				if (index < 0 || d2 < minDistance2 && vd < STEP_SIZE)
				{
					index=i;
					minDistance2=d2;
				}
			}

			return index;
		}

		private function rebuild():void
		{
			var pointMovies:Array=GraphUtils.getAllChildren(_ground, new PropertyCompareRequirement("name", POINT_NAME));
			var points:Array=Arrays.getConverted(pointMovies, new DisplayObjectToPoint());
			var startPoint:DisplayObject=_ground[POINT_NAME + "0"];
			var currentPoint:Point=new Point(startPoint.x, startPoint.y);
			_points=new ArrayList();
			_points.push(currentPoint);
			while (points.length > 0)
			{
				var index:int=getNearestIndexByPoints(currentPoint, points);
				currentPoint=points[index];
				_points.push(currentPoint);
				points.splice(index, 1);
				if (DEBUG)
				{
					_drawSprite.graphics.lineStyle(2, 0xff0000);
					_drawSprite.graphics.drawCircle(currentPoint.x, currentPoint.y, 1);
					var textField:TextField=new TextField();
					textField.text=_points.length.toString();
					textField.x=currentPoint.x;
					textField.y=currentPoint.y;
					_drawSprite.addChild(textField);
				}
			}
			var distance:Point=new Point(_points.last.x - _points.first.x, _points.last.y - _points.first.y);
			if (distance.length < CYCLED_DISTANCE)
				_cycled=true;
		}

		public function getNormal(index:int):Number
		{
			var p1:Point=getPoint(index - 1) || getPoint(index);
			var p2:Point=getPoint(index + 1) || getPoint(index);
			var a:Number=Math.atan2(p2.y - p1.y, p2.x - p1.x) + 0.5 * Math.PI;
			return a;
		}

		public function getAngle(index:int):Number
		{
			var p1:Point=_points[index - 1] || _points[index];
			var p2:Point=_points[index + 1] || _points[index];
			var a:Number=Math.atan2(p2.y - p1.y, p2.x - p1.x) + Math.PI;
			return a;
		}


		public function get ground():Sprite
		{
			return _ground;
		}

//		public function get points():Array
//		{
//			return _points;
//		}

	}
}