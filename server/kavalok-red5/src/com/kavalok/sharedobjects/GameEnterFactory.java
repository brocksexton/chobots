package com.kavalok.sharedObjects;

import com.kavalok.utils.ISOFactory;

public class GameEnterFactory implements ISOFactory {

  private int maxChars;
  
  public GameEnterFactory(int maxChars) {
    super();
    this.maxChars = maxChars;
  }

  @Override
  public SOListener create() {
    return new GameEnterListener(maxChars);
  }

}
