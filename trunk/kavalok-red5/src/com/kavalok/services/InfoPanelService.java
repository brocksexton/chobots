package com.kavalok.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.kavalok.dao.InfoPanelDAO;
import com.kavalok.db.InfoPanel;
import com.kavalok.dto.infoPanel.InfoPanelAdminTO;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;
import com.kavalok.services.common.DataServiceNotTransactionBase;

public class InfoPanelService extends DataServiceNotTransactionBase {
	
	private UserAdapter userAdmin = UserManager.getInstance().getCurrentUser();
	
	public Boolean isAuthorized(){
      if(!userAdmin.getAdminStatus()){
          userAdmin.goodBye("Hacking attempt detected", false);
          return false;
      } else {
          return true;
      }

  }
	public List<InfoPanelAdminTO> getEntities() {
		ArrayList<InfoPanelAdminTO> result = new ArrayList<InfoPanelAdminTO>();
		InfoPanelDAO dao = new InfoPanelDAO(getSession());
	    for (InfoPanel infoItem : dao.findAll()) {
	      result.add(new InfoPanelAdminTO(infoItem));
	    }
	    return result;		
	}
	
	public InfoPanelAdminTO saveEntity(InfoPanelAdminTO item) {
		if(!isAuthorized()) return null;
		InfoPanelDAO dao = new InfoPanelDAO(getSession());
		InfoPanel panel = dao.findInfo(item.getId());
		if (panel == null) {
			panel = new InfoPanel();
		}
		panel.setCaption(item.getCaption());
		panel.setData(item.getData());
		panel.setEnabled(item.getEnabled());
		panel.setCreated(new Date());
		dao.makePersistent(panel);
		
		return new InfoPanelAdminTO(panel);
	}
	
	public List<InfoPanel> getAvailableList() {
		return new InfoPanelDAO(getSession()).getAvailableList();
	}
	
}
