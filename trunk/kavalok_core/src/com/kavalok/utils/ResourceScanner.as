package com.kavalok.utils
{
	import com.kavalok.localization.Localiztion;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ResourceScanner
	{
		static private const PREFIX:String = 'res_';
		
		public function ResourceScanner()
		{
		}
		
		public function apply(content:Sprite):void
		{
			var children:Array = GraphUtils.getAllChildren(content);
			
			for each (var child:DisplayObject in children)
			{
				if (child is TextField)
				{
					registerTextField(child as TextField);
				}
				else if (child is SimpleButton)
				{
					registerButton(child as SimpleButton);
					
				}	
			}
		}
		
		private function registerButton(button:SimpleButton):void
		{
			var states : Array = [button.upState, button.downState, button.overState];
			for each(var state:DisplayObject in states)
			{
				if (state is TextField)
				{
					registerButtonField(state as TextField)
				}
				else
				{
					if (state is DisplayObjectContainer)
					{
						var children:Array =  GraphUtils.getAllChildren(DisplayObjectContainer(state));
						for each (var child:DisplayObject in children)
						{
							if(child is TextField)
								registerButtonField(child as TextField);
						}
					}
				}
				

			}
		}
		
		private function registerButtonField(textField:TextField) : void 
		{
			if (textField && textField.text.indexOf("_") != -1)
			{
				var parts : Array = textField.text.split("_");
				Localiztion.getBundle(Strings.trim(parts[0])).registerTextField(textField, Strings.trim(parts[1]));
			}
		}
		
		private function registerTextField(field:TextField):void
		{
			if (field.name.indexOf(PREFIX) == 0)
			{
				var bundle:String = getBundle(field.name);
				Localiztion.getBundle(bundle).registerTextField(field); 
			}
		}
		
		private function getBundle(text : String) : String
		{
			return Strings.trim(text.substr(PREFIX.length));
		}

	}
}