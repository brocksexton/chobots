package com.kavalok.services;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.kavalok.dao.LocationInfoDAO;
import org.red5.server.api.so.ISharedObject;

import com.kavalok.KavalokApplication;
import com.kavalok.services.common.ServiceBase;
import com.kavalok.sharedObjects.SOListener;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class LocationService extends ServiceBase {

    public void moveTO(String sharedObjId, Integer x, Integer y, Boolean petBusy) {
        if (sharedObjId == null || sharedObjId.length() == 0)
            return;
        ISharedObject sharedObject = KavalokApplication.getInstance().getSharedObject(sharedObjId);
        if (sharedObject == null) {
            return;
        }

        UserManager userMan = UserManager.getInstance();
        UserAdapter currUser = userMan.getCurrentUser();
        SOListener listener = SOListener.getListener(sharedObject);
        List<String> connectedChars = listener.getConnectedChars();
        // ObjectMap<String, Object> command;
        if (connectedChars.size() > 1 && connectedChars.contains(currUser.getLogin())) {
            List<String> connChars = new ArrayList<String>(connectedChars);
            for (Iterator<String> iterator = connChars.iterator(); iterator.hasNext(); ) {
                String login = (String) iterator.next();
                UserAdapter user = userMan.getUser(login);
                if (user != null && !currUser.getUserId().equals(user.getUserId())) {

                    user.sendLocationMove(currUser.getUserId().intValue(), currUser.getLogin(), x, y, petBusy);

                }

            }
        }
    }

}
