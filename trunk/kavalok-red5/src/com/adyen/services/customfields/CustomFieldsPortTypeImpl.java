/**
 * Please modify this class to meet your needs
 * This class is not complete
 */

package com.adyen.services.customfields;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;

import com.kavalok.billing.adyen.AdyenUtil;
import com.kavalok.dao.TransactionDAO;
import com.kavalok.dao.TransactionUserInfoDAO;
import com.kavalok.dao.UserDAO;
import com.kavalok.db.Transaction;
import com.kavalok.db.TransactionUserInfo;
import com.kavalok.db.User;
import com.kavalok.transactions.DefaultTransactionStrategy;

/**
 * This class was generated by Apache CXF 2.1.4 Fri Feb 13 12:35:42 EET 2009
 * Generated source version: 2.1.4
 * 
 */

@javax.jws.WebService(serviceName = "CustomFields", portName = "CustomFieldsHttpPort", targetNamespace = "http://customfields.services.adyen.com", wsdlLocation = "https://ca-test.adyen.com/ca/services/CustomFields?wsdl", endpointInterface = "com.adyen.services.customfields.CustomFieldsPortType")
public class CustomFieldsPortTypeImpl implements CustomFieldsPortType {

  private static String INCORRECT_PASSWORD_ERROR = "Incorrect password";

  private static String LOGIN_NOT_FOUND_ERROR = "Login not found";

  private static String INCORRECT_PASSWORD_ERROR_DE = "Falsches Kennwort";

  private static String LOGIN_NOT_FOUND_ERROR_DE = "Falsche Benutzerkennung";

  private static final String CUSTOM_PAYMENT_FIELD = "custom_payment";

  private static final String USER_ID_FIELD = "userId";

  private static final String PASSWORD_FIELD = "password";

  private static final String LOGIN_FIELD = "login";

  private static final Logger LOG = AdyenUtil.getLogger();

  private static String MISSING_FIELD_ERROR_FORMAT = "Please enter %s";

  private static String MISSING_FIELD_ERROR_FORMAT_DE = "Bitte geben Sie %s ein";

  private static Map<String, String> CUSTOM_FIELD_NAMES_MAPPING;

  private static Map<String, String> CUSTOM_FIELD_NAMES_MAPPING_DE;

  private static Map<String, String> ALL_CUSTOM_FIELD_NAMES_MAPPING;

  private static Map<String, String> ALL_CUSTOM_FIELD_NAMES_MAPPING_DE;

  static {
    CUSTOM_FIELD_NAMES_MAPPING = new HashMap<String, String>();
    CUSTOM_FIELD_NAMES_MAPPING.put("first_name", "First Name");
    CUSTOM_FIELD_NAMES_MAPPING.put("last_name", "Last Name");
    CUSTOM_FIELD_NAMES_MAPPING.put("zip", "Zip/Postal Code");
    CUSTOM_FIELD_NAMES_MAPPING.put("state2", "State");
    CUSTOM_FIELD_NAMES_MAPPING.put("phone", "Phone");
    CUSTOM_FIELD_NAMES_MAPPING.put("email", "Email");
    CUSTOM_FIELD_NAMES_MAPPING.put("state", "State");
    CUSTOM_FIELD_NAMES_MAPPING.put("address1", "Address1");
    CUSTOM_FIELD_NAMES_MAPPING.put("address2", "Address2");
    CUSTOM_FIELD_NAMES_MAPPING.put("country", "Country");
    CUSTOM_FIELD_NAMES_MAPPING.put("city", "City");

    ALL_CUSTOM_FIELD_NAMES_MAPPING = new HashMap<String, String>();
    ALL_CUSTOM_FIELD_NAMES_MAPPING.putAll(CUSTOM_FIELD_NAMES_MAPPING);
    ALL_CUSTOM_FIELD_NAMES_MAPPING.put("login", "Name");
    ALL_CUSTOM_FIELD_NAMES_MAPPING.put("password", "Password");

    CUSTOM_FIELD_NAMES_MAPPING_DE = new HashMap<String, String>();
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("first_name", "Ihren Vornamen");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("last_name", "Ihren Nachnamen");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("zip", "Postleitzahl");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("state2", "Land");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("phone", "Telefonnummer");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("email", "E-Mail-Adresse");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("state", "Land");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("address1", "Ihre Adresse1");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("address2", "Ihre Adresse2");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("country", "Land");
    CUSTOM_FIELD_NAMES_MAPPING_DE.put("city", "Stadt");

    ALL_CUSTOM_FIELD_NAMES_MAPPING_DE = new HashMap<String, String>();
    ALL_CUSTOM_FIELD_NAMES_MAPPING_DE.putAll(CUSTOM_FIELD_NAMES_MAPPING_DE);
    ALL_CUSTOM_FIELD_NAMES_MAPPING_DE.put("login", "Ihr Nutzername");
    ALL_CUSTOM_FIELD_NAMES_MAPPING_DE.put("password", "Ihr Kennwort");

  }

