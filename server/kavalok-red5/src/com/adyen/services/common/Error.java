
package com.adyen.services.common;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for Error.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="Error">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="Unknown"/>
 *     &lt;enumeration value="NotAllowed"/>
 *     &lt;enumeration value="NoAmountSpecified"/>
 *     &lt;enumeration value="InvalidCardNumber"/>
 *     &lt;enumeration value="UnableToDetermineVariant"/>
 *     &lt;enumeration value="CVCisNotTheRightLength"/>
 *     &lt;enumeration value="BillingAddressProblem"/>
 *     &lt;enumeration value="InvalidPaRes3dSecure"/>
 *     &lt;enumeration value="SessionAlreadyUsed"/>
 *     &lt;enumeration value="RecurringNotEnabled"/>
 *     &lt;enumeration value="InvalidBankAccountNumber"/>
 *     &lt;enumeration value="RechargeContractNotFound"/>
 *     &lt;enumeration value="RechargeToManyPaymentDetails"/>
 *     &lt;enumeration value="RechargeInvalidContract"/>
 *     &lt;enumeration value="RechargeDetailNotFound"/>
 *     &lt;enumeration value="RechargeFailedToDisable"/>
 *     &lt;enumeration value="RechargeDetailNotAvailableForContract"/>
 *     &lt;enumeration value="InvalidMerchantAccount"/>
 *     &lt;enumeration value="RequestMissing"/>
 *     &lt;enumeration value="InternalError"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "Error")
@XmlEnum
public enum Error {

    @XmlEnumValue("Unknown")
    UNKNOWN("Unknown"),
    @XmlEnumValue("NotAllowed")
    NOT_ALLOWED("NotAllowed"),
    @XmlEnumValue("NoAmountSpecified")
    NO_AMOUNT_SPECIFIED("NoAmountSpecified"),
    @XmlEnumValue("InvalidCardNumber")
    INVALID_CARD_NUMBER("InvalidCardNumber"),
    @XmlEnumValue("UnableToDetermineVariant")
    UNABLE_TO_DETERMINE_VARIANT("UnableToDetermineVariant"),
    @XmlEnumValue("CVCisNotTheRightLength")
    CV_CIS_NOT_THE_RIGHT_LENGTH("CVCisNotTheRightLength"),
    @XmlEnumValue("BillingAddressProblem")
    BILLING_ADDRESS_PROBLEM("BillingAddressProblem"),
    @XmlEnumValue("InvalidPaRes3dSecure")
    INVALID_PA_RES_3_D_SECURE("InvalidPaRes3dSecure"),
    @XmlEnumValue("SessionAlreadyUsed")
    SESSION_ALREADY_USED("SessionAlreadyUsed"),
    @XmlEnumValue("RecurringNotEnabled")
    RECURRING_NOT_ENABLED("RecurringNotEnabled"),
    @XmlEnumValue("InvalidBankAccountNumber")
    INVALID_BANK_ACCOUNT_NUMBER("InvalidBankAccountNumber"),
    @XmlEnumValue("RechargeContractNotFound")
    RECHARGE_CONTRACT_NOT_FOUND("RechargeContractNotFound"),
    @XmlEnumValue("RechargeToManyPaymentDetails")
    RECHARGE_TO_MANY_PAYMENT_DETAILS("RechargeToManyPaymentDetails"),
    @XmlEnumValue("RechargeInvalidContract")
    RECHARGE_INVALID_CONTRACT("RechargeInvalidContract"),
    @XmlEnumValue("RechargeDetailNotFound")
    RECHARGE_DETAIL_NOT_FOUND("RechargeDetailNotFound"),
    @XmlEnumValue("RechargeFailedToDisable")
    RECHARGE_FAILED_TO_DISABLE("RechargeFailedToDisable"),
    @XmlEnumValue("RechargeDetailNotAvailableForContract")
    RECHARGE_DETAIL_NOT_AVAILABLE_FOR_CONTRACT("RechargeDetailNotAvailableForContract"),
    @XmlEnumValue("InvalidMerchantAccount")
    INVALID_MERCHANT_ACCOUNT("InvalidMerchantAccount"),
    @XmlEnumValue("RequestMissing")
    REQUEST_MISSING("RequestMissing"),
    @XmlEnumValue("InternalError")
    INTERNAL_ERROR("InternalError");
    private final String value;

    Error(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static Error fromValue(String v) {
        for (Error c: Error.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
