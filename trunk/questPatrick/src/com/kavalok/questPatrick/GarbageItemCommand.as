package com.kavalok.questPatrick
{
	import com.kavalok.Global;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.quest.findItems.FindItemsQuestBase;
	import com.kavalok.quest.findItems.QuestItem;
	import com.kavalok.quest.findItems.QuestItemCommand;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Sequence;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;

	public class GarbageItemCommand extends QuestItemCommand
	{
		private static const GARBAGE : Array = [McGabage0, McGabage1, McGabage2, McGabage3, McGabage4, McGabage5, McGabage6];
		
		public function GarbageItemCommand(quest:FindItemsQuestBase, bell:QuestItem)
		{
			super(quest, bell, null);
		}
		
		override protected function createItemSprite():Sprite
		{
			var type : Class = Arrays.randomItem(GARBAGE);
			return new type();
		}
		
		override protected function takeItem(sender:SpriteEntryPoint):void
		{
			if(!Global.charManager.stuffs.isItemUsed(PatrickQuest.POT))
				return;
			super.takeItem(sender);
			_quest.removeItem();
		}

		override protected function hideItem():void
		{
			var properties : Array = [];
			for(var i : uint = 3; i > 0; i--)
			{
				properties.push({x:_sprite.x + i});
				properties.push({x:_sprite.x - i});
			}
			new Sequence(_sprite, properties, 1, onAnimationEnd);
		}
		
		private function onAnimationEnd() : void
		{
			var properties : Array = [];
			new SpriteTweaner(_sprite, {scaleX:0, scaleY:0}, 4, null, onSecondAnimationEnd);
			GraphUtils.detachFromDisplay(_sprite);
		}
		private function onSecondAnimationEnd(sprite : Sprite) : void
		{
			GraphUtils.detachFromDisplay(_sprite);
		}
	}
}