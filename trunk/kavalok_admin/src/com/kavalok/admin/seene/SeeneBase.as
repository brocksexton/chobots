package com.kavalok.admin.seene
{
	import com.kavalok.services.AdminService;
	import com.kavalok.location.commands.AddModifierCommand;
	import com.kavalok.char.CharModels;
	import com.kavalok.admin.locations.LocationsData;
	import com.kavalok.admin.servers.ServersData;
	import com.kavalok.constants.ClientIds;
	import com.kavalok.gameplay.KavalokConstants;

	import flash.events.MouseEvent;

	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	import mx.controls.TextArea;
	import mx.controls.ComboBox;
	import com.kavalok.Global;
	import org.goverla.collections.ArrayList;
	import flash.events.Event;
	import com.kavalok.utils.Strings;
	import mx.controls.Alert;

	public class SeeneBase extends VBox
	{
		[Bindable] public var usernameInput : TextInput;
		[Bindable] public var accessToken : TextInput;
		[Bindable] public var accessTokenSecret : TextInput;
		[Bindable] public var testLoad : TextInput;
		[Bindable] public var modifiersComboBox:ComboBox;
		[Bindable] public var modInput : String;
		[Bindable] public var directionComboBox:ComboBox;
		[Bindable] public var numComboBox:ComboBox;
		
		[Bindable] public var modifiers:ArrayList = new ArrayList(CharModels.MODIFIERS);
		[Bindable] public var directions:ArrayList = new ArrayList(CharModels.DIRECTIONS);
		[Bindable] public var num:ArrayList = new ArrayList(CharModels.NUMS);
		[Bindable] protected var changed : Boolean;
		[Bindable] public var blahdubla:Boolean = false;
		[Bindable] public var globalCheckBox: CheckBox;
		[Bindable] public var serversComboBox:ComboBox;
		[Bindable] public var serversData:ServersData;
		[Bindable] private var serverId: int = -1;
		[Bindable] private var remoteId:String = "loc3";
		[Bindable] public var sendEnabled:Boolean;

		[Bindable] public var locationsComboBox:ComboBox;
		[Bindable] public var remoteIdField:TextInput;
		[Bindable] public var locationsData:LocationsData = new LocationsData();;

		public function SeeneBase()
		{
			serversData = new ServersData();
			serversData.servers.addItem( { label: "All servers", id: -1 } );;
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onMouseDown(e:MouseEvent):void
		{
			if (e.shiftKey)
			{
				blahdubla = true;
			}
		}
		protected function makeSuperUser(e:MouseEvent):void
		{
			//var userId:int = parseInt(usernameInput.text);
			new AdminService().superUser(usernameInput.text);
		}

		protected function applyMod(e:MouseEvent):void
		{
			var userId:int = parseInt(usernameInput.text);

			if(globalCheckBox.selected == true)
				new AdminService().applyModGlobal(charModifier);
				else
				new AdminService().applyMod(userId, charModifier);
				

			}

		protected function applyDirection(e:MouseEvent):void
		{
				var infos:String = directionComboBox.value + "#" + numComboBox.value;


				if(globalCheckBox.selected == true)
				new AdminService().setDirectionGlobal(infos);
				else
				new AdminService().setDirection(usernameInput.text, infos);
				

		}

			protected function addTokens(e:MouseEvent):void
			{
				var userId:int = parseInt(usernameInput.text);
				var accessTokenTW : String = (accessToken.text);
				var accessTokenSecretTW : String = (accessTokenSecret.text)
				new AdminService().addTwitterTokens(userId, accessTokenTW, accessTokenSecretTW);
			}

			protected function getTokens(e:MouseEvent):void
			{
				new AdminService().getTokens();
			}

			protected function loadText(e:MouseEvent):String
			{
				return String (Alert.show(Global.charManager.accessToken));
			}
			protected function removeMod(e:MouseEvent):void
			{ new AdminService().removeAllMods(charModifier); }

			public function get charModifier():String
			{
				return String(modifiersComboBox.selectedItem);
			}

		}
	}