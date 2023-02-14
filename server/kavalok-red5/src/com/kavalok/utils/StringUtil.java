package com.kavalok.utils;

import java.io.UnsupportedEncodingException;

//import org.apache.ws.commons.util.Base64;

import org.apache.commons.codec.binary.Base64;

import com.kavalok.mail.MailUtil;

public class StringUtil {
  
  private static final String ID_CHARS = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_";

  public static boolean isEmptyOrNull(String string)
  {
    return string == null || string.trim().length() == 0;
  }
  
  public static String generateRandomString(Integer length)
  {
    StringBuilder result = new StringBuilder();
    for(int i  = 0; i < length; i++) {
      int index = ((Double)(Math.random() * ID_CHARS.length())).intValue();
      result.append(ID_CHARS.charAt(index));
    }
    return result.toString();
  } 
  
  public static String toBase64(String source)
  {
   /* byte[] bytes = null;
    try {
      bytes = source.getBytes(MailUtil.ENCODING);
    } catch (UnsupportedEncodingException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }*/
    return encodeB(source);
  }

  public static String encodeB(String b)
  {
    byte[] encoded = Base64.encodeBase64(b.getBytes());
    return new String(encoded);
  }


}
