package com.kavalok.db;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;

import org.hibernate.validator.NotNull;

import com.kavalok.dao.QueriesNames;

@Entity
@NamedQuery(name = QueriesNames.COMPETITION_RESULT_DELETE, query = "delete from CompetitionResult where competition=:competition")
public class CompetitionResult extends ModelBase {

  // update CompetitionResult c, User u set c.login = u.login where
  // c.user_id=u.id;

  private User user;

  private String login;

  private Long user_id;

  private Competition competition;

  private Double score;

  private User competitor;

  public CompetitionResult() {
    super();
  }

  public CompetitionResult(User user, User competitor, Competition competition, Double score) {
    super();
    this.user = user;
    setLogin(user.getLogin());
    this.competition = competition;
    this.score = score;
    this.competitor = competitor;
  }

  @NotNull
  @ManyToOne
  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  @NotNull
  @ManyToOne
  public Competition getCompetition() {
    return competition;
  }

  public void setCompetition(Competition competition) {
    this.competition = competition;
  }

  public Double getScore() {
    return score;
  }

  public void setScore(Double score) {
    this.score = score;
  }

  @ManyToOne
  public User getCompetitor() {
    return competitor;
  }

  public void setCompetitor(User competitor) {
    this.competitor = competitor;
  }

  @Column(insertable = false, updatable = false)
  public Long getUser_id() {
    return user_id;
  }

  public void setUser_id(Long user_id) {
    this.user_id = user_id;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

}
