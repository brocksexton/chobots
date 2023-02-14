package com.kavalok.dto;

import com.kavalok.ApplicationConfig;
import com.kavalok.KavalokApplication;

public class ServerPropertiesTO {

	private String charSet;
	private String videoPlayerURL;
	private String petHelpURL;
	private String termsAndConditionsURL;
	private String blogURL;

	public ServerPropertiesTO() {
		super();
		
		ApplicationConfig appConfig = KavalokApplication.getInstance()
				.getApplicationConfig();
		this.charSet = appConfig.getCharSet();
		this.videoPlayerURL = appConfig.getVideoPlayerURL();
		this.petHelpURL = appConfig.getPetHelpURL();
		this.termsAndConditionsURL = appConfig.getTermsAndConditionsURL();
		this.blogURL = appConfig.getBlogURL();
	}

	public String getCharSet() {
		return charSet;
	}

	public void setCharSet(String charSet) {
		this.charSet = charSet;
	}

	public String getVideoPlayerURL() {
		return videoPlayerURL;
	}

	public void setVideoPlayerURL(String videoPlayerURL) {
		this.videoPlayerURL = videoPlayerURL;
	}

	public String getPetHelpURL() {
		return petHelpURL;
	}

	public void setPetHelpURL(String petHelpURL) {
		this.petHelpURL = petHelpURL;
	}

	public String getTermsAndConditionsURL() {
		return termsAndConditionsURL;
	}

	public void setTermsAndConditionsURL(String termsAndConditionsURL) {
		this.termsAndConditionsURL = termsAndConditionsURL;
	}

	public String getBlogURL() {
		return blogURL;
	}

	public void setBlogURL(String blogURL) {
		this.blogURL = blogURL;
	}
	
}
