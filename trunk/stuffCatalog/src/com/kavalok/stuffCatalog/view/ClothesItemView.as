package com.kavalok.stuffCatalog.view
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.char.CharModel;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.utils.GraphUtils;
	import flash.external.ExternalInterface;
	import com.kavalok.dto.stuff.StuffTypeTO;
	 import com.kavalok.services.StuffServiceNT;

	
	import flash.display.Sprite;

	public class ClothesItemView extends ItemViewBase
	{
		private var _stuffSprite:StuffSprite;
		private static var _charModel:CharModel;
		private var getPlacement:StuffTypeTO; 
		
		public function ClothesItemView(itemInfo:StuffSprite)
		{
			_stuffSprite = itemInfo;
			createContent();
			new StuffServiceNT(setPlacement).getStuffTypeFromId(itemInfo.item.id);
		}
		
		private function setPlacement(item:StuffTypeTO):void
		{
			getPlacement = item;
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
			_charModel.refresh()
			
			addChild(_charModel);
		}

		
		override public function refresh():void
		{
			var stuff:StuffItemLightTO = new StuffItemLightTO();
			stuff.fileName = _stuffSprite.item.fileName;
			stuff.color = _stuffSprite.color;
			stuff.colorSec = _stuffSprite.colorSec;
			stuff.placement = getPlacement.placement;

			var result:Array = [stuff];
			var usedClothes:Array = Global.charManager.clothes;
			
			// ExternalInterface.call('console.log', "Got clothes: itemid : " + _stuffSprite.item.id);
			for each (var clothe:StuffItemLightTO in usedClothes)
			{
				if(Stuffs.isCompatible(clothe.placement, getPlacement.placement))
				{
					// ExternalInterface.call('console.log', "is Compatable");
					result.push(clothe);
				}
			}
			// ExternalInterface.call('console.log', "pushed clothe");
			_charModel.char.clothes = result;
			_charModel.reload();
			// ExternalInterface.call('console.log', "reloaded");
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