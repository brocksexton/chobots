package com.kavalok.dto;

public class KeysTO {
	private Byte[] securityKey;

	private Byte[] chatSecurityKey;

	public KeysTO() {
		super();
	}

	public KeysTO(Byte[] securityKey, Byte[] chatSecurityKey) {
		super();
		this.securityKey = securityKey;
		this.chatSecurityKey = chatSecurityKey;
	}

	public Byte[] getSecurityKey() {
		return securityKey;
	}

	public void setSecurityKey(Byte[] securityKey) {
		this.securityKey = securityKey;
	}

	public Byte[] getChatSecurityKey() {
		return chatSecurityKey;
	}

	public void setChatSecurityKey(Byte[] chatSecurityKey) {
		this.chatSecurityKey = chatSecurityKey;
	}


}
