package com.kavalok.dto.home;

import java.util.ArrayList;
import java.util.List;

import com.kavalok.dto.stuff.StuffItemLightTO;
import com.kavalok.dto.stuff.StuffTypeTO;

public class CharHomeTO {
	
	private List<StuffTypeTO> items = new ArrayList<StuffTypeTO>();

	private List<StuffItemLightTO> furniture = new ArrayList<StuffItemLightTO>();

	private Boolean citizen;
	
	private Boolean robotExists;

  private Integer rep;

  private String crit;

  public List<StuffTypeTO> getItems() {
    return items;
  }

  public void setItems(List<StuffTypeTO> items) {
    this.items = items;
  }

  public List<StuffItemLightTO> getFurniture() {
    return furniture;
  }

  public void setFurniture(List<StuffItemLightTO> furniture) {
    this.furniture = furniture;
  }

  public Boolean getCitizen() {
    return citizen;
  }

  public void setCitizen(Boolean citizen) {
    this.citizen = citizen;
  }

public Boolean getRobotExists() {
	return robotExists;
}

public String crit(){
  return crit;
}

public void setCrit(String crit){
  this.crit = crit;
}

public void setRobotExists(Boolean robotExists) {
	this.robotExists = robotExists;
}

public void setRep(int rep)
{
  this.rep = rep;
}

public Integer getRep(){
  return rep;
}

}
