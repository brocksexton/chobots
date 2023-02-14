package com.kavalok.dialogs.buy
{
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class ItemOfTheMonthView extends FlashViewBase
	{
		private var _content:MovieClip;
		private var _itemOfTheMonth1:MovieClip;
		private var _itemOfTheMonth6:MovieClip;
		private var _itemOfTheMonth12:MovieClip;
		private var _itemOfTheMonth1Title:MovieClip;
		private var _itemOfTheMonth6Title:MovieClip;
		private var _itemOfTheMonth12Title:MovieClip;

		private var _i1visible:Boolean;
		private var _i6visible:Boolean;
		private var _i12visible:Boolean;

		public function ItemOfTheMonthView(content:MovieClip, i1visible : Boolean = true, i6visible : Boolean = true, i12visible : Boolean = true)
		{
			_i1visible = i1visible;
			_i6visible = i6visible;
			_i12visible = i12visible;

			_content = content;
			super(content);
			_itemOfTheMonth1=content.itemOfTheMonth1;
			_itemOfTheMonth6=content.itemOfTheMonth6;
			_itemOfTheMonth12=content.itemOfTheMonth12;
			_itemOfTheMonth1Title=content.itemOfTheMonth1Title;
			_itemOfTheMonth6Title=content.itemOfTheMonth6Title;
			_itemOfTheMonth12Title=content.itemOfTheMonth12Title;

			_itemOfTheMonth1.visible=false;
			_itemOfTheMonth6.visible=false;
			_itemOfTheMonth12.visible=false;
			_itemOfTheMonth1Title.visible=false;
			_itemOfTheMonth6Title.visible=false;
			_itemOfTheMonth12Title.visible=false;

			if(RemoteConnection.instance.connected){
				initItems();
			}else{
				RemoteConnection.instance.connectEvent.addListener(initItems);
			}
		}
		
		private function initItems():void
		{
			new StuffServiceNT(onGetItemOfTheMonth).getItemOfTheMonthType();
			RemoteConnection.instance.connectEvent.removeListenerIfHas(initItems);
		}
		

		private function onGetItemOfTheMonth(result:Array) : void
		{
			if(!result)
				return;
				
			if(_i1visible)
				initItemOfTheMonh(_itemOfTheMonth1, _itemOfTheMonth1Title, StuffTypeTO(result[0]))
			if(_i6visible)
				initItemOfTheMonh(_itemOfTheMonth6, _itemOfTheMonth6Title, StuffTypeTO(result[1]))
			if(_i12visible)
				initItemOfTheMonh(_itemOfTheMonth12, _itemOfTheMonth12Title, StuffTypeTO(result[2]))
		}
		private function initItemOfTheMonh(mc:MovieClip, titleClip : MovieClip, result:StuffTypeTO) : void
		{
			if(!result)
				return;
			//-- createModel
			var model:ResourceSprite = result.createModel();
			model.loadContent();
			GraphUtils.scale(model, mc.height, mc.width)
			mc.addChild(model);
			
			var modelRect:Rectangle = model.getBounds(mc);
			var positionRect:Rectangle = mc.getBounds(mc);
			model.x += (positionRect.x + 0.5 * positionRect.width)
				- (modelRect.x + 0.5 * modelRect.width)
			model.y += (positionRect.y + 0.5 * positionRect.height)
				- (modelRect.y + 0.5 * modelRect.height);
			
			mc.visible=true;
			if(result.name && result.name.length>0){
				var name : String = result.name.replace("&#252;", "ü");
				name = name.replace("&uuml;", "ü");
				titleClip.itemTitle.text = name;
				titleClip.visible = true;
			}
		}
	}
}

