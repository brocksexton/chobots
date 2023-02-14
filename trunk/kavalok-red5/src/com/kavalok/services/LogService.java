package com.kavalok.services;

import java.util.*;
import java.lang.*;
import java.io.*;

import com.kavalok.dao.LogAdminDAO;
import com.kavalok.db.LogAdmin;
import com.kavalok.dao.LogToolsDAO;
import com.kavalok.db.LogTools;
import com.kavalok.dao.LogGiftDAO;
import com.kavalok.db.LogGift;
import com.kavalok.db.TradeLog;
import com.kavalok.dao.TradeLogDAO;
import com.kavalok.dto.PagedResult;
import com.kavalok.services.common.DataServiceNotTransactionBase;

public class LogService extends DataServiceNotTransactionBase {

    public void amL(String action, Integer success, String type) {
        if (success.equals(1)) {
            LogAdmin adminLog = new LogAdmin(action, getAdapter().getConnection().getRemoteAddress(), getAdapter().getUserId(), getAdapter().getPanelName(), type);
            new LogAdminDAO(getSession()).makePersistent(adminLog);
        } else {
            LogAdmin adminLog = new LogAdmin(action, getAdapter().getConnection().getRemoteAddress(), Long.valueOf(0), "0", type);
            new LogAdminDAO(getSession()).makePersistent(adminLog);
        }
    }

    public void tlG(String action, Integer recipientId, String recipient, String type) {
        LogTools toolsLog = new LogTools(action, getAdapter().getConnection().getRemoteAddress(), getAdapter().getUserId(), getAdapter().getLogin(), type, recipient, Long.valueOf(recipientId));
        new LogToolsDAO(getSession()).makePersistent(toolsLog);
    }

    public void gL(String item, Integer recipientId, String recipient, Integer itemId) {
        LogGift giftLog = new LogGift(item, getAdapter().getConnection().getRemoteAddress(), getAdapter().getUserId(), getAdapter().getLogin(), Long.valueOf(itemId), recipient, Long.valueOf(recipientId));
        new LogGiftDAO(getSession()).makePersistent(giftLog);
    }
	
	public void lT(String item, Integer partnerId, String recipient, String itemIDS){
	    String[] items = item.split(",");
		String[] itemIDss = itemIDS.split(",");
		System.out.println("ITEMSSSSS:" + Arrays.toString(items));
		
        int[] intwholef= new int[itemIDss.length];

        for(int n = 0; n < itemIDss.length; n++) {
        intwholef[n] = Integer.parseInt(itemIDss[n]);
        }
		
		for(int i = 0; i < items.length; i++){
		  TradeLog tradeLog = new TradeLog(items[i], getAdapter().getConnection().getRemoteAddress(), getAdapter().getUserId(), getAdapter().getLogin(), recipient, Long.valueOf(partnerId), intwholef[i]);
           new TradeLogDAO(getSession()).makePersistent(tradeLog);
		}
    }

}
