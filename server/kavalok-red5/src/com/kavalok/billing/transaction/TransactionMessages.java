package com.kavalok.billing.transaction;

import com.kavalok.db.Transaction;

public class TransactionMessages {

  public static String getTransactionSuccessResponse(Transaction transaction) {
    return transaction.getSuccessMessage();
  }

}
