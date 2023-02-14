package com.kavalok.dialogs
{
	import com.kavalok.utils.ResourceScanner;
	
	import flash.events.MouseEvent;

	public class DialogInviteFriend extends DialogOkView
	{
		private var _content : McInviteDialog;
		public function DialogInviteFriend()
		{
			_content = new McInviteDialog();
			super(null, true, _content);
			new ResourceScanner().apply(content);
			_content.closeButton.addEventListener(MouseEvent.CLICK, onOkClick);
		}
		
	}
}