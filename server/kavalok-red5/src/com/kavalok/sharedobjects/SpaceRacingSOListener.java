package com.kavalok.sharedObjects;

import java.util.ArrayList;
import java.util.List;

import org.red5.server.api.so.ISharedObjectBase;

import com.kavalok.sharedObjects.spaceRacing.SpaceItem;

public class SpaceRacingSOListener extends SOListener {
  
  private static final Integer PAGE_COUNT = 50;
  private static final Integer OBJECTS_PER_PAGE = 3;
  private static final Integer OBJECTS_COUNT = 8;
  private static final Integer WIDTH = 900;
  private static final Integer HEIGHT = 510;
  private static final String CLIENT_ID = "GameStage";

  private List<String> readyPlayers = new ArrayList<String>();

  private boolean mapCreated = false;

  public SpaceRacingSOListener() {
    super();
  }
  
  public boolean rSetReady()
  {
    readyPlayers.add(getCharId());
    trySendMap();
    return true;
  }
  
  
  
  @Override
  public void onSharedObjectDisconnect(ISharedObjectBase sharedObject) {
    super.onSharedObjectDisconnect(sharedObject);
    if(readyPlayers.contains(getCharId()))
      readyPlayers.remove(getCharId());
    trySendMap();
  }
  
  private void trySendMap()
  {
    if(mapCreated) 
      return;
    if(readyPlayers.size() == connectedUsers.size())
    {
      sendMap();
    }
    
  }
  private void sendMap()
  {

    List<SpaceItem> map = new ArrayList<SpaceItem>();
                     
    int objCount = OBJECTS_PER_PAGE * PAGE_COUNT;
     
    for (int i = 0; i < objCount; i++)
    {
      int objNum = toInt(Math.random() * OBJECTS_COUNT);
      int x = toInt(Math.random() * WIDTH);
      int y = toInt(- Math.random() * (HEIGHT * PAGE_COUNT - 2 * HEIGHT) - HEIGHT);
         
      map.add(new SpaceItem(objNum, x , y));
    }
     
    callClient(CLIENT_ID, "rMap", map);
  }
  
  private int toInt(Double value)
  {
    return value.intValue();
  }
  
}
