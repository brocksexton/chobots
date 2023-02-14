package com.kavalok.db;

import com.kavalok.utils.HibernateUtil;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Transient;

@Entity
public class LocationInfo extends ModelBase {

    private String name;

    private String hash;

    public LocationInfo() {
        super();
    }


    @Column(unique = true)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHash() {
        return hash;
    }

    public void setHash(String hash) {
        this.hash = hash;
    }


}
