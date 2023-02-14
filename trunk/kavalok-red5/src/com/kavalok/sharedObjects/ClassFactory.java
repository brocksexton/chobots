package com.kavalok.sharedObjects;

import net.sf.cglib.core.ReflectUtils;

import com.kavalok.utils.ISOFactory;

public class ClassFactory implements ISOFactory {
  
  private Class<?> listenerClass;
  
  public ClassFactory(Class<?> listenerClass) {
    super();
    this.listenerClass = listenerClass;
  }

  @Override
  public SOListener create() {
    return (SOListener) ReflectUtils.newInstance(listenerClass);
  }

}
