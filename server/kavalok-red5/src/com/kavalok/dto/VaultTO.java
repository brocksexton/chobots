package com.kavalok.dto;

import com.kavalok.db.Vault;

public class VaultTO {

  private int id;
  private int code;
  private String prizeType;
  private int prize;
  private int claimedById;
  private boolean enabled;

  public VaultTO(Vault vault) {
    super();
    id = vault.getId().intValue();
    code = vault.getCode();
    prizeType = vault.getPrizeType();
    prize  = vault.getPrize();
    claimedById = vault.getClaimedById();
    enabled = vault.isEnabled();
  }

  public VaultTO() {
    super();
  }

  public int getId() {
    return id;
  }
  
  public void setId(int id) {
    this.id = id;
  }
  
  public int getCode() {
    return code;
  }
  
  public void setCode(int code) {
    this.code = code;
  }
  
  public String getPrizeType() {
    return prizeType;
  }

  public void setPrizeType(String prizeType) {
    this.prizeType = prizeType;
  }
  
  public int getPrize() {
    return prize;
  }

  public void setPrize(int prize) {
    this.prize = prize;
  }
 
  public int getClaimedById() {
    return claimedById;
  }

  public void setClaimedById(int claimedById) {
    this.claimedById = claimedById;
  }
  
  public boolean isEnabled() {
    return enabled;
  }

  public void setEnabled(boolean enabled) {
    this.enabled = enabled;
  }


}
