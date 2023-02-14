package com.kavalok.services.stuff;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.KavalokApplication;
import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.dao.StuffTypeDAO;
import com.kavalok.dto.stuff.StuffTypeTO;
import com.kavalok.utils.ReflectUtil;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class DefaultShopProcessor implements IShopProcessor {



  @SuppressWarnings("unchecked")
  @Override
  public List<StuffTypeTO> getStuffTypes(Session session, String shopName) {
    UserAdapter userAdmin = UserManager.getInstance().getCurrentUser();
    List<StuffTypeWrapper> result;
    Integer groupNum = KavalokApplication.getInstance().getStuffGroupNum();
    if(false){
    result = new StuffTypeDAO(session).findByShopName(shopName);
  }
  else
  {
    result = new StuffTypeDAO(session).findByShopName(shopName, groupNum);
  }
    List stuffs = ReflectUtil.convertBeans(result, StuffTypeTO.class);
    return stuffs;
  }

  @Override
  public Integer getStuffTypesCount(Session session, String shopName) {
    Integer groupNum = KavalokApplication.getInstance().getStuffGroupNum();
    return new StuffTypeDAO(session).findByShopNameCount(shopName, groupNum);
  }

}
