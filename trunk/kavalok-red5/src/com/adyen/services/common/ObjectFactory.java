
package com.adyen.services.common;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.adyen.services.common package. 
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

    private final static QName _ServiceExceptionType_QNAME = new QName("http://common.services.adyen.com", "type");
    private final static QName _ServiceExceptionError_QNAME = new QName("http://common.services.adyen.com", "error");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.adyen.services.common
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link ServiceException }
     * 
     */
    public ServiceException createServiceException() {
        return new ServiceException();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Type }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://common.services.adyen.com", name = "type", scope = ServiceException.class)
    public JAXBElement<Type> createServiceExceptionType(Type value) {
        return new JAXBElement<Type>(_ServiceExceptionType_QNAME, Type.class, ServiceException.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Error }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://common.services.adyen.com", name = "error", scope = ServiceException.class)
    public JAXBElement<Error> createServiceExceptionError(Error value) {
        return new JAXBElement<Error>(_ServiceExceptionError_QNAME, Error.class, ServiceException.class, value);
    }

}
