package com.kavalok.sharedObjects;

import java.util.ArrayList;
import java.util.HashMap;

import org.hibernate.Session;

import com.kavalok.dao.GameCharDAO;
import com.kavalok.dao.StuffItemDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.StuffItem;
import com.kavalok.db.User;
import com.kavalok.dto.stuff.StuffItemLightTO;
import com.kavalok.transactions.ISessionDependent;
import com.kavalok.transactions.TransactionUtil;

public class TradeListener extends SOListener implements ISessionDependent {

  private HashMap<String, ArrayList<Integer>> items = new HashMap<String, ArrayList<Integer>>();
  private ArrayList<String> acceptedChars = new ArrayList<String>();
  private Session session;
  
  public TradeListener() {
    super();
  }
  
  
  @Override
  public void setSession(Session session) {
    this.session = session;
    
  }
  public boolean rRemoveItem(String owner, StuffItemLightTO item)
  {
    if(acceptedChars.size() > 0 || !hasItem(item))
      return true;
    ArrayList<Integer> charItems = items.get(getCharId());
    charItems.remove(new Integer(item.getId().intValue()));
    return false;
  }
  public boolean rAddItem(String owner, StuffItemLightTO item)
  {
    
    if(acceptedChars.size() > 0 || hasItem(item))
      return true;
    if(items.get(getCharId()) == null)
    {
      items.put(getCharId(), new ArrayList<Integer>());
    }
    ArrayList<Integer> charItems = items.get(getCharId());
    charItems.add(item.getId().intValue());
    return false;
  }
  
  public boolean rAccept(String charId)
  {
    String login = getCharId();
    if(acceptedChars.contains(login))
      throw new IllegalStateException("User " + login + " is trying to hack the trade");
    
    acceptedChars.add(login);
    if(acceptedChars.size() == 2)
    {
      processTrade();
    }
    return false;
  }

  private boolean hasItem(StuffItemLightTO item) {
    for(ArrayList<Integer> list : items.values())
    {
      for(int id : list)
      {
        if(id == item.getId().intValue())
          return true;
      }
    }
    return false;
  }
  private void processTrade() {
     TransactionUtil.callTransaction(this, "doProcessTrade", new ArrayList<Object>());
     
  }

  public void doProcessTrade() {
    UserDAO userDAO = new UserDAO(session);
    for(String login : acceptedChars)
    {
      User user = userDAO.findByLogin(login);
      for(String traderLogin : items.keySet())
      {
        if(!traderLogin.equals(login))
        {
          User trader = userDAO.findByLogin(traderLogin);
          ArrayList<Integer> traderItems = items.get(traderLogin);
          moveItems(user.getGameChar(), trader.getGameChar(), traderItems);
        }
      }
      
    }
  }


  private void moveItems(GameChar to, GameChar from, ArrayList<Integer> ids) {
    System.out.println("moving items, trade done ");
    StuffItemDAO stuffItemDAO = new StuffItemDAO(session);
    for(Integer id : ids)
    {
      boolean processed = false;
      for(StuffItem item : from.getStuffItems())
      {
        if(item.getId().intValue() == id)
        {
          item.setX(0);
          item.setY(0);
          item.setGameChar(to);
          stuffItemDAO.makePersistent(item);
          processed = true;
          System.out.println("an item was processed, moved item from one user to another..");
        }
      }
      if(!processed)
        throw new IllegalStateException("user " + from.getLogin() + " doesnt have the item with id " + id);
    }
    GameCharDAO dao = new GameCharDAO(session);
    dao.makePersistent(to);
    dao.makePersistent(from);
  }



}
