package com.kavalok.dao.common;

import java.util.List;

public interface IDAO<T> {

  T findById(Long id, boolean lock);

  List<T> findAll();

  List<T> findByExample(T exampleInstance, String[] excludeProperty);

  T makePersistent(T entity);

  void makeTransient(T entity);
}