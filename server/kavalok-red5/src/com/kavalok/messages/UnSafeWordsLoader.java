package com.kavalok.messages;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Session;

import com.kavalok.dao.BlockWordDAO;
import com.kavalok.dao.ReviewWordDAO;
import com.kavalok.dao.SkipWordDAO;
import com.kavalok.db.BlockWord;
import com.kavalok.db.ReviewWord;
import com.kavalok.db.SkipWord;
import com.kavalok.transactions.ISessionDependent;

public class UnSafeWordsLoader implements ISessionDependent {

  private Session session;

  private HashMap<MessageSafety, List<String>> words;

  public UnSafeWordsLoader(HashMap<MessageSafety, List<String>> words) {
    this.words = words;
  }

  public void load() {
    //TODO : refactor this duplications
    List<BlockWord> blockWords = new BlockWordDAO(session).findAll();
    ArrayList<String> blockWordsValues = new ArrayList<String>();
    for(BlockWord blockWord : blockWords)
      blockWordsValues.add(blockWord.getWord());
    words.put(MessageSafety.BAD, blockWordsValues);

    List<SkipWord> skipWords = new SkipWordDAO(session).findAll();
    ArrayList<String> skipWordsValues = new ArrayList<String>();
    for(SkipWord skipWord : skipWords)
      skipWordsValues.add(skipWord.getWord());
    words.put(MessageSafety.SKIP, skipWordsValues);

    List<ReviewWord> reviewWords = new ReviewWordDAO(session).findAll();
    ArrayList<String> reviewWordsValues = new ArrayList<String>();
    for(ReviewWord reviewWord : reviewWords)
      reviewWordsValues.add(reviewWord.getWord());
    words.put(MessageSafety.REVIEW, reviewWordsValues);
  }

  @Override
  public void setSession(Session session) {
    this.session = session;

  }

}
