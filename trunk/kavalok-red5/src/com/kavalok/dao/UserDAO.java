package com.kavalok.dao;

import java.sql.SQLException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.kavalok.db.GameChar;
import com.kavalok.db.Partner;
import com.kavalok.db.RobotTeam;
import com.kavalok.db.Crew;
import com.kavalok.db.Server;
import com.kavalok.db.StuffItem;
import com.kavalok.db.User;
import com.kavalok.db.ModeratorLog;
import com.kavalok.dto.CharTOCache;
import com.kavalok.services.LoginService;

public class UserDAO extends LoginDAOBase<User> {

  
  public UserDAO(Session session) {
    super(session);
  }

  public void addServerNotNullRestriction(Criteria criteria) {
    criteria.add(Restrictions.isNotNull("server"));
  }

  public void addServerIdRestriction(Long id, Criteria criteria) {
    Criteria serverCriteria = criteria.createCriteria("server");
    serverCriteria.add(Restrictions.eq("id", id));
  }

  public Criteria createUserCriteria() {
    return createCriteria();
  }

  public Integer getRegisrations(Date minDate, Date maxDate) {
    Criteria criteria = createCriteria(minDate, maxDate);
    return (Integer) criteria.uniqueResult();
  }

  private Criteria createCriteria(Date minDate, Date maxDate) {
    Criteria criteria = createCriteria();
    criteria.setProjection(Projections.rowCount());
    criteria.add(Restrictions.between("created", minDate, maxDate));
    return criteria;
  }

  public Integer getActivations(Date minDate, Date maxDate) {
    Criteria criteria = createCriteria(minDate, maxDate);
    criteria.add(Restrictions.or(Restrictions.isNull("activationKey"), Restrictions.eq("activated", true)));
    return (Integer) criteria.uniqueResult();
  }

  public Integer countByPrefix(String prefix) {
    Criteria criteria = createCriteria();
    criteria.setProjection(Projections.rowCount());
    criteria.add(Restrictions.like("login", prefix + "%"));
    return (Integer) criteria.uniqueResult();
  }

  public User findNotLogedByPrefix(String prefix) {
    Criteria criteria = createCriteria();
    criteria.add(Restrictions.isNull("server"));
    criteria.add(Restrictions.like("login", prefix + "%"));
    criteria.setMaxResults(1);
    return (User) criteria.uniqueResult();
  }

  public Integer sizeByReferrer(Partner referrer) {
    Criteria criteria = createReferrerCriteria(referrer);
    criteria.setProjection(Projections.rowCount());
    addPartnerRestriction(criteria, referrer);
    return (Integer) criteria.uniqueResult();
  }

  public Integer sizeByReferrer(Partner referrer, Date from, Date to) {
    Criteria criteria = createReferrerCriteria(referrer);
    criteria.setProjection(Projections.rowCount());
    addPartnerRestriction(criteria, referrer);
    addCreatedRectriction(from, to, criteria);
    return (Integer) criteria.uniqueResult();
  }

  @SuppressWarnings("unchecked")
  public List<User> findByPartner(Partner partner, Date from, Date to, Integer firstResult, Integer maxResults) {
    Criteria criteria = createCriteria();
    addCreatedRectriction(from, to, criteria);
    criteria = criteria.createCriteria("marketingInfo");
    addPartnerRestriction(criteria, partner);
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    return criteria.list();
  }

  public void setSizeProjection(Criteria criteria) {
    criteria.setProjection(Projections.rowCount());
  }

  private void addCreatedRectriction(Date from, Date to, Criteria criteria) {
    criteria.add(Restrictions.between("created", from, to));
  }

  @SuppressWarnings("unchecked")
  public List<User> findByReferrer(Partner referrer, Integer firstResult, Integer maxResults) {
    Criteria criteria = createReferrerCriteria(referrer, firstResult, maxResults);
    return criteria.list();
  }

  private void addPartnerRestriction(Criteria criteria, Partner partner) {
    criteria.add(Restrictions.eq("partner", partner));
  }

  private Criteria createReferrerCriteria(Partner referrer, Integer firstResult, Integer maxResults) {
    Criteria criteria = createReferrerCriteria(referrer);
    criteria.setFirstResult(firstResult);
    criteria.setMaxResults(maxResults);
    return criteria;
  }

  private Criteria createReferrerCriteria(Partner referrer) {
    Criteria criteria = createCriteria().createCriteria("marketingInfo");
    addPartnerRestriction(criteria, referrer);
    return criteria;
  }

  public List<User> findParents() {
    return findAllByParameter("parent", true);
  }

    public List<User> findModerators() {
    return findAllByParameter("moderator", true);
  }
    public List<User> findAgents() {
    return findAllByParameter("agent", true);
  }
      public List<User> findJournalists() {
    return findAllByParameter("journalist", true);
  }

  @SuppressWarnings("unchecked")
  public List<User> findByEmail(String email, boolean skipDeleted) {
    String[] names = { "email", "deleted" };
    Object[] values = { email, !skipDeleted };
    Order order = Order.asc("login");

    Criteria criteria = createCriteria(names, values, order);

    return criteria.list();
  }

