package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.Global;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import com.kavalok.dialogs.DialogYesNoView;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import com.kavalok.gameplay.ToolTips;
	import flash.geom.ColorTransform;
	import com.kavalok.utils.GraphUtils;
	import com.ethan.CountDown;
	import com.ethan.CountDownEvent;

	import com.kavalok.events.EventSender;
	
	public class DialogLottoView extends DialogViewBase
	{
		public var okButton:SimpleButton; //exit X button
		public var enterButton:SimpleButton; // enter the lottery; pay for ticket
		public var nextButton:SimpleButton; //addEntries
		public var prevButton:SimpleButton; // remove entries
		public var priceField:TextField; //price of ticket
		public var entryField:TextField; //how many times user entered
		public var prizeField:TextField; //what the prize is
		public var entries:TextField; //entries amount
		public var timeField:TextField; //how much time is left 
		public var totalEntryField:TextField; //total entries by all users
		public var typeClip:MovieClip; //citizen or bugs image
		public var timerCountDown : CountDown = new CountDown(); // initiator of ethans countdown class


		private var _ticketPrice:int; //price of a ticket
		private var _enterTimes:int; //how many times user entered
		private var _prizeType:String; //citizen or bugs
		private var _prize:int; //how much citizen or bugs
		private var _pieces : Array; // Array to hold pieces of the date
		private var _endDate : Date; //finishing date
		private var _lottoId:int; //ID of lottery displayed
		private var _totalEntries:int; //how many entries in total
		private var _cumulativeMode:Boolean; //prize = num of entries * price of ticket
		private var _ii : Boolean = false; // boolean to ensure the popup dialog appears only once.

		private var _ok:EventSender = new EventSender();
	
		public function DialogLottoView(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false)
		{
			super(content || new DialogLotto(), text, modal);
			Global.isLocked = true;
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
			prevButton.addEventListener(MouseEvent.CLICK, delEntry);
			nextButton.addEventListener(MouseEvent.CLICK, addEntry);
			enterButton.addEventListener(MouseEvent.CLICK, onEnterLottoClick);
			ToolTips.registerObject(enterButton, "The more you enter, the higher your\nchances are of winning the prize!");
			ToolTips.registerObject(prevButton, "Reduce entry amount by 1.");
			ToolTips.registerObject(nextButton, "Increase entry amount by 1.");
			timerCountDown.addEventListener( CountDownEvent.UPDATE , _updateDisplay );

			new AdminService(onGetLotto).getLotto();
			typeClip.gotoAndStop(1);
		}
		
		private function delEntry(evt:MouseEvent) : void {
		 var cA : Number = new Number(parseInt(entries.text));
		  if(cA >= 2){
		  cA--;
		  entries.text = cA.toString();
		 }
		}
		
		private function addEntry(evt:MouseEvent) : void {
		 var cA : int = parseInt(entries.text);
		  if(cA <= 98){
		  cA++;
		  entries.text = cA.toString();
		 }
		}
		
		private function onGetLotto(lotto:Array) : void {
		
			if(lotto[0] == undefined){
			   hide();
			   Dialogs.showOkDialog("There is no active draw! Check back soon.");
			   Global.isLocked = false;
			   return;
			}else{
				_ticketPrice = lotto[0].ticketPrice;
				_prizeType = lotto[0].prizeType.toString();
				_prize = lotto[0].prize;
				_pieces = lotto[0].endDate.split(",");
				_lottoId = lotto[0].id;
				_totalEntries = lotto[0].totalEntries;
				_cumulativeMode = lotto[0].cumulativeMode;
				var yr:Number = new Number(parseInt(_pieces[0]));
				var mnt:Number = new Number(parseInt(_pieces[1]));
				var dy:Number = new Number(parseInt(_pieces[2]));
				var hr:Number = new Number(parseInt(_pieces[3]));
				var mn:Number = new Number(parseInt(_pieces[4]));
				var sc:Number = new Number(parseInt(_pieces[5]));
				_endDate = new Date(yr, mnt, dy, hr, mn, sc);
				timerCountDown.init(new Date(yr, mnt, dy, hr, mn, sc));
				Global.isLocked = false;
			}
		
		}

		private function onEnterLottoClick(e:MouseEvent):void
		{
            var entrz : int = parseInt(entries.text);
			var dialog:DialogYesNoView = Dialogs.showYesNoDialog("Are you sure you want to enter for " + _ticketPrice * entrz + " bugs?");
			dialog.yes.addListener(onYesClick);

		}

		private function onYesClick():void
		{
            var entrz : int = parseInt(entries.text);
			Global.isLocked = true;
			if(Global.charManager.money < _ticketPrice * entrz)
			{
				Dialogs.showOkDialog("You do not have enough money to enter. You need " + (_ticketPrice * entrz - Global.charManager.money).toString() + " more!");
				Global.isLocked = false;
				hide();
			} else if (Global.charManager.isModerator){
				Dialogs.showOkDialog("Nope. It wouldn't be fair if mods got to enter :)");
				Global.isLocked = false;
				hide();
				} else { 
			new AdminService(onEnteredLotto).enterLotto(_lottoId, entrz);
		}
		}
		private function onEnteredLotto(result:String):void
		{
			new AdminService(onGetLotto).getLotto();

		//	Dialogs.showOkDialog("You have successfully entered. The winner will be randomly picked and announced when the draw is over!");
			Global.charManager.refreshMoney();
			Global.isLocked = false;
		}
		private function updateFields():void
		{
			priceField.htmlText = "<b>" + _ticketPrice + "</b> bugs";
			totalEntryField.htmlText = "<b>" + _totalEntries + "</b>";

			if(!_cumulativeMode)
			prizeField.htmlText = "<b>" + _prize + "</b> " + ((_prizeType == "citizen") ? "days" : (_prizeType == "mystery") ? "secret prize" : "bugs");
			else
			prizeField.htmlText = "<b>" + (_totalEntries * _ticketPrice) + "</b> bugs";

			typeClip.gotoAndStop(_prizeType);

			new AdminService(onGotLottoEntries).getLottoEntries();
		}

		private function onGotLottoEntries(result:int):void
		{
			_enterTimes = result;
			entryField.htmlText = "You have entered <b>" + _enterTimes + "</b> " + ((_enterTimes == 1) ? "time" : "times");
		}
		
		public function get ok():EventSender
		{
			return _ok;
		}

	
		private function updateTime(e:TimerEvent = null):void
		{
	
		var currentDate:Date = Global.getServerTime();
		
		var timeLeft:Number = _endDate.getTime() - currentDate.getTime();
		
		var seconds:Number = Math.floor(timeLeft / 1000);
		var minutes:Number = Math.floor(seconds / 60);
		var hours:Number = Math.floor(minutes / 60);
		var days:Number = Math.floor(hours / 24);

		seconds %= 60;
		minutes %= 60;
		hours %= 24;


		var sec:String = seconds.toString();
		var min:String = minutes.toString();
		var hrs:String = hours.toString();
		var d:String = days.toString();

		var timey:String = hrs + " hours, " + min + " minutes";
		timeField.text = timey;
	}

    private function _updateDisplay( evt:CountDownEvent ) : void
		{
			var diff:Number = evt.millisecondsLeft;
			
			var daysLeft:int = Math.floor((diff / (60*60*24)) / 1000);
			var dL:String = Math.floor((diff/ (60*60*24)) / 1000).toString();
			var daysPortion:Number = (100-(daysLeft*100/30))/100;
			diff -= (daysLeft*CountDown.MILLISECONDS_PER_DAY);
			
			var hoursLeft:int = Math.floor((diff / (60*60))/1000);
			var hL:String = Math.floor((diff / (60*60))/1000).toString();
			var hoursPortion:Number = (100-(hoursLeft*100/24))/100;
			diff -= (hoursLeft*CountDown.MILLISECONDS_PER_HOUR);
			
			var minutesLeft:int = Math.floor((diff / 60)/1000);
			var mL:String = Math.floor((diff / 60)/1000).toString();
			var minutesPortion:Number = (100-(minutesLeft*100/60))/100;
			diff -= (minutesLeft*CountDown.MILLISECONDS_PER_MINUTE);
			
			var secondsLeft:int = Math.floor(diff/1000);
			var sL:String = Math.floor(diff/1000).toString();
			var secondsPortion:Number = (100-(secondsLeft*100/60))/100;
			
			if(daysLeft < 10){  dL = "0" + daysLeft.toString();}
			if(hoursLeft < 10){ hL = "0" + hoursLeft.toString();}
			if(minutesLeft < 10){ mL = "0" + minutesLeft.toString();}
			if(secondsLeft < 10){ sL = "0" + secondsLeft.toString();}
			
			var FORMAT:String = dL + ":" + hL + ":" + mL + ":" + sL;
			if(FORMAT != "00:00:00:00"){
			   timeField.text = hL + " hours, " + mL + " minutes";
			   updateFields();
			}else{
		       hide();
			   if(_ii == false){
		       Dialogs.showOkDialog("The draw has ended. The results will be announced soon!");
			   timerCountDown.stop();
			   timerCountDown.removeEventListener(CountDownEvent.UPDATE , _updateDisplay);
			   _ii = true;
			   }
			}
		}
		
		protected function onOkClick(event:MouseEvent):void
		{
			hide();
			ok.sendEvent();
		}
		
	
	}
}