// UTF-8
/**
 *              I. INTRODUCTION
 *
 * There are two methods, that are used in ActionScript drawing: lineTo() and curveTo()
 * and realize sengment and Bezier second-order curve drawing correspondingly.
 * There are tools in Flash IDE to draw curves with Bezier third-order curves,
 * but during the compilation process they are approximated with second-order curves.
 * As the result, all shapes in compiled SWF-file become segments or Bezier second-order curves.
 * That's why we encounter a group of tasks, that need mathematical engine
 * to work with segments and Bezier second-order curves.
 *
 *
 *              II. BASE TASKS
 *
 * 1. Controlling:
 *   - using control points;
 *   - placing the particular point in particular coondinates;
 *   - rotating around any point;
 *   - offseting.
 * 2. Geometric properties:
 *   - finding actual point on curve or line by time-iterator;
 *   - parents (line for the segment and parabola for the Bezier curve)
 *   - length of the given segment
 *   - bounding rectangle
 *   - square (for the Bezier curve)
 *   - tangants
 * 3. Getting points on curve:
 *   - by distance from the beginning;
 *   - nearest to the given point;
 *   - inretsections with other segments and curves.
 *
 * Most of other practical tasks can be solved based on these solutions.
 *
 * Actually, these tasks are realizaed in this class package.
 * Samples for other practical tasks are located in <code>howtodo</code> package.
 *
 *
 *              III. CONCEPTIONS
 *
 * 1. <code>Bezier</code> and <code>Line</code> classes are realized in a similar way and most of
 * their methods have similar or the same syntax, defined by <code>IParametric</code> interface.
 * Of course, there are differencies: for example, <code>Line</code> doesn't have
 * <code>area</code> and <code>control</code> properties. <code>Bezier</code>
 * in it's turn doesn't have <code>angle</code>, that is presented in <code>Line.
 *
 * 2. Geometric figures (lines), defined in <code>Line</code> and <code>Bezier</code> classes,
 * are controlled in parametric form, every point of the figure is defined by it's time-iterator.
 * In the beginning it can seem inconvenient that computation of the point on curve returns
 * a time-iterator that is <code>Number</code> instead of <point>Point</point> class instance.
 * However, this realization helps us to avoid redundant convertations in future calculations.
 * To convert point on figure to the <class>Point</class>, use the <code>getPoint()</code> method.
 * To find time-iterator for the two-dimensional point, use the <code>getClosest()</code> method.
 *
 * 3. <class>Bezier</code> and <code>Line</code> instances can be infinite or limited with <code>start</code>
 * and <code>end</code> points. Limited nature can be set using <code>isSegment</code> property (default value
 * is <code>true</code>).
 * If you use <code>isSegment</code> <code>false</code>, then class methods results will include points that lie
 * outside of start-end segment. In other case, methods results will contain only points, that belong to
 * the segment, defined by <code>start</code> and <code>end</code> properties.
 *
 * @lang eng
 * @translator Maxim Kachurovskiy http://www.riapriority.com
 *
 **/

/* *
 * 		I. ВС ТУПЛЕНИЕ
 * 
 * Для программного рисования во Flash используется два метода: lineTo() и curveTo(),
 * реализующие соответственно отрисовку отрезка и кривой Безье второго порядка.
 * В редакторе Flash имеется возможность отрисовывать кривые с помощью кривых Безье
 * третьего порядка, однако, на этапе компиляции, они аппроксимируются кривыми
 * Безье второго порядка.
 * В итоге, все векторные фигуры в скомпилированном swf файле реализованы с помощью
 * отрезков или кривых Безье второго порядка.
 * В результате возникает целый спектр задач, для решения которых требуется математический
 * аппарат работы с отрезками и кривыми Безье второго порядка.
 * 
 * 
 * 		II. БАЗОВЫЕ ЗАДАЧИ
 * 
 * 1. управление:
 *   - с помощью контрольных точек;
 *   - установка заданной точки в произвольно заданые координаты;
 *   - поворот относительно произвольно заданной точки;
 *   - смещение на заданное расстояние.
 * 2. геометрические свойства:
 *   - получение точки на плоскости по известному time-итератору;
 *   - родители (прямая для отрезка и парабола для кривой Безье)
 *   - длина заданного сегмента
 *   - габаритный прямоугольник
 *   - площадь (для кривой Безье)
 *   - касательные
 * 3. получение точек на кривой:
 *   - по дистанции от начала;
 *   - ближайшей до произвольно заданной;
 *   - пересечения с другими кривыми и отрезками.
 * 
 * Подавляющее большинство остальных практических задач могут быть решены
 * на основе решений этих базовых задач. 
 * 
 * Собственно, перечисленные базовые задачи и реализованы в этом пакете классов. 
 * Примеры решения других практических задач вынесены в пакет howtodo.
 * 
 * 
 * 		III. КОНЦЕПЦИИ
 * 
 * 1. Классы Bezier и Line реализованы схожим образом и подавляющее большинство
 * их методов имеют либо схожий, либо аналогичный синтаксис, определенный интерфейсом IParametric.
 * Разумеется, есть и отличия: к примеру, у Line не может быть свойства area,
 * и отсутствует управляющая точка control; у Bezier, в свою очередь нет свойства
 * angle, присутствующего в Line.
 *
 * 2. Геометрические фигуры(линии), реализованные в классах Line и Bezier, задаются в
 * параметрической форме, и каждая точка фигуры характеризуется time-итератором.
 * Возможно, что поначалу покажется неудобным, что при вычислении точки на кривой
 * возвращается не привычный всем объект класса Point, а time-итератор,
 * являющийся Number. Однако такая реализация позволяет избежать избыточных 
 * конвертаций при последующих расчетах.
 * При необходимости перевести точку фигуры в объект Point, используйте метод getPoint().
 * При необходимости найти time-итератор двумерной точки, используйте метод getClosest().
 * 
 * 3. Объекты Bezier и Line могут быть бесконечны, либо ограничены конечными точками start и end.
 * Ограниченность может быть установлена свойством isSegment (по умолчанию true).
 * Если задать isSegment=false, то возвращаемые методами значения будут содержать точки, в том числе, 
 * лежащие за пределами сегмента start-end. В противном случае, возвращаемые методами значения 
 * будут содержать только точки, принадлежащие сегменту лежащему между start и end.
 * 
 * TODO: [Dembicki] Дописать
 **/
 

 
 

