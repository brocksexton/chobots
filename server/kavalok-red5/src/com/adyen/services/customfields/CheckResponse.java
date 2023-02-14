
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
 *         &lt;element name="customFieldResponse" type="{http://customfields.services.adyen.com}CustomFieldResponse"/>
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
    "customFieldResponse"
})
@XmlRootElement(name = "checkResponse")
public class CheckResponse {

    @XmlElement(required = true, nillable = true)
    protected CustomFieldResponse customFieldResponse;

    /**
     * Gets the value of the customFieldResponse property.
     * 
     * @return
     *     possible object is
     *     {@link CustomFieldResponse }
     *     
     */
    public CustomFieldResponse getCustomFieldResponse() {
        return customFieldResponse;
    }

    /**
     * Sets the value of the customFieldResponse property.
     * 
     * @param value
     *     allowed object is
     *     {@link CustomFieldResponse }
     *     
     */
    public void setCustomFieldResponse(CustomFieldResponse value) {
        this.customFieldResponse = value;
    }

}
