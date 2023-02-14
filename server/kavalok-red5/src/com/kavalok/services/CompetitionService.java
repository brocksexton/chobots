package com.kavalok.services;

import java.util.Date;
import java.util.LinkedHashMap;

import com.kavalok.dao.CompetitionDAO;
import com.kavalok.dao.CompetitionResultDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.Competition;
import com.kavalok.db.CompetitionResult;
import com.kavalok.db.User;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.services.common.SimpleEncryptor;

public class CompetitionService extends DataServiceNotTransactionBase {

    @SuppressWarnings("unchecked")
    public Byte[] addCompetitorResult(LinkedHashMap competitorUserIdEnc, LinkedHashMap competitionNameEnc,
                                      LinkedHashMap resultEnc) {
        if(isMod()) {
            System.out.println("is mod, not giving result...");
            return null;
        }

        SimpleEncryptor encryptor = new SimpleEncryptor(getAdapter().getSecurityKey());

        Long competitorId = null;
        String competitorLogin = null;
        try {
            competitorId = new Long(encryptor.decrypt(competitorUserIdEnc));
        } catch (NumberFormatException e) {
            competitorLogin = encryptor.decrypt(competitorUserIdEnc);

        }
        String competitionName = encryptor.decrypt(competitionNameEnc);
        Double result = Double.valueOf(encryptor.decrypt(resultEnc));
        CompetitionDAO competitionDAO = new CompetitionDAO(getSession());
        Competition competition = competitionDAO.findByName(competitionName);
        if (competitionOpen(competition)) {
            UserDAO userDAO = new UserDAO(getSession());
            CompetitionResultDAO competitionResultDAO = new CompetitionResultDAO(getSession());

            User user = new User();
            user.setId(getAdapter().getUserId());
            user.setLogin(getAdapter().getLogin());
            User competitor = competitorId != null ? userDAO.findById(competitorId) : userDAO.findByLogin(competitorLogin);
            Integer count = competitionResultDAO.countByCompetitors(user, competitor, competition);
            Double newResult = result / (count + 1);
            CompetitionResult competitionResult = new CompetitionResult(user, competitor, competition, newResult);
            competitionResultDAO.makePersistent(competitionResult);
        }
        return getAdapter().newSecurityKey();
    }

    private Boolean isMod()
    {
        UserDAO ud = new UserDAO(getSession());
        User u = ud.findById(getAdapter().getUserId());

        if (u != null && u.isModerator()) {
            return true;
        }

        return false;
    }

    @SuppressWarnings("unchecked")
    public Byte[] addResult(LinkedHashMap competitionNameEnc, LinkedHashMap resultEnc) {
        if(isMod()) {
            System.out.println("is mod, not giving result...");
            return null;
        }


        SimpleEncryptor encryptor = new SimpleEncryptor(getAdapter().getSecurityKey());
        String competitionName = encryptor.decrypt(competitionNameEnc);
        Double result = Double.valueOf(encryptor.decrypt(resultEnc));

        CompetitionDAO competitionDAO = new CompetitionDAO(getSession());
        Competition competition = competitionDAO.findByName(competitionName);
        if (competitionOpen(competition)) {
            CompetitionResult competitionResult = new CompetitionResult();
            User user = new User();
            user.setId(getAdapter().getUserId());
            user.setLogin(getAdapter().getLogin());
            competitionResult.setUser(user);
            competitionResult.setLogin(getAdapter().getLogin());
            competitionResult.setCompetition(competition);
            competitionResult.setScore(result);
            new CompetitionResultDAO(getSession()).makePersistent(competitionResult);
        }
        return getAdapter().newSecurityKey();

    }

    private boolean competitionOpen(Competition competition) {
        Date now = new Date();
        return competition != null && competition.getStart().before(now) && competition.getFinish().after(now);
    }
}
