package
{
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.pets.PetConstructor;
	import com.kavalok.pets.PetItem;
	import com.kavalok.services.PetService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	
	public class Pets extends WindowModule
	{
		static private var _instance:Pets;
		
		private var _bundle:ResourceBundle = Localiztion.getBundle(Modules.PETS);
		private var _petItems:Array = [];
		
		override public function initialize():void
		{
			super.initialize();
			_instance = this;
			
			if (Global.petManager.pet)
			{
				readyEvent.sendEvent();
				closeModule();
				Dialogs.showOkDialog(_bundle.messages.petExists);
			}
			else
			{
				new PetService(onGetPetItems).getPetItems();
			}
		}
		
		private function onGetPetItems(result:Object):void
		{
			for each (var data:Object in result)
			{
				_petItems.push(new PetItem(data));
			}
			
			addChild(new PetConstructor().content);
			
			readyEvent.sendEvent();
		}
		
		public function getItems(placement:String):Array
		{
			return Arrays.getByRequirement(_petItems,
				new PropertyCompareRequirement('placement', placement));
		}
		
		public function getItemByName(name:String):PetItem
		{
			return Arrays.firstByRequirement(_petItems,
				new PropertyCompareRequirement('name', name)) as PetItem;
		}
		
		static public function get instance():Pets { return _instance; }
		
		public function get bundle():ResourceBundle { return _bundle; }
	}
	
}