package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.CharService;
	//import fl.controls.NumericStepper;
	import com.kavalok.services.MagicServiceNT;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import flash.events.*;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.Global;
	import flash.text.TextField;
	import com.kavalok.gameplay.commands.AddMoneyCommand;

	import com.kavalok.events.EventSender;

	public class DialogBankView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var myBankMoney:int = Global.charManager.bankMoney;
		public var myCoinsMoney:int = Global.charManager.money;
		public var bankValueAmount:int;
		public var lastVisit:TextField;
		public var totalText:TextField;
		public var origValue:Number;
		public var oneDay:int = 1440 * 60;
		public var bugsText:TextField;
		public var subBtn:SimpleButton;
		public var money:int = Global.charManager.money;
		public var totalMoney:int = (Global.charManager.money + Global.charManager.bankMoney);
		public var bankValue:TextField;
		public var addBtn:SimpleButton;
		private var _ok:EventSender = new EventSender();

		public function DialogBankView(text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false)
		{
			super(content || new DialogBank(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			okButton.visible = okVisible;
			addBtn.addEventListener(MouseEvent.CLICK, onAddClick);
			subBtn.addEventListener(MouseEvent.CLICK, onAddClick);
			ToolTips.registerObject(addBtn, "Deposit 100 bugs");
			ToolTips.registerObject(subBtn, "Withdraw 100 bugs");
			ToolTips.registerObject(bankValue, "Amount of bugs in bank");
			update();
			lastVisit.text = "";
			totalText.text = totalMoney.toString();
			bugsText.text = money.toString();
			new MagicServiceNT(lolItsReadyxD).getLastVisit();
		}

		public function get ok():EventSender
		{
			return _ok;
		}

		private function lolItsReadyxD(lastVisitDate:int):void
		{
			if (lastVisitDate < oneDay)
			{
				lastVisit.text = "You've already visited today!";
			}
			else
			{
				lastVisit.text = "You haven't visited yet!";
				new MagicServiceNT().setLastVisit();
			}

		}

		public function onAddClick(e:MouseEvent):void
		{
			if (bankValueAmount >= 0)
			{
				if (bankValueAmount >= Global.charManager.money)
				{
					Dialogs.showOkDialog("You don't have enough money to deposit!");
				}
				else
				{

					if (e.target.name.indexOf("sub") != -1 && bankValueAmount != 0)
					{
						myBankMoney -=  100;
						myCoinsMoney +=  100;
						update();
					}
					else if (e.target.name.indexOf("add") != -1)
					{
						myBankMoney +=  100;
						myCoinsMoney -=  100;
						update();
					}
					else
					{
						return;
					}
					//update();

				}

			}
		}

		public function update():void
		{

			bugsText.text = (myCoinsMoney).toString();

			//bugsText.text = (money - myBankMoney).toString();
			bankValue.text = myBankMoney.toString();
			bankValueAmount = parseInt(bankValue.text);
		}
		protected function onOkClick(event:MouseEvent):void
		{
			hide();
			ok.sendEvent();
			new AdminService().saveBankMoney(Global.charManager.userId, myBankMoney);
			Global.charManager.bankMoney = myBankMoney;
			Global.charManager.money = parseInt(bugsText.text);
			new CharService().C(parseInt(bugsText.text));
			trace("bm is " + Global.charManager.bankMoney);
		}


	}
}