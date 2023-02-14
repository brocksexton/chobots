package org.goverla.remoting.common {

	import mx.rpc.IResponder;
	
	import org.goverla.errors.ResponderError;
	
	public class Responder implements IResponder {
		
		public static var defaultResultHandler : Function;
		
		public static var defaultFaultHandler : Function;
		
		public function Responder(resultHandler : Function, faultHandler : Function) {
			_resultHandler = (resultHandler != null ? resultHandler : defaultResultHandler);
			_faultHandler = (faultHandler != null ?  faultHandler : defaultFaultHandler);
		}
		
		public function result(data : Object):void {
			execute(_resultHandler, data);
		}
		
		public function fault(info : Object):void	{
			execute(_faultHandler, info);
		}
		
		private function execute(handler : Function, argument : Object) : void {
			if(handler == null) {
				throw new ResponderError("No handler defined.");
			}	
			handler(argument);		
		}
		
		private var _resultHandler : Function;

		private var _faultHandler : Function;
		
	}

}