package {
	
	import com.kavalok.Global;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.telescop.EarthScene;
	import com.kavalok.text.TextPlayer;
	
	import flash.events.MouseEvent;
	

	public class Telescop extends LocationModule
	{
		
		private static const bundle : ResourceBundle = Localiztion.getBundle("telescop");
		
		private var _foreground : Foreground;
		private var _scene : EarthScene;
		public function Telescop()
		{
		}
		
		override public function initialize():void
		{
			var background : Background = new Background();
			addChild(background);
			_scene = new EarthScene();
			addChild(_scene);
			_scene.init();
			background.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			
			_foreground = new Foreground();
			addChild(_foreground);
			_foreground.earthField.text = "";
			_foreground.moonField.text = "";
			var earthTextPlayer : TextPlayer = new TextPlayer(_foreground.earthField);
			earthTextPlayer.finish.addListener(onEarthTextEnd);
			earthTextPlayer.play(bundle.messages.aboutEarth || "");
			readyEvent.sendEvent();
		}
		
		private function onEarthTextEnd() : void
		{
			var moonTextPlayer : TextPlayer = new TextPlayer(_foreground.moonField);
			moonTextPlayer.play(bundle.messages.aboutMoon || "");
		}
		
		private function onCloseClick(event : MouseEvent) : void
		{
			_scene.destroy();
			closeModule();
			Global.locationManager.returnToPrevLoc();
		}
	}
}
