package com.kavalok.gameplay.competitions
{
	import com.kavalok.Global;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.CompetitionResultTO;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.layout.VBoxLayout;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.TimeUtils;

	public class ScoreBoardView extends FlashViewBase
	{
		private static const TIME_FORMAT : String = "{0}.{1}.{2} {3}:{4}";
		private static var bundle : ResourceBundle = Localiztion.getBundle(ResourceBundles.COMPETITIONS);
		private var _content : McScoreBoard;
		private var _layout : VBoxLayout;
		private var _name : String;
		
		public function ScoreBoardView(name : String)
		{
			_content = new McScoreBoard();
			super(_content);
			clear();
			_layout = new VBoxLayout(_content.scores);
			_layout.margin = 4;
			bundle.registerTextField(_content.competitionNameField, name);
		}
		
		public function refresh(list : Array) : void
		{
			clear();
			var userResult : CompetitionResultTO = list.pop();
			var date : Date = userResult.finish;

			_content.finishTimeField.text = Strings.substitute(bundle.getMessage("finishTime"),
				date.monthUTC + 1, date.dateUTC, date.fullYearUTC, date.hoursUTC, TimeUtils.getTimeSubstring(date.minutesUTC));
			
			_content.nameField.text = Global.charManager.charId;
			_content.scoreField.text = userResult.score.toFixed(2);


			
			for(var i : int = 0; i < list.length; i++)
			{
				var resultTO : CompetitionResultTO = list[i];
				var item : McCompetitionItem = new McCompetitionItem();
				item.placeField.text = (i + 1).toString();
	
				if(resultTO.login == Global.charManager.charId)
					item.nameField.htmlText = "<b><u>" + resultTO.login;
				else
					item.nameField.text = resultTO.login;
	
				item.scoreField.text = resultTO.score.toFixed(2);
				_content.scores.addChild(item);
			}
			_layout.apply();
		}
		
		private function clear() : void
		{
			_content.finishTimeField.text = "";
			_content.nameField.text = "";
			_content.scoreField.text = "";

			GraphUtils.removeAllChildren(_content.scores);
		}
		
	}
}