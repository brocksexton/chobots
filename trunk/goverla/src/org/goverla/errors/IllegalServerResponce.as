package org.goverla.errors {

	public class IllegalServerResponce extends Error {

		public function IllegalServerResponce(message : String, responce : Object) {
		    this.responce = responce;
			super(message);
		}
		
    	public var responce : Object;

	}
	
}