package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.services.CharService;
	
	public class MiniCardsView extends MiniBagView
	{
		public function MiniCardsView()
		{
			_rowCount = 1; 
			_colCount = 3;
			
			super(); 
		}
		
		override protected function getItems():Array
		{
			var items:Array = Global.charManager.stuffs.getCards();
			items.sortOn('id', Array.NUMERIC | Array.DESCENDING); 
			return items;
		}
		
		override protected function apply(item:StuffItemLightTO):void
		{
			Global.charManager.playerCard = item;
		}
		
		override protected function removeit(item:StuffItemLightTO) : void
		{
			if(Global.charManager.playerCard == item)
			{
				//Dialogs.showOkDialog("Unequip this card before deleting.");
				Global.charManager.playerCard = null;
			}
			Global.charManager.stuffs.deleteItem(item);
			new AddMoneyCommand(item.backPrice, "recycle " + item.fileName, false, null, false).execute();
		}
	}
}