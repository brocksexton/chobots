package away3d.events
{
    import away3d.core.base.*;
    
    import flash.events.Event;
    
    /**
    * Passed as a parameter when a segment event occurs
    */
    public class SegmentEvent extends Event
    {
    	/**
    	 * Defines the value of the type property of a materialChanged event object.
    	 */
    	public static const MATERIAL_CHANGED:String = "materialChanged";
    	
    	/**
    	 * A reference to the segment object that is relevant to the event.
    	 */
        public var segment:Segment;
		
		/**
		 * Creates a new <code>SegmentEvent</code> object.
		 * 
		 * @param	type		The type of the event. Possible values are: <code>SegmentEvent.MATERIAL_CHANGED</code>.
		 * @param	segment		A reference to the segment object that is relevant to the event.
		 */
        public function SegmentEvent(type:String, segment:Segment)
        {
            super(type);
            this.segment = segment;
        }
		
		/**
		 * Creates a copy of the SegmentEvent object and sets the value of each property to match that of the original.
		 */
        public override function clone():Event
        {
            return new SegmentEvent(type, segment);
        }
    }
}
