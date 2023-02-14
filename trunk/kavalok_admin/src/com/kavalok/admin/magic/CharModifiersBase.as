package com.kavalok.admin.magic
{
	import com.kavalok.admin.stuffs.StuffChooserBase;
	import com.kavalok.char.CharModels;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.services.AdminService;
	import com.kavalok.location.commands.MoveToLocationCommand;
	//import com.kavalok.location.commands.AddModifierCommand;
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.Strings;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.HSlider;
	import mx.controls.TextInput;
	import org.goverla.collections.ArrayList;
	import com.kavalok.services.LogService;
	import flash.events.Event;

	public class CharModifiersBase extends MagicViewBase
	{
		static public const SCALE_MODIFIER:String = 'CharScaleModifier';
		static public const BODY_MODIFIER:String = 'CharBodyModifier';
		static public const CLOTHES_MODIFIER:String = 'CharClothesModifier';
		static public const ROT_MODIFIER:String = 'CharRotationModifier';
		static public const ALPHA_MODIFIER:String = 'CharAlphaModifier';

		[Bindable] public var scaleSlider:HSlider;
		[Bindable] public var rotationSlider:HSlider;
		[Bindable] public var alphaSlider:HSlider;
		[Bindable] public var bodyCombo:ComboBox;
		[Bindable] public var modCombo:ComboBox;
		[Bindable] public var bodies:ArrayList = new ArrayList(CharModels.BODIES);
		[Bindable] public var modifiers:ArrayList = new ArrayList(CharModels.MODIFIERS);
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
		public function applyAll():void
		{
			var stateS:Object = {scale: charScale}
			var stateR:Object = {rotation: charRotation}
			var stateA:Object = {alpha: charAlpha}

			sendModifierState(SCALE_MODIFIER, stateS);
			sendModifierState(ROT_MODIFIER, stateR);
			sendModifierState(ALPHA_MODIFIER, stateA);
		}
		public function applyRotation():void
		{
			var state:Object = {rotation: charRotation}
			sendModifierState(ROT_MODIFIER, state);
		}

		public function clearRotation():void
		{
			clearModifierState(ROT_MODIFIER);
			rotationSlider.value = 0;
		}

		public function clearAll():void
		{
			clearModifierState(ROT_MODIFIER);
			clearModifierState(ALPHA_MODIFIER);
			clearModifierState(SCALE_MODIFIER);
			scaleSlider.value = 1;
			rotationSlider.value = 0;
			alphaSlider.value = 1;
		}
		public function applyAlpha():void
		{
			var state:Object = {alpha: charAlpha}
			sendModifierState(ALPHA_MODIFIER, state);
		}

		public function clearAlpha():void
		{
			clearModifierState(ALPHA_MODIFIER);
			alphaSlider.value = 1;
		}
		public function clearScale():void
		{
			clearModifierState(SCALE_MODIFIER);
			scaleSlider.value = 1;
		}

		public function applyBody():void
		{
			var state:Object = {body: charBody}
			sendModifierState(BODY_MODIFIER, state);
			new LogService().adminLog("Applied body " + bodyCombo.selectedItem + " at " + remoteId, 1, "magic");
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
			new LogService().adminLog("Applied clothes " + stuffChooser.item.name + " at " + remoteId, 1, "magic");
		}
		public function clearClothes():void
		{
			clearModifierState(CLOTHES_MODIFIER);
		}

		public function get charScale():Number
		{
			return scaleSlider.value;
		}

		public function get charRotation():Number
		{
			return rotationSlider.value;
		}
		public function get charAlpha():Number
		{
			return alphaSlider.value;
		}

		public function get charBody():String
		{
			return String(bodyCombo.selectedItem);
		}


	}

}

