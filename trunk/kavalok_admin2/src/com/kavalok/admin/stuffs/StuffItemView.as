package com.kavalok.admin.stuffs
{
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.utils.GraphUtils;
	
	import mx.core.UIComponent;
	
	public class StuffItemView extends UIComponent
	{
		private var _stuffModel:ResourceSprite;
		
		public function StuffItemView()
		{
			width = 100;
			height = 100;
		}
		
		public function set stuffType(value:Object):void 
		{
			setStuffType(value);
		}
		
		public function setStuffType(value:Object, color:int = 0xFFFFFF):void
		{
			if (_stuffModel)
				GraphUtils.detachFromDisplay(_stuffModel);
				
			if (value == null)
				return;
				
			var st:StuffItemLightTO;
			
			if (value is StuffTypeAdminTO)
			{
				st = new StuffItemLightTO();
				st.fileName = StuffTypeAdminTO(value).fileName;
				st.type = StuffTypeAdminTO(value).type;
				st.hasColor = StuffTypeAdminTO(value).hasColor;
				st.color = color;
			}
			else if (value is StuffTypeTO)
			{
				st = new StuffItemLightTO();
				st.fileName = StuffTypeTO(value).fileName;
				st.type = StuffTypeTO(value).type;
				st.hasColor = StuffTypeTO(value).hasColor;
				st.color = color;
			}
			
			if (st && st.fileName)
			{
				_stuffModel = st.createModel();
				_stuffModel.width = width;
				_stuffModel.height = height;
				_stuffModel.loadContent();
				_stuffModel.useView = false;
				this.addChild(_stuffModel);
			}
		}
		
		
	}
	
}