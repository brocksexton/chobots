package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.validator.NotNull;


@Entity
public class ReviewWord extends ModelBase {
  private String word;


  public ReviewWord() {
    super();
  }

  public ReviewWord(String word) {
    super();
    this.word = word;
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
