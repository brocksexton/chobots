package com.kavalok.dialogs
{
	import flash.external.ExternalInterface;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.KavalokConstants;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.kavalok.Global;
	import flash.display.Loader;
	import com.kavalok.events.EventSender;
	import com.kavalok.services.AdminService;
	import flash.net.URLRequest;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import flash.events.Event;
	import com.kavalok.services.CharService;
	import flash.display.DisplayObject;
	import com.kavalok.gameplay.windows.ShowCharViewCommand;
	import com.kavalok.utils.GraphUtils;
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class DialogOutfitsView extends DialogViewBase
	{
		public var closeButton:SimpleButton;
		public var useButton : SimpleButton;
		public var saveButton : SimpleButton;
		public var leftClick : SimpleButton;
		public var rightClick : SimpleButton;
		public var nextClick : SimpleButton;
		public var prevClick : SimpleButton;
		public var clearButton : SimpleButton;
		public var _model:CharModel;
		public var _model2:CharModel;
		public var _model3:CharModel;
		public var charZone:Sprite;
		public var charZone2:Sprite;
		public var charZone3:Sprite;
		public var StarPremium:Sprite;
		public var OutfitNumber:int = 1;
		private var _content:DialogOutfits;
		
		public function DialogOutfitsView(text:String = null, modal:Boolean = true)
		{
			_content = new DialogOutfits();
			super(_content, null, false);
			GraphUtils.attachModalShadow(_content,true);
			_model = new CharModel();
			_model.refresh();
			_model.char.body = Global.charManager.body;
			_model.char.color = Global.charManager.color;
			
			_model2 = new CharModel();
			_model2.refresh();
			_model2.char.body = Global.charManager.body;
			_model2.char.color = Global.charManager.color;
			
			_model3 = new CharModel();
			_model3.refresh();
			_model3.char.body = Global.charManager.body;
			_model3.char.color = Global.charManager.color;
			
			charZone.addChild(_model);
			GraphUtils.fitToObject(_model, charZone);
			
			charZone2.addChild(_model2);
			GraphUtils.fitToObject(_model2, charZone2);
			
			charZone3.addChild(_model3);
			GraphUtils.fitToObject(_model3, charZone3);
			
			var splitOutfits:Array = Global.charManager.outfits.split("#");
			getOutfits(splitOutfits[0], _model2, charZone2) //PREVIOUS
			getOutfits(splitOutfits[1], _model, charZone)
			getOutfits(splitOutfits[2], _model3, charZone3) //NEXT
			StarPremium.visible = false;
			//clearButton.visible = false;
			clearButton.addEventListener(MouseEvent.CLICK, onClearClick);
			closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			useButton.addEventListener(MouseEvent.CLICK, onUseClick);
			saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
			leftClick.addEventListener(MouseEvent.CLICK, onRotateLeftClick);		
			rightClick.addEventListener(MouseEvent.CLICK, onRotateRightClick);
			nextClick.addEventListener(MouseEvent.CLICK, onNextClick);
			//ExternalInterface.call("console.log", splitOutfits.length);
			if(splitOutfits.length <= OutfitNumber) {
				GraphUtils.setBtnEnabled(nextClick, false);
			}
			GraphUtils.setBtnEnabled(prevClick, false);
			prevClick.addEventListener(MouseEvent.CLICK, onPrevClick);
		}
		
		private function onNextClick(e:MouseEvent) : void
		{
			OutfitNumber = OutfitNumber+1;
			var splitOutfits:Array = Global.charManager.outfits.split("#");
			
			GraphUtils.setBtnEnabled(prevClick, true);
			if(splitOutfits.length > OutfitNumber) {
				GraphUtils.setBtnEnabled(nextClick, true);
			} else {
				GraphUtils.setBtnEnabled(nextClick, false);
			}
			if(OutfitNumber >= 2 && !Global.charManager.isCitizen) {
				GraphUtils.setBtnEnabled(nextClick, false);
				StarPremium.visible = true;
			}
			getOutfits(splitOutfits[OutfitNumber-1], _model2, charZone2) //PREV
			GraphUtils.setBtnEnabled(useButton, true);
			getOutfits(splitOutfits[OutfitNumber], _model, charZone);
			getOutfits(splitOutfits[OutfitNumber+1], _model3, charZone3) //NEXT
		}
		
		private function onPrevClick(e:MouseEvent) : void
		{
			OutfitNumber = OutfitNumber-1;
			var splitOutfits:Array = Global.charManager.outfits.split("#");
			
			GraphUtils.setBtnEnabled(nextClick, true);
			StarPremium.visible = false;
			if(OutfitNumber < 2) {
				GraphUtils.setBtnEnabled(prevClick, false);
			}
			getOutfits(splitOutfits[OutfitNumber-1], _model2, charZone2); //PREV
			GraphUtils.setBtnEnabled(useButton, true);
			getOutfits(splitOutfits[OutfitNumber], _model, charZone);
			getOutfits(splitOutfits[OutfitNumber+1], _model3, charZone3); //NEXT
		}
		
		public function getOutfits(Outfit:String, charModel:CharModel, Zone:Sprite) : void
		{
			charModel.char.clothes = [];
			var useButtonEnabled:Boolean = true;
			if(Outfit) {
				var myArray:Array = Outfit.split(",");
				var i:int = -1;
				while (++i < myArray.length) {
					var _item:StuffItemLightTO = Global.charManager.stuffs.getById(myArray[i]);
					if(_item) {
						charModel.char.clothes.push(_item);
						if(charModel == _model) {
							if(_item.premium && !Global.charManager.isCitizen) {
								useButtonEnabled = false;
							} else if(_item.shopName == 'agentsShop' && !Global.charManager.isAgent) {
								useButtonEnabled = false;
							}
						}
					}
				}
				if(useButtonEnabled == false) {
					GraphUtils.setBtnEnabled(useButton, false);
				}
			}
			charModel.reload();
		}
		
		private function onClearClick(e:MouseEvent) : void
		{
			var splitOutfits:Array = Global.charManager.outfits.split("#");
			var newSplitOutfits:Array = splitOutfits.splice(OutfitNumber, 1);
			
			var newOutfits:String = splitOutfits.join("#");
			Global.charManager.outfits = newOutfits;
			
			new CharService().saveOutfits(newOutfits);
			//ExternalInterface.call("console.log", splitOutfits.length);
			if(splitOutfits.length <= OutfitNumber) {
				GraphUtils.setBtnEnabled(nextClick, false);
			}
			GraphUtils.setBtnEnabled(useButton, true);
			getOutfits(splitOutfits[OutfitNumber], _model, charZone)
			getOutfits(splitOutfits[OutfitNumber+1], _model3, charZone3) //NEXT
		}
		
		
		private function onRotateLeftClick(e:MouseEvent) : void
		{
			_model.rotateLeft();
		}
		
		private function onRotateRightClick(e:MouseEvent) : void
		{
			_model.rotateRight();
		}
		
		private function onUseClick(e:MouseEvent) : void
		{
			Global.charManager.clothes = _model.char.clothes;
			hide();
		}

		private function onSaveClick(e:MouseEvent) : void
		{
			Global.isLocked = true;
			_model.char.clothes = Global.charManager.clothes;
			_model.reload();
			
			var clothes:Array = Global.charManager.clothes;
			var result:Array = [];
			for each (var item:StuffItemLightTO in clothes)
			{
				result.push(item.id);
			}
			
			var splitOutfits:Array = Global.charManager.outfits.split("#");
			if(splitOutfits[OutfitNumber]) {
				splitOutfits[OutfitNumber] = result.toString();
			} else {
				splitOutfits[splitOutfits.length] = result.toString();
			}
			GraphUtils.setBtnEnabled(nextClick, true);
			var newOutfits:String = splitOutfits.join("#");
			Global.charManager.outfits = newOutfits;
			
			new CharService().saveOutfits(newOutfits);
			Global.isLocked = false;
			
		}
		
		protected function onCloseClick(event : MouseEvent) : void
		{
			hide();
		}
	}
}