package com.kavalok.admin.admin
{
	import com.kavalok.Global;
	import com.kavalok.admin.log.data.UserChatDataProvider;
	import com.kavalok.admin.users.data.FilterConfig;
	import com.kavalok.admin.users.data.LocalizationConverter;
	import com.kavalok.admin.users.data.ServersDataProvider;
	import com.kavalok.admin.users.data.UsersDataProvider;
	import com.kavalok.admin.users.filters.BooleanFilter;
	import com.kavalok.admin.users.filters.FiltersList;
	import com.kavalok.admin.users.filters.NumberFilter;
	import com.kavalok.admin.users.filters.StringFilter;
	import com.kavalok.services.AdminService;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.UserTO;
	import com.kavalok.dto.admin.FilterTO;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.ListEvent;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.utils.Arrays;
	import org.goverla.utils.Strings;

	public class AdminConfigBase extends VBox
	{
		public var filtersList : FiltersList;
		public var usersDataGrid : DataGrid;
		
		[Bindable]
		public var permissionLevel : int;
		
		[Bindable]
		public var usernameInput : TextInput;
		
		[Bindable]
		public var passInput : TextInput;
		
		[Bindable]
		public var permissionInput : TextInput;
	
		
		public function AdminConfigBase()
		{
			super();
		}
		
       public function createAccount(e:MouseEvent) : void 
      {
	   var permissions:int = parseInt(permissionInput.text);
	  // new AdminService().createAdminAccount(usernameInput.text, passInput.text, permissions);
	
      }
	}
}