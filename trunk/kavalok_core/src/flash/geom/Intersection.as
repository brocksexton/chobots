// UTF-8
// translator: Flastar http://flastar.110mb.com
package flash.geom {

	/* *
	 * Если пересечение существует, то результатом вычисления может быть либо массив точек,
	 * либо полное или частичное совпадение фигур.<BR/>
	 * <BR/>
	 * Если значение <code>isCoincidence=false</code>, значит фигуры пересеклись и не совпали.
	 * В этом случае массив <code>currentTimes</code> будет содержать итераторы точек пересечения
	 * на текущем объекте, а массив <code>targetTimes</code> будет содержать итераторы точек
	 * пересечения на целевом объекте.<BR/>
	 * <BR/>
	 * Если значение <code>isCoincidence=true</code>, значит найдено совпадение.<BR/>
	 * Совпадение описывается парами итераторов, определяющих начало и конец фигуры совпадения.<BR/>
	 * Используйте метод <code>getSegment</code> для получения совпадающих фигур.<BR/>
	 * <BR/>
	 * К примеру, получая пересечение двух кривых Безье, требуется проверить, 
	 * существует ли пересечение и далее обрабатывать в зависимости от его типа:
	 * <BR/>
	 * <listing version="3.0">
	 * var intersection:Intersection = currentBezier.intersectionBezier(targetBezier);
	 * if (intersection) {
	 * 	if (intersection.isCoincidence) {
	 * 		// обработка совпадения
	 * 	} else {
	 * 		// обработка пересечения
	 * 	}
	 * }
	 * </listing>
	 * <BR/>
	 * <BR/>
	 * Совпадением двух отрезков может являться только отрезок.
	 * Он будет описан как пара значений в массиве currentTimes
	 * и соответствующая пара значений в массиве targetTimes.<BR/>
	 * Отрезок можно получить:<BR/>
	 * <listing version="3.0">
	 * currentLine.getSegment(intersection.currentTimes[0], intersection.currentTimes[1]);
	 * </listing>
	 * либо <BR/>
	 * <listing version="3.0">
	 * targetLine.getSegment(intersection.targetTimes[0], intersection.targetTimes[1]);
	 * </listing>
	 * результатом этих двух вычислений будет два эквивалентных отрезка.<BR/>
	 * 
	 * <BR/>
	 * <BR/>
	 * 
	 * Совпадение отрезка и кривой Безье может быть только, если кривая Безье вырождена 
	 * (управляющие точки лежат на одной линии).<BR/>
	 * В вырожденном случае возможна ситуация, при котором совпадение даст два отрезка (4 итератора).  
	 * 
	 * 
	 */
	/**
	 * If crossing exist, then result can be of array of points,
	 * or full or brownout coincidence of shapes.<BR/>
	 * <BR/>
	 * If variable <code>isCoincidence=false</code>, it means that shapes are crossing and not equally.
	 * In that case array <code>currentTimes</code> will have interators of points of crossing
	 * on current objects, and array <code>targetTimes</code> will contain interators of points
	 * of crossing on object.<BR/>
	 * <BR/>
	 * If variable <code>isCoincidence=true</code>, it means that found coincidence.<BR/>
	 * Coincidence describes by pair of interators, determinant begin and end of shape coincidence.<BR/>
	 * Use method <code>getSegment</code> for get coincidence shapes.<BR/>
	 * <BR/>
	 * For example, if you get crossing of two curves of Bezier, you must check, 
	 * are they crossing? And further work in influence from his type:
	 * <BR/>
	 * <listing version="3.0">
	 * var intersection:Intersection = currentBezier.intersectionBezier(targetBezier);
	 * if (intersection) {
	 * 	if (intersection.isCoincidence) {
	 * 		// processing of coincidence
	 * 	} else {
	 * 		// processing of crossing
	 * 	}
	 * }
	 * </listing>
	 * <BR/>
	 * <BR/>
	 * Coincidence of two segment of lines can be only segment of line.
	 * He will be describe how pair if variables in array currentTimes
	 * and correspond pair of variables in array targetTimes.<BR/>
	 * Segment of line can get:<BR/>
	 * <listing version="3.0">
	 * currentLine.getSegment(intersection.currentTimes[0], intersection.currentTimes[1]);
	 * </listing>
	 * or <BR/>
	 * <listing version="3.0">
	 * targetLine.getSegment(intersection.targetTimes[0], intersection.targetTimes[1]);
	 * </listing>
	 * Result of this two calculation will be two equivalent segments of line.<BR/>
	 * 
	 * <BR/>
	 * <BR/>
	 * 
	 * Coincidence segment of line and curve of Bezier can be only, if curve of Bezier to give rise
	 * (administrator points lie at one line).<BR/>
	 * 
	 * 
	 */	 
	public class Intersection extends Object {

		
		public static function isIntersectionPossible(current:Rectangle, target:Rectangle):Boolean {
			current = current.clone();
			target = target.clone();
			
			// fix negative
			if (current.width < 0) {
				current.x += current.width;
				current.width = -current.width;
			}
			if (current.height < 0) {
				current.y += current.height;
				current.height = -current.height;
			}
			
			if (target.width < 0) {
				target.x += target.width;
				target.width = -target.width;
			}
			if (target.height < 0) {
				target.y += target.height;
				target.height = -target.height;
			}
			// fix zero
			current.width += 1e-10;
			current.height += 1e-10;
			target.width += 1e-10;
			target.height += 1e-10;
			
			trace(current, target, current.intersects(target));
			return current.intersects(target);
		}

		
		/* *
		 * Свойство, указывающее на тип пересечения. 
		 * 
		 */
		/**
		 * Property, that show type of crossing.<BR/> 
		 * 
		 */
		public var isCoincidence:Boolean = false;

		/* *
		 * Массив, содержащий time-итераторы точек пересечения.
		 * time-итераторы задаются для объекта, метод которого был вызван. 
		 **/
		/**
		 * Array, having time-interators of points of crossing.
		 * time-interators given for object, method whose was call. 
		 **/
		public const currentTimes:Array = new Array();

		/* *
		 * Массив, содержащий time-итераторы точек пересечения.
		 * time-итераторы задаются для объекта, который был передан 
		 * в качестве аргумента при вызове метода получения пересечений. 
		 **/
		/**
		 * Array, having time-interators of points of crossing.
		 * time-interators given for object, whose was dan 
		 * in role argument with calling method for getting crossings. 
		 **/
		public const targetTimes:Array = new Array();
	}
}