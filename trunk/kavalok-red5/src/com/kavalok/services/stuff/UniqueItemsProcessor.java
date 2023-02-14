package com.kavalok.services.stuff;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.GameCharDAO;
import com.kavalok.dao.StuffItemDAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.StuffItem;
import com.kavalok.dto.stuff.StuffTypeTO;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class UniqueItemsProcessor extends DefaultShopProcessor {

  @Override
  public List<StuffTypeTO> getStuffTypes(Session session, String shopName) {
    List<StuffTypeTO> result = super.getStuffTypes(session, shopName);
    
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();
    GameChar gameChar = new GameCharDAO(session).findByUserId(adapter.getUserId());
    List<StuffItem> familyStuff = new StuffItemDAO(session).findByTypes(gameChar, new String[]{StuffTypes.HOUSE, StuffTypes.FURNITURE, StuffTypes.PET_ITEMS}, false);
    for(StuffItem item : familyStuff)
    {
      for(StuffTypeTO typeTO : result)
      {
        if(typeTO.getId().equals(item.getType().getId()))
        {
          typeTO.setEnabled(false);
          break;
        }
      }
    }
    return result;
  }

}
