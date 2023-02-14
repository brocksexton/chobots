// UTF-8
// translator: Flastar http://flastar.110mb.com

package flash.geom {

	public interface IParametric {

		/* *
		 * Режим ограничения линии.
		 * @default true   
		 **/
		 
		/**
		 * Regime of line constraint.
		 * @default true   
		 **/
		function get isSegment():Boolean;

		function set isSegment(value:Boolean):void;

		/**
		 * First control point of figure
		 * @default (0,0)
		 **/
		function get start():Point;

		function set start(value:Point):void;

		/**
		 * Last point of figure
		 * @default (0,0)
		 **/
		function get end():Point;

		function set end(value:Point):void;

		/**
		 * Length of figure
		 * @return Number
		 */
		function get length():Number;

		/* *
		 * Вычисляет и возвращает точку по time-итератору.
		 * @return Point;
		 **/
		/**
		 * Calculate and return 2-dimentional point by time-interator.
		 * @return Point;
		 **/
		function getPoint(time:Number, point:Point=null):Point;

		/* *
		 * Вычисляет и возвращает time-итератор точки по дистанции от <code>start</code>.
		 * @return Number;
		 **/
		 
		/**
		 * Calculate and return time-interator of point at distance from <code>start</code>.
		 * @return Number;
		 **/		 
		function getTimeByDistance(distance:Number):Number;

		/* *
		 * Вычисляет и возвращает массив time-итераторов точек с заданным шагом.
		 * @return Array;
		 **/
		 
		/**
		 * Calculate and return array of time-interators of points with given step.
		 * @return Array;
		 **/
		 
		function getTimesSequence(step:Number, startShift:Number = 0):Array;

		/**
		 * Calculate and return bounds rectangle.
		 * @return Rectangle;
		 **/
		 
		function get bounds():Rectangle;

		//  == management == 
		/* *
		 * Изменяет объект таким образом, что точка с заданным итератором
		 * примет координаты, определенные параметрами.
		 * @return void 
		 **/
		/**
		 * Change object, that point with given interator
		 * apply coordinates, definite by parameters.
		 * @return void 
		 **/
		 
		function setPoint(time:Number, x:Number = undefined, y:Number = undefined):void;

		/* *
		 * Смещает объект на заданную дистанцию по осям X и Y
		 * @return void 
		 **/
		 
		/**
		 * Move object at given distance by X Y
		 * @return void 
		 **/
		 
		function offset(dx:Number, dy:Number):void;

		/**
		 * 
		 * @return void 
		 **/
		 
		function angleOffset(value:Number, fulcrum:Point = null):void;

		/**
		 * Calculate and return time-interator of point, nearer to given. 
		 * @return Number
		 **/
		function getClosest(fromPoint:Point):Number;
		
		
		//		function getSegment (fromTime:Number=0, toTime:Number=1):IParametric;
		
		/**
		 * Calculate and return length of segment from point <code>start</code>
		 * at point, given by parameter <code>time</code>;
		 * @return Number
		 **/
		 
		function getSegmentLength(time:Number):Number;

		// == intersections ==
		/**
		 * Calcilate and return intersection with Line
		 * @return Intersection
		 **/
		function intersectionLine(line:Line):Intersection;

		/**
		 * Calcilate and return intersection with Bezier curve
		 * @return Intersection
		 **/
		function intersectionBezier(target:Bezier):Intersection;

		
		/**
		 * Calculate and return string presentation of object
		 * @return String
		 **/
		 
		function toString():String;
	}
}