package com.kavalok.admin.chat.commands
{
	import com.kavalok.admin.chat.data.WordData;
	
	import org.goverla.interfaces.ICommand;
	import com.kavalok.remoting.BaseDelegate;

	public class WordCommandBase implements ICommand
	{
		protected var wordData : WordData;
		
		public function WordCommandBase(wordData : WordData)
		{
			this.wordData = wordData;
		}

		public function execute():void
		{
			wordData.enabled = false;
		}
		
		protected function onResult(result : Object) : void
		{
			wordData.enabled = true;
		}

		protected function onFault(fault : Object) : void
		{
			wordData.enabled = true;
			BaseDelegate.defaultFaultHandler(fault);
		}
		
	}
}