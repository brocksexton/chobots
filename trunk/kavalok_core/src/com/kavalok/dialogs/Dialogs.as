package com.kavalok.dialogs{	import com.kavalok.Global;	import com.kavalok.char.Char;	import com.kavalok.char.CharModel;	import com.kavalok.char.CharModels;	import com.kavalok.char.Directions;	import com.kavalok.gameplay.KavalokConstants;	import com.kavalok.games.McChar;	import com.kavalok.games.McFinishScreen;	import com.kavalok.utils.GraphUtils;	import com.kavalok.utils.ResourceScanner;	import com.kavalok.dto.stuff.StuffItemLightTO;		import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.display.Sprite;		//COMMENT		public class Dialogs	{		private static const MAX_PLAYERS:uint = 5;				public static var BUY_ACCOUNT_OPENED:Boolean = false;				public static function showBuyAccountDialog(source:String):DialogBuyAccount		{			BUY_ACCOUNT_OPENED = true;			return DialogBuyAccount(showDialog(new DialogBuyAccount(source, true), false));		}				public static function showInviteDialog():DialogInviteFriend		{			return DialogInviteFriend(showDialog(new DialogInviteFriend()));		}				public static function showProlongAccountDialog(source:String):DialogProlongAccount		{			BUY_ACCOUNT_OPENED = true;			return DialogProlongAccount(showDialog(new DialogProlongAccount(source, true), false));		}				public static function showCitizenStatusDialog(source:String, modal:Boolean = true):DialogCitizenStatus		{			BUY_ACCOUNT_OPENED = true;			return DialogCitizenStatus(showDialog(new DialogCitizenStatus(source, modal), false));		}				/*public static function showCitizenDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogCitizenStatus		{			BUY_ACCOUNT_OPENED = true;			return DialogCitizenStatus(showDialog(new DialogCitizenStatus(source, modal), false));		}*/				public static function showMusicDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogMusicView		{			return DialogMusicView(showDialog(new DialogMusicView(text, okVisible, content, modal)));		}				public static function showOkDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true, twitterText:String = null, dialogColour:int = 0):DialogOkView		{			return DialogOkView(showDialog(new DialogOkView(text, okVisible, content, modal, twitterText, dialogColour)));		}		public static function showMarketSellDialog(itemId:int):DialogMarketSellView		{			return DialogMarketSellView(showDialog(new DialogMarketSellView(itemId)));		}				public static function showMarketDialog(text:String = null, modal:Boolean = true):DialogMarketView		{			return DialogMarketView(showDialog(new DialogMarketView(text, modal)));		}				public static function showLottoDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogLottoView		{			return DialogLottoView(showDialog(new DialogLottoView(text, okVisible, content, modal)));		}		public static function showBugsDialog(text:String, modal:Boolean = true):DialogBugsView		{			return DialogBugsView(showDialog(new DialogBugsView(text, modal)));		}		public static function showDailyDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogDailyView		{			return DialogDailyView(showDialog(new DialogDailyView(text, okVisible, content, modal)));		}				public static function showErrorDialog(text:String = null, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogErrorView		{			return DialogErrorView(showDialog(new DialogErrorView(text, okVisible, content, modal)));		}		public static function showBadgesDialog(charId:int, text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogBadgesView		{			return DialogBadgesView(showDialog(new DialogBadgesView(charId, text, okVisible, content, modal)));		}				public static function showPanelDialog(text:String = null, modal:Boolean = true) : DialogPanelView		{			return DialogPanelView(showDialog(new DialogPanelView(text,modal)));		}				public static function showBankDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogBankView		{			return DialogBankView(showDialog(new DialogBankView(text, okVisible, content, modal)));		}				public static function showSendTweetDialog(tweetMsg:String = null, text:String = null, modal:Boolean = true):DialogSendTweetView		{			return DialogSendTweetView(showDialog(new DialogSendTweetView(tweetMsg, text, modal)));		}				public static function showLongTextMessageDialog(text:String = null, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogLongTextView		{			return DialogLongTextView(showDialog(new DialogLongTextView(text, okVisible, content, modal)));		}				public static function showModMsgDialog(msgType:String, text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogModMsgView		{			return DialogModMsgView(showDialog(new DialogModMsgView(msgType, text, okVisible, content, modal)));		}				public static function showYesNoDialog(text:String = null, modal:Boolean = true):DialogYesNoView		{			return DialogYesNoView(showDialog(new DialogYesNoView(text, modal)));		}				public static function showGirlBoyDialog(text:String = null, modal:Boolean = true):DialogGirlBoyView		{			return DialogGirlBoyView(showDialog(new DialogGirlBoyView(text, modal)));		}			public static function showAgentRulesDialog(text:String = null, modal:Boolean = true):DialogAgentRulesView		{			return DialogAgentRulesView(showDialog(new DialogAgentRulesView(text, modal)));		}		public static function showModeratorDialog(text:String = null, modal:Boolean = true):DialogModeratorView		{			return DialogModeratorView(showDialog(new DialogModeratorView(text, modal)));		}				public static function showEmailDialog(text:String = null, modal:Boolean = true):DialogEmailView		{			return DialogEmailView(showDialog(new DialogEmailView(text, modal)));		}				public static function showExperienceDialog(text:String = null, modal:Boolean = true):DialogExperienceView		{			return DialogExperienceView(showDialog(new DialogExperienceView(text, modal)));		}				public static function showSeasonDialog(text:String = null, modal:Boolean = true) : DialogSeasonView		{			return DialogSeasonView(showDialog(new DialogSeasonView(text,modal)));		}				public static function showSpinDialog(text:String = null, modal:Boolean = true) : DialogSpinView		{			return DialogSpinView(showDialog(new DialogSpinView(text,modal)));		}				public static function showVaultDialog(text:String = null, modal:Boolean = true) : DialogVaultView		{			return DialogVaultView(showDialog(new DialogVaultView(text,modal)));		}      		public static function showItemDialog(item:StuffItemLightTO, text:String = null, modal:Boolean = true) : DialogItemView		{			return DialogItemView(showDialog(new DialogItemView(item,text,modal)));		}	  		public static function showOutfitsDialog(text:String = null, modal:Boolean = true) : DialogOutfitsView		{			return DialogOutfitsView(showDialog(new DialogOutfitsView(text, modal), false));		}	  		public static function showTwitterDialog(text:String = null, modal:Boolean = true):DialogTwitterView		{			return DialogTwitterView(showDialog(new DialogTwitterView(text, modal)));		}		public static function showTokenDialog(text:String = null, modal:Boolean = true):DialogTokenView		{			return DialogTokenView(showDialog(new DialogTokenView(text, modal)));		}	//	public static function showBadgeDialog(text:String = null, modal:Boolean = true):DialogBadgeView	//	{	//		return DialogBadgeView(showDialog(new DialogBadgeView(text, modal)));	//	}				public static function showTwitterTimelineDialog(moretxt:String, text:String, modal:Boolean = false):DialogTwitterTimelineView		{			return DialogTwitterTimelineView(showDialog(new DialogTwitterTimelineView(moretxt, text, modal)));		}				public static function showTeleportDialog(text:String = null, modal:Boolean = true):DialogTeleportView		{			return DialogTeleportView(showDialog(new DialogTeleportView(text, modal)));		}				public static function showNewspaperDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogNewspaperView		{			return DialogNewspaperView(showDialog(new DialogNewspaperView(text, okVisible, content, modal)));		}			/*	public static function showShopDialog(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = true):DialogShopView		{			return DialogShopView(showDialog(new DialogShopView(text, okVisible, content, modal)));		}*/				public static function hideDialogWindow(dialog:DisplayObject):void		{			dialog.visible = false;		}				public static function centerWindow(window:DisplayObject):void		{			window.x = (KavalokConstants.SCREEN_WIDTH - window.width) / 2;			window.y = (KavalokConstants.SCREEN_HEIGHT - window.height) / 2;		}				public static function showGameResults(result:Array, charStates:Object):DialogOkView		{			var view:McFinishScreen = new McFinishScreen();			var dialog:DialogOkView = Dialogs.showOkDialog(null, true, view);						for (var i:int = 0; i < MAX_PLAYERS; i++)			{				var mc:McChar = view['mcChar' + (i + 1)];								if (i < result.length)				{					var charId:String = result[i];					var stateId:String = Global.charManager.getCharStateId(charId);					var state:Object = charStates[stateId];										var char:Char = new Char(state);										var model:CharModel = new CharModel(char);										if (i == 0)						model.setModel(CharModels.DANCE_VICTORY);					else						model.setModel(CharModels.STAY, Directions.DOWN);										model.scale = 1.5;					model.position = mc.mcCharZone;										mc.txtName.text = charId;					mc.mcCharZone.visible = false;					mc.addChild(model);				}				else				{					mc.visible = false;				}			}			return dialog;		}				public static function showDialogWindow(dialog:Sprite, modal:Boolean = true, container:Sprite = null, docenterWindow:Boolean = true):void		{			if (container == null)				container = Global.dialogsContainer;						new ResourceScanner().apply(dialog);						if (modal)				GraphUtils.attachModalShadow(dialog, docenterWindow);						if (docenterWindow)				centerWindow(dialog);						if (Global.stage)				Global.stage.focus = null;						if (Global.root)				container.addChild(dialog);		}				private static function showDialog(dialog:DialogViewBase, centerWindow:Boolean = true):DialogViewBase		{			dialog.show(centerWindow);			return dialog;		}		}}