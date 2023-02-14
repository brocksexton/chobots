package com.kavalok.dao;

import java.util.Date;

import org.hibernate.Session;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.SKU;

public class SKUDAO extends DAO<SKU> {

  public SKUDAO(Session session) {
    super(session);
  }

  public SKU findActiveSKU(Integer term) {
    return findActiveMemebershipSKU(term, false);
  }

  public SKU findActiveStuffSKU(Long itemTypeId) {
    return findActiveStuffSKU(itemTypeId, false);
  }

  public SKU findActiveStuffSKU(Long itemTypeId, Boolean specialOffer) {
    Date now = new Date();

    Criterion criterion = Restrictions.eq("itemTypeId", itemTypeId);
    criterion = Restrictions.and(criterion, Restrictions.eq("type", SKU.TYPE_STUFF));
    criterion = applyActiveSKUCriterion(specialOffer, now, criterion);

    return findByCriteriaUnique(criterion);
  }

  public SKU findActiveMemebershipSKU(Integer term, Boolean specialOffer) {
    Date now = new Date();

    Criterion criterion = Restrictions.eq("term", term);
    criterion = Restrictions.and(criterion, Restrictions.eq("type", SKU.TYPE_MEMBERSHIP));
    criterion = applyActiveSKUCriterion(specialOffer, now, criterion);

    return findByCriteriaUnique(criterion);
  }

  private Criterion applyActiveSKUCriterion(Boolean specialOffer, Date now, Criterion criterion) {
    criterion = Restrictions.and(criterion, Restrictions.lt("startDate", now));
    criterion = Restrictions.and(criterion, Restrictions.eq("specialOffer", specialOffer));

    Criterion criterionEndDate = Restrictions.isNull("endDate");
    criterionEndDate = Restrictions.or(criterionEndDate, Restrictions.ge("endDate", now));

    criterion = Restrictions.and(criterion, criterionEndDate);
    return criterion;
  }

}
