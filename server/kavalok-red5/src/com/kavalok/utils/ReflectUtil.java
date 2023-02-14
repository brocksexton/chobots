package com.kavalok.utils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import net.sf.cglib.core.ReflectUtils;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.kavalok.cache.StuffTypeWrapper;
import com.kavalok.db.RobotType;
import com.kavalok.db.StuffItem;
import com.kavalok.dto.stuff.StuffItemLightTO;
import com.kavalok.dto.stuff.StuffTypeTO;

public final class ReflectUtil {

  public static Logger logger = LoggerFactory.getLogger(ReflectUtil.class);

  @SuppressWarnings("unchecked")
  public static List convertBeansByConstructor(List source, Class type) {
    ArrayList result = new ArrayList();
    for (Object item : source) {

      Object resultItem = ReflectUtils.newInstance(type, new Class[] { item.getClass() }, new Object[] { item });
      result.add(resultItem);
    }
    return result;

  }

  public static List<StuffItemLightTO> convertBeansByConstructorStuffItemLightTO(List<StuffItem> source) {
    ArrayList<StuffItemLightTO> result = new ArrayList<StuffItemLightTO>();
    for (Object item : source) {

      StuffItemLightTO resultItem = new StuffItemLightTO((StuffItem) item);
      result.add(resultItem);
    }
    return result;

  }

  @SuppressWarnings("unchecked")
  public static List convertBeans(List source, Class type) {
    List result = new ArrayList();
    if (StuffTypeTO.class.equals(type)) {
      return convertStuffType(source);
    }

    for (Object item : source) {
      Object resultItem;
      try {
        resultItem = ReflectUtils.newInstance(type);
        BeanUtils.copyProperties(resultItem, item);
        result.add(resultItem);
      } catch (Exception e) {
        logger.error(e.getMessage(), e);
      }
    }
    return result;
  }

  @SuppressWarnings("unchecked")
  private static List convertStuffType(List source) {
    List result = new ArrayList();
    for (int i = 0; i < source.size(); i++) {
      Object sourceObject = source.get(i);
      StuffTypeTO resultItem;
      if (sourceObject instanceof RobotType) {
        resultItem = new StuffTypeTO((RobotType) sourceObject);
      } else {
        resultItem = new StuffTypeTO((StuffTypeWrapper) sourceObject);
      }
      result.add(resultItem);
    }
    return result;
  }

  @SuppressWarnings("unchecked")
  public static String getRootPath(Class type) {
    String classFile = type.getSimpleName() + ".class";
    URL url = type.getResource(classFile);
    String classPath = type.getName().replace(".", "/") + ".class";
    String result = url.getFile().replace(classPath, "");
    return result;
  }

  public static Object callMethod(Object context, String methodName, Collection<Object> args)
      throws NoSuchMethodException, IllegalAccessException, InvocationTargetException {
    List<Class<?>> argsTypes = getTypes(args);

    Method method = context.getClass().getMethod(methodName, (Class<?>[]) argsTypes.toArray(new Class<?>[] {}));
    return method.invoke(context, args.toArray());
  }

  public static Object callGetter(Object context, String property) throws NoSuchMethodException,
      IllegalAccessException, InvocationTargetException {

    String getterName = "get" + property.substring(0, 1).toUpperCase() + property.substring(1);
    Method method = context.getClass().getMethod(getterName);
    return method.invoke(context);
  }

  private static List<Class<?>> getTypes(Collection<Object> args) {
    List<Class<?>> argsTypes = new ArrayList<Class<?>>();
    for (Object arg : args) {
      if (arg == null) {
        argsTypes.add(Object.class);
      } else {
        argsTypes.add(arg.getClass());
      }
    }
    return argsTypes;
  }
}
