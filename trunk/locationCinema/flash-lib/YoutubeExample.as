package
{
    import flash.display.Sprite;
    
    public class YoutubeExample extends Sprite
    {
        private var webView:Sprite;
        
        public function YoutubeExample()
        {
            webView = new Sprite();
            webView.graphics.beginFill(0x000000);
            webView.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            webView.graphics.endFill();
            addChild(webView);
            
            var request:URLRequest = new URLRequest("https://www.youtube.com/embed/M7lc1UVf-VE?list=PLB_zuMqcN6UcON6MGd_oZ_zjG73FtrJc2&autoplay=1");
            navigateToURL(request, "_blank");
        }
    }
}
