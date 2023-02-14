package away3d.loaders
{
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.events.*;
	
	import flash.events.EventDispatcher;
	
	public class AbstractParser extends EventDispatcher
	{
		use namespace arcane;
		/** @private */
    	arcane var _totalChunks:int = 0;
        /** @private */
    	arcane var _parsedChunks:int = 0;
		/** @private */
    	arcane var _parsesuccess:ParserEvent;
		/** @private */
    	arcane var _parseerror:ParserEvent;
		/** @private */
    	arcane var _parseprogress:ParserEvent;
		/** @private */
    	arcane function notifyProgress():void
		{
			if (!_parseprogress)
        		_parseprogress = new ParserEvent(ParserEvent.PARSE_PROGRESS, this, container);
        	
        	dispatchEvent(_parseprogress);
		}
		/** @private */
    	arcane function notifySuccess():void
		{
			if (!_parsesuccess)
        		_parsesuccess = new ParserEvent(ParserEvent.PARSE_SUCCESS, this, container);
        	
        	dispatchEvent(_parsesuccess);
		}
		/** @private */
    	arcane function notifyError():void
		{
			if (!_parseerror)
        		_parseerror = new ParserEvent(ParserEvent.PARSE_ERROR, this, container);
        	
        	dispatchEvent(_parseerror);
		}
		
        /**
        * 3d container object used for storing the parsed 3ds object.
        */
		public var container:Object3D;
		
    	/**
    	 * Returns the total number of data chunks parsed
    	 */
		public function get parsedChunks():int
		{
			return _parsedChunks;
		}
    	
    	/**
    	 * Returns the total number of data chunks available
    	 */
		public function get totalChunks():int
		{
			return _totalChunks;
		}
        
		/**
		 * Processes the next chunk in the parser
		 */
		public function parseNext():void
        {
        	notifySuccess();
        }
	}
}