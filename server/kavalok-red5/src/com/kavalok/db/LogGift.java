package com.kavalok.db;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.annotations.Type;

@Entity
public class LogGift extends ModelBase {

  private String item;

  private String ip;

  private Long senderId;

  private String sender;

  private Long id;

  private Date created;

  private Long itemId;

  private String recipient;

  private Long recipientId;

  public LogGift() {
    super();
  }

  public LogGift(String item) {
    super();
    this.item = item;
  }

  public LogGift(String item, String ip, Long senderId, String sender, Long itemId, String recipient, Long recipientId) {
    super();
    this.item = item;
    this.ip = ip;
    this.senderId = senderId;
    this.sender = sender;
    this.itemId = itemId;
    this.recipient = recipient;
    this.recipientId = recipientId;
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

    public Long getItemId() {
    return itemId;
  }

  public void setItemId(Long itemId) {
    this.itemId = itemId;
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
