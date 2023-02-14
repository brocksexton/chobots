package com.kavalok.dto.stuff;

import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.db.StuffType;

public class StuffTypeAdminTO {

    private Long id;
    private String fileName;
    private Boolean hasColor;
    private Boolean doubleColor;
    private Boolean premium;
    private Boolean giftable;
    private Boolean rainable;
    private int price;
    private String shopName;
    private String type;
    private String placement;
    private String info;
    private String itemOfTheMonth;
    private int groupNum;
    private String name;
    private byte[] otherInfo;


    public StuffTypeAdminTO() {
        super();
    }

    public StuffTypeAdminTO(StuffType type) {
        this.id = type.getId();
        this.fileName = type.getFileName();
        this.hasColor = type.getHasColor();
        this.doubleColor = type.getDoubleColor();
        this.premium = type.getPremium();
        this.giftable = type.getGiftable();
        this.price = type.getPrice();
        this.shopName = type.getShop().getName();
        this.type = type.getType();
        this.placement = type.getPlacement();
        this.info = type.getInfo();
        this.itemOfTheMonth = type.getItemOfTheMonth();
        this.rainable = type.getRainable();
        this.groupNum = type.getGroupNum();
        this.name = type.getName();
        this.otherInfo = type.getOtherInfo();
    }

    public StuffTypeAdminTO(StuffTypeWrapper type) {
        this.id = type.getId();
        this.fileName = type.getFileName();
        this.hasColor = type.getHasColor();
        this.doubleColor = type.getDoubleColor();
        this.premium = type.getPremium();
        this.giftable = type.getGiftable();
        this.price = type.getPrice();
        this.shopName = type.getShopName();
        this.type = type.getType();
        this.placement = type.getPlacement();
        this.info = type.getInfo();
        this.itemOfTheMonth = type.getItemOfTheMonth();
        this.rainable = type.getRainable();
        this.groupNum = type.getGroupNum();
        this.name = type.getName();
        this.otherInfo = type.getOtherInfo();
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public Boolean getHasColor() {
        return hasColor;
    }

    public void setHasColor(Boolean hasColor) {
        this.hasColor = hasColor;
    }

    public Boolean getDoubleColor() {
        return doubleColor;
    }

    public void setDoubleColor(Boolean doubleColor) {
        this.doubleColor = doubleColor;
    }


    public Boolean getPremium() {
        return premium;
    }

    public void setPremium(Boolean premium) {
        this.premium = premium;
    }

    public Boolean getGiftable() {
        return giftable;
    }

    public void setGiftable(Boolean giftable) {
        this.giftable = giftable;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getPlacement() {
        return placement;
    }

    public void setPlacement(String placement) {
        this.placement = placement;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getItemOfTheMonth() {
        return itemOfTheMonth;
    }

    public void setItemOfTheMonth(String itemOfTheMonth) {
        this.itemOfTheMonth = itemOfTheMonth;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Boolean getRainable() {
        return rainable;
    }

    public void setRainable(Boolean rainable) {
        this.rainable = rainable;
    }

    public int getGroupNum() {
        return groupNum;
    }

    public void setGroupNum(int groupNum) {
        this.groupNum = groupNum;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public byte[] getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(byte[] otherInfo)
    {
        this.otherInfo = otherInfo;
    }
}
