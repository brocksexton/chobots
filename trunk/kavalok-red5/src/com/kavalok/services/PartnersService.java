package com.kavalok.services;

import java.util.Date;
import java.util.List;

import com.kavalok.dao.PartnerDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.Partner;
import com.kavalok.db.User;
import com.kavalok.dto.PagedResult;
import com.kavalok.dto.UserTO;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class PartnersService extends DataServiceNotTransactionBase {

  public PagedResult<UserTO> getUsersByDates(Date from, Date to, Integer firstResult, Integer maxResults) {
    Partner partner = getPartner();
    List<User> users = new UserDAO(getSession()).findByPartner(partner, from, to, firstResult, maxResults);
    List<UserTO> tos = UserTO.convertUsers(getSession(), users);
    return new PagedResult<UserTO>(new UserDAO(getSession()).sizeByReferrer(partner, from, to), tos);
  }
  public PagedResult<UserTO> getUsers(Integer firstResult, Integer maxResults) {
    Partner partner = getPartner();
    List<User> users = new UserDAO(getSession()).findByReferrer(partner, firstResult, maxResults);
    List<UserTO> tos = UserTO.convertUsers(getSession(), users);
    return new PagedResult<UserTO>(new UserDAO(getSession()).sizeByReferrer(partner), tos);
  }

  
  private Partner getPartner()
  {
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();
    // TODO Should be partner id instead of UserId
    return new PartnerDAO(getSession()).findById(adapter.getUserId());
  }
}
