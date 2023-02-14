package com.kavalok.dao;

import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.News;

public class NewsDAO extends DAO<News> {

  public NewsDAO(Session session) {
    super(session);
  }

 /* public List<Server> findAvailable() {
    return findAllByParameters(new String[] { "available", "running" }, new Object[] { true, true });
  }
*/
  public List<News> findShowing() {
    return findAllByParameter("show", true);
  }

  public News findByInfo(String info) {
    return findByParameter("info", info);
}
  public News findByNum(Integer num) {
    return findByParameter("num", num);
}

  public News findByImage(String image) {
    return findByParameter("image", image);
  }

}
