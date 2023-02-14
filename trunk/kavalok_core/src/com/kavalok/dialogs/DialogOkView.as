package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.Global;
		import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import com.kavalok.utils.GraphUtils;

	import com.kavalok.events.EventSender;
	
	public class DialogOkView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var colourSprite:Sprite;
		public var _twitText:String;
		private var _ok:EventSender = new EventSender();
		private var _Dcontent:MovieClip = null;
	
		public function DialogOkView(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false, twitterText:String = null, dialogColour:int = 0)
		{
			super(content || new DialogOk(), text, modal);
			_Dcontent = content;
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
			_twitText = twitterText;

		//	if(content == null)
			setDialogColor();
		
		}
		
		public function get ok():EventSender
		{
			return _ok;
		}
		
		protected function onOkClick(event:MouseEvent):void
		{
			hide();
			ok.sendEvent();
		}
		
		protected function onTwitterClick(e:MouseEvent):void
		{
			new AdminService().sendTweet(Global.charManager.userId, Global.charManager.accessToken, Global.charManager.accessTokenSecret, _twitText);
		}

		private function setDialogColor():void
		{
		//	var bName:String = colour.toString();
			//var bnamey:uint = uint("0x" + bName);
		//	var transformy:ColorTransform = new ColorTransform();//_content.dialogBg.colourSprite.transform.colorTransform
			trace(Global.charManager.uiColour);
			trace(Global.charManager.uiColour.toString(16));
			trace(Global.charManager.uiColourint);
		//	transformy.color = Global.charManager.uiColourint;
			if(_Dcontent == null){
			//colourSprite.transform.colorTransform = transformy;
			Global.applyUIColour(colourSprite);
			} else {
			try {
			Global.applyUIColour(_Dcontent.colourSprite);
			} catch (e:Error){
				trace("ERROR");
			}
			//_Dcontent.colourSprite.transform.colorTransform = transformy;
			}

		 }
			
		
	
	}
}