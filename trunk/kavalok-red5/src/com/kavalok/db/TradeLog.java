package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class TradeLog extends ModelBase {

  private String item;

  private String ip;

  private Long senderId;

  private String sender;

  private Long id;

  private Date created;

  private String recipient;

  private Long recipientId;
  
  private Integer itemID;

  public TradeLog() {
    super();
  }

  public TradeLog(String item) {
    super();
    this.item = item;
  }

  public TradeLog(String item, String ip, Long senderId, String sender, String recipient, Long recipientId, Integer itemID) {
    super();
    this.item = item;
    this.ip = ip;
    this.senderId = senderId;
    this.sender = sender;
    this.recipient = recipient;
    this.recipientId = recipientId;
	this.itemID = itemID;
  }

  @Id
  @GeneratedValue
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  @Type(type = "text")
  public String getItem() {
    return item;
  }

  public void setItem(String item) {
    this.item = item;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }
  
  public Integer getItemID(){
     return itemID;
  }
  
  public void setItemID(Integer itemID){
     this.itemID = itemID;
  }

  public Long getSenderId() {
    return senderId;
  }

  public void setSenderId(Long senderId) {
    this.senderId = senderId;
  }

  public String getSender() {
    return sender;
  }

  public void setSender(String sender) {
    this.sender = sender;
  }

    public String getRecipient() {
    return recipient;
  }

  public void setRecipient(String recipient) {
    this.recipient = recipient;
  }

  public Long getRecipientId(){
    return recipientId;
  }

  public void setRecipientId(Long recipientId)
  {
    this.recipientId = recipientId;
  }

}
