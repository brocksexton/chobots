package com.kavalok.services;

import java.util.ArrayList;
import java.util.List;

import com.kavalok.dao.PaperMessageDAO;
import com.kavalok.db.PaperMessage;
import com.kavalok.services.common.DataServiceNotTransactionBase;

public class PaperService extends DataServiceNotTransactionBase {

  public Integer getMessagesCount() {
    return new PaperMessageDAO(getSession()).size();
  }

  public List<String> getTitles(Integer size) {
    ArrayList<String> result = new ArrayList<String>();
    PaperMessageDAO dao = new PaperMessageDAO(getSession());
    Integer totalMessages = dao.size();
    List<PaperMessage> list = new PaperMessageDAO(getSession()).findAll(totalMessages - size, size);
    for (PaperMessage message : list) {
      result.add(message.getTitle());
    }
    return result;
  }

  public List<PaperMessage> getMessages(Integer size) {
    PaperMessageDAO dao = new PaperMessageDAO(getSession());
    Integer totalMessages = dao.size();
    return new PaperMessageDAO(getSession()).findAll(totalMessages - size, size);
  }

  public String getMessage(Integer index) {
    List<PaperMessage> list = new PaperMessageDAO(getSession()).findAll(index, 1);
    return list.get(0).getContent();
  }
}
