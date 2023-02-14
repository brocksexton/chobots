package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.McPresentWindow;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.services.RobotServiceNT;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class RobotItemBoughtMessage extends MessageBase
	{
		public var itemId:int;
		
		private var _bundle:ResourceBundle = Global.resourceBundles.kavalok;
		private var _item:RobotItemTO;
		
		public function RobotItemBoughtMessage():void
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}
		
		private function onGetItem(result : RobotItemTO):void
		{
			_item = result;
			if (_item)
				showStuff(sender, getText());
		}
		
		override public function getText():String
		{
			return Global.resourceBundles.robots.messages.payedRobotItemBought;
		}
		
		override public function getIcon():Class
		{
			return McMsgRoboItemIcon;
		}
		
		override public function show():void
		{
			new RobotServiceNT(onGetItem).getItem(itemId);
		}
		
	
		protected function showStuff(
			caption:String,
			text:String,
			onClose:Function = null):void
		{
			//-- create window
			var view:McPresentWindow  = new McPresentWindow();
			view.captionField.text = String(caption);
			view.messageField.text = String(text);
			
			view.closeButton.visible = false;
			view.sellButton.visible = false;
			view.useButton.addEventListener(MouseEvent.CLICK, closeDialog);
			
			_bundle.registerButton(view.useButton, 'ok');
				 
			//-- createModel
			var model:ResourceSprite = new RobotItemSprite(_item);
			GraphUtils.scale(model, view.stuffRect.height, view.stuffRect.width)
			view.addChild(model);
			
			var modelRect:Rectangle = model.getBounds(view);
			var positionRect:Rectangle = view.stuffRect.getBounds(view);
			model.x += (positionRect.x + 0.5 * positionRect.width)
				- (modelRect.x + 0.5 * modelRect.width)
			model.y += (positionRect.y + 0.5 * positionRect.height)
				- (modelRect.y + 0.5 * modelRect.height);
			view.removeChild(view.stuffRect);
			//--
			
			showDialog(view); 
		}

		
	}
}