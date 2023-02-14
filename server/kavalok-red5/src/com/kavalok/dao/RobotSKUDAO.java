package com.kavalok.dao;

import java.util.Date;

import org.hibernate.Session;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.RobotSKU;
import com.kavalok.db.RobotType;

public class RobotSKUDAO extends DAO<RobotSKU> {

  public RobotSKUDAO(Session session) {
    super(session);
  }

  public RobotSKU findActiveSKU(RobotType robotType) {
    return findActiveSKU(robotType, false);
  }

  public RobotSKU findActiveSKU(RobotType robotType, Boolean specialOffer) {
    Date now = new Date();

    Criterion criterion = Restrictions.eq("robotType", robotType);
    criterion = Restrictions.and(criterion, Restrictions.lt("startDate", now));
    criterion = Restrictions.and(criterion, Restrictions.eq("specialOffer", specialOffer));

    Criterion criterionEndDate = Restrictions.isNull("endDate");
    criterionEndDate = Restrictions.or(criterionEndDate, Restrictions.ge("endDate", now));

    criterion = Restrictions.and(criterion, criterionEndDate);

    return findByCriteriaUnique(criterion);
  }

}
