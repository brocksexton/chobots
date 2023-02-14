package away3d.core.base
{
	/**
	 * Holds vertexposition information about a single animation frame.
	 */
    public class Frame implements IFrame
    {
    	private var _vertexposition:VertexPosition;
    	
    	/**
    	 * An array of vertex position objects.
    	 */
        public var vertexpositions:Array = [];
    	
		/**
		 * Creates a new <code>Frame</code> object.
		 */
        public function Frame()
        {
        }
        
		/**
		 * @inheritDoc
		 */
        public function adjust(k:Number = 1):void
        {
            for each (_vertexposition in vertexpositions) {
                _vertexposition.adjust(k);
            }
        }
    }
}
