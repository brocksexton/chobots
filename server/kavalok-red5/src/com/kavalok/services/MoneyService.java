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
import com.kavalok.dao.ClientErrorDAO;
import com.kavalok.db.ClientError;

public class MoneyService extends DataServiceNotTransactionBase {

    private static final Double INVITED_MULTIPLIER = 0.07;

    @SuppressWarnings("unchecked")
    public Byte[] addMoney(LinkedHashMap encrypted, LinkedHashMap encryptedReason, LinkedHashMap privKey) {
        System.err.println("Adding money...");

        UserAdapter adapter = UserManager.getInstance().getCurrentUser();
		String newPrivKey = new SimpleEncryptor(adapter.getSecurityKey()).decrypt(privKey);
		if(!getAdapter().processKey(newPrivKey, getSession(), "bugs")) {
			ClientError adminLog = new ClientError("[HACK] " + adapter.getLogin() + " tried to hack bugs", adapter.getConnection().getRemoteAddress(), adapter.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
			return null;
		}
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
	
	@SuppressWarnings("unchecked")
    public Byte[] addEmeralds(LinkedHashMap encrypted, LinkedHashMap encryptedReason, LinkedHashMap privKey) {
		
		System.err.println("Adding emeralds...");
	
        UserAdapter adapter = UserManager.getInstance().getCurrentUser();
		String newPrivKey = new SimpleEncryptor(adapter.getSecurityKey()).decrypt(privKey);
		if(!getAdapter().processKey(newPrivKey, getSession(), "emeralds")) {
			ClientError adminLog = new ClientError("[HACK] " + adapter.getLogin() + " tried to hack emeralds", adapter.getConnection().getRemoteAddress(), adapter.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
			return null;
		}
        String decrypted = null;
        try {
            decrypted = new SimpleEncryptor(adapter.getSecurityKey()).decrypt(encrypted);
        } catch (IllegalArgumentException e) {
            System.err.println(adapter.getLogin() + " tries to hack MoneyService");
            adapter.goodBye("Hacking Emeralds", false);
        }

        String reason = new SimpleEncryptor(adapter.getSecurityKey()).decrypt(encryptedReason);
		Integer value = Integer.valueOf(decrypted);
		
        adapter.addEmeralds(getSession(), new User(adapter.getUserId()), value, reason);
		return adapter.newSecurityKey();
	}

}
