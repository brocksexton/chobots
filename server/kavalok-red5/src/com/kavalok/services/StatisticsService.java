package com.kavalok.services;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.kavalok.billing.transaction.TransactionConstants;
import com.kavalok.dao.MembershipHistoryDAO;
import com.kavalok.dao.RobotTransactionDAO;
import com.kavalok.dao.StuffItemDAO;
import com.kavalok.dao.TransactionDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.dao.statistics.LoginStatisticsDAO;
import com.kavalok.dao.statistics.MoneyStatisticsDAO;
import com.kavalok.dao.statistics.ServerStatisticsDAO;
import com.kavalok.db.RobotTransaction;
import com.kavalok.db.Server;
import com.kavalok.db.StuffItem;
import com.kavalok.db.Transaction;
import com.kavalok.db.User;
import com.kavalok.dto.ChartStatisticsTO;
import com.kavalok.dto.LoginStatisticsTO;
import com.kavalok.dto.MoneyEarnedTO;
import com.kavalok.dto.PagedResult;
import com.kavalok.dto.PurchaseStatisticsTO;
import com.kavalok.dto.ServerStatisticsTO;
import com.kavalok.dto.TransactionStatisticsTO;
import com.kavalok.dto.UserLoginStatisticsTO;
import com.kavalok.dto.admin.ActivationStatisticsTO;
import com.kavalok.dto.statistics.MembersAgeTO;
import com.kavalok.permissions.AccessPartner;
import com.kavalok.services.common.DataServiceNotTransactionBase;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;
import com.kavalok.utils.ReflectUtil;

public class StatisticsService extends DataServiceNotTransactionBase {

  public PagedResult<MoneyEarnedTO> getMoneyEarned(Date minDate, Date maxDate, Integer firstResult, Integer maxResults) {
    List<MoneyEarnedTO> result = new ArrayList<MoneyEarnedTO>();
    MoneyStatisticsDAO dao = new MoneyStatisticsDAO(getSession());
    for (Object[] objects : dao.find(minDate, maxDate, firstResult, maxResults)) {
      User user = (User) objects[0];
      Long money = (Long) objects[1];
      result.add(new MoneyEarnedTO(user.getLogin(), money.intValue()));
    }
    return new PagedResult<MoneyEarnedTO>(dao.getCount(minDate, maxDate), result);
  }

  @SuppressWarnings("unchecked")
  public List<MembersAgeTO> getMembersAge(Date from, Date to, Integer period) {
    MembershipHistoryDAO historyDAO = new MembershipHistoryDAO(getSession());
    return ReflectUtil.convertBeansByConstructor(historyDAO.countByUserAge(from, to, period), MembersAgeTO.class);
  }

  public List<PurchaseStatisticsTO> getPurchaseStatistics(Date minDate, Date maxDate) {
    List<PurchaseStatisticsTO> result = new ArrayList<PurchaseStatisticsTO>();
    for (Object[] objects : new StuffItemDAO(getSession()).findForDates(minDate, maxDate)) {
      StuffItem item = (StuffItem) objects[0];
      Long count = (Long) objects[1];
      result.add(new PurchaseStatisticsTO(item.getType().getFileName(), count.intValue()));
    }
    return result;
  }

  public LoginStatisticsTO getTotalLogins(Date minDate, Date maxDate) {
    LoginStatisticsDAO dao = new LoginStatisticsDAO(getSession());
    Object[] args = dao.findForAll(minDate, maxDate);
    Long seconds = (Long) args[0];
    Integer loginCount = ((Long) args[1]).intValue();
    Integer avgSessionTime = dao.getAverageTime(minDate, maxDate);
    return new LoginStatisticsTO(seconds, avgSessionTime, loginCount);

  }

  public List<ActivationStatisticsTO> getActivationChart(Date minDate, Date maxDate, Integer count) {
    List<ActivationStatisticsTO> result = new ArrayList<ActivationStatisticsTO>();
    UserDAO userDAO = new UserDAO(getSession());
    Date previousDate = minDate;
    Long difference = (maxDate.getTime() - minDate.getTime()) / count;
    for (int i = 0; i < count; i++) {
      Date currentDate = new Date(previousDate.getTime() + difference);
      ActivationStatisticsTO activationTO = new ActivationStatisticsTO();
      activationTO.setDate(currentDate);
      activationTO.setActivated(userDAO.getActivations(previousDate, currentDate));
      activationTO.setRegistered(userDAO.getRegisrations(previousDate, currentDate));
      result.add(activationTO);
      previousDate = currentDate;
    }
    return result;
  }

