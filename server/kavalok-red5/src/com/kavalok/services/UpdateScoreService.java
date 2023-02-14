package com.kavalok.services;

import java.util.LinkedHashMap;

import com.kavalok.dao.TopScoreDAO;
import com.kavalok.db.GameChar;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.services.common.SimpleEncryptor;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;

public class UpdateScoreService extends DataServiceNotTransactionBase {

  @SuppressWarnings("unchecked")
  public Byte[] updateScore(LinkedHashMap encryptedScoreId, LinkedHashMap encryptedScore) {
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();
    
    String scoreId = new SimpleEncryptor(adapter.getSecurityKey()).decrypt(encryptedScoreId);
    Double score = Double.valueOf(new SimpleEncryptor(adapter.getSecurityKey()).decrypt(encryptedScore));

    if (adapter.getPersistent()) {
    	GameChar gameChar = adapter.getChar(getSession());
    	TopScoreDAO scoreDAO = new TopScoreDAO(getSession());
    	scoreDAO.setScore(gameChar, scoreId, score);
    }
    
    return adapter.newSecurityKey();
  }

}
