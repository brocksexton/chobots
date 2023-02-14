package com.kavalok.admin.servers
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	
	import mx.utils.StringUtil;
	
	import org.goverla.collections.ArrayList;
	
	public class modData
	{
		private var bundle : ResourceBundle = Localiztion.getBundle(ResourceBundles.MOD_SELECT);

		[Bindable]
		public var modifiers : ArrayList = new ArrayList();
		
		public function modData()
		{
			refresh();
		}

		public function refresh() : void
		{
			modifiers = new ArrayList();
		}
		
		private function onGetServers(result : Array) : void
		{
			modifiers.addItems(result);
		}

		private function getLabel(server : Object) : String
		{
			var name : String = bundle.messages[modifiers.name] || modifiers.name;
			return StringUtil.substitute("\nname: {1}", name);
		}
		
	}
}