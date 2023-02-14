package com.kavalok.billing.adyen;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.zip.GZIPOutputStream;

import org.apache.commons.codec.binary.Base64;

public class Base64GzipEncoder {

  public static void main(String[] args) throws IOException {

    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    BufferedOutputStream bufos = new BufferedOutputStream(new GZIPOutputStream(bos));
    bufos.write("Chobot's Suit".getBytes());
    bufos.close();
    System.err.println(new String(bos.toByteArray()));
    System.err.println(new String(Base64.encodeBase64(bos.toByteArray())));
    bos.close();

  }

}
