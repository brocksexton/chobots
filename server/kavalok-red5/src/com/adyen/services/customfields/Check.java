
package com.adyen.services.customfields;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="customFieldRequest" type="{http://customfields.services.adyen.com}CustomFieldRequest"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "customFieldRequest"
})
@XmlRootElement(name = "check")
public class Check {

    @XmlElement(required = true, nillable = true)
    protected CustomFieldRequest customFieldRequest;

    /**
     * Gets the value of the customFieldRequest property.
     * 
     * @return
     *     possible object is
     *     {@link CustomFieldRequest }
     *     
     */
    public CustomFieldRequest getCustomFieldRequest() {
        return customFieldRequest;
    }

    /**
     * Sets the value of the customFieldRequest property.
     * 
     * @param value
     *     allowed object is
     *     {@link CustomFieldRequest }
     *     
     */
    public void setCustomFieldRequest(CustomFieldRequest value) {
        this.customFieldRequest = value;
    }

}
