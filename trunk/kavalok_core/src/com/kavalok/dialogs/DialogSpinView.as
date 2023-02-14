package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.McCharWindow;
	import com.kavalok.MoodType;
	import com.kavalok.RankType;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharManager;
	import com.kavalok.char.CharModel;
	import com.kavalok.dialogs.DialogSendTweetView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.gameplay.controls.RectangleSprite;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.location.LocationManager;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.CharService;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.ui.Window;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.NameRequirement;
	import com.kavalok.utils.SpriteTweaner;
	import com.kavalok.utils.Strings;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
   
   public class DialogSpinView extends DialogViewBase
   {
       
      
      public var pick:MovieClip;
      public var wheel:MovieClip;
      public var closeButton:SimpleButton;
      public var play:int;
      public var start:int = 1;
      public var endframe:int;
      public var spinButton:SimpleButton;
	  public var spinNum:TextField;
      private var _ok:EventSender;
      
      public function DialogSpinView(text:String, modal:Boolean = true)
      {
         _ok = new EventSender();
         super(content || new DialogSpin(),text,modal);
         Global.charManager.refreshSpin();
         Global.resourceBundles.kavalok.registerButton(closeButton,"Close");
         Global.resourceBundles.kavalok.registerButton(spinButton,"Spin!");
		 Global.charManager.spinChangeEvent.addListener(onSpinsChanged);
         closeButton.addEventListener(MouseEvent.CLICK,onOkClick);
         spinButton.addEventListener(MouseEvent.CLICK,onSpinClick);
         wheel.addEventListener(Event.ENTER_FRAME,checkframe);
         pick.visible = true;
         wheel.visible = true;
         wheel.gotoAndStop(1);
         pick.gotoAndStop(1);
		 spinNum.text = Global.charManager.spinAmount.toString();
      }
      
	  private function onSpinsChanged() : void
	  {
		if(Global.charManager.spinAmount < 1) { 
			GraphUtils.setBtnEnabled(spinButton, false);
		} else { 
			GraphUtils.setBtnEnabled(spinButton, true);
		}
		spinNum.text = Global.charManager.spinAmount.toString();
	  }
	  
      public function random(min:int = 0, max:int = 2147483647) : int
      {
         if(min == max)
         {
            return min;
         }
         if(min < max)
         {
            return min + Math.random() * (max - min + 1);
         }
         return max + Math.random() * (min - max + 1);
      }
      
      public function checkframe(event:Event) : void
      {
         if(wheel.currentFrame == endframe)
         {
            wheel.gotoAndStop(endframe);
            pick.gotoAndStop(1);
            if(play == 1)
            {
               new AdminService().spinWheel(endframe);
               //new AdminService().spinWheel(110);
               Global.charManager.refreshSpin();
               play = 0;
               Global.isLocked = false;
            }
         }
      }
      
      protected function onOkClick(event:MouseEvent) : void
      {
         hide();
         ok.sendEvent();
      }
      
      public function onSpinClick(event:MouseEvent) : void
      {
         Global.isLocked = true;
		 spinNum.text = (Global.charManager.spinAmount-1).toString();
         endframe = random(100,147);
         if(endframe == 120 || 121 || 122 || 123)
         {
            endframe = random(100,123);
         }
         else
         {
            endframe = random(100,147);
         }
         endframe = random(100,147);
         if(Global.charManager.spinAmount < 1)
         {
            Dialogs.showOkDialog("Uh oh, you ran out of spins!: " + Global.charManager.spinAmount);
            Global.isLocked = false;
         }
         else
         {
            play = 1;
            wheel.gotoAndPlay(start);
            pick.gotoAndPlay(1);
         }
      }
      
      public function get ok() : EventSender
      {
         return _ok;
      }
   }
}
