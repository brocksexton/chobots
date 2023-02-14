
package com.adyen.services.customfields;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElementRef;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for CustomFieldRequest complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="CustomFieldRequest">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="fields" type="{http://customfields.services.adyen.com}ArrayOfCustomField" minOccurs="0"/>
 *         &lt;element name="merchantAccount" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="merchantReference" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "CustomFieldRequest", propOrder = {
    "fields",
    "merchantAccount",
    "merchantReference"
})
public class CustomFieldRequest {

    @XmlElementRef(name = "fields", namespace = "http://customfields.services.adyen.com", type = JAXBElement.class)
    protected JAXBElement<ArrayOfCustomField> fields;
    @XmlElementRef(name = "merchantAccount", namespace = "http://customfields.services.adyen.com", type = JAXBElement.class)
    protected JAXBElement<String> merchantAccount;
    @XmlElementRef(name = "merchantReference", namespace = "http://customfields.services.adyen.com", type = JAXBElement.class)
    protected JAXBElement<String> merchantReference;

    /**
     * Gets the value of the fields property.
     * 
     * @return
     *     possible object is
     *     {@link JAXBElement }{@code <}{@link ArrayOfCustomField }{@code >}
     *     
     */
    public JAXBElement<ArrayOfCustomField> getFields() {
        return fields;
    }

    /**
     * Sets the value of the fields property.
     * 
     * @param value
     *     allowed object is
     *     {@link JAXBElement }{@code <}{@link ArrayOfCustomField }{@code >}
     *     
     */
    public void setFields(JAXBElement<ArrayOfCustomField> value) {
        this.fields = ((JAXBElement<ArrayOfCustomField> ) value);
    }

    /**
     * Gets the value of the merchantAccount property.
     * 
     * @return
     *     possible object is
     *     {@link JAXBElement }{@code <}{@link String }{@code >}
     *     
     */
    public JAXBElement<String> getMerchantAccount() {
        return merchantAccount;
    }

    /**
     * Sets the value of the merchantAccount property.
     * 
     * @param value
     *     allowed object is
     *     {@link JAXBElement }{@code <}{@link String }{@code >}
     *     
     */
    public void setMerchantAccount(JAXBElement<String> value) {
        this.merchantAccount = ((JAXBElement<String> ) value);
    }

    /**
     * Gets the value of the merchantReference property.
     * 
     * @return
     *     possible object is
     *     {@link JAXBElement }{@code <}{@link String }{@code >}
     *     
     */
    public JAXBElement<String> getMerchantReference() {
        return merchantReference;
    }

    /**
     * Sets the value of the merchantReference property.
     * 
     * @param value
     *     allowed object is
     *     {@link JAXBElement }{@code <}{@link String }{@code >}
     *     
     */
    public void setMerchantReference(JAXBElement<String> value) {
        this.merchantReference = ((JAXBElement<String> ) value);
    }

}
