package com.kavalok.messages;

public class MessageCheckResult {
  private String part;

  private MessageSafety safety;

  public MessageCheckResult(String part, MessageSafety safety) {
    super();
    this.part = part;
    this.safety = safety;
  }

  public String getPart() {
    return part;
  }

  public MessageSafety getSafety() {
    return safety;
  }

}
