package com.kavalok.stuffCatalog.view
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.robots.RobotItemInfoSprite;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.SpriteDecorator;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class RobotItemView extends ItemViewBase
	{
		static private const WIDTH:int = 200;
		static private const HEIGHT:int = 200;
		static private const MODEL_HEIGHT:int = 80;
		
		private var _stuffSprite:StuffSprite;
		private var _model:Sprite;
		
		public function RobotItemView(itemInfo:StuffSprite)
		{
			_stuffSprite = itemInfo;
			createContent();
			refresh();
		}
		
		private function createContent():void
		{
			var rect:Sprite = GraphUtils.createRectSprite(WIDTH, HEIGHT, 0, 0);
			addChild(rect);
			
			_model = Sprite(Global.classLibrary.getInstance(_stuffSprite.url, 'McStuff'));
			addChild(_model);
			GraphUtils.scale(_model, MODEL_HEIGHT, WIDTH);
			GraphUtils.alignCenter(_model,
				new Rectangle(0, 0, WIDTH, MODEL_HEIGHT));
				
			var item:RobotItemTO = new RobotItemTO();
			item.name = _stuffSprite.item.name;
			ReflectUtil.copyFieldsAndProperties(StuffTypeTO(_stuffSprite.item).robotInfo, item);
			var info:Sprite = new RobotItemInfoSprite(item);
			info.y = _model.height + 10;
			addChild(info);
		}
		
		override public function refresh():void
		{
			SpriteDecorator.decorateColor(_model, _stuffSprite.color, _stuffSprite.colorSec);
		}
		
	}
}