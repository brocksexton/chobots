package com.kavalok.dto;

import java.util.Date;

import com.kavalok.db.Competition;

public class CompetitionResultTO {

  private String competitionName;

  private Date finish;

  private String login;

  private Double score;

  public CompetitionResultTO(Object[] source) {
    Competition competition = (Competition) source[0];
    competitionName = competition.getName();
    finish = competition.getFinish();
    login = ((String) source[3]);
    score = (Double) source[2];
  }

  public CompetitionResultTO() {
    super();
  }

  public CompetitionResultTO(String competitionName, Date finish, String login, Double score) {
    super();
    this.competitionName = competitionName;
    this.finish = finish;
    this.login = login;
    this.score = score;
  }

  public String getCompetitionName() {
    return competitionName;
  }

  public void setCompetitionName(String competitionName) {
    this.competitionName = competitionName;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

  public Double getScore() {
    return score;
  }

  public void setScore(Double score) {
    this.score = score;
  }

  public Date getFinish() {
    return finish;
  }

  public void setFinish(Date finish) {
    this.finish = finish;
  }

}
