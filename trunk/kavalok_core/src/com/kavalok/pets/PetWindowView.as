package com.kavalok.pets
{
	import com.kavalok.Global;
	import com.kavalok.constants.BrowserConstants;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.pet.PetTO;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.Shops;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.gameplay.controls.ProgressBar;
	import com.kavalok.gameplay.frame.PagedStuffsView;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.pets.commands.DisposePetCommand;
	import com.kavalok.ui.Window;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class PetWindowView extends Window
	{
		static private const MODEL_SCALE:Number = 2;
		
		private var _pet:PetTO;
		private var _content:McPetWindow = new McPetWindow();
		private var _foodBar:ProgressBar = new ProgressBar(_content.foodBar);
		private var _healthBar:ProgressBar = new ProgressBar(_content.healthBar);
		private var _loyalityBar:ProgressBar = new ProgressBar(_content.loyalityBar);
		private var _bundle:ResourceBundle = Global.resourceBundles.pets;
		private var _stuffs:PagedStuffsView = new PagedStuffsView(_content.stuffsClip, 2, 3);
		private var _model:PetModel;
		private var _shops:Array = [Shops.PET_FOOD_SHOP, Shops.PET_GAME_SHOP, Shops.PET_REST_SHOP];
		private var _currentShop:String = null;
		
		static public function getWindowId(petId:int):String
		{
			return 'pet_' + String(petId);
		}
		
		public function PetWindowView(pet:PetTO)
		{
			_pet = pet;
			
			if (petManager.isMy(_pet))
				_pet = Global.petManager.pet;
				
			_content.stuffsClip.background.stop();
			_content.nameField.text = _pet.name;
			_stuffs.applyEvent.addListener(onStuffApply);
			
			super(_content);
			addListeners();
			initPanel();
			createModel();
			refresh();
		}
		
		private function initPanel():void
		{
			if (petManager.isMy(_pet))
			{
				initButton(panel.foodButton,	onFoodClick,	'toFeed', ResourceBundles.PETS);
				initButton(panel.sitButton,	onSitClick,	'sitPet', ResourceBundles.PETS);
				initButton(panel.standButton,	onSitClick,	'unsitPet', ResourceBundles.PETS);

				initButton(panel.playButton,	onPlayClick,	'toPlay', ResourceBundles.PETS);
				initButton(panel.healthButton,	onHealthClick,	'toRest', ResourceBundles.PETS);
				initButton(panel.takeButton,	onTakeClick,	'takePet', ResourceBundles.PETS);
				initButton(panel.leaveButton,	onLeaveClick,	'leavePet', ResourceBundles.PETS);
				initButton(panel.disposeButton,	onDisposeClick,	'disposePet', ResourceBundles.PETS);
				initButton(_content.helpButton,	onHelpClick,	'petRules', ResourceBundles.PETS);
			}
			else
			{
				panel.visible = false;
			}
		}
		
		private function onHelpClick(e:MouseEvent):void
		{
			navigateToURL(
				new URLRequest(Global.serverProperties.petHelpURL), BrowserConstants.BLANK);
		}
		
		private function onStuffApply(item:StuffItemLightTO):void
		{
			if (_currentShop == Shops.PET_FOOD_SHOP)
				Global.charManager.stuffs.removeItem(item);
				
			Global.petManager.doStuffAction(item);
			
			_currentShop = null;
			refresh();
		}
		
		private function onFoodClick(e:MouseEvent):void
		{
			_currentShop = Shops.PET_FOOD_SHOP;
			refreshItems();
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			_currentShop = Shops.PET_GAME_SHOP;
			refreshItems();
		}

		private function onHealthClick(e:MouseEvent):void
		{
			_currentShop = Shops.PET_REST_SHOP;
			refreshItems();
		}

		private function onTakeClick(e:MouseEvent):void
		{
			if (Global.charManager.isCitizen)
			{
				_pet.atHome = false;
				Global.petManager.update();
			}
			else
			{
				new CitizenWarningCommand("pet", null).execute()
			}
			
			refresh();
		}

		private function onLeaveClick(e:MouseEvent):void
		{
			_pet.atHome = true;
			Global.petManager.update();
			refresh();
		}

		private function onSitClick(e:MouseEvent):void
		{
			if(Global.charManager.isCitizen){
			_pet.sit = !_pet.sit;
			Global.petManager.update();
			refresh();
		}
		else
		{
			new CitizenWarningCommand("pet", null).execute();
		}
		
		}

		private function onDisposeClick(e:MouseEvent):void
		{
			new DisposePetCommand().execute();
		}
		
		private function createModel():void
		{
			_model = new PetModel(_pet);
			_model.scale = MODEL_SCALE;
			_model.setModel(PetModels.STAY);
			_content.addChild(_model);
			GraphUtils.setCoords(_model, _content.petPosition);
			GraphUtils.detachFromDisplay(_content.petPosition);
		}
		
		private function refresh():void
		{
			_foodBar.value = _pet.food / 100;
			_healthBar.value = _pet.health / 100;
			_loyalityBar.value = _pet.loyality / 100;
			
			_model.visible = _currentShop == null;
			_content.stuffsClip.visible = _currentShop != null;
			
			var atHome:Boolean = Global.locationManager.isOwnHome;
			
			panel.takeButton.visible = atHome && _pet.atHome;
			panel.leaveButton.visible = atHome && !_pet.atHome; 
			panel.sitButton.visible = !_pet.sit;
			panel.standButton.visible = _pet.sit;
			_content.ageField.text = "Age " +_pet.age;
			
			GraphUtils.setBtnEnabled(panel.foodButton, _currentShop != Shops.PET_FOOD_SHOP);
			GraphUtils.setBtnEnabled(panel.playButton, _currentShop != Shops.PET_GAME_SHOP);
			GraphUtils.setBtnEnabled(panel.healthButton, _currentShop != Shops.PET_REST_SHOP);
			
			_stuffs.applyEnabled = !Global.petManager.isBusy;

		}
		
		private function refreshItems():void
		{
			if (_currentShop)
			{
				_content.stuffsClip.gotoAndStop(_shops.indexOf(_currentShop) + 1);
				_stuffs.items = Global.charManager.stuffs.getByShop(_currentShop);
				
				for each (var viewItem:StuffSprite in _stuffs.viewItems)
				{
					var item:StuffItemLightTO = StuffItemLightTO(viewItem.item); 
					viewItem.enabled = (!item.premium || item.premium && Global.charManager.isCitizen);
				}
			}
				
			refresh();
		}
		
		private function onPetChange():void
		{
			if (!petManager.pet)
				closeWindow();
			else
				refresh();
		}
		
		private function addListeners():void
		{
			if (petManager.isMy(_pet))
			{
				petManager.refreshEvent.addListener(onPetChange);
				Global.locationManager.locationDestroy.addListener(closeWindow);
				Global.charManager.stuffs.refreshEvent.addListener(refreshItems);
				Global.charManager.citizenChangeEvent.addListener(refreshItems);
			}
		}
		
		override public function onClose():void
		{
			if (petManager.isMy(_pet))
			{
				petManager.refreshEvent.removeListener(onPetChange);
				Global.locationManager.locationDestroy.removeListener(closeWindow);
				Global.charManager.stuffs.refreshEvent.removeListener(refreshItems);
				Global.charManager.citizenChangeEvent.removeListener(refreshItems);
			}
		}
		
		override public function get windowId():String
		{
			return getWindowId(_pet.id);			
		}
		
		override public function get dragArea():InteractiveObject
		{
			return _content.headerButton;
		}
		
		override public function set alpha(value:Number):void
		{
			var items : Array = [_content.background, _content.buttonsPanel];
			for each(var object: DisplayObject in items)
			{
				object.alpha = value;
			}
		}
		
		public function get panel():McButtonsPanel
		{
			 return _content.buttonsPanel;
		}
		
		public function get petManager():PetManager
		{
			 return Global.petManager;
		}
		
	}
}