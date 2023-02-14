package com.kavalok.admin.magic
{
	import com.kavalok.admin.stuffs.StuffChooserBase;
	import com.kavalok.char.CharModels;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.utils.ReflectUtil;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.HSlider;
	import org.goverla.collections.ArrayList;

	public class CharModifiersBase extends MagicViewBase
	{
		static public const SCALE_MODIFIER:String = 'CharScaleModifier';
		static public const BODY_MODIFIER:String = 'CharBodyModifier';
		static public const CLOTHES_MODIFIER:String = 'CharClothesModifier';
		
		[Bindable] public var scaleSlider:HSlider;
		[Bindable] public var bodyCombo:ComboBox;
		[Bindable] public var bodies:ArrayList = new ArrayList(CharModels.BODIES);
		[Bindable] public var stuffChooser:StuffChooserBase;
		[Bindable] public var replaceClothesCheckBox:CheckBox;
		
		
		public function CharModifiersBase()
		{
			super();
		}
		
		public function applyScale():void
		{
			var state:Object = {scale: charScale}
			sendModifierState(SCALE_MODIFIER, state);
		}
		public function clearScale():void
		{
			clearModifierState(SCALE_MODIFIER);
		}
		
		public function applyBody():void
		{
			var state:Object = {body: charBody}
			sendModifierState(BODY_MODIFIER, state);
		}
		public function clearBody():void
		{
			clearModifierState(BODY_MODIFIER);
		}
		
		public function applyClothes():void
		{
			var item:StuffItemLightTO = new StuffItemLightTO();
			ReflectUtil.copyFieldsAndProperties(stuffChooser.item, item);
			item.color = stuffChooser.color;
			
			var state:Object = 
			{
				item: item,
				replaceCurrent: replaceClothesCheckBox.selected
			}
			sendModifierState(CLOTHES_MODIFIER, state);
		}
		public function clearClothes():void
		{
			clearModifierState(CLOTHES_MODIFIER);
		}
		
		public function get charScale():Number
		{
			return scaleSlider.value;
		}
		
		public function get charBody():String
		{
			return String(bodyCombo.selectedItem);
		}
		
	}
	
}