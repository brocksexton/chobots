package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.commands.AllowWordCommand;
	import com.kavalok.admin.chat.commands.BlockChatCommand;
	import com.kavalok.admin.chat.commands.BlockWordCommand;
	import com.kavalok.admin.chat.commands.SkipWordCommand;
	import com.kavalok.admin.chat.commands.RemoveReviewCommand;
	import com.kavalok.admin.chat.data.WordData;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;

	public class BadWordItemBase extends HBox
	{
		public function BadWordItemBase()
		{
			super();
		}
		
		protected function onBlockClick(event : MouseEvent) : void
		{
			new BlockWordCommand(WordData(data)).execute();
		}
		protected function onSkipClick(event : MouseEvent) : void
		{
			new SkipWordCommand(WordData(data)).execute();
		}
		protected function onAllowClick(event : MouseEvent) : void
		{
			new AllowWordCommand(WordData(data)).execute();
		}
		protected function onBlockUserClick(event : MouseEvent) : void
		{
			new BlockChatCommand(WordData(data)).execute();
		}
		protected function onRemoveClick(event : MouseEvent) : void
		{
			new RemoveReviewCommand(WordData(data)).execute();
		}
		
	}
}