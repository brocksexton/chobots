package away3d.core.draw
{
    import away3d.core.base.*;
    import away3d.core.render.*;
    
    import flash.display.DisplayObject;
	
	/**
	 * Displayobject container drawing primitive.
	 */
    public class DrawDisplayObject extends DrawPrimitive
    {
    	/**
    	 * The screenvertex used to position the drawing primitive in the view.
    	 */
        public var screenvertex:ScreenVertex;
        
    	/**
    	 * A reference to the displayobject used by the drawing primitive.
    	 */
        public var displayobject:DisplayObject;
        
    	/**
    	 * A reference to the session used by the drawing primitive.
    	 */
        public var session:AbstractRenderSession;
        
		/**
		 * @inheritDoc
		 */
        public override function calc():void
        {
            screenZ = screenvertex.z;
            minZ = screenZ;
            maxZ = screenZ;
            minX = screenvertex.x - displayobject.width/2;
            minY = screenvertex.y - displayobject.height/2;
            maxX = screenvertex.x + displayobject.width/2;
            maxY = screenvertex.y + displayobject.height/2;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function clear():void
        {
            displayobject = null;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function render():void
        {
            displayobject.x = screenvertex.x;// - displayobject.width/2;
            displayobject.y = screenvertex.y;// - displayobject.height/2;
            session.addDisplayObject(displayobject);
        }
		
		//TODO: correct function for contains in DrawDisplayObject
		/**
		 * @inheritDoc
		 */
        public override function contains(x:Number, y:Number):Boolean
        {   
            return true;
        }
    }
}
