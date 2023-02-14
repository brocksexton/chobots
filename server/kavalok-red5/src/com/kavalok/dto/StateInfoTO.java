package com.kavalok.dto;

import java.util.List;

import org.red5.io.utils.ObjectMap;

public class StateInfoTO {

  private ObjectMap<String, Object> state;
  private List<String> connectedChars;
  
  public StateInfoTO(ObjectMap<String, Object> state, List<String> connectedChars) {
    super();
    this.state = state;
    this.connectedChars = connectedChars;
  }
  public ObjectMap<String, Object> getState() {
    return state;
  }
  public void setState(ObjectMap<String, Object> state) {
    this.state = state;
  }
  public List<String> getConnectedChars() {
    return connectedChars;
  }
  public void setConnectedChars(List<String> connectedChars) {
    this.connectedChars = connectedChars;
  }
  
}
