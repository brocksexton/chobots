package banner_lebronjr23_250_250_fla 
{
	import flash.accessibility.*;
	import flash.display.*;
	import flash.errors.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.text.ime.*;
	import flash.ui.*;
	import flash.utils.*;
	
	public dynamic class Sprite63_1 extends flash.display.MovieClip
	{
		public function Sprite63_1()
		{
			super();
			addFrameScript(0, this.frame1);
			return;
		}

		public function fl_ClickToGoToWebPage(arg1:flash.events.MouseEvent):void
		{
			navigateToURL(new URLRequest("http://Chobots.net"), "_blank");
			return;
		}

		function frame1():*
		{
			this.loadBtn.addEventListener(MouseEvent.CLICK, this.fl_ClickToGoToWebPage);
			return;
		}

		public var loadBtn:flash.display.SimpleButton;

		public var mcOverAnimation:PlayGuitarRock;

		public var movieClip_1:flash.display.MovieClip;

		public var palm_1:flash.display.MovieClip;
	}
}