  /*
   * (non-Javadoc)
   * 
   * @see com.adyen.services.customfields.CustomFieldsPortType#check(com.adyen.services.customfields.CustomFieldRequest
   *      customFieldRequest )*
   */
  public com.adyen.services.customfields.CustomFieldResponse check(
      com.adyen.services.customfields.CustomFieldRequest customFieldRequest) throws ServiceException {
    LOG.error("CustomFieldsPortTypeImpl  operation check");

    try {
      com.adyen.services.customfields.CustomFieldResponse _return = new com.adyen.services.customfields.CustomFieldResponse();

      Map<String, String> fieldValues = new HashMap<String, String>();

      Map<String, CustomField> failedFieldsMap = new HashMap<String, CustomField>();

      Long transactionId = null;
      Long userId = null;
      String password = null;
      String login = null;
      boolean customPayment = false;

      LOG.error("getMerchantAccount: " + customFieldRequest.getMerchantAccount().getValue());

      for (Iterator<CustomField> iterator = customFieldRequest.getFields().getValue().getCustomField().iterator(); iterator
          .hasNext();) {
        CustomField customField = iterator.next();
        String name = customField.getName().getValue();
        String value = customField.getValue().getValue();
        LOG.error("field name: " + name + ", value: " + value);
        fieldValues.put(name, value);
        if (CUSTOM_PAYMENT_FIELD.equals(name) && "yes".equals(value)) {
          customPayment = true;
        } else if ("transactionId".equals(name)) {
          try {
            transactionId = new Long(value);
          } catch (Exception e) {
            try {
              transactionId = new Long(value.substring(1));
            } catch (Exception e1) {
            }
          }
        } else if (USER_ID_FIELD.equals(name)) {
          try {
            userId = new Long(value);
          } catch (Exception e) {
          }

        } else if (PASSWORD_FIELD.equals(name) && !isEmpty(value)) {
          password = value;
          failedFieldsMap.put(name, customField);
        } else if (LOGIN_FIELD.equals(name) && !isEmpty(value)) {
          login = value;
          failedFieldsMap.put(name, customField);
        } else if (isEmpty(value)) {
          customField.getValue().setValue(
              String.format(getMissingFieldErrorFormat(customFieldRequest), getAllCustomFieldNamesMapping(
                  customFieldRequest).get(name)));
          failedFieldsMap.put(name, customField);
        }
      }

      if (userId == null) {
        if (isEmpty(login) && !isEmpty(password)) {
          failedFieldsMap.remove(PASSWORD_FIELD);
        } else if (isEmpty(password) && !isEmpty(login)) {
          failedFieldsMap.remove(LOGIN_FIELD);
        }
        processTransaction(transactionId, login, password, failedFieldsMap, customFieldRequest);
      } else {
        failedFieldsMap.remove(LOGIN_FIELD);
        failedFieldsMap.remove(PASSWORD_FIELD);
      }

      if (customPayment) {
        for (Iterator<String> iterator = getCustomFieldNamesMapping(customFieldRequest).keySet().iterator(); iterator
            .hasNext();) {
          String fieldName = (String) iterator.next();
          failedFieldsMap.remove(fieldName);
        }
      }

      processAddressFields(fieldValues, failedFieldsMap);
      // processLoginFields(failedFieldsMap);

      if (!failedFieldsMap.values().isEmpty()) {
        ArrayOfCustomField fieldsArray = new ArrayOfCustomField();
        fieldsArray.getCustomField().addAll(failedFieldsMap.values());
        customFieldRequest.getFields().setValue(fieldsArray);
        _return.setFields(customFieldRequest.getFields());
      } else {
        QName _name = new javax.xml.namespace.QName("http://customfields.services.adyen.com", "response");
        JAXBElement<String> resp = new JAXBElement<String>(_name, String.class, "[accepted]");
        _return.setResponse(resp);
        logFields(fieldValues);
      }

      return _return;
    } catch (Exception ex) {
      ex.printStackTrace();
      throw new RuntimeException(ex);
    }
    // throw new ServiceException("ServiceException...");
  }

