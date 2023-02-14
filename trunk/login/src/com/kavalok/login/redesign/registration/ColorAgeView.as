package com.kavalok.login.redesign.registration
{
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.gameplay.controls.ToggleButton;
	import com.kavalok.gameplay.controls.ToggleButtonsGroup;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.PrefixRequirement;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ColorAgeView extends WizardViewBase
	{
		private static const MODEL_PREFIX : String = "chobot_";
		private var _content : McSelectColor;
		private var _ageGroup : ToggleButtonsGroup = new ToggleButtonsGroup();
		private var _colorGroup : ToggleButtonsGroup = new ToggleButtonsGroup();
		private var _nextButton : EnabledButton;
		
		private var _modelTypes:Object = {
			body1: { classRef:chobot_body1, color: 0xFFCC00},
			body2: { classRef:chobot_body2, color: 0xFF9900},
			body3: { classRef:chobot_body3, color: 0xFF0000},
			body4: { classRef:chobot_body4, color: 0xFF66FF},
			body5: { classRef:chobot_body5, color: 0x9900FF},
			body6: { classRef:chobot_body6, color: 0x5FBEFE},
			body7: { classRef:chobot_body7, color: 0x0033FF},
			body9: { classRef:chobot_body9, color: 0x01BA01},
			body10: { classRef:chobot_body10, color: 0xB13501}
			//body11: { classRef:chobot_body11, color: 0xFFC287}
		};
		//	body8: { classRef:chobot_body8, color: 0x32BCBB},
		
		public function ColorAgeView(content:McSelectColor)
		{
			_content = content;
			GraphUtils.removeChildren(_content.modelContainer);
			super(content);
			_nextButton = new EnabledButton(_content.nextButton);
			_nextButton.enabled = false;
			_content.nextButton.addEventListener(MouseEvent.CLICK, nextEvent.sendEvent);
			_content.backButton.addEventListener(MouseEvent.CLICK, backEvent.sendEvent);
			new EnabledButton(_content.backButton);
			
			//_content.boySelect.visible = false;
			//_content.girlSelect.visible = false;
			//_content.genders.visible = false;
			_content.colors.visible = false;
			var ageButtons : Array = GraphUtils.getAllChildren(_content, new PrefixRequirement("name", "age"));
			var button : MovieClip;
			var toggleButton : ToggleButton;
			for each(button in ageButtons)
			{
				toggleButton = new ToggleButton(button);
				_ageGroup.add(toggleButton);
			}
			_content.age0.addEventListener(MouseEvent.CLICK, onChildClick);
			_content.age1.addEventListener(MouseEvent.CLICK, onChildClick);
			_content.age2.addEventListener(MouseEvent.CLICK, onJuniorClick);
			_content.age3.addEventListener(MouseEvent.CLICK, onAdultClick);
		//	data.gender = "boy";
		//	_content.genders.boy.addEventListener(MouseEvent.CLICK, onBoyClick);
		//	_content.genders.girl.addEventListener(MouseEvent.CLICK, onGirlClick);
			var colorButtons : Array = GraphUtils.getAllChildren(_content.colors, new PrefixRequirement("name", "body"));
			for each(button in colorButtons)
			{
				toggleButton = new ToggleButton(button);
				_colorGroup.add(toggleButton);
				button.addEventListener(MouseEvent.CLICK, onColorClick);
			}
		}
		
		private function onColorClick(event : MouseEvent) : void
		{
			_colorGroup.selectedMovie = MovieClip(event.target);
			data.color = _modelTypes[MovieClip(event.target).name].color;
			
			var type : Class = _modelTypes[MovieClip(event.target).name].classRef;
			GraphUtils.removeChildren(_content.modelContainer);
			
			_content.modelContainer.addChild(new type());
			_nextButton.enabled = true;
		}
		
			private function onBoyClick(event : MouseEvent) : void
			{
				data.gender = "boy";
			//	_content.boySelect.visible=true;
			//	_content.girlSelect.visible=false;
			//	_content.colors.visible = true;
			}
		
					private function onGirlClick(event : MouseEvent) : void
					{
						data.gender = "girl";
						//_content.boySelect.visible=false;
						//_content.girlSelect.visible=true;
						//_content.colors.visible = true;
					}
		
		private function onChildClick(event : MouseEvent) : void
		{
			_content.colors.visible = true;
			data.isParent = false;
			data.hasEmail = false;
			_ageGroup.selectedMovie = MovieClip(event.target);
		}
		private function onJuniorClick(event : MouseEvent) : void
		{
			_content.colors.visible = true;
			data.isParent = false;
			data.hasEmail = true;
			_ageGroup.selectedMovie = MovieClip(event.target);
		}
		private function onAdultClick(event : MouseEvent) : void
		{
			_content.colors.visible = true;
			data.isParent = true;
			data.hasEmail = true;
			_ageGroup.selectedMovie = MovieClip(event.target);
		}
		
	}
}