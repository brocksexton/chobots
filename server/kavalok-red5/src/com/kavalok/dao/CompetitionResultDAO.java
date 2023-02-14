package com.kavalok.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projection;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.kavalok.dao.common.DAO;
import com.kavalok.db.Competition;
import com.kavalok.db.CompetitionResult;
import com.kavalok.db.User;

public class CompetitionResultDAO extends DAO<CompetitionResult> {

    public CompetitionResultDAO(Session session) {
        super(session);
    }

    public void clearCompetition(Competition competition) {
        Query query = getSession().getNamedQuery(QueriesNames.COMPETITION_RESULT_DELETE);
        query.setEntity("competition", competition);
        query.executeUpdate();
    }

    public Integer sizeOfCompetitionResults(Competition competition) {
        ProjectionList list = getCompetitionResultProjection();
        list.add(Projections.rowCount());
        Criteria criteria = getCompetitionResultsCriteria(competition, list, false);
        criteria.setProjection(Projections.rowCount());
        return (Integer) criteria.uniqueResult();
    }

    public Object[] getCompetitionResult(Competition competition, User user) {
        Criteria criteria = getCompetitionResultsCriteria(competition, getCompetitionResultProjection(), true);
        criteria.add(Restrictions.eq("user", user));
        return (Object[]) criteria.uniqueResult();
    }

    public List<?> getCompetitionResults(Competition competition, Integer firstResult, Integer maxResults) {
        Criteria criteria = getCompetitionResultsCriteria(competition, getCompetitionResultProjection(), true);
        criteria.setFirstResult(firstResult);
        criteria.setMaxResults(maxResults);
        return criteria.list();

    }

    private Criteria getCompetitionResultsCriteria(Competition competition, Projection projection, boolean addOrderByScore) {
        Criteria criteria = createCriteria();
        criteria.add(Restrictions.eq("competition", competition));
        if (addOrderByScore)
            criteria.addOrder(Order.desc("score"));
        criteria.setProjection(projection);
        return criteria;
    }

    private ProjectionList getCompetitionResultProjection() {
        ProjectionList list = Projections.projectionList();
        list.add(Projections.groupProperty("competition"));
        list.add(Projections.groupProperty("user_id"));
        list.add(Projections.sum("score"), "score");
        list.add(Projections.property("login"));
        return list;
    }

    public Integer countByCompetitors(User user, User competitor, Competition competition) {
        Criteria criteria = createCriteria();
        criteria.add(Restrictions.eq("user", user));
        criteria.add(Restrictions.eq("competitor", competitor));
        criteria.add(Restrictions.eq("competition", competition));
        criteria.setProjection(Projections.rowCount());
        return (Integer) criteria.uniqueResult();
    }


}
