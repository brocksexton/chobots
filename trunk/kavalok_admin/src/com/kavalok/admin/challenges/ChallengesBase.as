package com.kavalok.admin.challenges
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

	public class NewsBase extends VBox
	{
		[Bindable] public var image1input : TextInput;
		[Bindable] public var image2input : TextInput;
		[Bindable] public var image3input : TextInput;
		[Bindable] public var image4input : TextInput;
		[Bindable] public var event1input : TextInput;
		[Bindable] public var event2input : TextInput;
		[Bindable] public var event3input : TextInput;
			[Bindable] public var featuredUserInput : TextInput;
		[Bindable] public var event4input : TextInput;
		[Bindable] public var date1input : TextInput;
		[Bindable] public var date2input : TextInput;
		[Bindable] public var date3input : TextInput;
		[Bindable] public var date4input : TextInput;

		[Bindable] protected var changed : Boolean = false;

		private var challengesDates:Array = new Array();
		private var challengesImages:Array = new Array();
		private var challengesInfo:Array = new Array();
		private var featuredChar:Array = new Array();

		public function NewsBase()
		{
			super();
			new AdminService(gotNews).getNews();
		}

		private function gotNews(result:Array):void
		{
				for each(var challenges:Object in result)
				{
					challengesDates.push(challenges.dates.toString());
					challengesInfo.push(challenges.info.toString());
					challengesImages.push(challenges.image.toString());
					featuredChar.push(challenges.charName.toString());
					
				}
				featuredUserInput.text = featuredChar[0].toString();
				date1input.text = challengesDates[0].toString();
				date2input.text = challengesDates[1].toString();
				date3input.text = challengesDates[2].toString();
				date4input.text = challengesDates[3].toString();
				event1input.text = newsInfo[0].toString();
				event2input.text = newsInfo[1].toString();
				event3input.text = newsInfo[2].toString();
				event4input.text = newsInfo[3].toString();
				image1input.text = newsImages[0].toString();
				image2input.text = newsImages[1].toString();
				image3input.text = newsImages[2].toString();
				image4input.text = newsImages[3].toString();
				Alert.show("got it + " + newsDates[0].toString());
		}

		public function onSaveNewsClick(e:MouseEvent):void
		{
			new AdminService().saveNews(date1input.text, date2input.text, date3input.text, date4input.text, event1input.text, event2input.text, event3input.text, event4input.text, image1input.text, image2input.text, image3input.text, image4input.text, featuredUserInput.text);
		}

		}
	}