  public User findParentByEmail(String email) {
    return findByParameters(new String[] { "email", "parent" }, new Object[] { email, true });
  }

  public Integer countByServer(Server value) {
    Criteria criteria = createCriteria(new String[] { "server" }, new Object[] { value });
    criteria.setProjection(Projections.rowCount());
    return (Integer) criteria.uniqueResult();
  }

  public List<User> findByServer(Server value) {
    return findAllByParameter("server", value);
  }

  @SuppressWarnings("unchecked")
  public User getGuest() {

    String[] names = { "email" };
    Object[] values = { LoginService.GUEST_EMAIL };

    Criteria criteria = createCriteria(names, values);

    List<User> users = criteria.list();
    int counter = 0;

    User guest = null;

    UserServerDAO usDAO = new UserServerDAO(getSession());

    for (User user : users) {
      counter++;
      if (usDAO.getUserServer(user) == null) {
        guest = user;
        break;
      }
    }

    GameCharDAO gameCharDAO = new GameCharDAO(getSession());
    if (guest == null) {
      GameChar gameChar = new GameChar();
      gameChar.setBody("default");
      gameCharDAO.makePersistent(gameChar);

      String login = "guest" + Integer.valueOf(counter);
      guest = new User(login, "");
      guest.setEmail("GUEST");
      guest.setGameChar(gameChar);
      guest.setParent(false);
      guest.setGuest(true);
      guest.setActivationKey("");
      makePersistent(guest);
      gameChar.setUserId(guest.getId());
      gameCharDAO.makePersistent(gameChar);

    } else {
      GameChar gameChar = guest.getGameChar();

      StuffItemDAO itemDAO = new StuffItemDAO(getSession());
      List<StuffItem> items = gameChar.getStuffItems();
      for (StuffItem item : items) {
        item.setGameChar(null);
        itemDAO.makePersistent(item);
      }

      gameChar.setMoney(0d);
      gameChar.setColor((new Random()).nextInt(0xFFFFFF));
      gameCharDAO.makePersistent(gameChar);
    }

    return guest;
  }

  public void removeFriendship(Long userId, Long friendId) throws HibernateException, SQLException {
    String sqlQuery = "delete from User_User where (User_id=%1$d and friends_id=%2$d) "
        + "or (User_id=%2$d and friends_id=%1$d)";
    sqlQuery = String.format(sqlQuery, userId, friendId);
    SQLQuery query = getSession().createSQLQuery(sqlQuery);
    query.executeUpdate();

  }
 
 
 public void addToBuddyList(Integer mainID, Integer otherID) throws HibernateException, SQLException{
 //String sqlQuery = "insert into User_User where (User_id=%1$d and friends_id=%2$d) "
        //+ "or (User_id=%2$d and friends_id=%1$d)";
 String sqlQuery = "insert into User_User (User_id, friends_id) VALUES ('%2$d', '%1$d')";
    sqlQuery = String.format(sqlQuery, mainID, otherID);
    SQLQuery query = getSession().createSQLQuery(sqlQuery);
    query.executeUpdate();
 String sqlQueryy = "insert into User_User (User_id, friends_id) VALUES ('%1$d', '%2$d')";
    sqlQueryy = String.format(sqlQueryy, mainID, otherID);
    SQLQuery queryy = getSession().createSQLQuery(sqlQueryy);
    queryy.executeUpdate();
 }
 
 public void updateM(String update, Long pID) throws HibernateException, SQLException{
    String sqlQuery = "insert into ModeratorLog (message, panelId) VALUES ('%1$d', '%2$d')";
    sqlQuery = String.format(sqlQuery, update, pID);
    SQLQuery query = getSession().createSQLQuery(sqlQuery);
    query.executeUpdate();
  }

  public void clearServerId(List<Long> ids) throws HibernateException, SQLException {
    String sqlQuery = "delete from UserServer where userId in (%1s)";
    StringBuffer idsList = new StringBuffer();
    for (Iterator<Long> iterator = ids.iterator(); iterator.hasNext();) {
      Long userId = iterator.next();
      idsList.append(userId);
      if (ids.size() > 1 && iterator.hasNext()) {
        idsList.append(",");
      }
    }
    sqlQuery = String.format(sqlQuery, idsList.toString());
    SQLQuery query = getSession().createSQLQuery(sqlQuery);
    query.executeUpdate();
  }

  @Override
  public User makePersistent(User entity) {
    CharTOCache.getInstance().removeCharTO(entity.getId());
    CharTOCache.getInstance().removeCharTO(entity.getLogin());
    return super.makePersistent(entity);
  }

  public List<User> findByRobotTeam(RobotTeam robotTeam) {
    return findAllByParameter("robotTeam", robotTeam);
  }

  public List<User> findByCrew(Crew crew){
    return findAllByParameter("crew", crew);
  }

}
