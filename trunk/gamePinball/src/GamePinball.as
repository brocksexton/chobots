package
{
	import com.kavalok.Global;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.TopScores;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.pinball.BallsView;
	import com.kavalok.pinball.GlazeUtil;
	import com.kavalok.pinball.KeyboardController;
	import com.kavalok.pinball.MouseController;
	import com.kavalok.pinball.space.EventSpace;
	import com.kavalok.pinball.spaceBuilders.AnimationBuilder;
	import com.kavalok.pinball.spaceBuilders.CurveMovementBuilder;
	import com.kavalok.pinball.spaceBuilders.IDynamicSpaceBuilder;
	import com.kavalok.pinball.spaceBuilders.ISpaceBuilder;
	import com.kavalok.pinball.spaceBuilders.LineMovementBuilder;
	import com.kavalok.pinball.spaceBuilders.StaticCircleBuilder;
	import com.kavalok.pinball.spaceBuilders.StaticShapeBuilder;
	import com.kavalok.security.EncryptedValue;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Maths;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.Sequence;
	import com.kavalok.utils.Timers;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.dynamics.forces.Spring;
	import org.rje.glaze.engine.dynamics.joints.Joint;
	import org.rje.glaze.engine.dynamics.joints.PinJoint;
	import org.rje.glaze.engine.math.Vector2D;

	[SWF(width='900', height='510', backgroundColor='0xeAAAAAA', framerate='30')]
	public class GamePinball extends LocationModule
	{
		private static const DEBUG_DRAW : Boolean = false;
		
		public static const BALL_RADIUS : Number = 10;
		private static const MONEY_COEFFICIENT : Number = 1/5;
		private static const POINTS_FOR_LEVEL : Number = 100;
		private static const PUSH_SPEED : Number = 100;
		private static const PUSH_OFFSET : Number = 20;
		private static const PUSH_PAUSE : Number = 2000;
		private static const BALL_START_FRAME : Number = 18;
		private static const SPRING_OFFSET : Number = 100;
		private static const HAND_DENSITY : Number = 10;
		private static const SPRING_STIFFNESS : Number = 10000;
		private static const MAX_ANGLE : Number = Maths.degreesToRadians(30);
		private static const STATIC_MATERIAL : Material = new Material(0, 0.01, 1);
		private static const HAND_W : uint = 15;
		private static const BALLS : uint = 2;
		private static const FPS : uint = 0;
		private static const PPS : uint = 100;
		private static const LEVEL_FORCE : uint = 30;
		private static const MASSLESS_FORCE : uint = 200;
		private static const MINIMUM_START_SPEED : int = -100;
		private static const MAXIMUM_SPEED_OFFSET : int = -2000;

		private static const HAND_CIRCLE_OFFSET : Point = new Point(50, 0);
		private static const HAND_CIRCLE_RADIUS : Number = 10;
		private static const LOCAL_HAND_COORDS : Array = [new Point(-100, -10), new Point(-100, 10), new Point(0, 10), new Point(0, -10)];
		private static const JOINT_POSITION : Point = new Point(-50, 0);
		
		private static var resourceBundle : ResourceBundle = Localiztion.getBundle("gamePinball");
		
		public var content : Background;
		
		private var _space : EventSpace;
		private var _ball : Ball;
		private var _ballBody : RigidBody;
		private var _builders : Array = [];
		private var _dynamicBuilders : Array = [];
		private var _drawSprite : Sprite;
		private var _left : RigidBody;
		private var _right : RigidBody;
		private var _startRightPosition : Point;
		
		private var _startLeftPosition : Point;
		private var _leftSpring : Spring;
		private var _rightSpring : Spring;
		private var _processStep : Boolean = true;
		private var _level : uint;
		private var _points : EncryptedValue = new EncryptedValue();
		
		private var _startBegin : Boolean = false;
		private var _gameStarted : Boolean = false;
		private var _leftUp : Boolean = false;
		private var _rightUp : Boolean = false;
		private var _pushEnabled : Boolean = true;
		private var _ballsView : BallsView;

		public function GamePinball()
		{
			super();
		}
		override public function initialize() : void
		{
			Dialogs.showOkDialog(resourceBundle.messages.rules, true, new McInfo());
			Global.frame.visible = false;
			content = new Background();
			new ResourceScanner().apply(content);
			_drawSprite = new Sprite();
			addChild(content);
			addChild(_drawSprite);
			_ballsView = new BallsView(content.balls, BALLS);
			eventManager.registerEvent(this, Event.ENTER_FRAME, onEnterFrame);
			eventManager.registerEvent(content.exitButton, MouseEvent.CLICK, onExitClick);
			eventManager.registerEvent(content.playButton, MouseEvent.CLICK, onPlay);
			
			_space = new EventSpace(FPS, PPS);
			_space.masslessForce.setTo(0, MASSLESS_FORCE);
			_space.physicsStepEvent.addListener(onPhysicsStep);
			createBall();
			_builders.push(new StaticShapeBuilder(PhysixSquare, new Material(0, 0, 1)));
			_builders.push(new StaticShapeBuilder(SpringSquare, new Material(3, 0, 1), 0x00ff00));
			_builders.push(new StaticCircleBuilder(SpringCircle, new Material(3, 0, 1), 0x00ff00));
			_dynamicBuilders.push(new CurveMovementBuilder(_ballBody));
			_dynamicBuilders.push(new AnimationBuilder(_ballBody));
			_dynamicBuilders.push(new LineMovementBuilder(_ballBody));
			buildSpace();
			createHands();
			new KeyboardController(this);
			new MouseController(this);
			play();
			readyEvent.sendEvent();
		}
		
		private function get level() : uint
		{
			return _level;
		}
		private function set level(value : uint) : void
		{
			_level = value;
			_space.masslessForce.setTo(0, MASSLESS_FORCE + value * LEVEL_FORCE);
			content.levelText.text = resourceBundle.messages.level + value;
		}
		private function set points(value : int) : void
		{
			_points.value = value;
			content.pointsText.text = value.toString();
			if(points / (level * POINTS_FOR_LEVEL) >= 1)
			{
				level++;
			}
			
		}
		private function get points() : int
		{
			return _points.value;
		}
		
		public function setBallLevel(level : String) : void
		{
			if(level == null)
			{
				level = "level0";
			}
			content[level].addChild(_ball);
		}
		
		public function pushRight() : void
		{
			push(PUSH_SPEED);
		}
		public function pushLeft() : void
		{
			push(-PUSH_SPEED);
		}
		
		private function push(speed : Number) : void
		{
			if(!_pushEnabled)
				return;
			
			_pushEnabled = false;
			
			Global.playSound(SoundHit1);
			if(_ballBody.p.x != -100)
			{
				_ballBody.v.setTo(_ballBody.v.x + speed, _ballBody.v.y);
			}
			var offset : Number = - PUSH_OFFSET * speed / Math.abs(speed);
			var filter : BlurFilter = new BlurFilter();
			filters = [filter];
			new Sequence(this, [{x : offset}, {x:0}], 2, onSequenceEnd);
			Timers.callAfter(enablePush, PUSH_PAUSE);
		}
		
		private function onSequenceEnd() : void
		{
			filters = [];
		}
		private function enablePush() : void
		{
			_pushEnabled = true;
		}
		
		public function leftUp() : void
		{
			if(!_leftUp)
			{
				_leftSpring.stiffness = - SPRING_STIFFNESS;
				handUp(content.leftHand);
				_leftUp = true;
			}
			//content.leftHand.play();
		}
		public function leftDown() : void
		{
			if(_leftUp)
			{
				_leftSpring.stiffness = SPRING_STIFFNESS;
				handDown(content.leftHand);
				_leftUp = false;
			}
		}
		
		public function rightUp() : void
		{
			if(!_rightUp)
			{
				_rightSpring.stiffness = - SPRING_STIFFNESS;
				handUp(content.rightHand);
				_rightUp = true;
			}
		}
		public function rightDown() : void
		{
			if(_rightUp)
			{
				_rightSpring.stiffness = SPRING_STIFFNESS;
				handDown(content.rightHand);
				_rightUp = false;
			}
		}
		
		public function endStart() : void
		{
			if(!_startBegin)
				return;
			var speedCoef : Number = (content.startAnimation.currentFrame - BALL_START_FRAME)
				/ (content.startAnimation.totalFrames - BALL_START_FRAME);
			_startBegin = false;
			content.startAnimation.gotoAndStop(1);
			_ballBody.p.setTo(865, 410);
			_ballBody.v.setTo(0, MINIMUM_START_SPEED + MAXIMUM_SPEED_OFFSET * speedCoef);
			_space.stoped = false;
		}
		public function beginStart() : void
		{
			if(_gameStarted)
				return;
			_startBegin = true;
			_gameStarted = true;
			content.startAnimation.gotoAndPlay(BALL_START_FRAME);
		}
		public function addPoints(value : uint) : void
		{
			points += value;
		}
		
		private function onPlay(event : MouseEvent) : void
		{
			play();
		}
		
		private function play() : void
		{
			points = 0;
			level = 1;
			_ballsView.balls = BALLS;
			newBall();
		}
		private function newBall() : void
		{
			for each(var builder : IDynamicSpaceBuilder in _dynamicBuilders)
				builder.stop();
				
			
			Global.playSound(SoundStart);
			_ball.x = _ball.y = -100;
			_ballBody.p.setTo(-100, -100);
			_space.stoped = true;
			content.startAnimation.gotoAndPlay(1);
			_gameStarted = false;
		}
		private function handDown(movie : MovieClip) : void
		{
			Global.playSound(SoundHands);
			movie.gotoAndPlay(5);
		}
		private function handUp(movie : MovieClip) : void
		{
			Global.playSound(SoundHands);
			movie.gotoAndPlay(2);
		}
		private function createBall() : void
		{
			var circle : Circle = new Circle(BALL_RADIUS, new Vector2D(0, 0), new Material(1,0,10));
			_ballBody = new RigidBody();
			_ballBody.p.setTo(-100, -100);
			_ballBody.addShape(circle);
			_space.addRigidBody(_ballBody);
			_ball = new Ball();
			content.level0.addChild(_ball);
		}
		
		private function createHands() : void
		{
			_left = createHand(content.physicsContent.left);
			_right = createHand(content.physicsContent.right);
			_leftSpring = createSpring(_left, 100);
			_rightSpring = createSpring(_right, -100);
			_startLeftPosition = GraphUtils.transformCoords(JOINT_POSITION.clone(), content.physicsContent.left, Global.root); 
			_startRightPosition = GraphUtils.transformCoords(JOINT_POSITION.clone(), content.physicsContent.right, Global.root); 
			content.leftHand.gotoAndStop(1);
			content.rightHand.gotoAndStop(1);
		}

		private function createSpring(body : RigidBody, offsetX : Number) : Spring
		{
			var spring : Spring = new Spring(body, new Vector2D(body.p.x, body.p.y + 500), SPRING_STIFFNESS)
			_space.addForce(spring);
			return spring;
		}
		private function createHand(hand : DisplayObject) : RigidBody
		{
			var shape : Polygon = GlazeUtil.getPolygon(hand, LOCAL_HAND_COORDS, new Material(0, 0.1, HAND_DENSITY), false);
			var body : RigidBody = new RigidBody();
			body.addShape(shape);
			body.p.setTo(hand.x, hand.y);
			_space.addRigidBody(body);
			var jointPosition : Point = GraphUtils.transformCoords(JOINT_POSITION.clone(), hand, Global.root);
			var joint : PinJoint = new PinJoint(_space.defaultStaticBody, body
				, toVector2D(jointPosition), new Vector2D(jointPosition.x - hand.x, jointPosition.y - hand.y));
			_space.addJoint(joint);
			return body;
		}

		private function toVector2D(point : Point) : Vector2D
		{
			return new Vector2D(point.x, point.y);
		}
		private function buildSpace() : void
		{
			content.physicsContent.visible = false;
			var allBuilders : ArrayList = new ArrayList();
			allBuilders.addItems(_builders);
			allBuilders.addItems(_dynamicBuilders);
			buildByMovie(content.physicsContent, allBuilders);
			buildByMovie(content, allBuilders);
		}
		
		private function buildByMovie(movie : MovieClip, builders : ArrayList) : void
		{
			for(var i : uint = 0; i < movie.numChildren; i++)
			{
				var child : DisplayObject = movie.getChildAt(i);
				for each(var builder : ISpaceBuilder in builders)
				{
					builder.process(child, _space, this);
				}
			}
			
		}
		
		
		private function onPhysicsStep():void 
		{
			for each(var builder : IDynamicSpaceBuilder in _dynamicBuilders)
			{
				builder.step();
			}
			
		}
		private function onEnterFrame(event:Event):void 
		{
			_space.step();
			if(_ballBody.p.y > KavalokConstants.SCREEN_HEIGHT)
			{
				_ballsView.balls--;
				if(_ballsView.balls < 0)
				{
					gameOver();
				}
				else
				{
					newBall();
				}
			}
			_ball.x = _ballBody.p.x;
			_ball.y = _ballBody.p.y;
			
			
			if (DEBUG_DRAW)
			{
				_drawSprite.graphics.clear();
				draw();
				//throw new Error(); 
			}
		}
		
		private function gameOver() : void
		{
			Global.playSound(SoundEnd);
			content.levelText.text = resourceBundle.messages.gameOver;
			_ball.x = _ball.y = -100;
			_ballBody.p.setTo(-100, -100);
			_space.stoped = true;
			
			var money:int = points * MONEY_COEFFICIENT*2;
			new AddMoneyCommand(money, Competitions.PINBALL, true).execute();
			if (points <= 130){
			} else if (points <= 190){
				Global.addExperience(3);
			} else if (points <= 260){
				Global.addExperience(6);
			} else if (points <= 380){
				Global.addExperience(9);
			} else if (points <= 450){
				Global.addExperience(12);
			} else if (points <= 620){
				Global.addExperience(14);
			} else {
				Global.addExperience(18);
			}
			new TopScores(getQualifiedClassName(this), points, play, exit);
			
		}
		private function draw() : void
		{
			//Draw everything
			var shape:GeometricShape = _space.activeShapes;
			while (shape) {
				shape.draw(_drawSprite.graphics, false);
				drawCenter(shape);
				shape = shape.next;
			}
			shape = _space.staticShapes;
			while (shape) {
				shape.draw(_drawSprite.graphics, false);
				drawCenter(shape);
				shape = shape.next;
			}
			var joint:Joint = _space.joints;
			while (joint) {
				joint.draw(_drawSprite.graphics, false);
				joint = joint.next;
			}			
			
		}		
		private function onExitClick(event : MouseEvent) : void
		{
			exit();
		}
		private function exit() : void
		{
			closeModule();
			Global.frame.visible = true;
			Global.locationManager.returnToPrevLoc();
			Global.sendAchievement("ac21;","Pinball");
		}
		private function onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.charCode)
			{
				case "1".charCodeAt(0):
					_ballBody.p.setTo(490, 400);
					_ballBody.v.setTo(400, -600);
				break;
				case "2".charCodeAt(0):
					_ballBody.p.setTo(410, 400);
					_ballBody.v.setTo(-400, -600);
				break;
				case "3".charCodeAt(0):
					_ballBody.p.setTo(120, 370);
					//_ballBody.v.setTo(-400, -600);
				break;
				case "4".charCodeAt(0):
					_ballBody.p.setTo(180, 370);
					_ballBody.v.setTo(400, 0);
				break;
				case "5".charCodeAt(0):
					points += POINTS_FOR_LEVEL;
				break;
				case "0".charCodeAt(0): 
					_ballBody.p.setTo(865, 410);
					_ballBody.v.setTo(0, -3000);
				break;
			}
			
		}
		private function drawCenter(shape : GeometricShape) : void
		{
			//trace(shape)
			_drawSprite.graphics.lineStyle(0, 0xff0000);
			_drawSprite.graphics.drawCircle(shape.offset.x, shape.offset.y, 5);
		}
		
	}
}