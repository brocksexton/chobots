package com.kavalok.services;

import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.dao.LocationInfoDAO;
import com.kavalok.dao.ServerDAO;
import com.kavalok.dao.ShopDAO;
import com.kavalok.dao.StuffTypeDAO;
import com.kavalok.db.LocationInfo;
import com.kavalok.db.Server;
import com.kavalok.db.Shop;
import com.kavalok.db.StuffType;
import com.kavalok.dto.stuff.StuffTypeAdminTO;
import com.kavalok.services.common.DataServiceBase;
import com.kavalok.utils.ReflectUtil;
import com.kavalok.xmlrpc.RemoteClient;
import org.apache.commons.lang.StringUtils;

import java.util.ArrayList;
import java.util.List;
import static java.lang.Math.round;
import static java.lang.Math.random;
import static java.lang.Math.pow;
import static java.lang.Math.abs;
import static java.lang.Math.min;
import static org.apache.commons.lang.StringUtils.leftPad;

public class LocationInfoService extends DataServiceBase {

    public LocationInfoService() {
        super();
    }

    public String gh(String locName) {
        String hash;

        LocationInfoDAO lid = new LocationInfoDAO(getSession());
        LocationInfo li = lid.getByName(locName);

        if (li == null) {
            li = new LocationInfo();
            li.setName(locName);
            li.setHash(getRandomHash(30));

            lid.makePersistent(li);
        }

        return li.getHash();
    }

    public String getRandomHash(int length)
    {
        StringBuffer sb = new StringBuffer();
        for (int i = length; i > 0; i -= 12) {
            int n = min(12, abs(i));
            sb.append(leftPad(Long.toString(round(random() * pow(36, n)), 36), n, '0'));
        }
        return sb.toString();
    }

}
