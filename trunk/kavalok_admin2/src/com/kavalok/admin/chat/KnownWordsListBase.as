package com.kavalok.admin.chat
{
	import com.kavalok.admin.chat.data.WordsDataProvider;
	import com.kavalok.admin.chat.events.RemoveWordEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.TextInput;
	
	import org.goverla.utils.Arrays;
	import org.goverla.utils.comparing.PropertyCompareRequirement;

	public class KnownWordsListBase extends VBox
	{
		
		[Bindable]
		public var textInput : TextInput;

		[Bindable]
		public var minLength : int = 4;
		
		[Bindable]
		protected var dataProvider : WordsDataProvider;
		
		public function KnownWordsListBase()
		{
			super();
		}
		
		protected function addWord(word : String) : void {}
		protected function findWord(word : String) : void 
		{
			dataProvider.part = word;
		}
		internal function removeWord(id : int) : void {}
		
		
		protected function inList(word : String) : Boolean
		{
			return Arrays.containsByRequirement(dataProvider, new PropertyCompareRequirement("word", word.toLowerCase()));
		}
		
		protected function onFindClick(event : MouseEvent) : void 
		{
			findWord(textInput.text.toLowerCase());
		}
		protected function onAddClick(event : MouseEvent) : void
		{
			addWord(textInput.text.toLowerCase());
			textInput.text = "";
		}
		protected function onRemoveItem(event : RemoveWordEvent) : void
		{
			removeWord(event.word.id);
		}
		protected function onRemoveWord(result : int) : void
		{
			var req : PropertyCompareRequirement = new PropertyCompareRequirement("id", result);
			Arrays.removeByRequirement(dataProvider, req);
		}
		protected function onAddWord(result : Object) : void
		{
			dataProvider.list.addItem(result);
		}
	}
}