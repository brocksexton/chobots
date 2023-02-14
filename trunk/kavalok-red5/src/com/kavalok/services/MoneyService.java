package com.kavalok.services;

import java.util.LinkedHashMap;

import com.kavalok.dao.GameCharDAO;
import com.kavalok.db.GameChar;
import com.kavalok.db.User;
import com.kavalok.messages.UsersCache;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.services.common.SimpleEncryptor;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class MoneyService extends DataServiceNotTransactionBase {

    private static final Double INVITED_MULTIPLIER = 0.07;

    @SuppressWarnings("unchecked")
    public Byte[] addMoney(LinkedHashMap encrypted, LinkedHashMap encryptedReason) {

        UserAdapter adapter = UserManager.getInstance().getCurrentUser();
        String decrypted = null;
        try {
            decrypted = new SimpleEncryptor(adapter.getSecurityKey()).decrypt(encrypted);
        } catch (IllegalArgumentException e) {
            System.err.println(adapter.getLogin() + " tries to hack MoneyService");
            adapter.goodBye("Money Hacking", false);
        }

        String reason = new SimpleEncryptor(adapter.getSecurityKey()).decrypt(encryptedReason);

        Integer value = Integer.valueOf(decrypted);
        adapter.addMoney(getSession(), new User(adapter.getUserId()), value, reason);
        Integer invitedValue = ((Double) (value * INVITED_MULTIPLIER)).intValue();
        if (invitedValue > 0) {
            Long invitedBy = UsersCache.getInstance().getInvitedBy(adapter.getUserId(), getSession());
            if (invitedBy != null) {
                GameCharDAO gameCharDAO = new GameCharDAO(getSession());
                GameChar invitedByChar = gameCharDAO.findByUserId(invitedBy);
                invitedByChar.setMoney(invitedByChar.getMoney() + invitedValue);
                invitedByChar.setTotalMoneyEarnedByInvites(invitedByChar.getTotalMoneyEarnedByInvites() + value);
                invitedByChar.setTotalBonusMoney(invitedByChar.getTotalBonusMoney() + invitedValue);
                gameCharDAO.makePersistent(invitedByChar);
            }
        }
        return adapter.newSecurityKey();

    }

}