  public List<List<ServerStatisticsTO>> getLoadChart(Date minDate, Date maxDate, Integer count) {
    List<List<ServerStatisticsTO>> result = new ArrayList<List<ServerStatisticsTO>>();
    ServerStatisticsDAO dao = new ServerStatisticsDAO(getSession());
    Date previousDate = minDate;
    Long difference = (maxDate.getTime() - minDate.getTime()) / count;
    for (int i = 0; i < count; i++) {
      Date currentDate = new Date(previousDate.getTime() + difference);
      ArrayList<ServerStatisticsTO> partData = new ArrayList<ServerStatisticsTO>();
      List<Object[]> serversData = dao.findByDates(previousDate, currentDate);
      for (Object[] serverData : serversData) {
        Server server = (Server) serverData[0];
        Integer usersCount = ((Double) serverData[1]).intValue();
        partData.add(new ServerStatisticsTO(server.getName(), usersCount, previousDate));
      }
      result.add(partData);
      previousDate = currentDate;
    }
    return result;
  }

  public List<LoginStatisticsTO> getUsersChart(Date minDate, Date maxDate, Integer count) {
    List<LoginStatisticsTO> result = new ArrayList<LoginStatisticsTO>();
    LoginStatisticsDAO dao = new LoginStatisticsDAO(getSession());
    Date previousDate = minDate;
    Long difference = (maxDate.getTime() - minDate.getTime()) / count;
    for (int i = 0; i < count; i++) {
      Date currentDate = new Date(previousDate.getTime() + difference);
      Object[] args = dao.findForAll(previousDate, currentDate);
      Long seconds = (Long) args[0];
      Integer loginCount = ((Long) args[1]).intValue();
      ChartStatisticsTO statisticsTO = new ChartStatisticsTO(currentDate, seconds, loginCount);
      result.add(statisticsTO);
      previousDate = currentDate;
    }
    return result;
  }

  public PagedResult<UserLoginStatisticsTO> getUserLogins(Date minDate, Date maxDate, Integer firstResult,
      Integer maxResults) {

    List<UserLoginStatisticsTO> data = new ArrayList<UserLoginStatisticsTO>();
    LoginStatisticsDAO dao = new LoginStatisticsDAO(getSession());
    List<Object[]> list = dao.findForUsers(minDate, maxDate, firstResult, maxResults);
    for (Object[] args : list) {
      User user = (User) args[0];
      Long seconds = (Long) args[1];
      Integer loginCount = ((Long) args[2]).intValue();
      data.add(new UserLoginStatisticsTO(user.getLogin(), seconds, loginCount));
    }
    return new PagedResult<UserLoginStatisticsTO>(dao.getCount(minDate, maxDate), data);
  }

  @SuppressWarnings("deprecation")
  public List<TransactionStatisticsTO> getTransactionStatistics(String minDate, String maxDate) throws ParseException {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   
    Date minD = sdf.parse(minDate);
    Date maxD = sdf.parse(maxDate);
    
    Long partnerId = null;
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();

    if (AccessPartner.class.equals(adapter.getAccessType())) {
      partnerId = adapter.getUserId();
    }
   
    List<TransactionStatisticsTO> result = new ArrayList<TransactionStatisticsTO>();
    for (Object[] objects : new TransactionDAO(getSession()).findForDatesOld(partnerId, minD, maxD)) {
      Transaction t = (Transaction) objects[0];
      Long count = (Long) objects[1];
      String message = t.getSuccessMessage();
      int type = t.getType();
      Double price = TransactionConstants.PACKAGE_PRICES.get(type);
      addTransactionStatResult(result, count, message, price);
    }
    for (Object[] objects : new TransactionDAO(getSession()).findForDates(partnerId, minD, maxD)) {
      Transaction t = (Transaction) objects[0];
      Long count = (Long) objects[1];
      String message = t.getSku().getName();
      Double price = t.getSku().getPrice();
      addTransactionStatResult(result, count, message, price);
    }
    return result;
  }

  @SuppressWarnings("deprecation")
  public List<TransactionStatisticsTO> getRobotTransactionStatistics(String minDate, String maxDate) throws ParseException {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   
    Date minD = sdf.parse(minDate);
    Date maxD = sdf.parse(maxDate);
    
    Long partnerId = null;
    UserAdapter adapter = UserManager.getInstance().getCurrentUser();

    if (AccessPartner.class.equals(adapter.getAccessType())) {
      partnerId = adapter.getUserId();
    }
   
    List<TransactionStatisticsTO> result = new ArrayList<TransactionStatisticsTO>();
    for (Object[] objects : new RobotTransactionDAO(getSession()).findForDates(partnerId, minD, maxD)) {
      RobotTransaction t = (RobotTransaction) objects[0];
      Long count = (Long) objects[1];
      String message = t.getRobotSKU().getName();
      Double price = t.getRobotSKU().getPrice();
      addTransactionStatResult(result, count, message, price);
    }
    return result;
  }

  private void addTransactionStatResult(List<TransactionStatisticsTO> result, Long count, String message, Double price) {
    if (price != null) {
      message += " " + price;

      double sum = price * count;
      int decimalPlace = 2;
      BigDecimal bd = new BigDecimal(sum);
      bd = bd.setScale(decimalPlace, BigDecimal.ROUND_UP);
      sum = bd.doubleValue();
      result.add(new TransactionStatisticsTO(message, count.intValue(), sum));
    }
  }
}
