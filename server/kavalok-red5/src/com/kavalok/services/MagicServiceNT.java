package com.kavalok.services;

import java.util.Date;

import com.kavalok.dao.GameCharDAO;
import com.kavalok.db.GameChar;
import com.kavalok.services.common.DataServiceNotTransactionBase;

public class MagicServiceNT extends DataServiceNotTransactionBase {

    public Integer getMagicPeriod() {
        Long userId = getAdapter().getUserId();
        GameChar gameChar = new GameCharDAO(getSession()).findByUserId(userId);
        return getPeriod(gameChar.getMagicDate());
    }

    public Integer getLastVisit() {
        Long userId = getAdapter().getUserId();
        GameChar gameChar = new GameCharDAO(getSession()).findByUserId(userId);
        return getPeriod(gameChar.getBankVisit());
    }

    public Integer getLastDaily() {
        Long userId = getAdapter().getUserId();
        GameChar gameChar = new GameCharDAO(getSession()).findByUserId(userId);
        return getPeriod(gameChar.getLastDaily());
    }


    public void setLastDaily() {
        Long userId = getAdapter().getUserId();
        GameCharDAO charDAO = new GameCharDAO(getSession());
        GameChar gameChar = charDAO.findByUserId(userId);
        gameChar.setLastDaily(new Date());
        charDAO.makePersistent(gameChar);
    }

    public void updateMagicDate() {
        Long userId = getAdapter().getUserId();
        GameCharDAO charDAO = new GameCharDAO(getSession());
        GameChar gameChar = charDAO.findByUserId(userId);
        gameChar.setMagicDate(new Date());
        charDAO.makePersistent(gameChar);
    }

    public void setLastVisit() {
        Long userId = getAdapter().getUserId();
        GameCharDAO charDAO = new GameCharDAO(getSession());
        GameChar gameChar = charDAO.findByUserId(userId);
        gameChar.setBankVisit(new Date());
        charDAO.makePersistent(gameChar);
    }

    private Integer getPeriod(Date date) {
        Long result;
        if (date != null) {
            result = (new Date().getTime() - date.getTime()) / 1000;
        } else {
            result = -1L;
        }
        return result.intValue();
    }
}
