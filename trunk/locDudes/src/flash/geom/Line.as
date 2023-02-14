// UTF-8
// translator: Flastar http://flastar.110mb.com

package flash.geom {

	/* *
	 * Класс Line представляет линию в параметрическом представлении, 
	 * задаваемую точками на плоскости <code>start</code> и <code>end</code>
	 * и реализован в поддержку встроенного метода <code>lineTo()</code>.<BR/>
	 * В классе реализованы свойства и методы, предоставляющие доступ к основным 
	 * геометрическим свойствам линии.<BR/>
	 * Точки, принадлежащие линии определяются их time-итератором. 
	 * Итератор <code>t</code> точки на линии <code>P<sub>t</sub></code> равен отношению 
	 * расстояния от точки <code>P<sub>t</sub></code> до стартоврой точки <code>S</code> 
	 * к расстоянию от конечной точки <code>E</code> до стартовой точки <code>S</code>.  
	 * <BR/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;(E-S)&#42;t</code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Bezier
	 * @see Intersection
	 */
	 
	/**
	 * Class Line introdaction line at parametrical introduction, 
	 * given by points on plane <code>start</code> and <code>end</code>
	 * and realized to support internal method <code>lineTo()</code>.<BR/>
	 * At class realized properties and methods, they help you take access to basic 
	 * geometry properties of line.<BR/>
	 * Points, belongs to line defines by time-iterator. 
	 * Interator <code>t</code> points on line <code>P<sub>t</sub></code> equally bearing 
	 * distance from point <code>P<sub>t</sub></code> at start point <code>S</code> 
	 * with distace from end point <code>E</code> at start point <code>S</code>.  
	 * <BR/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;(E-S)&#42;t</code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Bezier
	 * @see Intersection
	 */

	public class Line extends Object implements IParametric {

		
		protected const PRECISION : Number = 1e-10;

		protected var __start : Point;
		protected var __end : Point;
		protected var __isSegment : Boolean;

		public function Line(start : Point = undefined, end : Point = undefined, isSegment : Boolean = true) {
			initInstance(start, end, isSegment);
		}

		protected function initInstance(start : Point = undefined, end : Point = undefined, isSegment : Boolean = true) : void {
			__start = (start as Point) || new Point();
			__end = (end as Point) || new Point();
			__isSegment = Boolean(isSegment);
		}

		/*
		 * Поскольку публичные переменные нельзя нельзя переопределять в дочерних классах, 
		 * start, end и isSegment реализованы как get-set методы, а не как публичные переменные.
		 */

		/* *
		 * Начальная опорная (anchor) точка отрезка. Итератор <code>time</code> равен нулю.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/

		/*
		 * As public variables impossible to redefine in daughter classes, 
		 * start, end and isSegment realized how get-set methods, not how public variables.
		 */

		/**
		 * First anchor point of piece of line. Interator <code>time</code> equally 0.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/

		
		public function get start() : Point {
			return __start;
		}

		public function set start(value : Point) : void {
			__start = value;
		}

		/* *
		 * Конечная опорная (anchor) точка отрезка. Итератор <code>time</code> равен единице.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		 
		/**
		 * Final bearing(anchor) point of piece of line. Interator <code>time</code> equally 1.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/

		public function get end() : Point {
			return __end;
		}

		public function set end(value : Point) : void {
			__end = value;
		}

		/* *
		 * Определяет является ли линия бесконечной в обе стороны
		 * или ограничена в пределах итераторов от 0 до 1.<BR/>
		 * <BR/>
		 * <BR/>
		 * Текущее значение isSegment влияет на результаты методов:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Bezier.html#intersectionLine">Bezier.intersectionLine</a><BR/>
		 * 
		 * @see #intersectionBezier
		 * @see #intersectionLine
		 * @see #getClosest
		 * 
		 * @default true
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		 
		/**
		 * Defined, is line infinite in both side
		 * or limited in borders of interators 0-1.<BR/>
		 * <BR/>
		 * <BR/>
		 * Current variable isSegment influense at results of methods:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Bezier.html#intersectionLine">Bezier.intersectionLine</a><BR/>
		 * 
		 * @see #intersectionBezier
		 * @see #intersectionLine
		 * @see #getClosest
		 * 
		 * @default true
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		public function get isSegment() : Boolean {
			return __isSegment;
		}

		public function set isSegment(value : Boolean) : void {
			__isSegment = Boolean(value);
		}

		/* *
		 * 
		 * @return Line копия текущего объекта Line.  
		 */	
		/**
		 * 
		 * @return Line copy of current object Line.  
		 */

		public function clone() : Line {
			return new Line(__start.clone(), __end.clone(), __isSegment);
		}

		/* *
		 * Угол наклона линии в радианах.
		 * Поворот осуществляется относительно точки <code>start</code>.
		 * Возвращаемое значение находится в пределах от положительного PI до отрицательного PI;
		 * 
		 **/
		/**
		 * Angle of incline line at radian.
		 * Rotate realize respecting at point <code>start</code>.
		 * The return value is between positive PI and negative PI. 
		 **/
		public function get angle() : Number {
			return Math.atan2(__end.y - __start.y, __end.x - __start.x);
		}

		public function set angle(rad : Number) : void {
			const distance : Number = Point.distance(__start, __end);
			const polar : Point = Point.polar(distance, rad);
			__end.x = __start.x + polar.x;
			__end.y = __start.y + polar.y; 
		}

		/* *
		 * Поворачивает линию относительно точки <code>fulcrum</code> на заданный угол.
		 * Если точка <code>fulcrum</code> не задана, используется (0,0);
		 * @param value:Number угол поворота в радианах
		 * @param fulcrum:Point центр вращения. 
		 * Если параметр не определен, центром вращения является точка <code>start</code>
		 */
		 
		/**
		 * Rotate line respection at point <code>fulcrum</code> at current angle.
		 * If point <code>fulcrum</code> undefined, then automatically use (0,0);
		 * @param value:Number angle(radian)
		 * @param fulcrum:Point center of rotation. 
		 * If variable undefined, center of rotation is point <code>start</code>
		 */

		public function angleOffset(rad : Number, fulcrum : Point = null) : void {
			fulcrum = fulcrum || new Point();
			const startLine : Line = new Line(fulcrum, __start);
			startLine.angle += rad;
			const endLine : Line = new Line(fulcrum, __end);
			endLine.angle += rad;
		}

		/* *
		 * Смещает линию на заданное расстояние по осям X и Y.  
		 * 
		 * @param dx:Number величина смещения по оси X
		 * @param dy:Number величина смещения по оси Y
		 * 
		 */
		 
		/**
		 * Move line at given distance at axes X and Y.  
		 * 
		 * @param dx:Number variable of moving at axe X
		 * @param dy:Number variable of moving at axe Y
		 * 
		 */		 		
		public function offset(dx : Number, dy : Number) : void {
			__start.offset(dx, dy);
			__end.offset(dx, dy);
		}

		/* *
		 * Вычисляет и возвращает длину отрезка <code>start</code>-<code>end</code>.
		 * Возвращаемое число всегда положительное значение; 
		 * @return Number;
		 **/
		/**
		 * Calculate and return length of piece of line <code>start</code>-<code>end</code>.
		 * Return number only positively; 
		 * @return Number;
		 **/

		public function get length() : Number {
			return Point.distance(__start, __end); 
		}

		/* *
		 * Вычисляет и возвращает точку на линии, заданную time-итератором.
		 * @param time time-итератор
		 * @return Point точка на линии
		 * 
		 */		
		/**
		 * Calculate and return point on line, given by time-iterator.
		 * @param time time-итератор
		 * @return Point point on line
		 * 
		 */
		public function getPoint(time : Number, point : Point = null) : Point {
			point = (point as Point) || new Point();
			point.x = __start.x + (__end.x - __start.x) * time;
			point.y = __start.y + (__end.y - __start.y) * time;
			return point;
		}

		/* *
		 * Вычисляет и возвращает time-итератор точки находящейся на заданной дистанции по линии от точки start. 
		 * @param distance:Number
		 * @return Number
		 * 
		 */
		 
		/**
		 * Calculate and return time-iterator of point that can be found at given distance on line from point start. 
		 * @param distance:Number
		 * @return Number
		 * 
		 */
		public function getTimeByDistance(distance : Number) : Number {
			return distance / Point.distance(__start, __end);
		}

		/* *
		 * Изменяет позицию точки <code>end</code> таким образром, 
		 * что точка <code>P<sub>time</sub></code> станет в координаты,
		 * заданные параметрами <code>x</code> и <code>y</code>.
		 * Если параметр <code>x</code> или <code>y</code> не определен,
		 * значение соответствующей координаты точки <code>P<sub>time</sub></code>
		 * не изменится. 
		 * @param time
		 * @param x
		 * @param y
		 * 
		 */		
		/**
		 * Change position of point <code>end</code>, 
		 * that point <code>P<sub>time</sub></code> take coordinates,
		 * given by parameters <code>x</code> and <code>y</code>.
		 * If parameter <code>x</code> or <code>y</code> undefined,
		 * correspond variable <code>P<sub>time</sub></code>
		 * don't change. 
		 * @param time 
		 * @param x
		 * @param y
		 * 
		 */
		public function setPoint(time : Number, x : Number = undefined, y : Number = undefined) : void {
			if (isNaN(x) && isNaN(y)) {
				return;
			}
			const point : Point = getPoint(time);
			if (!isNaN(x)) {
				point.x = x;
			}
			if (!isNaN(y)) {
				point.y = y;
			}
			__end.x = point.x + (point.x - __start.x) * ((1 - time) / time);
			__end.y = point.y + (point.y - __start.y) * ((1 - time) / time);
		}

		/* *
		 * Возвращает габаритный прямоугольник объекта. 
		 **/
		/**
		 * Return overall rectangle of object. 
		 **/
		public function get bounds() : Rectangle {
			if (__start.x > __end.x) {
				if (__start.y > __end.y) {
					return new Rectangle(__end.x, __end.y, __start.x - __end.x, __start.y - __end.y);
				} else {
					return new Rectangle(__end.x, __start.y, __start.x - __end.x, __end.y - __start.y);
				}
			}
			if (__start.y > __end.y) {
				return new Rectangle(__start.x, __end.y, __end.x - __start.x, __start.y - __end.y);
			} 
			return new Rectangle(__start.x, __start.y, __end.x - __start.x, __end.y - __start.y);
		}

		/* *
		 * Возвращает отрезок - сегмент линии, заданный начальным и конечным итераторами.
		 * 
		 * @param fromTime:Number time-итератор начальной точки сегмента
		 * @param toTime:Number time-итератор конечной точки сегмента кривой
		 * 
		 * @return Line 
		 * 
		 */		
		/**
		 * Return piece of line - segment of line, given by beginning and ending interators.
		 * 
		 * @param fromTime:Number time-iterator first point of segment
		 * @param toTime:Number time-iterator end point of segment of curve
		 * 
		 * @return Line 
		 * 
		 */
		public function getSegment(fromTime : Number = 0, toTime : Number = 1) : Line {
			return new Line(getPoint(fromTime), getPoint(toTime));
		}

		/* *
		 * Возвращает длину сегмента линии от точки <code>start</code> 
		 * до точки на линии, заданной time-итератором.
		 *  
		 * @param time - итератор точки.
		 * 
		 * @return Number 
		 * 
		 */
		/**
		 * Return length of segment of line from point <code>start</code> 
		 * at point on line, given by time-iterator.
		 *  
		 * @param time - iterator of point.
		 * 
		 * @return Number 
		 * 
		 */
		public function getSegmentLength(time : Number) : Number {
			return Point.distance(__start, getPoint(time));
		}

		/* *
		 * Вычисляет и возвращает массив точек на линии удаленных друг от друга на 
		 * расстояние, заданное параметром <code>step</code>.<BR/>
		 * Перавя точка массива будет смещена от стартовой точки на расстояние, 
		 * заданное параметром <code>startShift</code>. 
		 * При этом, если значение <code>startShift</code> превышает значение
		 * <code>step</code>, будет использован остаток от деления на <code>step</code>.<BR/>
		 * <BR/>
		 * Типичное применение данного метода - вычисление последовательности точек 
		 * для рисования пунктирных линий. 
		 * 
		 * @param step
		 * @param startShift
		 * @return 
		 * 
		 */
		/**
		 * Calculate and return array of points on line than can be found at distance 
		 * given be parameter <code>step</code>.<BR/>
		 * First point of array will be moved from start point at distance, 
		 * given be parameter <code>startShift</code>. 
		 * If variable <code>startShift</code> bigger then 
		 * <code>step</code>, will be used remainder from segmentation on <code>step</code>.<BR/>
		 * <BR/>
		 * Use this method it - calculating consecution of points 
		 * for drawing dotted lines. 
		 * 
		 * @param step
		 * @param startShift
		 * @return 
		 * 
		 */

		public function getTimesSequence(step : Number, startShift : Number = 0) : Array {
			step = Math.abs(step);
			const distance : Number = (startShift % step + step) % step;
			
			const times : Array = new Array();
			const lineLength : Number = Point.distance(__start, __end);
			if (distance > lineLength) {
				return times;
			}
			const timeStep : Number = step / lineLength;
			var time : Number = getTimeByDistance(distance);
			
			while (time <= 1) {
				times[times.length] = time;
				time += timeStep;
			}
			return times;
		}

		/* *
		 * Вычисляет и возвращает пересечение двух линий.
		 * @param line:Line
		 * @return Intersection;
		 * 
		 * @see #isSegment
		 */
		/**
		 * Calculate and return crossing of two lines.
		 * @param line:Line
		 * @return Intersection;
		 * 
		 * @see #isSegment
		 */

		
		public function intersectionLine(targetLine : Line) : Intersection {
			// checkBounds
			if (__isSegment && targetLine.__isSegment) {
				const fxMax : Number = Math.max(__start.x, __end.x);
				const fyMax : Number = Math.max(__start.y, __end.y);
				const fxMin : Number = Math.min(__start.x, __end.x);
				const fyMin : Number = Math.min(__start.y, __end.y);
				
				const sxMax : Number = Math.max(targetLine.__start.x, targetLine.__end.x);
				const syMax : Number = Math.max(targetLine.__start.y, targetLine.__end.y);
				const sxMin : Number = Math.min(targetLine.__start.x, targetLine.__end.x);
				const syMin : Number = Math.min(targetLine.__start.y, targetLine.__end.y);
		
				if (fxMax < sxMin || sxMax < fxMin || fyMax < syMin || syMax < fyMin) { 
					// no intersection
					return null;  
				} 
			}
			// end check bounds

			var intersection : Intersection;
			
			const fseX : Number = __end.x - __start.x;
			const fseY : Number = __end.y - __start.y;
			
			const sseX : Number = targetLine.__end.x - targetLine.__start.x;
			const sseY : Number = targetLine.__end.y - targetLine.__start.y;
			
			const sfsX : Number = __start.x - targetLine.__start.x;
			const sfsY : Number = __start.y - targetLine.__start.y;
			
			
			const denominator : Number = fseX * sseY - fseY * sseX;
			const a : Number = sseX * sfsY - sfsX * sseY;
			
			if (denominator == 0) { 
				if (a == 0) { 
					// TODO: new coincident type
					// coincident
					//					const sfeX:Number = start.x - targetLine.end.x;
					//					const sfeY:Number = start.y - targetLine.end.y;
					//					const startTime:Number = -(sfsX/fseX || sfsY/fseY) || 0;
					//					const endTime:Number = -(sfeX/fseX || sfeY/fseY) || 0;
					//					
					//					const order_array:Array = [new OrderedPoint(0, start),
					//						new OrderedPoint(1, end),
					//						new OrderedPoint(startTime, targetLine.start),
					//						new OrderedPoint(endTime, targetLine.end)];
					//					order_array.sortOn(OrderedPoint.TIME, Array.NUMERIC);
					//					
					//					const startOrdered:OrderedPoint = order_array[1];
					//					const endOrdered:OrderedPoint = order_array[2];

					intersection = new Intersection();
					intersection.isCoincidence = true;
					// intersection.coincidenceLine = new Line(startOrdered.point, endOrdered.point);
					return intersection;
				} else { 
					// parallel
					return null;
				}
			}
			
			const currentTime : Number = a / denominator;
			if (__isSegment) {
				if (currentTime < 0 || currentTime > 1) { 
					// no intersection
					return null;
				}
			}
			
			const b : Number = fseX * sfsY - sfsX * fseY;
			const oppositeTime : Number = b / denominator;
			if (targetLine.__isSegment) {
				if (oppositeTime < 0 || oppositeTime > 1) { 
					// no intersection
					return null;
				}
			}

			intersection = new Intersection();
			intersection.currentTimes[0] = currentTime;
			intersection.targetTimes[0] = oppositeTime;
			return intersection;
		}

		
		/* *
		 * Вычисляет и возвращает пересечение с Bezier;
		 * @param target:Bezier
		 * @return 
		 * 
		 */
		/**
		 * Calculate and return crossing with Bezier;
		 * @param target:Bezier
		 * @return 
		 * 
		 */		 		
		public function intersectionBezier(target : Bezier) : Intersection {
			const intersection : Intersection = new Intersection();
			target;
			return intersection;
		}

		/* *
		 * Вычисляет и возвращает точку на линии, ближайшую к заданной.
		 * @param fromPoint:Point - произвольная точка.
		 * @return Number - time-итератор точки на линии.
		 * @see isSegment
		 */
		/**
		 * Calculate and return point on line, the nearest at given.
		 * @param fromPoint:Point - free point.
		 * @return Number - time-interator of point on line.
		 * @see isSegment
		 */
		public function getClosest(fromPoint : Point) : Number {
			const from_distance : Number = Point.distance(__start, fromPoint);
			const from_angle : Number = Math.atan2(__start.y - __end.y, __start.x - __end.x);
			const difference : Number = from_angle - angle;
			const distance : Number = from_distance * Math.cos(difference);
			const time : Number = distance / length;
			if (!__isSegment) {
				return time;
			}
			if(time < 0) {
				return 0;
			}
			if (time > 1) {
				return 1;
			}
			return time;
		}

		
		
		//**************************************************
		//				UTILS 
		//**************************************************
		/**
		 * 
		 * @return 
		 * 
		 */
		public function toString() : String {
			return 	"(start:" + __start + ", end:" + __end + ")";
		}
	}
}

import flash.geom.Point;

class OrderedPoint {

	public static const TIME : String = "time";

	public var time : Number;
	public var point : Point;

	public function OrderedPoint(timeValue : Number, pt : Point) {
		time = timeValue;
		point = pt.clone();
	}
}
