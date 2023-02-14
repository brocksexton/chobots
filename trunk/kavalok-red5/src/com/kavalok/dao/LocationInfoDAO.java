package com.kavalok.dao;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.EmailExtraInfo;
import com.kavalok.db.LocationInfo;
import org.hibernate.Session;

public class LocationInfoDAO extends DAO<LocationInfo> {

    public LocationInfoDAO(Session session) {
        super(session);
    }

    public LocationInfo getByName(String locName)
    {
        LocationInfo result;
        result = (LocationInfo) findByParameter("name", locName);

        if(result != null){
            return result;
        }

        return result;
    }


}
