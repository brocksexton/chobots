package com.kavalok.sharedObjects;

import java.util.Timer;
import java.util.TimerTask;

public class NichosRopeTimer extends TimerTask {

  private NichosRopeSOListener listener;

  private Timer timer;

  public NichosRopeTimer(Timer timer, NichosRopeSOListener listener) {
    this.listener = listener;
    this.timer = timer;
  }

  @Override
  public void run() {
    timer.cancel();
    listener.moveRope();
    if (!listener.stopTimer) {
      Timer timer = new Timer("NichosRopeSOListener timer");
      NichosRopeTimer nichosRopeTimer = new NichosRopeTimer(timer, this.listener);
      timer.schedule(nichosRopeTimer, 200);
    }
  }

}
