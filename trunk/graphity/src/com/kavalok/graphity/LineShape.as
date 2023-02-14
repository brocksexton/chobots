package com.kavalok.graphity
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.SmoothCurve;
	
	public class LineShape extends Sprite
	{
		static private const MAX_SIZE:int = 70;
		static private const OPTIMIZE_VALUE:Number = 2;
		
		private var _points:Array = [];
		private var _info:LineInfo;
		private var _owner:String;
		private var _length:Number = 0;
		
		public function LineShape(info:LineInfo = null)
		{
			_info = info;
		}
		
		public function setStartPoint(x:int, y:int):void
		{
			_points = [new Point(x, y)];
			initGraphics();
		}
		
		public function addPoint(x:int, y:int):void
		{
			var point:Point = new Point(x ,y); 
			_points.push(point);
			graphics.lineTo(x, y);
			
			if (_points.length > 1)
				_length += GraphUtils.distance(_points[_points.length - 2], point);
		}
		
		private function initGraphics():void
		{
			graphics.clear();
			
			var thickness:Number = 2 + MAX_SIZE * _info.size;
			var alpha:Number = GraphUtils.claimRange(_info.alpha, 0.1, 1);
			graphics.lineStyle(thickness, _info.color, alpha);
			
			filters = [new BlurFilter(
				MAX_SIZE * _info.blur,
				MAX_SIZE * _info.blur)
			];
			
			
			graphics.moveTo(_points[0].x, _points[0].y);
		}
		
		public function optimize():void
		{
			while (_points.length > 3)
			{
				var i:int = 1;
				var flagDone:Boolean = true;
				
				while (i < _points.length - 1)
				{
					var distance:Number = getDistance(_points[i], _points[i-1], _points[i+1]);
					
					if (Math.abs(distance) < OPTIMIZE_VALUE)
					{
						flagDone = false;
						_points.splice(i, 1);
						i+=1;
					}
					else
					{
						i+=2
					}
				}
				
				if (flagDone)
					break;
			}
			
			repaint();
		}
		
		private function getDistance(p:Point, p0:Point, p1:Point):Number
		{
			var y01:Number = (p0.y - p1.y);
			var x10:Number = (p1.x - p0.x);
			
			return ( y01 * p.x + x10 * p.y + p0.x*p1.y - p1.x*p0.y )
				/ Math.sqrt( x10*x10 + y01*y01 );
		}
		
		public function repaint(smooth:Boolean = true):void
		{
			initGraphics();
			var i:int;
			
			if (smooth)
			{
				var curve:SmoothCurve = new SmoothCurve(_points[0], _points[_points.length - 1]);
				for (i = 1; i < _points.length - 1; i++)
				{
					curve.pushControl(_points[i]);
				}
				curve.draw(graphics);
			}
			else
			{
				graphics.moveTo(_points[0].x, _points[0].y); 
				for (i = 1; i < _points.length; i++)
				{
					graphics.lineTo(_points[i].x, _points[i].y); 
				}
			}
		}
		
		public function getState():Object
		{
			var array:Array = [];
			for each (var point:Point in _points)
			{
				var value:int = (point.x << 10) + point.y;
				array.push(value);
			}
			
			return {info: _info, points: array};;
		}
		
		public function restoreFromState(state:Object):void
		{
			_owner = state.charId;
			_info = new LineInfo();
			//ReflectUtil.copyFieldsAndProperties(state.info, _info);
			_info.alpha = state.info.alpha;
			_info.color = state.info.color;
			_info.blur = state.info.blur;
			_info.size = state.info.size;
			
			_points = [];
			for (var i:int = 0; i < state.points.length; i++)
			{
				var value:int = state.points[i];
				var x:int = value >> 10;
				var y:int = value & 1023;
				
				_points.push(new Point(x, y));
			}
			
			repaint();
		}
		
		public function get length():Number
		{
			 return _length;
		}
		
		public function get owner():String
		{
			 return _owner;
		}
	}
}