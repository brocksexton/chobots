package org.goverla.dragdrop.common {

	public class DropAcceptance {
		
		private var _dropAccepted : Boolean = false;
		private var _errorMessage : String = null;
		
		public function DropAcceptance(dropAccepted : Boolean, errorMessage : String = "") {
			this._dropAccepted = dropAccepted;
			this._errorMessage = errorMessage;
		}
		
		public function get dropAccepted() : Boolean {
			return _dropAccepted;
		}
	
		public function get errorMessage() : String {
			return _errorMessage;
		}
		
		
		
	}
}