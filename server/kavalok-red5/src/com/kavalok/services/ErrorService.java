package com.kavalok.services;

import java.util.Date;

import com.kavalok.dao.ClientErrorDAO;
import com.kavalok.db.ClientError;
import com.kavalok.dto.PagedResult;
import com.kavalok.services.common.DataServiceNotTransactionBase;

public class ErrorService extends DataServiceNotTransactionBase {

  public PagedResult<ClientError> getErrors(Integer firstResult, Integer maxResults) {
    ClientErrorDAO errorsDAO = new ClientErrorDAO(getSession());
    return new PagedResult<ClientError>(errorsDAO.size(), errorsDAO.findErrors(firstResult, maxResults));
  }

  public void addError(String message) {
    ClientErrorDAO errorsDAO = new ClientErrorDAO(getSession());
    ClientError clientError = errorsDAO.findError(message);
    if (clientError == null) {
      clientError = new ClientError(message);
    }
    clientError.setCount(clientError.getCount() + 1);
    clientError.setUpdated(new Date());
    errorsDAO.makePersistent(clientError);
  }
}
