package com.kavalok.services;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.dao.ServerDAO;
import com.kavalok.dao.ShopDAO;
import com.kavalok.dao.StuffTypeDAO;
import com.kavalok.db.Server;
import com.kavalok.db.Shop;
import com.kavalok.db.StuffType;
import com.kavalok.dto.stuff.StuffTypeAdminTO;
import com.kavalok.services.common.DataServiceBase;
import com.kavalok.utils.ReflectUtil;
import com.kavalok.xmlrpc.RemoteClient;

public class StuffTypeService extends DataServiceBase {

    public StuffTypeService() {
        super();
    }

    @SuppressWarnings("unchecked")
    public List<StuffTypeAdminTO> getStuffList() {
        StuffTypeDAO dao = new StuffTypeDAO(getSession());
        List<StuffType> typeList = (List<StuffType>) dao.findAll();
        List<StuffTypeAdminTO> toList = ReflectUtil.convertBeansByConstructor(typeList, StuffTypeAdminTO.class);
        return toList;
    }

    @SuppressWarnings("unchecked")
    public List<StuffTypeAdminTO> getStuffListByShop(String shopName) {

        StuffTypeDAO dao = new StuffTypeDAO(getSession());
        List<StuffTypeWrapper> typeList = dao.findByShopName(shopName);
        List<StuffTypeAdminTO> toList = ReflectUtil.convertBeansByConstructor(typeList, StuffTypeAdminTO.class);
        return toList;
    }

    public List<String> getShops() {
        ShopDAO dao = new ShopDAO(getSession());
        List<Shop> shops = dao.findAll();
        List<String> result = new ArrayList<String>();
        for (Shop shop : shops) {
            result.add(shop.getName());
        }
        return result;
    }

    public void saveItem(StuffTypeAdminTO item) {
        if (StringUtils.isBlank(item.getFileName()) || StringUtils.isBlank(item.getShopName())
                || StringUtils.isBlank(item.getType())) {
            return;
        }
        StuffTypeDAO stuffDAO = new StuffTypeDAO(getSession());
        StuffType stuff = new StuffType();
        if (item.getId() != null && item.getId() > 0)
            stuff = stuffDAO.findById(item.getId());

        ShopDAO shopDAO = new ShopDAO(getSession());
        Shop shop = shopDAO.findByName(item.getShopName());

        stuff.setPremium(item.getPremium());
        stuff.setHasColor(item.getHasColor());
        stuff.setDoubleColor(item.getDoubleColor());
        stuff.setGiftable(item.getGiftable());
        stuff.setRainable(item.getRainable());
        stuff.setPrice(item.getPrice());
		stuff.setEmeralds(item.getEmeralds());
        stuff.setShop(shop);
        stuff.setPlacement(item.getPlacement());
        stuff.setInfo(item.getInfo());
        stuff.setItemOfTheMonth(item.getItemOfTheMonth());
        stuff.setGroupNum(item.getGroupNum());
        stuff.setName(item.getName());
        stuff.setFileName(item.getFileName());
        stuff.setType(item.getType());

        if(item.getType().equals("O")) {
            // is fish
            stuff.setOtherInfo(item.getOtherInfo());
        } else {
            stuff.setOtherInfo(new byte[2]);
        }
        stuffDAO.makePersistent(stuff);

        List<Server> servers = new ServerDAO(getSession()).findRunning();
        for (Server server : servers) {
            try {
                new RemoteClient(server).refreshStuffTypeCache();
            } catch (Exception e) {

            }
        }

    }

}
