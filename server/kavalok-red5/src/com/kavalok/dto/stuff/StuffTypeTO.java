package com.kavalok.dto.stuff;

import com.kavalok.KavalokApplication;
import com.mysql.jdbc.Blob;
import org.red5.io.utils.ObjectMap;

import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.db.RobotType;
import com.kavalok.db.StuffType;
import com.kavalok.services.stuff.StuffTypes;

public class StuffTypeTO extends StuffTOBase {

    private Integer count;
    private String placement;
    private Boolean enabled = true;
    private Boolean premium;
    private String otherInfo;
    private ObjectMap<String, Object> robotInfo;
    private ObjectMap<String, Object> skuInfo;

    public StuffTypeTO() {
        super();
    }

    public StuffTypeTO(RobotType type) {
        super();
        setId(type.getId());
        setFileName(type.getName());
        setType(StuffTypes.ROBOT);
        setName(type.getName());
        setPrice(type.getPrice());
        setHasColor(type.getHasColor());
        setPlacement(type.getPlacement());
        setPremium(type.getPremium());
    }

    public StuffTypeTO(StuffType type) {
        super();
        setId(type.getId());
        setFileName(type.getFileName());
        setType(type.getType());
        setName(type.getName());
        setPrice(type.getPrice());
		setPrice(type.getEmeralds());
        setHasColor(type.getHasColor());
        setDoubleColor(type.getDoubleColor());
        this.placement = type.getPlacement();
        this.premium = type.getPremium();
        setOtherInfo(type.getOtherInfo());

      //  KavalokApplication.logger.warn("otherInfo bytes length  : > " + otherInfo.length);

    }

    public StuffTypeTO(StuffTypeWrapper type) {
        super();
        setId(type.getId());
        setOtherInfo(type.getOtherInfo());
        setFileName(type.getFileName());
        setType(type.getType());
        setName(type.getName());
        setPrice(type.getPrice());
		setEmeralds(type.getEmeralds());
        setHasColor(type.getHasColor());
        setDoubleColor(type.getDoubleColor());
        this.placement = type.getPlacement();
        this.premium = type.getPremium();

//        KavalokApplication.logger.warn("otherInfo bytes length  : > " + otherInfo.length);

    }

    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

    public String getPlacement() {
        return placement;
    }

    public void setPlacement(String placement) {
        this.placement = placement;
    }

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }


    public Boolean getPremium() {
        return premium;
    }

    public void setPremium(Boolean premium) {
        this.premium = premium;
    }

    public ObjectMap<String, Object> getRobotInfo() {
        return robotInfo;
    }

    public void setRobotInfo(ObjectMap<String, Object> robotInfo) {
        this.robotInfo = robotInfo;
    }

    public ObjectMap<String, Object> getSkuInfo() {
        return skuInfo;
    }

    public void setSkuInfo(ObjectMap<String, Object> skuInfo) {
        this.skuInfo = skuInfo;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }
}
