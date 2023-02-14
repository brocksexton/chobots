package away3d.primitives
{
    import away3d.core.base.*;
    import away3d.core.utils.*;
    
    import flash.display.*;
    
    /**
    * Creates a 3d cube primitive with the Away3d logo.
    */ 
    public class LogoCube extends Cube
    {
		
		/**
		 * Creates a new <code>LogoCube</code> object.
		 *
		 * @param	init			[optional]	An initialisation object for specifying default instance properties.
		 */
        public function LogoCube(init:Object = null)
        {
            super(init);
            
            var sprite:Sprite = new Sprite();
            var graphics:Graphics = sprite.graphics;

            graphics.lineStyle(1, 0xFF00FF);
            graphics.drawRect(0, 0, 400, 400);
            graphics.endFill();

            graphics.lineStyle();
            graphics.beginFill(0x0000FF);
            graphics.moveTo(185, 48);
            graphics.lineTo(47, 325);
            graphics.lineTo(285, 325);
            graphics.lineTo(268, 295);
            graphics.lineTo(98, 295);
            graphics.lineTo(219, 48);
            graphics.endFill();

            material = Cast.material(sprite);
			
			type = "LogoCube";
        	url = "primitive";
        }
    }
    
}