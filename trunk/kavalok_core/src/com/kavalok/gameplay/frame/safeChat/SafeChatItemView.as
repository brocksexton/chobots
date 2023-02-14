package com.kavalok.gameplay.frame.safeChat
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.ToolTips;
	
	import flash.display.MovieClip;
	
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.ReflectUtil;
	import com.kavalok.utils.GraphUtils;
	
	public class SafeChatItemView
	{
		private static const ICON_SIZE : Number = 32;
		private static const CLASS_PREFIX : String = "Icon_";
		private static const MAX_CHARS : uint = 6;
		
		private var _content : MovieClip;
		
		public function SafeChatItemView(id : String, content : MovieClip = null)
		{
			if(content == null)
				content = new SafeChatItem();
			_content = content;
			_content.useHandCursor = true;
			_content.mouseChildren = false;
			_content.buttonMode = true;
			_content.id = id;
			GraphUtils.removeChildren(_content.icon);
			var type : Class = ReflectUtil.getTypeByName(CLASS_PREFIX + id);
			var icon : MovieClip = new type();
			icon.x = (ICON_SIZE - icon.width) / 2;
			icon.y = (ICON_SIZE - icon.height) / 2;
			_content.icon.addChild(icon);
			var bundle : ResourceBundle = Localiztion.getBundle(ResourceBundles.SAFE_CHAT);
			bundle.registerMessage(this, "message", id);
			_content.view = this; //if not added this object will be destroyed 
			ToolTips.registerObject(_content, id, ResourceBundles.SAFE_CHAT);
		}
		
		public function set message(value : String) : void
		{
			_content.word.text = cropString(value);
		}
		
		public function get content() : MovieClip
		{
			return _content;
		}
		
		private function cropString(value : String) : String
		{
			if(value.length > MAX_CHARS)
			{
				return value.substr(0, MAX_CHARS) + "...";
			}
			return value;
		}

	}
}