package com.kavalok.dao.statistics;

import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.statistics.ServerStatistics;

public class ServerStatisticsDAO extends DAO<ServerStatistics> {

  public ServerStatisticsDAO(Session session) {
    super(session);
  }
  
  @SuppressWarnings("unchecked")
  public List<Object[]> findByDates(Date minDate, Date maxDate)
  {
    Criteria criteria = createCriteria();
    ProjectionList list = Projections.projectionList();
    list.add(Projections.groupProperty("server"));
    list.add(Projections.avg("usersCount"));
    criteria.setProjection(list);
    criteria.add(Restrictions.le("created", maxDate));
    criteria.add(Restrictions.ge("created", minDate));
    return criteria.list();
    
  }

}
