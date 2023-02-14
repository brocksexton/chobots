package com.kavalok.admin.magic
{
	import mx.controls.RadioButtonGroup;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	/**
	 * ...
	 * @author Canab
	 */
	
	public class AdvancedColorBase extends MagicViewBase
	{
		static private const LOCATION_MODIFIER:String = 'LocationColorModifier';
		static private const BACKGROUND_MODIFIER:String = 'BackgroundColorModifier';
		static private const CHARS_MODIFIER:String = 'CharContainerColorModifier';
		
		[Bindable] public var locationColor:ColorControlBase;
		[Bindable] public var charsColor:ColorControlBase;
		[Bindable] public var targetRadioGroup:RadioButtonGroup;
		
		public function AdvancedColorBase()
		{
			super();
		}
		
		protected function applyLocationColor():void 
		{
			if (targetRadioGroup.selectedValue == 1)
				sendModifierState(LOCATION_MODIFIER, locationColor.colorInfo);
			else
				sendModifierState(BACKGROUND_MODIFIER, locationColor.colorInfo);
				
				
				new LogService().adminLog("Changed location color of " + remoteId, 1, "magic");
		}
		
		protected function resetLocationColor():void 
		{
			clearModifierState(LOCATION_MODIFIER);
			clearModifierState(BACKGROUND_MODIFIER);
			locationColor.reset();
			new LogService().adminLog("Reset location color of " + remoteId, 1, "magic");
		}
		
		protected function applyCharColor():void 
		{
			sendModifierState(CHARS_MODIFIER, charsColor.colorInfo);
			new LogService().adminLog("Changed chars color in " + remoteId, 1, "magic");
		}
		
		protected function resetCharColor():void 
		{
			clearModifierState(CHARS_MODIFIER);
			charsColor.reset();
		}
	}
	
}