package com.kavalok.dialogs
{
   import com.kavalok.Global;
   import com.kavalok.events.EventSender;
   import com.kavalok.gameplay.ToolTips;
   import com.kavalok.utils.GraphUtils;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class DialogBadgesView extends DialogViewBase
   {
      public var nextButton:SimpleButton;
      public var prevButton:SimpleButton;
      public var okButton:SimpleButton;
      private var badges:Array;
      public var badgeContainer2:MovieClip;
      private var _ok:EventSender;
      public var badgeContainer:MovieClip;
      
      public function DialogBadgesView(charId:int, text:String, okVisible:Boolean = true, content:MovieClip = null, modal:Boolean = false)
      {
         _ok = new EventSender();
         badges = new Array();
         super(content || new DialogBadges(),text,modal);
         okButton.addEventListener(MouseEvent.CLICK,onOkClick);
         okButton.visible = okVisible;
         ToolTips.registerObject(badgeContainer.citizen,"Become a citizen.");
         ToolTips.registerObject(badgeContainer.journalist,"Become a journalist.");
         ToolTips.registerObject(badgeContainer.agent,"Become an agent.");
         ToolTips.registerObject(badgeContainer.eliteagent,"Become an elite agent.");
         ToolTips.registerObject(badgeContainer.brush,"Earn a brush.");
         ToolTips.registerObject(badgeContainer.camera,"Earn a camera.");
         ToolTips.registerObject(badgeContainer2.friends,"Make 100 friends.");
         ToolTips.registerObject(badgeContainer2.pet,"Own or adopt a pet.");
         ToolTips.registerObject(badgeContainer2.gift,"Send a gift to someone.");
         ToolTips.registerObject(badgeContainer2.trade,"Make your first trade.");
         ToolTips.registerObject(badgeContainer.robot,"Create a robots team.");
         ToolTips.registerObject(badgeContainer.contest,"Win any contest.");
         ToolTips.registerObject(badgeContainer.nicho,"Mission - Complete Nichos mission.");
         ToolTips.registerObject(badgeContainer.chopix,"Park - Complete Chopix quest.");
         ToolTips.registerObject(badgeContainer.choproff,"Academy - Complete Choproff quest.");
         ToolTips.registerObject(badgeContainer.cleaner,"Garbage Collecting - Complete Chistochob\'s quest.");
         ToolTips.registerObject(badgeContainer2.sam,"Music Stage - Complete Sam\'s quest.");
         ToolTips.registerObject(badgeContainer2.santa,"Christmasy Park - Complete Santa\'s quest.");
         ToolTips.registerObject(badgeContainer2.pirate,"Ship - Complete Captain Chokru\'s quest.");
         ToolTips.registerObject(badgeContainer2.library,"Library - Complete Suzie\'s quest.");
         ToolTips.registerObject(badgeContainer.pinball,"Pinball - Play a game of Pinball.");
         ToolTips.registerObject(badgeContainer.factory,"RoboFactory - Play a game of RoboFactory.");
         ToolTips.registerObject(badgeContainer.crab,"Crab Game - Play a game of Mechanical Crab.");
         ToolTips.registerObject(badgeContainer.choboard,"Choboard - Play a game of Choboard.");
         ToolTips.registerObject(badgeContainer.asteroid,"Asteroid - Play a game of Asteroid.");
         ToolTips.registerObject(badgeContainer.sweet,"Sweet Battle - Play a game of Sweetbattle.");
         ToolTips.registerObject(badgeContainer2.garbage,"Garbage Collector - Play a game of Garbage Collector.");
         ToolTips.registerObject(badgeContainer2.bugs1,"Fancy livin\' - have 100,000 bugs.");
         ToolTips.registerObject(badgeContainer2.bugs2,"Filthy Rich - have 1,000,000 bugs.");
         ToolTips.registerObject(badgeContainer2.bugs3,"Rockefeller - have 5,000,000 bugs.");
         ToolTips.registerObject(badgeContainer.olympics,"Win the Chotopia Olympics");
         ToolTips.registerObject(badgeContainer.levels,"Reach level 60.");
         ToolTips.registerObject(badgeContainer.remote,"Earn a remote.");
         ToolTips.registerObject(badgeContainer.apet,"Abandon your pet.");
         ToolTips.registerObject(badgeContainer.magic,"Use any magic consumable.");
         ToolTips.registerObject(badgeContainer.shirts,"Earn 10, 20 and 30 day login shirts.");
         ToolTips.registerObject(badgeContainer2.foliant,"Earn a foliant.");
         ToolTips.registerObject(badgeContainer2.feather,"Earn a feather.");
         ToolTips.registerObject(badgeContainer2.mic,"Earn a microphone.");
         ToolTips.registerObject(badgeContainer2.comic,"Earn a comic.");
         badgeContainer2.visible = false;
         initContainerButtons();
         GraphUtils.setBtnEnabled(nextButton,true);
         refresh();
      }
      
      public function refresh() : void
      {
         var colorTransform:ColorTransform = null;
         var colorTransform1:ColorTransform = null;
         var colorTransform2:ColorTransform = null;
         var colorTransform3:ColorTransform = null;
         var colorTransform4:ColorTransform = null;
         var colorTransform5:ColorTransform = null;
         var colorTransform6:ColorTransform = null;
         var colorTransform7:ColorTransform = null;
         var colorTransform8:ColorTransform = null;
         var colorTransform9:ColorTransform = null;
         var colorTransform10:ColorTransform = null;
         var colorTransform11:ColorTransform = null;
         var colorTransform12:ColorTransform = null;
         var colorTransform13:ColorTransform = null;
         var colorTransform14:ColorTransform = null;
         var colorTransform15:ColorTransform = null;
         var colorTransform16:ColorTransform = null;
         var colorTransform17:ColorTransform = null;
         var colorTransform18:ColorTransform = null;
         var colorTransform19:ColorTransform = null;
         var colorTransform20:ColorTransform = null;
         var colorTransform21:ColorTransform = null;
         var colorTransform22:ColorTransform = null;
         var colorTransform23:ColorTransform = null;
         var colorTransform24:ColorTransform = null;
         var colorTransform25:ColorTransform = null;
         var colorTransform26:ColorTransform = null;
         var colorTransform27:ColorTransform = null;
         var colorTransform28:ColorTransform = null;
         var colorTransform29:ColorTransform = null;
         var colorTransform30:ColorTransform = null;
         var colorTransform31:ColorTransform = null;
         var colorTransform32:ColorTransform = null;
         var colorTransform33:ColorTransform = null;
         var colorTransform34:ColorTransform = null;
         var colorTransform35:ColorTransform = null;
         var colorTransform36:ColorTransform = null;
         var colorTransform37:ColorTransform = null;
         var colorTransform38:ColorTransform = null;
         var colorTransform39:ColorTransform = null;
         if(Global.charManager.achievements.indexOf("ac1;") != -1)
         {
            badgeContainer.citizen.visible = true;
         }
         else
         {
            badgeContainer.citizen.visible = true;
            colorTransform = badgeContainer.citizen.transform.colorTransform;
            colorTransform.color = 13083011;
            badgeContainer.citizen.transform.colorTransform = colorTransform;
         }
         if(Global.charManager.achievements.indexOf("ac2;") != -1)
         {
            badgeContainer.journalist.visible = true;
         }
         else
         {
            badgeContainer.journalist.visible = true;
            colorTransform1 = badgeContainer.journalist.transform.colorTransform;
            colorTransform1.color = 13083011;
            badgeContainer.journalist.transform.colorTransform = colorTransform1;
         }
         if(Global.charManager.achievements.indexOf("ac3;") != -1)
         {
            badgeContainer.agent.visible = true;
         }
         else
         {
            badgeContainer.agent.visible = true;
            colorTransform2 = badgeContainer.agent.transform.colorTransform;
            colorTransform2.color = 13083011;
            badgeContainer.agent.transform.colorTransform = colorTransform2;
         }
         if(Global.charManager.achievements.indexOf("ac4;") != -1)
         {
            badgeContainer.eliteagent.visible = true;
         }
         else
         {
            badgeContainer.eliteagent.visible = true;
            colorTransform3 = badgeContainer.eliteagent.transform.colorTransform;
            colorTransform3.color = 13083011;
            badgeContainer.eliteagent.transform.colorTransform = colorTransform3;
         }
         if(Global.charManager.achievements.indexOf("ac5;") != -1)
         {
            badgeContainer.brush.visible = true;
         }
         else
         {
            badgeContainer.brush.visible = true;
            colorTransform4 = badgeContainer.brush.transform.colorTransform;
            colorTransform4.color = 13083011;
            badgeContainer.brush.transform.colorTransform = colorTransform4;
         }
         if(Global.charManager.achievements.indexOf("ac6;") != -1)
         {
            badgeContainer.olympics.visible = true;
         }
         else
         {
            badgeContainer.olympics.visible = true;
            colorTransform5 = badgeContainer.olympics.transform.colorTransform;
            colorTransform5.color = 13083011;
            badgeContainer.olympics.transform.colorTransform = colorTransform5;
         }
         if(Global.charManager.achievements.indexOf("ac7;") != -1)
         {
            badgeContainer.camera.visible = true;
         }
         else
         {
            badgeContainer.camera.visible = true;
            colorTransform6 = badgeContainer.camera.transform.colorTransform;
            colorTransform6.color = 13083011;
            badgeContainer.camera.transform.colorTransform = colorTransform6;
         }
         if(Global.charManager.achievements.indexOf("ac8;") != -1)
         {
            badgeContainer2.friends.visible = true;
         }
         else
         {
            badgeContainer2.friends.visible = true;
            colorTransform7 = badgeContainer2.friends.transform.colorTransform;
            colorTransform7.color = 13083011;
            badgeContainer2.friends.transform.colorTransform = colorTransform7;
         }
         if(Global.charManager.achievements.indexOf("ac9;") != -1)
         {
            badgeContainer2.pet.visible = true;
         }
         else
         {
            badgeContainer2.pet.visible = true;
            colorTransform8 = badgeContainer2.pet.transform.colorTransform;
            colorTransform8.color = 13083011;
            badgeContainer2.pet.transform.colorTransform = colorTransform8;
         }
         if(Global.charManager.achievements.indexOf("ac10;") != -1)
         {
            badgeContainer2.gift.visible = true;
         }
         else
         {
            badgeContainer2.gift.visible = true;
            colorTransform9 = badgeContainer2.gift.transform.colorTransform;
            colorTransform9.color = 13083011;
            badgeContainer2.gift.transform.colorTransform = colorTransform9;
         }
         if(Global.charManager.achievements.indexOf("ac11;") != -1)
         {
            badgeContainer.robot.visible = true;
         }
         else
         {
            badgeContainer.robot.visible = true;
            colorTransform10 = badgeContainer.robot.transform.colorTransform;
            colorTransform10.color = 13083011;
            badgeContainer.robot.transform.colorTransform = colorTransform10;
         }
         if(Global.charManager.achievements.indexOf("ac12;") != -1)
         {
            badgeContainer.contest.visible = true;
         }
         else
         {
            badgeContainer.contest.visible = true;
            colorTransform11 = badgeContainer.contest.transform.colorTransform;
            colorTransform11.color = 13083011;
            badgeContainer.contest.transform.colorTransform = colorTransform11;
         }
         if(Global.charManager.achievements.indexOf("ac13;") != -1)
         {
            badgeContainer.nicho.visible = true;
         }
         else
         {
            badgeContainer.nicho.visible = true;
            colorTransform12 = badgeContainer.nicho.transform.colorTransform;
            colorTransform12.color = 13083011;
            badgeContainer.nicho.transform.colorTransform = colorTransform12;
         }
         if(Global.charManager.achievements.indexOf("ac14;") != -1)
         {
            badgeContainer.chopix.visible = true;
         }
         else
         {
            badgeContainer.chopix.visible = true;
            colorTransform13 = badgeContainer.chopix.transform.colorTransform;
            colorTransform13.color = 13083011;
            badgeContainer.chopix.transform.colorTransform = colorTransform13;
         }
         if(Global.charManager.achievements.indexOf("ac15;") != -1)
         {
            badgeContainer.choproff.visible = true;
         }
         else
         {
            badgeContainer.choproff.visible = true;
            colorTransform14 = badgeContainer.choproff.transform.colorTransform;
            colorTransform14.color = 13083011;
            badgeContainer.choproff.transform.colorTransform = colorTransform14;
         }
         if(Global.charManager.achievements.indexOf("ac16;") != -1)
         {
            badgeContainer.cleaner.visible = true;
         }
         else
         {
            badgeContainer.cleaner.visible = true;
            colorTransform15 = badgeContainer.cleaner.transform.colorTransform;
            colorTransform15.color = 13083011;
            badgeContainer.cleaner.transform.colorTransform = colorTransform15;
         }
         if(Global.charManager.achievements.indexOf("ac17;") != -1)
         {
            badgeContainer2.sam.visible = true;
         }
         else
         {
            badgeContainer2.sam.visible = true;
            colorTransform16 = badgeContainer2.sam.transform.colorTransform;
            colorTransform16.color = 13083011;
            badgeContainer2.sam.transform.colorTransform = colorTransform16;
         }
         if(Global.charManager.achievements.indexOf("ac18;") != -1)
         {
            badgeContainer2.santa.visible = true;
         }
         else
         {
            badgeContainer2.santa.visible = true;
            colorTransform17 = badgeContainer2.santa.transform.colorTransform;
            colorTransform17.color = 13083011;
            badgeContainer2.santa.transform.colorTransform = colorTransform17;
         }
         if(Global.charManager.achievements.indexOf("ac19;") != -1)
         {
            badgeContainer2.pirate.visible = true;
         }
         else
         {
            badgeContainer2.pirate.visible = true;
            colorTransform18 = badgeContainer2.pirate.transform.colorTransform;
            colorTransform18.color = 13083011;
            badgeContainer2.pirate.transform.colorTransform = colorTransform18;
         }
         if(Global.charManager.achievements.indexOf("ac20;") != -1)
         {
            badgeContainer2.library.visible = true;
         }
         else
         {
            badgeContainer2.library.visible = true;
            colorTransform19 = badgeContainer2.library.transform.colorTransform;
            colorTransform19.color = 13083011;
            badgeContainer2.library.transform.colorTransform = colorTransform19;
         }
         if(Global.charManager.achievements.indexOf("ac21;") != -1)
         {
            badgeContainer.pinball.visible = true;
         }
         else
         {
            badgeContainer.pinball.visible = true;
            colorTransform20 = badgeContainer.pinball.transform.colorTransform;
            colorTransform20.color = 13083011;
            badgeContainer.pinball.transform.colorTransform = colorTransform20;
         }
         if(Global.charManager.achievements.indexOf("ac22;") != -1)
         {
            badgeContainer.factory.visible = true;
         }
         else
         {
            badgeContainer.factory.visible = true;
            colorTransform21 = badgeContainer.factory.transform.colorTransform;
            colorTransform21.color = 13083011;
            badgeContainer.factory.transform.colorTransform = colorTransform21;
         }
         if(Global.charManager.achievements.indexOf("ac23;") != -1)
         {
            badgeContainer.crab.visible = true;
         }
         else
         {
            badgeContainer.crab.visible = true;
            colorTransform22 = badgeContainer.crab.transform.colorTransform;
            colorTransform22.color = 13083011;
            badgeContainer.crab.transform.colorTransform = colorTransform22;
         }
         if(Global.charManager.achievements.indexOf("ac24;") != -1)
         {
            badgeContainer.choboard.visible = true;
         }
         else
         {
            badgeContainer.choboard.visible = true;
            colorTransform23 = badgeContainer.choboard.transform.colorTransform;
            colorTransform23.color = 13083011;
            badgeContainer.choboard.transform.colorTransform = colorTransform23;
         }
         if(Global.charManager.achievements.indexOf("ac25;") != -1)
         {
            badgeContainer.asteroid.visible = true;
         }
         else
         {
            badgeContainer.asteroid.visible = true;
            colorTransform24 = badgeContainer.asteroid.transform.colorTransform;
            colorTransform24.color = 13083011;
            badgeContainer.asteroid.transform.colorTransform = colorTransform24;
         }
         if(Global.charManager.achievements.indexOf("ac26;") != -1)
         {
            badgeContainer.sweet.visible = true;
         }
         else
         {
            badgeContainer.sweet.visible = true;
            colorTransform25 = badgeContainer.sweet.transform.colorTransform;
            colorTransform25.color = 13083011;
            badgeContainer.sweet.transform.colorTransform = colorTransform25;
         }
         if(Global.charManager.achievements.indexOf("ac27;") != -1)
         {
            badgeContainer2.garbage.visible = true;
         }
         else
         {
            badgeContainer2.garbage.visible = true;
            colorTransform26 = badgeContainer2.garbage.transform.colorTransform;
            colorTransform26.color = 13083011;
            badgeContainer2.garbage.transform.colorTransform = colorTransform26;
         }
         if(Global.charManager.achievements.indexOf("ac28;") != -1)
         {
            badgeContainer2.bugs1.visible = true;
         }
         else
         {
            badgeContainer2.bugs1.visible = true;
            colorTransform27 = badgeContainer2.bugs1.transform.colorTransform;
            colorTransform27.color = 13083011;
            badgeContainer2.bugs1.transform.colorTransform = colorTransform27;
         }
         if(Global.charManager.achievements.indexOf("ac29;") != -1)
         {
            badgeContainer2.bugs2.visible = true;
         }
         else
         {
            badgeContainer2.bugs2.visible = true;
            colorTransform28 = badgeContainer2.bugs2.transform.colorTransform;
            colorTransform28.color = 13083011;
            badgeContainer2.bugs2.transform.colorTransform = colorTransform28;
         }
         if(Global.charManager.achievements.indexOf("ac30;") != -1)
         {
            badgeContainer2.bugs3.visible = true;
         }
         else
         {
            badgeContainer2.bugs3.visible = true;
            colorTransform29 = badgeContainer2.bugs3.transform.colorTransform;
            colorTransform29.color = 13083011;
            badgeContainer2.bugs3.transform.colorTransform = colorTransform29;
         }
         if(Global.charManager.achievements.indexOf("ac31;") != -1)
         {
            badgeContainer2.trade.visible = true;
         }
         else
         {
            badgeContainer2.trade.visible = true;
            colorTransform30 = badgeContainer2.trade.transform.colorTransform;
            colorTransform30.color = 13083011;
            badgeContainer2.trade.transform.colorTransform = colorTransform30;
         }
         if(Global.charManager.achievements.indexOf("ac32;") != -1)
         {
            badgeContainer.levels.visible = true;
         }
         else
         {
            badgeContainer.levels.visible = true;
            colorTransform31 = badgeContainer.levels.transform.colorTransform;
            colorTransform31.color = 13083011;
            badgeContainer.levels.transform.colorTransform = colorTransform31;
         }
         if(Global.charManager.achievements.indexOf("ac33;") != -1)
         {
            badgeContainer.remote.visible = true;
         }
         else
         {
            badgeContainer.remote.visible = true;
            colorTransform32 = badgeContainer.remote.transform.colorTransform;
            colorTransform32.color = 13083011;
            badgeContainer.remote.transform.colorTransform = colorTransform32;
         }
         if(Global.charManager.achievements.indexOf("ac34;") != -1)
         {
            badgeContainer.apet.visible = true;
         }
         else
         {
            badgeContainer.apet.visible = true;
            colorTransform33 = badgeContainer.apet.transform.colorTransform;
            colorTransform33.color = 13083011;
            badgeContainer.apet.transform.colorTransform = colorTransform33;
         }
         if(Global.charManager.achievements.indexOf("ac35;") != -1)
         {
            badgeContainer.magic.visible = true;
         }
         else
         {
            badgeContainer.magic.visible = true;
            colorTransform34 = badgeContainer.magic.transform.colorTransform;
            colorTransform34.color = 13083011;
            badgeContainer.magic.transform.colorTransform = colorTransform34;
         }
         if(Global.charManager.achievements.indexOf("ac36;") != -1)
         {
            badgeContainer.shirts.visible = true;
         }
         else
         {
            badgeContainer.shirts.visible = true;
            colorTransform35 = badgeContainer.shirts.transform.colorTransform;
            colorTransform35.color = 13083011;
            badgeContainer.shirts.transform.colorTransform = colorTransform35;
         }
         if(Global.charManager.achievements.indexOf("ac37;") != -1)
         {
            badgeContainer2.foliant.visible = true;
         }
         else
         {
            badgeContainer2.foliant.visible = true;
            colorTransform36 = badgeContainer2.foliant.transform.colorTransform;
            colorTransform36.color = 13083011;
            badgeContainer2.foliant.transform.colorTransform = colorTransform36;
         }
         if(Global.charManager.achievements.indexOf("ac38;") != -1)
         {
            badgeContainer2.feather.visible = true;
         }
         else
         {
            badgeContainer2.feather.visible = true;
            colorTransform37 = badgeContainer2.feather.transform.colorTransform;
            colorTransform37.color = 13083011;
            badgeContainer2.feather.transform.colorTransform = colorTransform37;
         }
         if(Global.charManager.achievements.indexOf("ac39;") != -1)
         {
            badgeContainer2.mic.visible = true;
         }
         else
         {
            badgeContainer2.mic.visible = true;
            colorTransform38 = badgeContainer2.mic.transform.colorTransform;
            colorTransform38.color = 13083011;
            badgeContainer2.mic.transform.colorTransform = colorTransform38;
         }
         if(Global.charManager.achievements.indexOf("ac40;") != -1)
         {
            badgeContainer2.comic.visible = true;
         }
         else
         {
            badgeContainer2.comic.visible = true;
            colorTransform39 = badgeContainer2.comic.transform.colorTransform;
            colorTransform39.color = 13083011;
            badgeContainer2.comic.transform.colorTransform = colorTransform39;
         }
      }
      
      public function refreshContainer() : void
      {
      }
      
      public function get ok() : EventSender
      {
         return _ok;
      }
      
      protected function onOkClick(event:MouseEvent) : void
      {
         hide();
         ok.sendEvent();
      }
      
      public function initContainerButtons() : void
      {
         nextButton.addEventListener(MouseEvent.CLICK,onNextClick);
         prevButton.addEventListener(MouseEvent.CLICK,onPrevClick);
      }
      
      public function onPrevClick(e:MouseEvent) : void
      {
         badgeContainer2.visible = false;
         badgeContainer.visible = true;
         refreshContainer();
         refresh();
      }
      
      public function onNextClick(e:MouseEvent) : void
      {
         badgeContainer2.visible = true;
         badgeContainer.visible = false;
         refreshContainer();
         refresh();
      }
   }
}