  private Map<String, String> getCustomFieldNamesMapping(CustomFieldRequest customFieldRequest) {
    return "ChobotsDE".equals(customFieldRequest.merchantAccount.getValue()) ? CUSTOM_FIELD_NAMES_MAPPING_DE
        : CUSTOM_FIELD_NAMES_MAPPING;
  }

  private Map<String, String> getAllCustomFieldNamesMapping(CustomFieldRequest customFieldRequest) {
    return "ChobotsDE".equals(customFieldRequest.merchantAccount.getValue()) ? ALL_CUSTOM_FIELD_NAMES_MAPPING_DE
        : ALL_CUSTOM_FIELD_NAMES_MAPPING;
  }

  private String getMissingFieldErrorFormat(CustomFieldRequest customFieldRequest) {
    return "ChobotsDE".equals(customFieldRequest.merchantAccount.getValue()) ? MISSING_FIELD_ERROR_FORMAT_DE
        : MISSING_FIELD_ERROR_FORMAT;
  }

  private String getIncorrectPasswordError(CustomFieldRequest customFieldRequest) {
    return "ChobotsDE".equals(customFieldRequest.merchantAccount.getValue()) ? INCORRECT_PASSWORD_ERROR_DE
        : INCORRECT_PASSWORD_ERROR;
  }

  private String getLoginNotFoundError(CustomFieldRequest customFieldRequest) {
    return "ChobotsDE".equals(customFieldRequest.merchantAccount.getValue()) ? LOGIN_NOT_FOUND_ERROR_DE
        : LOGIN_NOT_FOUND_ERROR;
  }

  private void processLoginFields(Map<String, CustomField> failedFieldsMap, CustomFieldRequest customFieldRequest) {
    CustomField customField;
    customField = failedFieldsMap.get(LOGIN_FIELD);
    if (customField != null) {
      customField.getValue().setValue(getLoginNotFoundError(customFieldRequest));
      failedFieldsMap.put(LOGIN_FIELD, customField);
    }

    customField = failedFieldsMap.get(PASSWORD_FIELD);
    if (customField != null) {
      customField.getValue().setValue(getIncorrectPasswordError(customFieldRequest));
      failedFieldsMap.put(PASSWORD_FIELD, customField);
    }
  }

  private void processAddressFields(Map<String, String> fieldValues, Map<String, CustomField> failedFieldsMap) {
    String us_ca = fieldValues.get("us_ca");
    String not_us_ca = fieldValues.get("not_us_ca");
    if ("us_ca".equals(us_ca)) {
      failedFieldsMap.remove("country");
    }
    if ("not_us_ca".equals(not_us_ca)) {
      failedFieldsMap.remove("state");
    }
    failedFieldsMap.remove("us_ca");
    failedFieldsMap.remove("not_us_ca");

    failedFieldsMap.remove("address2");
  }

  private boolean processTransaction(Long transactionId, String login, String password,
      Map<String, CustomField> failedFieldsMap, CustomFieldRequest customFieldRequest) {
    boolean result = false;

    if (isEmpty(login) || isEmpty(password)) {
      return false;
    }

    DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
    try {
      dts.beforeCall();

      TransactionDAO tDao = new TransactionDAO(dts.getSession());
      Transaction trans = tDao.findById(transactionId);

      UserDAO userDao = new UserDAO(dts.getSession());
      User user = userDao.findByLogin(login);
      if (user != null) {
        failedFieldsMap.remove(LOGIN_FIELD);
        if (user.getPassword().equals(password)) {
          failedFieldsMap.remove(PASSWORD_FIELD);
          trans.setUser(user);
          tDao.makePersistent(trans);
          result = true;
        }
      }

      dts.afterCall();
    } catch (Exception e) {
      LOG.error("Cannot update transaction", e);
      dts.afterError(e);
    }
    if (!result) {
      failedFieldsMap.remove(USER_ID_FIELD);
    }
    processLoginFields(failedFieldsMap, customFieldRequest);
    return result;
  }

  private void logFields(Map<String, String> fields) {
    DefaultTransactionStrategy dts = new DefaultTransactionStrategy();
    try {
      dts.beforeCall();

      TransactionUserInfo tui = new TransactionUserInfo();
      BeanUtils.populate(tui, fields);
      TransactionUserInfoDAO dao = new TransactionUserInfoDAO(dts.getSession());
      dao.makePersistent(tui);
      dts.afterCall();
    } catch (Exception e) {
      dts.afterError(e);
    }

  }

  private boolean isEmpty(String value) {
    return value == null || value.trim().length() == 0;
  }
}
