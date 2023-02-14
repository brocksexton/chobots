package com.kavalok.dto;

public class WorldConfigTO {
  private Boolean safeModeEnabled;
  private Boolean drawingEnabled;

  public WorldConfigTO(Boolean safeModeEnabled, Boolean drawingEnabled) {
    this.safeModeEnabled = safeModeEnabled;
    this.drawingEnabled = drawingEnabled;
  }

  public WorldConfigTO() {
    super();
  }

  public Boolean getSafeModeEnabled() {
    return safeModeEnabled;
  }

  public void setSafeModeEnabled(Boolean safeModeEnabled) {
    this.safeModeEnabled = safeModeEnabled;
  }

  public Boolean getDrawingEnabled() {
    return drawingEnabled;
  }

  public void setDrawingEnabled(Boolean drawingEnabled) {
    this.drawingEnabled = drawingEnabled;
  }

}
