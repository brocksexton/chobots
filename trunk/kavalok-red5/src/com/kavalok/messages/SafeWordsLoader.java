package com.kavalok.messages;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.AllowedWordDAO;
import com.kavalok.db.AllowedWord;
import com.kavalok.transactions.ISessionDependent;

public class SafeWordsLoader implements ISessionDependent {

  private Session session;

  private HashMap<MessageSafety, List<String>> words;

  public SafeWordsLoader(HashMap<MessageSafety, List<String>> words) {
    this.words = words;
  }

  public void load() {
    List<AllowedWord> allowedWords = new AllowedWordDAO(session).findAll();

    ArrayList<String> allowedWordsValues = new ArrayList<String>();
    for (AllowedWord allowedWord : allowedWords)
      allowedWordsValues.add(allowedWord.getWord());
    words.put(MessageSafety.SAFE, allowedWordsValues);
  }

  @Override
  public void setSession(Session session) {
    this.session = session;

  }

}
