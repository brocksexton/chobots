
package com.adyen.services.customfields;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;

import com.adyen.services.common.ServiceException;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.adyen.services.customfields package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _ServiceException_QNAME = new QName("http://customfields.services.adyen.com", "ServiceException");
    private final static QName _CustomFieldName_QNAME = new QName("http://customfields.services.adyen.com", "name");
    private final static QName _CustomFieldValue_QNAME = new QName("http://customfields.services.adyen.com", "value");
    private final static QName _CustomFieldRequestMerchantReference_QNAME = new QName("http://customfields.services.adyen.com", "merchantReference");
    private final static QName _CustomFieldRequestMerchantAccount_QNAME = new QName("http://customfields.services.adyen.com", "merchantAccount");
    private final static QName _CustomFieldRequestFields_QNAME = new QName("http://customfields.services.adyen.com", "fields");
    private final static QName _CustomFieldResponseResponse_QNAME = new QName("http://customfields.services.adyen.com", "response");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.adyen.services.customfields
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link CustomField }
     * 
     */
    public CustomField createCustomField() {
        return new CustomField();
    }

    /**
     * Create an instance of {@link CustomFieldRequest }
     * 
     */
    public CustomFieldRequest createCustomFieldRequest() {
        return new CustomFieldRequest();
    }

    /**
     * Create an instance of {@link Check }
     * 
     */
    public Check createCheck() {
        return new Check();
    }

    /**
     * Create an instance of {@link CheckResponse }
     * 
     */
    public CheckResponse createCheckResponse() {
        return new CheckResponse();
    }

    /**
     * Create an instance of {@link ArrayOfCustomField }
     * 
     */
    public ArrayOfCustomField createArrayOfCustomField() {
        return new ArrayOfCustomField();
    }

    /**
     * Create an instance of {@link CustomFieldResponse }
     * 
     */
    public CustomFieldResponse createCustomFieldResponse() {
        return new CustomFieldResponse();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ServiceException }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "ServiceException")
    public JAXBElement<ServiceException> createServiceException(ServiceException value) {
        return new JAXBElement<ServiceException>(_ServiceException_QNAME, ServiceException.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "name", scope = CustomField.class)
    public JAXBElement<String> createCustomFieldName(String value) {
        return new JAXBElement<String>(_CustomFieldName_QNAME, String.class, CustomField.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "value", scope = CustomField.class)
    public JAXBElement<String> createCustomFieldValue(String value) {
        return new JAXBElement<String>(_CustomFieldValue_QNAME, String.class, CustomField.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "merchantReference", scope = CustomFieldRequest.class)
    public JAXBElement<String> createCustomFieldRequestMerchantReference(String value) {
        return new JAXBElement<String>(_CustomFieldRequestMerchantReference_QNAME, String.class, CustomFieldRequest.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "merchantAccount", scope = CustomFieldRequest.class)
    public JAXBElement<String> createCustomFieldRequestMerchantAccount(String value) {
        return new JAXBElement<String>(_CustomFieldRequestMerchantAccount_QNAME, String.class, CustomFieldRequest.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ArrayOfCustomField }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "fields", scope = CustomFieldRequest.class)
    public JAXBElement<ArrayOfCustomField> createCustomFieldRequestFields(ArrayOfCustomField value) {
        return new JAXBElement<ArrayOfCustomField>(_CustomFieldRequestFields_QNAME, ArrayOfCustomField.class, CustomFieldRequest.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "response", scope = CustomFieldResponse.class)
    public JAXBElement<String> createCustomFieldResponseResponse(String value) {
        return new JAXBElement<String>(_CustomFieldResponseResponse_QNAME, String.class, CustomFieldResponse.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ArrayOfCustomField }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://customfields.services.adyen.com", name = "fields", scope = CustomFieldResponse.class)
    public JAXBElement<ArrayOfCustomField> createCustomFieldResponseFields(ArrayOfCustomField value) {
        return new JAXBElement<ArrayOfCustomField>(_CustomFieldRequestFields_QNAME, ArrayOfCustomField.class, CustomFieldResponse.class, value);
    }

}
