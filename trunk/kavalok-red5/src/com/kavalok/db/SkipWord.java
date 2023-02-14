package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;

@Entity
public class SkipWord extends ModelBase {
  private String word;

  public SkipWord(String word) {
    super();
    this.word = word;
  }

  public SkipWord() {
    super();
    // TODO Auto-generated constructor stub
  }

  @NotNull
  @Column(unique = true)
  public String getWord() {
    return word;
  }

  public void setWord(String word) {
    this.word = word;
  }
}
