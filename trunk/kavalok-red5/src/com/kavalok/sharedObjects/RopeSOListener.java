package com.kavalok.sharedObjects;


public class RopeSOListener extends SOListener {

  private static final String RIGH_TEAM = "Right";
  private static final String LEFT_TEAM = "Left";
  private static final float MAX_ROPE_POSITION = 30;
  private static final String ID = "RopeEntryPoint";

  private float currentPosition = 0;
  
  public RopeSOListener() {
    super();
    
  }

  public Boolean rMoveRope(Integer diff)
  {
    currentPosition += diff;
    callClient(ID, "rSetRopePosition", currentPosition);
    if(Math.abs(currentPosition) > MAX_ROPE_POSITION)
    {
      String team = currentPosition > 0 ? RIGH_TEAM : LEFT_TEAM;
      callClient(ID, "rEndGame", team);
      currentPosition = 0;
      callClient(ID, "rSetRopePosition", currentPosition);
    }
    return true;
  }
  

}
