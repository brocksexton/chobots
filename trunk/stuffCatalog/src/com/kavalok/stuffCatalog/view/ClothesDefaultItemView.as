package com.kavalok.stuffCatalog.view
{
	import com.kavalok.Global;
	import com.kavalok.char.CharModel;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;

	public class ClothesDefaultItemView extends ItemViewBase
	{
		private var _stuffSprite:StuffSprite;
		private static var _charModel:CharModel;
		
		public function ClothesDefaultItemView(itemInfo:StuffSprite)
		{
			_stuffSprite = itemInfo;
			createContent();
			refresh();
		}
		
		private function createContent():void
		{
			var rect:Sprite = GraphUtils.createRectSprite(180, 180, 0, 0);
			addChild(rect);
			
			_charModel = new CharModel();
			_charModel.char.body = Global.charManager.body;
			_charModel.char.color = Global.charManager.color;
			_charModel.scale = 2.8;
			_charModel.x = 0.5 * rect.width;
			_charModel.y = rect.height - 20;
			
			addChild(_charModel);
		}

		
		override public function refresh():void
		{
			var stuff:StuffItemLightTO = new StuffItemLightTO();
			stuff.fileName = _stuffSprite.item.fileName;
			stuff.color = _stuffSprite.color;
			stuff.colorSec = _stuffSprite.colorSec;
			_charModel.char.clothes = [stuff];
			_charModel.reload();
		}
		
		public static function rotateLeft() : void
		{
			_charModel.rotateLeft();
		}
		
		public static function rotateRight() : void
		{
			_charModel.rotateRight();
		}
	}
}