package flash.geom {
	import flash.math.Equations;	

	/* * 
	 * <P>
	 * Класс Bezier представляет кривую Безье второго порядка в параметрическом представлении, 
	 * задаваемую точками на плоскости <code>start</code>, <code>control</code> и <code>end</code>
	 * и реализован в поддержку встроенного метода curveTo(). 
	 * В классе реализованы свойства и методы, предоставляющие доступ к основным геометрическим свойствам этой кривой.
	 * </P>
	 * <BR/>
	 * <h2>Краткие сведения о кривой Безье второго порядка.</h2>
	 * Любая точка P<sub>t</sub> на кривой Безье второго порядка вычисляется по формуле:<BR/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;S&#42;(1-t)<sup>2</sup>&nbsp;+&nbsp;2&#42;C&#42;(1-t)&#42;t&nbsp;+&nbsp;E&#42;t<sup>2</sup></code>&nbsp;&nbsp;&nbsp;&nbsp;(1)</h2><BR/>
	 * где: <BR/>
	 * <code><B>t</B></code> (<code><b>t</b>ime</code>) — time-итератор точки<BR/>
	 * <code><B>S</B></code> (<code><b>s</b>tart</code>) — начальная опорная (узловая) точка (<code>t=0</code>) (anchor point)<BR/>
	 * <code><B>С</B></code> (<code><b>c</b>ontrol</code>) — управляющая точка (direction point)<BR/> 
	 * <code><B>E</B></code> (<code><b>e</b>nd</code>) — конечная опорная (узловая) точка (<code>t=1</code>) (anchor point)<BR/>
	 * <BR/>
	 * Построение производится итерационным вычислением множества точек кривой, c изменением значения итератора t в пределах от нуля до единицы.<BR/>
	 * Точка кривой Безье характеризуется time-итератором.
	 * Две точки кривой, имеющие одинаковый time-итератор совпадут.
	 * В общем случае две точки кривой Безье второго порядка с различным time-итератором не совпадут.<BR/>
	 * <a name="bezier_building_demo"></a>
	 * <table width="100%" border=1><td>
	 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *			id="Step1Building" width="100%" height="500"
	 *			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *			<param name="movie" value="../../images/Step01Building.swf" />
	 *			<param name="quality" value="high" />
	 *			<param name="bgcolor" value="#FFFFFF" />
	 *			<param name="allowScriptAccess" value="sameDomain" />
	 *			<embed src="../../images/Step1Building.swf" quality="high" bgcolor="#FFFFFF"
	 *				width="100%" height="400" name="Step01Building"
	 * 				align="middle"
	 *				play="true"
	 *				loop="false"
	 *				quality="high"
	 *				allowScriptAccess="sameDomain"
	 *				type="application/x-shockwave-flash"
	 *				pluginspage="http://www.adobe.com/go/getflashplayer">
	 *			</embed>
	 *	</object>
	 * </td></table>
	 * <BR/>
	 * <P ALIGN="center"><B>Интерактивная демонстрация</B><BR/>
	 * <I>Используйте клавиши "влево" "вправо" для управления итератором.<BR/>
	 * Мышью перемещайте контрольные точки кривой.</I></P><BR/>
	 * <BR/>
	 * <h3>Свойства кривой Безье второго порядка</h3>
	 * <ul>
	 * 		<li>кривая непрерывна</li>
	 * 		<li>кривая аффинно-инвариантна</li>
	 * 		<li>все точки кривой Безье лежат в пределах треугольника ∆SCE</li>
	 * 		<li>точки <code>S</code> и <code>E</code> всегда принадлежат кривой Безье и ограничивают ее.</li>
	 * 		<li>точки с равномерно изменяющимся итератором распределены плотнее на участках с бóльшим изгибом</li>
	 * 		<li>вершина кривой Безье — точка с итератором <code>t=0.5</code> лежит на середине отрезка, соединяюшем <code>С</code> и середину отрезка <code>SE</code>.</li>
	 * 		<li>точка <code>C</code> в общем случае не принадлежит кривой и лежит на пересечении касательных к кривой в точках <code>S</code> и <code>E</code></li>
	 * 		<li>если точка <code>С</code> лежит на прямой <code>SE</code>, то такая кривая является вырожденной</li>
	 * 		<li>площадь фигуры, образуемой кривой Безье и отрезком <code>SE</code> равняется 2/3 </li>
	 * </ul>
	 * <h3>Кривая Безье и парабола</h3>
	 * Кривая Безье второго порядка является сегментом параболы.
	 * Кривая, построенная по <a href="#formula1">формуле <B>1</B></a>, и итератором <code><B>t</B></code> изменяющимся в бесконечных пределах является параболой. 
	 * Если кривая Безье лежит на параболе, то такая парабола по отношению к ней является родительской.
	 * <UL>
	 * 		<I>
	 * 		Это свойство также относится и к кривым Безье других степеней. Так, к примеру, отрезок можно 
	 * 		рассматривать как Безье первого порядка, а его родителем будет линия, которой принадлежит этот отрезок.
	 * 		Класс <a href="Line.html">Line</a> именно так интерпретирует отрезок для упрощения использования совместно с классом Bezier.<BR/>
	 * 		Кривая Безье третьего порядка на плоскости - сегмент проекции на плоскость кубической параболы, построеной в трехмерном пространстве.
	 * 		И общай случай: Кривая Безье порядка N на плоскости - сегмент проекции на плоскость N-мерной кривой, построеной в N-мерном пространстве.
	 * 		</I>
	 * </UL>
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @see Line
	 * @see Intersection
	 *  
	 **/
		 
	/**
	 * <p>
	 * Class <code>Bezier</code> represents a Bezier second-order curve in parametric view,
	 * and is given by <code>start</code>, <code>control</code> and <code>end</code> points on the plane.
	 * It exists to support the <code>curveTo()</code> method. Methods and properties of this class
	 * give access to the geometric properties of the curve.
	 * </p>
	 * <br/>
	 * <h2>Brief information about the Bezier second-order curve.</h2>
	 * Any point <code>P<sub>t</sub></code> on the Bezier second-order curve is computed using formula:<br/>
	 * <a name="formula1"></a><h2><code>P<sub>t</sub>&nbsp;=&nbsp;S&#42;(1-t)<sup>2</sup>
	 * &nbsp;+&nbsp;2&#42;C&#42;(1-t)&#42;t&nbsp;+&nbsp;E&#42;t<sup>2</sup></code>&nbsp;
	 * &nbsp;&nbsp;&nbsp;(1)</h2><br/>
	 * where: <br/>
	 * <code><strong>t</strong></code>(<code><strong>t</strong>ime</code>) — time-iterator of the point<br/>
	 * <code><strong>S</strong></code>(<code><strong>s</strong>tart</code>) — initial control (anchor) point (<code>t=0</code>)<br/>
	 * <code><strong>С</strong></code>(<code><strong>c</strong>ontrol</code>) — direction point<br/>
	 * <code><strong>E</strong></code>(<code><strong>e</strong>nd</code>) — final control (anchor) point (<code>t=1</code>)<br/>
	 * <br/>
	 * The curve is built by iterative computing of the curve points
	 * with time-iterator modification from 0 to 1<br/>
	 * Bezier curve point is characterized by it's time-iterator.
	 * Two curve points with the same time-iterator coincide.
	 * Generally, two curve points with different time-iterator do not coincide.<br/>
	 * <a name="bezier_building_demo"></a>
	 * <table width="100%" border=1><td>
	 * <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	 *				      id="Step1Building" width="100%" height="500"
	 *				      codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
	 *				      <param name="movie" value="../../images/Step01Building.swf" />
	 *				      <param name="quality" value="high" />
	 *				      <param name="bgcolor" value="#FFFFFF" />
	 *				      <param name="allowScriptAccess" value="sameDomain" />
	 *				      <embed src="../../images/Step1Building.swf" quality="high" bgcolor="#FFFFFF"
	 *						      width="100%" height="400" name="Step01Building"
	 *						      align="middle"
	 *						      play="true"
	 *						      loop="false"
	 *						      quality="high"
	 *						      allowScriptAccess="sameDomain"
	 *						      type="application/x-shockwave-flash"
	 *						      pluginspage="http://www.adobe.com/go/getflashplayer">
	 *				      </embed>
	 *      </object>
	 * </td></table>
	 * <br/>
	 * <p align="center"><strong>Interactive demo</strong><br/>
	 * <em>You can use "Left" and "Right" keys to control the iterator.<br/>
	 * Curve control points are dragable.</em></p><br/>
	 * <br/>
	 * <h3>Bezier second-order curve properties</h3>
	 * <ul>
	 *      <li>curve is continuous</li>
	 *      <li>curve is affine-invariant</li>
	 *      <li>all curve points lie inside the ∆SCE triangle</li>
	 *      <li>points <code>S</code> and <code>E</code> always
	 *      lie on the Bezier curve and limit it</li>
	 *      <li>points with uniformly changing iterator are closely
	 *      distributed on the segments with the bigger winding</li>
	 *      <li>Bezier curve summit - point with iterator <code>t = 0.5</code> -
	 *      lies in the middle of the segment, that connects <code>С</code> and the
	 *      middle of the <code>SE</code> segment</li>
	 *      <li>point <code>C</code> generally does not belongs to the curve
	 *      and lies on the intersection of the tangents to the curve from points
	 *      <code>S</code> and <code>E</code></li>
	 *      <li>if point <code>С</code> belongs to <code>SE</code> then the curve is singular</li>
	 *      <li>Square of the figure, composed of Bezier curve and segment
	 *      <code>SE</code> equals 2/3 of the ∆SCE triangle square</li>
	 * </ul>
	 * <h3>Bezier curve and parabola</h3>
	 * Bezier second-order curve is a parabola segment.
	 * Curve built from <a href="#formula1">formula <strong>1</strong></a> with iterator
	 * <code><strong>t</strong></code> changing in infinite limits is a parabola.
	 * If Bezier curve lies on parabola then this parabola is considered to be the parent for it.<br/>
	 * <em>
	 * This property also applies to the Bezier curves with other orders.
	 * For example, segment can be considered as Bezier first-order curve
	 * and it's parent will be the line that contains it.
	 * Class <code>Line</code> interprets segment this way to simplify
	 * it's usage together with <code>Bezier</code> class.<br/>
	 * Bezier third-order curve on the plane is a segment of projection of
	 * cubic parabola in a three-dimensional space on the plane.
	 * General case: Bezier N-order curve is a segment of projection
	 * of the N-order curve built in N-dimensional space.
	 * </em>
	 *
	 * @see Line
	 * @see Intersection
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @lang eng
	 * @translator Maxim Kachurovskiy http://www.riapriority.com
	 *
	 **/

	public class Bezier extends Object implements IParametric {

		protected static const PRECISION : Number = 1e-10;

		protected var startPoint : Point;
		protected var controlPoint : Point;
		protected var endPoint : Point;
		protected var __isSegment : Boolean = true;

		//**************************************************
		//				CONSTRUCTOR 
		//**************************************************
		
		/* *
		 * 
		 * Создает новый объект Bezier. 
		 * Если параметры не переданы, то все опорные точки создаются в координатах 0,0  
		 * 
		 * @param start:Point начальная точка кривой Безье 
		 * 
		 * @param control:Point контрольная точка кривой Безье
		 *  
		 * @param end:Point конечная точка кривой Безье
		 * 
		 * @param isSegment:Boolean режим обработки.
		 * 
		 * @example В этом примере создается кривая Безье в случайных координатах.  
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const bezier:Bezier = randomBezier();
		 * trace("random bezier: "+bezier);
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/** 
		 * Create new Bezier object.
		 * If parameters are not passed, all control points are created in coordinates 0,0
		 *
		 * @param start:Point initial point of Bezier curve
		 *
		 * @param control:Point control point of Bezier curve
		 *
		 * @param end:Point end point of Bezier curve
		 *
		 * @param isSegment:Boolean operating mode
		 *
		 * @example In this example created Bezier curve with random coordinates.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 * trace("random bezier: "+bezier);
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/
		public function Bezier(start : Point = undefined, control : Point = undefined, end : Point = undefined, isSegment : Boolean = true) {
			initInstance(start, control, end, isSegment);
		}

		// 
		protected function initInstance(start : Point = undefined, control : Point = undefined, end : Point = undefined, isSegment : Boolean = true) : void {
			startPoint = (start as Point) || new Point();
			controlPoint = (control as Point) || new Point();
			endPoint = (end as Point) || new Point();
			__isSegment = Boolean(isSegment);
		}

		// Поскольку публичные переменные нельзя нельзя переопределять в дочерних классах, 
		// start, control, end и isSegment реализованы как get-set методы, а не как публичные переменные.
		
		/* *
		 * Начальная опорная (anchor) точка кривой Безье. Итератор <code>time</code> равен нулю.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 * 
		 **/
		 
		// As public variables cannot be redefined in affiliated classes, start, control, end and isSegment
		// are realized as get-set methods, instead of as public variables.
		
		/**
		 * Initial anchor point of Bezier curve. Iterator <code>time</code> is equal to zero.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/

		
		public function get start() : Point {
			return startPoint;
		}

		public function set start(value : Point) : void {
			startPoint = value;
		}

		/* *
		 * Управляющая (direction) точка кривой Безье.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Direction point of Bezier curve.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/

		
		public function get control() : Point {
			return controlPoint;
		}

		public function set control(value : Point) : void {
			controlPoint = value;
		}

		/* *
		 * Конечная опорная (anchor) точка кривой Безье. Итератор <code>time</code> равен единице.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/
		 
		/**
		 * End anchor point of Bezier curve. Iterator <code>time</code> is equal to one
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/

		
		public function get end() : Point {
			return endPoint;
		}

		public function set end(value : Point) : void {
			endPoint = value;
		}

		
		/* *
		 * Определяет является ли кривая Безье бесконечной в обе стороны
		 * или ограничена в пределах значения итераторов от 0 до 1.<BR/>
		 * <BR/>
		 * Безье строится с использованием итератора в пределах от 0 до 1, однако, 
		 * может быть построена в произвольных пределах.<BR/> 
		 * Кривая Безье, построеная от минус бесконечности до плюс 
		 * бесконечности является параболой.<BR/>
		 * <BR/>
		 * Текущее значение isSegment влияет на результаты методов:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Line.html#intersectionBezier">Line.intersectionBezier</a><BR/>
		 * 
		 * @see #intersectionBezier
		 * @see #intersectionLine
		 * @see #getClosest
		 * 
		 * @default true
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Defines is the Bezier curve is infinite in both directions or is limited within
		 * the bounds of value of iterators from 0 up to 1.<BR/>
		 * <BR/>
		 * The Bezier curve is constructed with using iterator within the bounds from 0 up to 1,
		 * however, it can be constructed in any bounds.<BR/>
		 * The Bezier curve constructed from a minus of infinity up to plus of infinity is a parabola.<BR/>
		 * <BR/>
		 * Current value isSegment influence on the results of methods:<BR/>
		 * <a href="#intersectionBezier">intersectionBezier</a><BR/>
		 * <a href="#intersectionLine">intersectionLine</a><BR/>
		 * <a href="#getClosest">getClosest</a><BR/>
		 * <a href="Line.html#intersectionBezier">Line.intersectionBezier</a><BR/>
		 *
		 * @see #intersectionBezier
		 * @see #intersectionLine
		 * @see #getClosest
		 *
		 * @default true
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/

		
		
		public function get isSegment() : Boolean {
			return __isSegment;
		}

		public function set isSegment(value : Boolean) : void {
			__isSegment = Boolean(value);
		}

		
		/* *
		 * Создает и возвращает копию текущего объекта Bezier.
		 * 
		 * @return Bezier.
		 * 
		 * @example В этом примере создается случайная кривая Безье и ее копия. 
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 * 	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const bezier:Bezier = randomBezier();
		 * const clone:Bezier = bezier.clone();
		 * trace("bezier: "+bezier);
		 * trace("clone: "+clone);
		 * trace(bezier == clone);
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Creates and returns a copy of current object Bezier.
		 *
		 * @return Bezier.
		 *
		 * @example In this example creates random Bezier curve and its copy.
		 * <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 * const clone:Bezier = bezier.clone();
		 * trace("bezier: "+bezier);
		 * trace("clone: "+clone);
		 * trace(bezier == clone);
		 *
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 **/

		
		public function clone() : Bezier {
			return new Bezier(startPoint.clone(), controlPoint.clone(), endPoint.clone(), __isSegment);
		}

		//**************************************************
		//				GEOM PROPERTIES 
		//**************************************************
		
		/* *
		 * Вычисляет длину киривой Безье
		 * 
		 * @return Number длина кривой Безье.
		 * 
		 * @example В этом примере создается случайная кривая Безье и выводится ее длина.  
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	trace("bezier length: "+bezier.length);
		 * 
		 * </listing> 
		 * 
		 * 
		 * @see #getSegmentLength
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 * 
		 **/
		 
		/**
		 * Calculates length of the Bezier curve
		 *
		 * @return Number length of the Bezier curve.
		 *
		 * @example In this example creates random Bezier curve and traces its length.
		 * <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 *
		 * trace("bezier length: "+bezier.length);
		 *
		 * </listing>
		 *
		 *
		 * @see #getSegmentLength
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/

		
		public function get length() : Number {
			return getSegmentLength(1);
		}

		/* *
		 * Вычисляет длину сегмента кривой Безье от стартовой точки до
		 * точки на кривой, заданной параметром time. 
		 * 
		 * @param time:Number параметр time конечной точки сегмента.
		 * @return Number length of arc.
		 * 
		 * @example В этом примере создается случайная кривая Безье, 
		 * вычисляется time-итератор точки середины кривой, а затем
		 * выводятся значения половины длины кривой и длина сегмента
		 * кривой до средней точки - они должны быть равны.
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	const middleDistance:Number = bezier.length/2;
		 *	const middleTime:Number = bezier.getTimeByDistance(middleDistance);
		 *	const segmentLength:Number = bezier.getSegmentLength(middleTime);
		 *	
		 *	trace(middleDistance);
		 *	trace(segmentLength);
		 *	
		 *</listing> 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #length
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Calculates length of a segment of Bezier curve from a starting point
		 * up to a point on a curve which passed in parameter time.
		 *
		 * @param time:Number parameter time of the end point of a segment.
		 * @return Number length of arc.
		 *
		 * @example In this example creates random Bezier curve, calculates time-iterator
		 * of the middle of a curve, and then traces values of half of length of a curve
		 * and length of a segment of a curve up to an middle point - they should be equal.
		 * <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 *
		 * const middleDistance:Number = bezier.length/2;
		 * const middleTime:Number = bezier.getTimeByDistance(middleDistance);
		 * const segmentLength:Number = bezier.getSegmentLength(middleTime);
		 *
		 * trace(middleDistance);
		 * trace(segmentLength);
		 *
		 *</listing>
		 *
		 *
		 * @see #length
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/

		public function getSegmentLength(time : Number) : Number {
			const csX : Number = controlPoint.x - startPoint.x;
			const csY : Number = controlPoint.y - startPoint.y;
			const nvX : Number = endPoint.x - controlPoint.x - csX;
			const nvY : Number = endPoint.y - controlPoint.y - csY;
			
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			const c0 : Number = 4 * (csX * csX + csY * csY);
			const c1 : Number = 8 * (csX * nvX + csY * nvY);
			const c2 : Number = 4 * (nvX * nvX + nvY * nvY);
			
			var ft : Number;
			var f0 : Number;
			
			if (c2 == 0) {
				if (c1 == 0) {
					ft = Math.sqrt(c0) * time;
					return ft;
				} else {
					ft = (2 / 3) * (c1 * time + c0) * Math.sqrt(c1 * time + c0) / c1;
					f0 = (2 / 3) * c0 * Math.sqrt(c0) / c1;
					return (ft - f0);
				}
			} else {
				const sqrt_0 : Number = Math.sqrt(c2 * time * time + c1 * time + c0);
				const sqrt_c0 : Number = Math.sqrt(c0);
				const sqrt_c2 : Number = Math.sqrt(c2);
				const exp1 : Number = (0.5 * c1 + c2 * time) / sqrt_c2 + sqrt_0;
						
				if (exp1 < PRECISION) {
					ft = 0.25 * (2 * c2 * time + c1) * sqrt_0 / c2;
				} else {
					ft = 0.25 * (2 * c2 * time + c1) * sqrt_0 / c2 + 0.5 * Math.log((0.5 * c1 + c2 * time) / sqrt_c2 + sqrt_0) / sqrt_c2 * (c0 - 0.25 * c1 * c1 / c2);
				}
				
				const exp2 : Number = (0.5 * c1) / sqrt_c2 + sqrt_c0;
				if (exp2 < PRECISION) {
					f0 = 0.25 * (c1) * sqrt_c0 / c2;
				} else {
					f0 = 0.25 * (c1) * sqrt_c0 / c2 + 0.5 * Math.log((0.5 * c1) / sqrt_c2 + sqrt_c0) / sqrt_c2 * (c0 - 0.25 * c1 * c1 / c2);
				}
				return ft - f0;
			}
		}

		
		/* * 
		 * Вычисляет и возвращает площадь фигуры, ограниченой кривой Безье
		 * и отрезком <code>SE</code>.
		 * Площадь этой фигуры составляет 2/3 площади треугольника ∆SCE, 
		 * образуемого контрольными точками <code>start, control, end</code>.<BR/>
		 * Соответственно, оставшаяся часть треугольника составляет 1/3 его площади.
		 * 
		 * @return Number
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const randomBezier:Bezier = randomBezier();
		 *	
		 * trace("bezier area: "+randomBezier.area);
		 *	
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #triangleArea
		 * 
		 * @lang rus	
		 **/

		/**
		 * Calculates and returns the area of the figure limited by Bezier curve and
		 * a segment <code> SE </code>.
		 * The area of this figure makes 2/3 areas of a triangle ∆SCE, which is formed of
		 * control points <code>start, control, end</code>.<BR/>
		 * Accordingly, the rest of a triangle makes 1/3 its areas.
		 *
		 * @return Number
		 *
		 * @example <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 *
		 * trace("bezier area: "+randomBezier.area);
		 *
		 * </listing>
		 *
		 * @see #triangleArea
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 *
		 **/

		
		public function get area() : Number {
			return triangleArea * (2 / 3);
		}
		
		/**
		 * Gravity center of the figure limited by Bezier curve and line <code>SE</code>.
		 * 
		 * @return Point
		 **/

		public function get geometricCentroid() : Point {
			const x:Number = (startPoint.x + endPoint.x) * .4 + controlPoint.x * .2;
			const y:Number = (startPoint.y + endPoint.y) * .4 + controlPoint.y * .2;
			return new Point(x, y);
			// return Point.interpolate(controlPoint, Point.interpolate(startPoint, endPoint, 0.5), 0.2);
		}

		
		/* *
		 * Вычисляет и возвращает площадь треугольника ∆SCE, 
		 * образуемого контрольными точками <code>start, control, end</code>.  
		 * 
		 * @return Number
		 * 
		 * @see #area
		 * 
		 * @lang rus
		 **/
		 
		/**
		 * Calculates and returns the area of a triangle ∆SCE, which is formed of
		 * control points <code>start, control, end</code>.
		 *
		 * @return Number
		 *
		 * @see #area
		 *
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 **/

		public function get triangleArea() : Number {
			// heron's formula
			const distanceStartControl : Number = Point.distance(startPoint, controlPoint);
			const distanceEndControl : Number = Point.distance(endPoint, controlPoint);
			const distanceStartEnd : Number = Point.distance(startPoint, endPoint);
			
			const halfPerimeter : Number = (distanceStartControl + distanceEndControl + distanceStartEnd) / 2;
			const area : Number = Math.sqrt(halfPerimeter * (halfPerimeter - distanceStartControl) * (halfPerimeter - distanceEndControl) * (halfPerimeter - distanceStartEnd)); 
			return area;
		}

		/* *
		 * Вычисляет и возвращает габаритный прямоугольник сегмента кривой Безье.<BR/> 
		 * <I>Установка свойству isSegment=false не изменяет результат вычислений.</I> 
		 * 
		 * @return Rectangle габаритный прямоугольник.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		 
		/**
		 * Calculates and returns a bounds rectangular of a segment of Bezier curve.<BR/>
		 * <I>Property isSegment=false does not change result of calculations.</I>
		 *
		 * @return Rectangle bounds rectangular.
		 */

		public function get bounds() : Rectangle {
			var xMin : Number;
			var xMax : Number;
			var yMin : Number;
			var yMax : Number;
			
			const x : Number = startPoint.x - 2 * controlPoint.x + endPoint.x;
			const extremumTimeX : Number = ((startPoint.x - controlPoint.x) / x) || 0;
			const extemumPointX : Point = getPoint(extremumTimeX);
			
			if (isNaN(extemumPointX.x) || extremumTimeX <= 0 || extremumTimeX >= 1) {
				xMin = Math.min(startPoint.x, endPoint.x);
				xMax = Math.max(startPoint.x, endPoint.x);
			} else {
				xMin = Math.min(extemumPointX.x, Math.min(startPoint.x, endPoint.x));
				xMax = Math.max(extemumPointX.x, Math.max(startPoint.x, endPoint.x));
			}
			
			const y : Number = startPoint.y - 2 * controlPoint.y + endPoint.y;
			const extremumTimeY : Number = ((startPoint.y - controlPoint.y) / y) || 0;
			const extemumPointY : Point = getPoint(extremumTimeY);
			
			if (isNaN(extemumPointY.y) || extremumTimeY <= 0 || extremumTimeY >= 1) {
				yMin = Math.min(startPoint.y, endPoint.y);
				yMax = Math.max(startPoint.y, endPoint.y);
			} else {
				yMin = Math.min(extemumPointY.y, Math.min(startPoint.y, endPoint.y));
				yMax = Math.max(extemumPointY.y, Math.max(startPoint.y, endPoint.y));
			}

			const width : Number = xMax - xMin;
			const height : Number = yMax - yMin;
			return new Rectangle(xMin, yMin, width, height);
		}

		
		//**************************************************
		//		PARENT PARABOLA
		//**************************************************

		/* *
		 * Вычисляет и возвращает time-итератор вершины параболы.
		 * 
		 * @return Number;
		 * 
		 * @example <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *	
		 * function randomPoint():Point {
		 *	return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * 	return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *	
		 * const randomBezier:Bezier = randomBezier();
		 *	
		 * trace("parabola vertex time: "+randomBezier.parabolaVertex);
		 *	
		 * </listing>
		 * 
		 * @see #parabolaFocus
		 * 
		 */	

		/**
		 * Calculates and returns time-iterator of top of the parabola.
		 *
		 * @return Number;
		 *
		 * @example <listing version="3.0">
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const randomBezier:Bezier = randomBezier();
		 *
		 * trace("parabola vertex time: "+randomBezier.parabolaVertex);
		 *
		 * </listing>
		 *
		 * @see #parabolaFocus
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 *
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/

		public function get parabolaVertex() : Number {
			const x : Number = startPoint.x - 2 * controlPoint.x + endPoint.x;
			const y : Number = startPoint.y - 2 * controlPoint.y + endPoint.y;
			const summ : Number = x * x + y * y;
			const dx : Number = startPoint.x - controlPoint.x;
			const dy : Number = startPoint.y - controlPoint.y;
			const vertexTime : Number = (x * dx + y * dy) / summ;
			if (isNaN(vertexTime)) {
				return 1 / 2;
			} 
			return vertexTime;
		}

		/* *
		 * @return Point - фокус родительской параболы;
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see #parabolaVertex
		 */
		 
		/**
		 * @return Point - focus of a parental parabola;
		 *
		 * @see #parabolaVertex
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/

		
		public function get parabolaFocusPoint() : Point {
			const startX : Number = startPoint.x;
			const startY : Number = startPoint.y;
			const controlX : Number = controlPoint.x;
			const controlY : Number = controlPoint.y;
			const endX : Number = endPoint.x;
			const endY : Number = endPoint.y;

			const x : Number = startX - 2 * controlX + endX;
			const y : Number = startY - 2 * controlY + endY;
			const summ : Number = x * x + y * y;
			
			if (summ == 0) {
				return controlPoint.clone();
			}
			
			const dx : Number = controlX - startX;
			const dy : Number = controlY - startY;
			
			const minT : Number = -(x * dx + y * dy) / summ;
			
			const minF : Number = 1 - minT;
			
			const minT2 : Number = minT * minT;
			const minF2 : Number = minF * minF;
		
			const psx : Number = 2 * dx + 2 * minT * x;
			const psy : Number = 2 * dy + 2 * minT * y;
			
			const vertexX : Number = startX * minF2 + 2 * minT * minF * controlX + minT2 * endX;
			const vertexY : Number = startY * minF2 + 2 * minT * minF * controlY + minT2 * endY;
		
			var fx : Number = vertexX - psy / (4 * Math.SQRT2);
			var fy : Number = vertexY + psx / (4 * Math.SQRT2);
			
			const side : Number = (psy * (startX - vertexX) - psx * (startY - vertexY)) * (psy * (fx - vertexX) - psx * (fy - vertexY));

			if (side < 0) {
				fx = vertexX + psy / (4 * Math.SQRT2);
				fy = vertexY - psx / (4 * Math.SQRT2);
			}

			return new Point(fx, fy);
		}

		//**************************************************
		//		CURVE POINTS
		//**************************************************

		/* *
		 * Реализация <a href="#formula1">формулы 1</a><BR/>
		 * Вычисляет и возвращает объект Point представляющий точку на кривой Безье, заданную параметром <code>time</code>.
		 * 
		 * @param time:Number итератор точки кривой
		 * 
		 * @return Point точка на кривой Безье;<BR/>
		 * <I>
		 * Если передан параметр time равный 1 или 0, то будут возвращены объекты Point
		 * эквивалентные <code>start</code> и <code>end</code>, но не сами объекты <code>start</code> и <code>end</code> 
		 * </I> 
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	const time:Number = Math.random();
		 *	const point:Point = bezier.getPoint(time);
		 *	
		 *	trace(point);
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		/**
		 * Realization of <a href="#formula1">formula 1</a><BR/>
		 * Calculates and returns object Point which representing a point on a Bezier curve,
		 * specified by the parameter <code>time</code>.
		 *
		 * @param time:Number iterator of the point on curve
		 *
		 * @return Point point on the Bezier curve;<BR/>
		 * <I>
		 * If passed the parameter time equal to 1 or 0, object Point equivalent to <code>start</code>
		 * or <code>end</code> will be returned, but not objects exact <code>start</code> or <code>end</code>.
		 * </I>
		 *
		 * @example <listing version="3.0">
		 *
		 * import flash.geom.Bezier;
		 * import flash.geom.Point;
		 *
		 * function randomPoint():Point {
		 * return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 * }
		 * function randomBezier():Bezier {
		 * return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 * }
		 *
		 * const bezier:Bezier = randomBezier();
		 *
		 * const time:Number = Math.random();
		 * const point:Point = bezier.getPoint(time);
		 *
		 * trace(point);
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 * 
		 **/

		public function getPoint(time : Number, point : Point = null) : Point {
			if (isNaN(time)) {
				return undefined;
			}
			point = (point as Point) || new Point();
			const f : Number = 1 - time;
			point.x = startPoint.x * f * f + controlPoint.x * 2 * time * f + endPoint.x * time * time;
			point.y = startPoint.y * f * f + controlPoint.y * 2 * time * f + endPoint.y * time * time;
			return point;
		}

		/* *
		 * Поворачивает кривую относительно точки <code>fulcrum</code> на заданный угол.
		 * Если точка <code>fulcrum</code> не задана, используется (0,0)
		 * 
		 * @param value:Number угол вращения
		 * 
		 * @param fulcrum:Point центр вращения.
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		/**
		 * Rotate a curve concerning to a point <code>fulcrum</code> on the <code>value</code> angle
		 * If point <code>fulcrum</code> is not set, used (0,0)
		 * 
		 * @param value:Number rotation angle
		 * 
		 * @param fulcrum:Point center of rotation.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 *
		 **/
		public function angleOffset(value : Number, fulcrum : Point = null) : void {
			fulcrum = fulcrum || new Point();
			
			const startLine : Line = new Line(fulcrum, startPoint);
			startLine.angle += value;
			const controlLine : Line = new Line(fulcrum, controlPoint);
			controlLine.angle += value;
			const endLine : Line = new Line(fulcrum, endPoint);
			endLine.angle += value;
		}

		/* *
		 * Смещает кривую на заданное расстояние по осям X и Y.  
		 * 
		 * @param dx:Number величина смещения по оси X
		 * @param dy:Number величина смещения по оси Y
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang rus
		 */
		 
		/**
		 * Moves a curve on the prescribed distance on axes X and Y.
		 *
		 * @param dx:Number offset by X
		 * @param dy:Number offset by Y
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @lang eng
		 * @translator Ilya Segeda http://www.digitaldesign.com.ua
		 *
		 */

		public function offset(dX : Number, dY : Number) : void {
			startPoint.offset(dX, dY);
			endPoint.offset(dX, dY);
		}

		
		/**
		 * Вычисляет time-итератор точки, находящейся на заданной дистанции 
		 * по кривой от точки <code>start</code><BR/>
		 * <I>Для вычисления равноуделенных последовательностей точек,
		 * например для рисования пунктиром, используйте метод getTimesSequence</I>
		 * 
		 * @param distance:Number дистанция по кривой до искомой точки.
		 * 
		 * @return Number time iterator of bezier point;
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * 
		 *	trace(bezier.getTimeByDistance(-10); // negative value
		 *	trace(bezier.getTimeByDistance(bezier.length/2); // value between 0 and 1
		 * </listing>
		 * 
		 * @see #getPoint
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function getTimeByDistance(distance : Number) : Number {
			if (isNaN(distance)) {
				return 0;
			}
			var arcLength : Number;
			var diffArcLength : Number;
			const curveLength : Number = length;
			var time : Number = distance / curveLength;
			
			if (__isSegment) {
				if (distance <= 0) {
					return 0;
				}
				if (distance >= curveLength) {
					return 1;
				}
			}
			const csX : Number = controlPoint.x - startPoint.x;
			const csY : Number = controlPoint.y - startPoint.y;
			const ecX : Number = endPoint.x - controlPoint.x;
			const ecY : Number = endPoint.y - controlPoint.y;
			const nvX : Number = ecX - csX;
			const nvY : Number = ecY - csY;
	
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			const c0 : Number = 4 * (csX * csX + csY * csY);
			const c1 : Number = 8 * (csX * nvX + csY * nvY);
			const c2 : Number = 4 * (nvX * nvX + nvY * nvY);
			
			const c025 : Number = c0 - 0.25 * c1 * c1 / c2;
			const f0Base : Number = 0.25 * c1 * Math.sqrt(c0) / c2;
			const exp2 : Number = 0.5 * c1 / Math.sqrt(c2) + Math.sqrt(c0);
	
			const c00sqrt : Number = Math.sqrt(c0);
			const c20sqrt : Number = Math.sqrt(c2);
			var c22sqrt : Number;
			
			var exp1 : Number;
			var ft : Number;
			var ftBase : Number;
			
			var f0 : Number;
			const maxIterations : Number = 100;
	
			if (c2 == 0) {
				if (c1 == 0) {
					do {
						arcLength = c00sqrt * time;
						diffArcLength = Math.sqrt(Math.abs((c2 * time * time + c1 * time + c0))) || PRECISION; 
						time = time - (arcLength - distance) / diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
				} else {
					do {
						arcLength = (2 / 3) * (c1 * time + c0) * Math.sqrt(c1 * time + c0) / c1 - (2 / 3) * c0 * c00sqrt / c1; 
						diffArcLength = Math.sqrt(Math.abs((c2 * time * time + c1 * time + c0))) || PRECISION;
						time = time - (arcLength - distance) / diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
				}
			} else {
				do {
					c22sqrt = Math.sqrt(Math.abs(c2 * time * time + c1 * time + c0));
					exp1 = (0.5 * c1 + c2 * time) / c20sqrt + c22sqrt;
					ftBase = 0.25 * (2 * c2 * time + c1) * c22sqrt / c2;
					if (exp1 < PRECISION) {
						ft = ftBase;
					} else {
						ft = ftBase + 0.5 * Math.log((0.5 * c1 + c2 * time) / c20sqrt + c22sqrt) / c20sqrt * c025;
					}
					if (exp2 < PRECISION) {
						f0 = f0Base;
					} else {
						f0 = f0Base + 0.5 * Math.log((0.5 * c1) / c20sqrt + c00sqrt) / c20sqrt * c025;
					}
					arcLength = ft - f0;
					diffArcLength = c22sqrt || PRECISION; 
					time = time - (arcLength - distance) / diffArcLength;
				} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
			}
			
			return time;
		}

		/**  
		 * Вычисляет и возвращает массив time-итераторов точек, 
		 * находящихся друг от друга на дистанции по кривой,
		 * заданной параметром <code>step</code>.<BR/>
		 * Если задан параметр <code>startShift</code>, то расчет производится
		 * не от точки <code>start</code>, а от точки на кривой, находящейся на 
		 * заданнй этим параметром дистанции.<BR/>
		 * Значение startShift конвертируется в остаток от деления на step.<BR/> 
		 * 
		 * 
		 * @param step:Number шаг, дистанция по кривой между точками.
		 * @param startShift:Number дистанция по кривой, задающая смещение первой 
		 * точки последовательности относительно точки <code>start</code>
		 *  
		 * @return Array sequence of points on bezier curve;
		 * 
		 * @example <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 *	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	// TODO: [Dembicki] example 
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function getTimesSequence(step : Number, startShift : Number = 0) : Array {

			step = Math.abs(step);
			var distance : Number = startShift;
			
			const times : Array = new Array();
			const curveLength : Number = length;
			if (distance > curveLength) {
				return times;
			}
			
			if (distance < 0) {
				distance = distance % step + step;
			} else {
				distance = distance % step;
			}

			const csX : Number = controlPoint.x - startPoint.x;
			const csY : Number = controlPoint.y - startPoint.y;
			const ecX : Number = endPoint.x - controlPoint.x;
			const ecY : Number = endPoint.y - controlPoint.y;
			const nvX : Number = ecX - csX;
			const nvY : Number = ecY - csY;
			
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			const c0 : Number = 4 * (csX * csX + csY * csY);
			const c1 : Number = 8 * (csX * nvX + csY * nvY);
			const c2 : Number = 4 * (nvX * nvX + nvY * nvY);
	
			var arcLength : Number;
			var diffArcLength : Number;
			
			var time : Number = distance / curveLength;
			
			const c025 : Number = c0 - 0.25 * c1 * c1 / c2;
			const f0Base : Number = 0.25 * c1 * Math.sqrt(c0) / c2;
			const exp2 : Number = 0.5 * c1 / Math.sqrt(c2) + Math.sqrt(c0);
	
			const c00sqrt : Number = Math.sqrt(c0);
			const c20sqrt : Number = Math.sqrt(c2);
			// const c21sqrt:Number = c20sqrt*(c025);
			var c22sqrt : Number;
			
			var exp1 : Number;
			var ft : Number;
			var ftBase : Number;
			
			var f0 : Number;
			
			while (distance <= curveLength) {
				var limiter : Number = 20;
		
				if (c2 == 0) {
					if (c1 == 0) {
						do {
							arcLength = c00sqrt * time;
							diffArcLength = Math.sqrt(Math.abs(c2 * time * time + c1 * time + c0)) || PRECISION; 
							time = time - (arcLength - distance) / diffArcLength;
						} while (Math.abs(arcLength - distance) > PRECISION && limiter--);
					} else {
						do {
							arcLength = (2 / 3) * ((c1 * time + c0) * Math.sqrt(Math.abs(c1 * time + c0)) - c0 * c00sqrt) / c1; 
							diffArcLength = Math.sqrt(Math.abs(c2 * time * time + c1 * time + c0)) || PRECISION;
							time = time - (arcLength - distance) / diffArcLength;
						} while (Math.abs(arcLength - distance) > PRECISION && limiter--);
					}
				} else {
					do {
						c22sqrt = Math.sqrt(Math.abs(c2 * time * time + c1 * time + c0));
						exp1 = (0.5 * c1 + c2 * time) / c20sqrt + c22sqrt;
						ftBase = 0.25 * (2 * c2 * time + c1) * c22sqrt / c2;
						if (exp1 < PRECISION) {
							ft = ftBase;
						} else {
							ft = ftBase + 0.5 * Math.log((0.5 * c1 + c2 * time) / c20sqrt + c22sqrt) / c20sqrt * c025;
						}
						if (exp2 < PRECISION) {
							f0 = f0Base;
						} else {
							f0 = f0Base + 0.5 * Math.log((0.5 * c1) / c20sqrt + c00sqrt) / c20sqrt * c025;
						}
						arcLength = ft - f0;
						diffArcLength = c22sqrt || PRECISION; 
						time = time - (arcLength - distance) / diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && limiter--);
				}
				 
				times[times.length] = time;
				distance += step;
			}
			
			return times;
		}

		
		
		
		//**************************************************
		//				CHANGE BEZIER
		//**************************************************
		
		
		/**
		 * Изменяет кривую таким образом, что заданная параметром time точка кривой <code>P<sub>t</sub></code>, 
		 * будет находиться в заданных параметрами <code>x</code> и <code>y</code> координатах.<BR/>
		 * Если один из параметров <code>x</code> или <code>y</code> не задан, 
		 * то точка <code>P<sub>t</sub></code> не изменит значение соответствующей координаты.
		 * 
		 * @param time:Number time-итератор точки кривой.
		 * @param x:Number новое значение позиции точки по оси X.
		 * @param y:Number новое значение позиции точки по оси Y.
		 * 
		 * @example 
		 * <listing version="3.0">
		 * 
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	trace(bezier);
		 *	
		 *	bezier.setPoint(0, 0, 0);
		 *	bezier.setPoint(0.5, 100, 100);
		 *	bezier.setPoint(1, 200, 0);
		 *	
		 *	trace(bezier); // (start:(x=0, y=0), control:(x=100, y=200), end:(x=200, y=0))
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function setPoint(time : Number, x : Number = undefined, y : Number = undefined) : void {
			if ((isNaN(x) && isNaN(y))) {
				return;
			}
			
			const f : Number = 1 - time;
			const tSquared : Number = time * time;
			const fSquared : Number = f * f;
			const tf : Number = 2 * time * f;
			
			if (isNaN(x)) {
				x = startPoint.x * fSquared + controlPoint.x * 2 * tf + endPoint.x * tSquared;
			}
			if (isNaN(y)) {
				y = startPoint.y * fSquared + controlPoint.y * 2 * tf + endPoint.y * tSquared;
			}
			
			switch (time) {
				case 0:
					startPoint.x = x;
					startPoint.y = y; 
					break;
				case 1:
					endPoint.x = x; 
					endPoint.y = y; 
					break;
				default: 
					controlPoint.x = (x - endPoint.x * tSquared - startPoint.x * fSquared) / tf;
					controlPoint.y = (y - endPoint.y * tSquared - startPoint.y * fSquared) / tf;
			}
		}

		
		
		
		
		//**************************************************
		//				BEZIER AND EXTERNAL POINTS
		//**************************************************

		/**
		 * <P>Вычисляет и возвращает time-итератор точки на кривой, 
		 * ближайшей к точке <code>fromPoint</code>.<BR/>
		 * В зависимости от значения свойства <a href="#isSegment">isSegment</a>
		 * возвращает либо значение в пределах от 0 до 1, либо от минус 
		 * бесконечности до плюс бесконечности.</P>
		 * 
		 * @param fromPoint:Point произвольная точка на плоскости.
		 * 
		 * @return Number time-итератор точки на кривой.
		 * 
		 * @example
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 *	
		 *	TODO: [Dembicki] example
		 *	
		 * </listing>
		 * 
		 * @see #isSegment
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 **/

		public function getClosest(fromPoint : Point) : Number {
			if (!(fromPoint as Point)) {
				return NaN;
			}
			const sx : Number = startPoint.x;
			const sy : Number = startPoint.y;
			const cx : Number = controlPoint.x;
			const cy : Number = controlPoint.y;
			const ex : Number = endPoint.x;
			const ey : Number = endPoint.y;
	
			const lpx : Number = sx - fromPoint.x;
			const lpy : Number = sy - fromPoint.y;
			
			const kpx : Number = sx - 2 * cx + ex;
			const kpy : Number = sy - 2 * cy + ey;
			
			const npx : Number = -2 * sx + 2 * cx;
			const npy : Number = -2 * sy + 2 * cy;
			
			const delimiter : Number = 2 * (kpx * kpx + kpy * kpy);
			
			const A : Number = 3 * (npx * kpx + npy * kpy) / delimiter;
			const B : Number = ((npx * npx + npy * npy) + 2 * (lpx * kpx + lpy * kpy)) / delimiter;
			const C : Number = (npx * lpx + npy * lpy) / delimiter;
			
			const extremumTimes : Array = Equations.solveCubicEquation(1, A, B, C);
			
			if (__isSegment) {
				extremumTimes.push(0);
				extremumTimes.push(1);
			}
			
			var extremumTime : Number;
			var extremumPoint : Point;
			var extremumDistance : Number;
			
			var closestPointTime : Number;
			var closestDistance : Number;
			
			var isInside : Boolean;
			
			const len : uint = extremumTimes.length;
			for (var i : uint = 0;i < len; i++) {
				extremumTime = extremumTimes[i];
				extremumPoint = getPoint(extremumTime);
				
				// TODO: [Dembicki] протестировать, вспомнить, что тут за проблема, пофиксить.
				// PROBLEM!!!!!
				// trace("extremumDistance: "+extremumTime);
				extremumDistance = Point.distance(fromPoint, extremumPoint);
				
				isInside = (extremumTime >= 0) && (extremumTime <= 1);
				
				if (isNaN(closestPointTime)) {
					if (!__isSegment || isInside) {
						closestPointTime = extremumTime;
						closestDistance = extremumDistance;
					}
					continue;
				}
				
				if (extremumDistance < closestDistance) {
					if (!__isSegment || isInside) {
						closestPointTime = extremumTime;
						closestDistance = extremumDistance;
					}
				}
			}
			
			return closestPointTime;
		}

		
		
		//**************************************************
		//				WORKING WITH SEGMENTS
		//**************************************************
		
		/**
		 * Вычисляет и возвращает сегмент кривой Безье.
		 * 
		 * @param fromTime:Number time-итератор начальной точки сегмента
		 * @param toTime:Number time-итератор конечной точки сегмента кривой
		 * 
		 * @return Bezier;
		 * 
		 * @example 
		 * В данном примере на основе случайной кривой Безье создаются еще две.
		 * Первая из них - <code>segment1</code> 
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 * const bezier:Bezier = randomBezier();
		 * const segment1:Bezier = bezier.getSegment(1/3, 2/3);
		 * const segment2:Bezier = bezier.getSegment(-1, 2);
		 * 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */
		public function getSegment(fromTime : Number = 0, toTime : Number = 1) : Bezier {
			const segmentStart : Point = getPoint(fromTime);
			const segmentEnd : Point = getPoint(toTime);
			const segmentVertex : Point = getPoint((fromTime + toTime) / 2);
			const baseMiddle : Point = Point.interpolate(segmentStart, segmentEnd, 1 / 2);
			const segmentControl : Point = Point.interpolate(segmentVertex, baseMiddle, 2);
			return new Bezier(segmentStart, segmentControl, segmentEnd, true);
		}

		
		//**************************************************
		//				TANGENT OF BEZIER POINT
		//**************************************************


		/**
		 * Tangent is line that touches but does not intersect with bezier.
		 * Computes and returns the angle of tangent line in radians. 
		 * The return value is between positive pi and negative pi. 
		 * 
		 * @param t:Number time of bezier point
		 * @return Number angle in radians;
		 * 
		 * @example 
		 * <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */

		public function getTangentAngle(time : Number = 0) : Number {
			const t0X : Number = startPoint.x + (controlPoint.x - startPoint.x) * time;
			const t0Y : Number = startPoint.y + (controlPoint.y - startPoint.y) * time;
			const t1X : Number = controlPoint.x + (endPoint.x - controlPoint.x) * time;
			const t1Y : Number = controlPoint.y + (endPoint.y - controlPoint.y) * time;
			
			const distanceX : Number = t1X - t0X;
			const distanceY : Number = t1Y - t0Y;
			return Math.atan2(distanceY, distanceX);
		}

		//**************************************************
		//				INTERSECTIONS 
		//**************************************************

		/**
		 * Результат вычисления пересечения кривой Безье с линией может дать следующие результаты:  <BR/>
		 * - если пересечение отсутствует, возвращается null;<BR/>
		 * - если пересечение произошло в одной или двух точках, будет возвращен объект Intersection,
		 *   и time-итераторы точек пересечения на кривой Безье будут находиться в массиве currentTimes.
		 *   time-итераторы точек пересечения <code>target</code> будут находиться в массиве targetTimes;<BR/>
		 * - если кривая Безье вырождена, то может произойти совпадение. 
		 * В этом случае результатом будет являться отрезок - объект Line (<code>isSegment=true</code>), 
		 * который будет доступен как свойство <code>coincidenceLine</code> в возвращаемом объекте Intersection;<BR/>
		 * <BR/>  
		 * На результаты вычисления пересечений оказывает влияние свойство <code>isSegment<code> как текущего объекта,
		 * так и значение <code>isSegment</code> объекта target.
		 * 
		 * @param target:Line
		 * @return Intersection
		 *  
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * </listing>
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 * @see Intersection
		 * @see Line
		 * 
		 */

		// TODO: [Sergeev] метод не закончен.
		// 1. нигде не реализован расчет targetTimes. 
		//    Т.е. везде, где заполняем currentTimes должно быть заполнение targetTimes. 
		// 2. нет расчета совпадений
		// 3. нужно прокомментировать блоки кода, указать какой случай рассматривается. 
		// 4. оптимизация: поскольку на практике в 90 и более процентах случаев
		//    пересечения не будет, очень важно продумать стратегию простых проверок
		//    в самом начале метода. Таких как Intersection.isIntersectionPossible();
		//    Нужны быстрые, элементарные проверки.

		public function intersectionLine(target : Line) : Intersection {
			var intersection : Intersection = new Intersection();
			
			const sX : Number = startPoint.x;
			const sY : Number = startPoint.y;
			const cX : Number = controlPoint.x;
			const cY : Number = controlPoint.y;
			const eX : Number = endPoint.x;
			const eY : Number = endPoint.y;
			const oX : Number = target.start.x;
			const oY : Number = target.start.y;
			const lineAngle : Number = target.angle;
			var cosa : Number = Math.cos(lineAngle);
			var sina : Number = Math.sin(lineAngle);
			//
			var time0 : Number;
			var time1 : Number;
			var lineTime0 : Number;
			var lineTime1 : Number;
			var intersectionPoint0 : Point;
			var intersectionPoint1 : Point;
			const distanceX : Number = target.end.x - target.start.x;
			const distanceY : Number = target.end.y - target.start.y;
			const checkByX : Boolean = Math.abs(distanceX) > Math.abs(distanceY);

			
			if (Math.abs(cosa) < 1e-6) {
				cosa = 0; 
			}
			if (Math.abs(sina) < 1e-6) {
				sina = 0;
			}
			
			
			
			var divider : Number = -2 * sina * cX + sina * eX + sina * sX + 2 * cosa * cY - cosa * eY - cosa * sY;
			if (Math.abs(divider) < 1e-6) {
				divider = 0;
			}
			
			
			if (divider == 0) {
				
				const divider2 : Number = (-2 * sX + 2 * cX) * sina - (-2 * sY + 2 * cY) * cosa;
				if (divider2 == 0) {
					intersection.currentTimes[0] = 0;
					intersection.currentTimes[1] = 1;
					
					intersectionPoint0 = getPoint(0);
					intersectionPoint1 = getPoint(1);
					
					if (checkByX) {
						lineTime0 = (intersectionPoint0.x - target.start.x) / distanceX;
						lineTime1 = (intersectionPoint1.x - target.start.x) / distanceX;
					} else {
						lineTime0 = (intersectionPoint0.y - target.start.y) / distanceY;
						lineTime1 = (intersectionPoint1.y - target.start.y) / distanceY;
					}
				} else {
					
					time0 = -((sX - oX) * sina - (sY - oY) * cosa) / divider2;
					
					intersection.currentTimes[0] = time0;
					intersectionPoint0 = getPoint(time0);
					
					const intersection_is_in_segment : Number = (intersectionPoint0.x - target.start.x) * (intersectionPoint0.x - target.end.x);
					if (intersection_is_in_segment > 0)
						intersection = null;
				}
				
				return intersection;
			} 
			
			const discriminant : Number = +cosa * cosa * (sY * oY + cY * cY - eY * sY - 2 * cY * oY + eY * oY) + sina * cosa * (-sY * oX - eY * oX - 2 * cY * cX + eX * sY - sX * oY + 2 * cY * oX + 2 * cX * oY + eY * sX - eX * oY) + sina * sina * (eX * oX + sX * oX - 2 * cX * oX + cX * cX - eX * sX);
			
			
			
			if (discriminant < 0) {
				return null;
			}
			
			const a : Number = -2 * cosa * sY + 2 * sina * sX + 2 * cosa * cY - 2 * sina * cX;
			const c : Number = 2 * divider;
			
			var outsideBezier0 : Boolean;
			var outsideLine0 : Boolean;
			var outsideBezier1 : Boolean;
			var outsideLine1 : Boolean;
			
			if (discriminant == 0) {
				time0 = a / c;
				
				outsideBezier0 = time0 < 0 || time0 > 1;
				if (__isSegment && outsideBezier0) {
					return null;
				}
				
				intersectionPoint0 = getPoint(time0);
				
				if (checkByX) {
					lineTime0 = (intersectionPoint0.x - target.start.x) / distanceX;
				} else {
					lineTime0 = (intersectionPoint0.y - target.start.y) / distanceX;
				}
				
				outsideLine0 = lineTime0 < 0 || lineTime0 > 1;
				
				if (target.isSegment && outsideLine0) {
					return null;
				}
				
				intersection.currentTimes[0] = time0;
				intersection.targetTimes[0] = lineTime0;
				
				return intersection;
			}
			
			// if discriminant > 0

			const b : Number = 2 * Math.sqrt(discriminant);
			time0 = (a - b) / c;
			time1 = (a + b) / c;
			
			outsideBezier0 = time0 < 0 || time0 > 1;
			outsideBezier1 = time1 < 0 || time1 > 1;
			
			if (__isSegment && outsideBezier0 && outsideBezier1) {
				return null;
			}
			
			intersectionPoint0 = getPoint(time0);
			intersectionPoint1 = getPoint(time1);
			
			
			if (distanceX) {
				lineTime0 = (intersectionPoint0.x - target.start.x) / distanceX;
				lineTime1 = (intersectionPoint1.x - target.start.x) / distanceX;
			} else {
				lineTime0 = (intersectionPoint0.y - target.start.y) / distanceY;
				lineTime1 = (intersectionPoint1.y - target.start.y) / distanceY;
			}
			
			outsideLine0 = lineTime0 < 0 || lineTime0 > 1;
			outsideLine1 = lineTime1 < 0 || lineTime1 > 1;

			if (target.isSegment && outsideLine0 && outsideLine1) {
				return null;
			}
			
			if (__isSegment) {
				if (target.isSegment) {
					if (!outsideBezier0 && !outsideLine0) {
						intersection.currentTimes.push(time0);
						intersection.targetTimes.push(lineTime0);
					}
					if (!outsideBezier1 && !outsideLine1) {
						intersection.currentTimes.push(time1);
						intersection.targetTimes.push(lineTime1);
					}
				} else {
					if (!outsideBezier0) {
						intersection.currentTimes.push(time0);
						intersection.targetTimes.push(lineTime0);
					}
					if (!outsideBezier1) {
						intersection.currentTimes.push(time1);
						intersection.targetTimes.push(lineTime1);
					}
				}
				if (!intersection.currentTimes.length) {
					return null;
				}
				return intersection;
			}
			
			// if !this.isSegment

			if (target.isSegment) {
				if (!outsideLine0) {
					intersection.currentTimes.push(time0);
					intersection.targetTimes.push(lineTime0);
				}
				if (!outsideLine1) {
					intersection.currentTimes.push(time1);
					intersection.targetTimes.push(lineTime1);
				}
				if (!intersection.currentTimes.length) {
					return null;
				}
				return intersection;
			}
			
			// if !this.isSegment && !target.isSegment
			intersection.currentTimes.push(time0);
			intersection.targetTimes.push(lineTime0);
			intersection.currentTimes.push(time1);
			intersection.targetTimes.push(lineTime1);
			return intersection;
		}

		
		/**
		 * Результат вычисления пересечения кривой Безье с другой кривой Безье может дать следующие результаты:<BR/>
		 * - если пересечение отсутствует, возвращается null;<BR/>
		 * - если пересечение произошло в точках (от одной до четырех точек), будет возвращен объект Intersection,
		 *   и time-итераторы точек пересечения на данной кривой Безье будут находиться в массиве currentTimes.
		 *   time-итераторы точек пересечения <code>target</code> будут находиться в массиве <code>targetTimes</code>;<BR/>
		 * - также может произойти совпадение кривых. В этом случае результатом будет являться кривая - объект Bezier (<code>isSegment=true</code>), 
		 * которая будет доступна как свойство <code>coincidenceBezier</code> в возвращаемом объекте Intersection;<BR/>
		 * <BR/>
		 * На результаты вычисления пересечений оказывает влияние свойство <code>isSegment<code> как текущего объекта,
		 * так и значение <code>isSegment</code> объекта <code>target</code>.
		 * 
		 * @param target:Bezier
		 * @return Intersection
		 * 
		 * @example <listing version="3.0">
		 *	import flash.geom.Bezier;
		 * 	import flash.geom.Point;
		 *	
		 *	function randomPoint():Point {
		 *		return new Point(Math.random()&#42;stage.stageWidth, Math.random()&#42;stage.stageHeight);
		 *	}
		 *	function randomBezier():Bezier {
		 *		return new Bezier(randomPoint(), randomPoint(), randomPoint());
		 *	}
		 *	
		 *	const bezier:Bezier = randomBezier();
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 9.0
		 * 
		 */		

		// TODO: [Sergeev] метод не закончен.
		// 1. Убрать рекурсию - в первую очередь.
		// 2. Метод иногда дает пересечение в случаях, когда его нет. (iv:сделаю тест)  
		// 3. нигде не реализован расчет targetTimes. 
		//    Т.е. везде, где заполняем currentTimes должно быть заполнение targetTimes. 
		// 4. Требуется расчета совпадений
		// 5. Нужно прокомментировать блоки кода, указать какой случай рассматривается. 
		// 6. оптимизация: поскольку на практике в 90 и более процентах случаев
		//    пересечения не будет, очень важно продумать стратегию простых проверок
		//    в самом начале метода. Таких как Intersection.isIntersectionPossible();
		//    Нужны быстрые, элементарные проверки.

		public function intersectionBezier(target : Bezier) : Intersection {
			const vertexTime : Number = target.parabolaVertex;
			const targetParabolaVertex : Point = target.getPoint(vertexTime);
			const tpvX : Number = targetParabolaVertex.x;
			const tpvY : Number = targetParabolaVertex.y;
			
			const nX : Number = 2 * vertexTime * (target.startPoint.x - 2 * target.controlPoint.x + target.endPoint.x) + 2 * (target.controlPoint.x - target.startPoint.x);
			const nY : Number = 2 * vertexTime * (target.startPoint.y - 2 * target.controlPoint.y + target.endPoint.y) + 2 * (target.controlPoint.y - target.startPoint.y);

			const nnX : Number = 2 * (target.startPoint.x - 2 * target.controlPoint.x + target.endPoint.x);
			const nnY : Number = 2 * (target.startPoint.y - 2 * target.controlPoint.y + target.endPoint.y);

						
			var angle : Number = -Math.atan2(nY, nX);
			if ((nX == 0) && (nY == 0)) {
				angle = -Math.atan2(nnY, nnX);
			}
			
			const angleSin : Number = Math.sin(angle);
			const angleCos : Number = Math.cos(angle);
			
			
			// target
			const teX : Number = tpvX - target.endPoint.x;
			const teY : Number = tpvY - target.endPoint.y;
			const tsX : Number = tpvX - target.startPoint.x;
			const tsY : Number = tpvY - target.startPoint.y;
			
			var e1_x : Number = teX * angleCos - teY * angleSin;
			var e1_y : Number = teX * angleSin + teY * angleCos;
			
			var s1_x : Number = tsX * angleCos - tsY * angleSin;
			var s1_y : Number = tsX * angleSin + tsY * angleCos;		
				
			if (Math.abs(e1_x) < PRECISION) {
				e1_x = 0;
			}
			if (Math.abs(e1_y) < PRECISION) {
				e1_y = 0;
			}
			if (Math.abs(s1_x) < PRECISION) {
				s1_x = 0;
			}
			if (Math.abs(s1_y) < PRECISION) {
				s1_y = 0;
			}
							
			//			const nnX2:Number = nnX*angleCos - nnY*angleSin;
			//			const nnY2:Number = nnX*angleSin + nnY*angleCos;
			//			const tsX:Number = tpvX-target.startPoint.x;
			//			const tsY:Number = tpvY-target.startPoint.y;
			//			const tcX:Number = tpvX-target.controlPoint.x;
			//			const tcY:Number = tpvY-target.controlPoint.y;
			
			// current

			
			const csX : Number = tpvX - startPoint.x;
			const csY : Number = tpvY - startPoint.y;
			const sX : Number = csX * angleCos - csY * angleSin;
			const sY : Number = csX * angleSin + csY * angleCos;
			
			const ccX : Number = tpvX - controlPoint.x;
			const ccY : Number = tpvY - controlPoint.y;
			const cX : Number = ccX * angleCos - ccY * angleSin;
			const cY : Number = ccX * angleSin + ccY * angleCos;
			
			const ceX : Number = tpvX - endPoint.x;
			const ceY : Number = tpvY - endPoint.y;
			const eX : Number = ceX * angleCos - ceY * angleSin;
			const eY : Number = ceX * angleSin + ceY * angleCos;
									
									
			
			//			const sf2_x:Number = tsX*angleCos-tsY*angleSin;
			//			const sf2_y:Number = tsX*angleSin+tsY*angleCos;
			//			const sf2:Point = new Point(tsX*angleCos)-tsY*angleSin, tsX*angleSin+tsY*angleCos);
			//			const cf2:Point = new Point(tcX*angleCos-tcY*angleSin, tcX*angleSin+tcY*angleCos);
			//			const ef2:Point = new Point(teX*angleCos-teY*angleSin, teX*angleSin+teY*angleCos);

			var k : Number;
			
			if (e1_x != 0)
				k = e1_y / e1_x / e1_x;
			else {
				k = s1_y / s1_x / s1_x;			
			}
			
					
			var A : Number = k * (sX - 2 * cX + eX) * (sX - 2 * cX + eX);
			var B : Number = k * 4 * (sX - 2 * cX + eX) * (cX - sX);
			var C : Number = k * (4 * (cX - sX) * (cX - sX) + 2 * sX * (sX - 2 * cX + eX)) - (sY - 2 * cY + eY);
			var D : Number = k * 4 * sX * (cX - sX) - 2 * (cY - sY);
			var E : Number = k * sX * sX - sY;
			
			if (Math.abs(A) > 0.000000000001) {
				B /= A;
				C /= A;
				D /= A;
				E /= A;
				A = 1;				
			}
			
			const solves : Array = Equations.solveEquation(A, B, C, D, E);
			const intersection : Intersection = new Intersection();
			
			var time : Number;
			const len : uint = solves.length;
			if (!__isSegment && !target.isSegment) {
				for (var i : uint = 0;i < len; i++) {
					intersection.currentTimes[i] = solves[i];
				}
				return intersection;
			}
			
			if (!target.isSegment) {
				for (i = 0;i < len; i++) {
					time = solves[i];
					if (time >= 0 && time <= 1) {
						intersection.currentTimes.push(time);
					}
				}
				return intersection;
			}
			
			// TODO: check if point on target segment
			for (i = 0;i < len; i++) {
				time = solves[i];
				intersection.currentTimes.push(time);
			}
			
			return intersection;
		}

		
		
		//**************************************************
		//				UTILS 
		//**************************************************
		/**
		 * 
		 * @return String 
		 * 
		 */
		public function toString() : String {
			return 	"(start:" + startPoint + ", control:" + controlPoint + ", end:" + endPoint + ")";
		}

		//**************************************************
		//				PRIVATE 
		//**************************************************
	}
}


