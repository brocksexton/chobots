package com.kavalok.services.stuff;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Session;
import org.red5.io.utils.ObjectMap;

import com.kavalok.KavalokApplication;
import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.dao.SKUDAO;
import com.kavalok.dao.StuffTypeDAO;
import com.kavalok.db.SKU;
import com.kavalok.dto.stuff.StuffTypeTO;
import com.kavalok.utils.ReflectUtil;

public class PayedShopProcessor implements IShopProcessor {

  @SuppressWarnings("unchecked")
  @Override
  public List<StuffTypeTO> getStuffTypes(Session session, String shopName) {
    Integer groupNum = KavalokApplication.getInstance().getStuffGroupNum();
    List<StuffTypeWrapper> result = new StuffTypeDAO(session).findByShopName(shopName, groupNum);
    List itemsToRemove = new ArrayList();
    List resultTos = ReflectUtil.convertBeans(result, StuffTypeTO.class);
    SKUDAO dao = new SKUDAO(session);
    for (Iterator iterator = resultTos.iterator(); iterator.hasNext();) {
      StuffTypeTO stuffTypeTO = (StuffTypeTO) iterator.next();
      SKU sku = dao.findActiveStuffSKU(stuffTypeTO.getId()); 
      if (sku == null) {
        itemsToRemove.add(stuffTypeTO);
      } else {
        stuffTypeTO.setSkuInfo(getSKUInfo(sku));
      }

    }
    resultTos.removeAll(itemsToRemove);
    return resultTos;
  }

  private ObjectMap<String, Object> getSKUInfo(SKU sku) {
    ObjectMap<String, Object> result = null;
    if (sku != null) {
      result = new ObjectMap<String, Object>();
      result.put("id", sku.getId());
      result.put("price", sku.getPriceStr());
      result.put("sign", sku.getCurrencySign());
    }
    return result;
  }

  @Override
  public Integer getStuffTypesCount(Session session, String shopName) {
    Integer groupNum = KavalokApplication.getInstance().getStuffGroupNum();
    return new StuffTypeDAO(session).findByShopNameCount(shopName, groupNum);
  }

}
