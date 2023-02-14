package
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.RectangleSprite;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.ColorResourceSprite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.events.MouseEvent;
	
	import StarPremium;
	import StopSign;
	import McChatBubble;
	import CharWindowBackground;
	import McColorPicker;
	//import com.kavalok.CharWindowBackground;
	//import com.kavalok.McChatBubble;

	public class ItemViewer extends Sprite
	{
		public var citizenStar:StarPremium = new StarPremium;
		public var stopSign:StopSign = new StopSign;
		public var chatBubbles:McChatBubble = new McChatBubble;
		public var playercard:CharWindowBackground = new CharWindowBackground;
		//public var playercard:McCharWindow = new McCharWindow;
		public var colorPicker:McColorPicker;
		public var _stuff:ResourceSprite;
		private var readyEvent:EventSender = new EventSender();
		private var _model:Sprite;
		private var _loaderView:RectangleSprite;
		
		private var domain1:Array = loaderInfo.url.split("://");
		private var domain2:Array = domain1[1].split("/");
		private var domainOfSwf:String = domain2[0];
		private var currentColour:uint;
		private var bitmapData:BitmapData = new BitmapData(200,200); //A Bitmap Data object, the size is based on the color spectrum size
		private var colorTransform:ColorTransform = new ColorTransform();
		private var hexColor:*;
		
		public function ItemViewer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onLoaded);
		}
		
		private function onLoaded(e:Event = null) : void
		{
			if(domainOfSwf == "chobots.world") {
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				createView(); 
			} else {
				showSymbol(1)
			}
		}
		
		private function linkToPage(e:MouseEvent):void
		{
			var itemId:int = int(loaderInfo.parameters.itemId);
			var request:URLRequest = new URLRequest("/market/listItem?item="+itemId);
			navigateToURL(request);
		}
		
		private function showSymbol(number:int):void
		{
			this.addChild(stopSign);
			
			if(number > 1) { stopSign.gotoAndPlay(number); }
			
			this.width = this.height = stage.stageHeight*0.9; // CHANGE WIDTH TO MATCH HEIGHT
			this.x = (stage.stageWidth/2)-(this.width/2);  //POSITION IN MIDDLE
			this.y = (stage.stageHeight/2)-(this.height/2);  //POSITION IN MIDDLE
		}
		
		private function updateColorPicker(e:MouseEvent):void
		{
			hexColor = "0x" + bitmapData.getPixel(colorPicker.spectrum.mouseX,colorPicker.spectrum.mouseY).toString(16);
			colorTransform.color = hexColor;
			colorPicker.color.transform.colorTransform = colorTransform;
			currentColour = uint(bitmapData.getPixel(colorPicker.spectrum.mouseX,colorPicker.spectrum.mouseY))
		}
		
		private function setValue(e:MouseEvent):void
		{
			ExternalInterface.call("changeColor", currentColour);
			ExternalInterface.call("console.log", currentColour);
			removeChild(getChildByName("colorPicker"));
			createView()
		}
		
		private function loadColor(e:MouseEvent):void
		{
			removeChild(getChildByName("McStuff"));
			colorPicker = new McColorPicker;
			this.addChild(colorPicker);
			colorPicker.name = "colorPicker";
			colorPicker.width = this.width*0.9;
			colorPicker.height = this.height*0.9;
			this.width = this.height = stage.stageHeight*0.9;
			this.x = (stage.stageWidth/2)-(this.width/2); 
			this.y = (stage.stageHeight/2)-(this.height/2); 
			bitmapData.draw(colorPicker.spectrum);
			colorPicker.spectrum.addEventListener(MouseEvent.MOUSE_MOVE, updateColorPicker);
			colorPicker.spectrum.addEventListener(MouseEvent.MOUSE_UP, setValue);
		}
		
		private function createView():void
		{
			_loaderView = new RectangleSprite(this.width, this.width);
			_loaderView.suspendLayout();
			_loaderView.alpha = 0;
			_loaderView.resumeLayout();
			this.addChild(_loaderView);
			
			var itemName:String = loaderInfo.parameters.name;
			var itemType:String = loaderInfo.parameters.type;
			if(itemType == "bubble") {
				this.addChild(chatBubbles);
				chatBubbles.gotoAndStop(itemName);
				//chatBubbles.x = 7;
				//chatBubbles.y = 43.25; 
				chatBubbles.width = 174.1; 
				chatBubbles.height = 100; 
			} else if(itemType == "playercard") {
				this.addChild(playercard);
				playercard.gotoAndStop(itemName);
				playercard.width = this.width*0.95;
				playercard.height = this.height*0.95;
			} else {
				var color:int = int(loaderInfo.parameters.color);
				var citizen:int = int(loaderInfo.parameters.citizen);
				var itemIdCheck:int = int(loaderInfo.parameters.itemId);
				
				if(itemIdCheck) {
					this.addEventListener(MouseEvent.CLICK, linkToPage);
				}
				
				var url2:String = "/resources/clothes/"+itemName+".swf";
				if(loaderInfo.parameters.color) {
					if(currentColour) {
						color = currentColour;
					}
					var itemDisplayColor:ColorResourceSprite = new ColorResourceSprite(url2, "McStuff", color, true, true);
					itemDisplayColor.name = "McStuff";
					this.addChild(itemDisplayColor);
					if(loaderInfo.parameters.selectableColor) {
						this.addEventListener(MouseEvent.CLICK, loadColor);
					}
				} else {
					var itemDisplay2:ResourceSprite = new ResourceSprite(url2, "McStuff", true, true);
					this.addChild(itemDisplay2);
				}
				
				if(citizen == 1) { 
					this.addChild(citizenStar);
					citizenStar.width = 10
					citizenStar.height = 10
					citizenStar.x = 5
					citizenStar.y = 7
				}
			}
			
			this.width = this.height = stage.stageHeight*0.9;
			this.x = (stage.stageWidth/2)-(this.width/2);  //POSITION IN MIDDLE
			this.y = (stage.stageHeight/2)-(this.height/2);  //POSITION IN MIDDLE
		}
	}
}