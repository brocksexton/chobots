package com.kavalok.gameplay.tips
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.controls.StateButton;
	import com.kavalok.gameplay.controls.TextScroller;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class TipWindow
	{
		private var _closeEvent:EventSender = new EventSender();
		
		private var _tipId:int;
		private var _content:McResearchTip = new McResearchTip();
		private var _tipsCheckBox:StateButton = new StateButton(_content.tipsCheckBox);
		private var _scroller:TextScroller = new TextScroller(_content.scroller, _content.textField);
		private var _picture:DisplayObject;
		
		public function TipWindow()
		{
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.previousButton.addEventListener(MouseEvent.CLICK, onPrevClick);
			_content.nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			
			 _tipsCheckBox.state = Global.showTips ? 2 : 1;
			 _tipsCheckBox.stateEvent.addListener(onTipsClick);
			
			_content.pictureArea.visible = false;
			_content.textField.text = '';
			
			Global.resourceBundles.kavalok.registerTextField(_content.captionField, 'academy');
			
			refresh();
		}
		
		private function onTipsClick(sender:Object):void
		{
			Global.showTips = (_tipsCheckBox.state == 2);
			Global.saveSettings();
		}
		
		private function refresh():void
		{
			_content.pageField.text = '' + (_tipId + 1) + '/' + KavalokConstants.TIPS_COUNT;
			
			GraphUtils.setBtnEnabled(_content.previousButton, _tipId > 0)
			GraphUtils.setBtnEnabled(_content.nextButton, _tipId < KavalokConstants.TIPS_COUNT - 1);
			
			_scroller.updateScrollerVisible();
			_scroller.position = 0;
		}
		
		public function loadTip(tipId:int):void
		{
			_tipId = tipId;
			Global.isLocked = true;
			new LoadTipCommand(_tipId, onLoad).execute();
		}
		
		private function onLoad(tip:Tip):void
		{
			Global.isLocked = false;
			
			_content.captionField.text = tip.title || "";
			_content.textField.text = tip.text || "";
			
			setPicture(tip.picture)
				
			refresh();
		}
		
		private function setPicture(picture:DisplayObject):void
		{
			if (_picture)
				_content.removeChild(_picture);
				
			_picture = picture;
			
			if (_picture)
			{
				var bounds:Rectangle = _content.pictureArea.getRect(_content);
				
				GraphUtils.scale(picture, bounds.height, bounds.width);
				
				picture.x = bounds.x + 0.5 * bounds.width - 0.5 * picture.width; 
				picture.y = bounds.y + 0.5 * bounds.height - 0.5 * picture.height; 
				
				_content.addChild(picture);
			}
		}
		
		private function onPrevClick(e:MouseEvent):void
		{
			loadTip(_tipId - 1);
		}
		
		private function onNextClick(e:MouseEvent):void
		{
			loadTip(_tipId + 1); 
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			_closeEvent.sendEvent();
			Dialogs.hideDialogWindow(content);
		}
		
		public function get content():Sprite { return _content; }
		public function get closeEvent():EventSender { return _closeEvent; }
	}
}