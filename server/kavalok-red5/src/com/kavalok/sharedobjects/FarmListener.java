package com.kavalok.sharedObjects;

import org.red5.io.utils.ObjectMap;

public class FarmListener extends SOListener {

	private static final String CLIENT_ID = "farm";
	private static final String FRAME = "frame";
	
	public FarmListener() {
		super();
	}

	public Boolean svField(String fieldId) {
		
		ObjectMap<String, Object> state = getStateObject(CLIENT_ID, fieldId);
		
		if (!state.containsKey(FRAME)) {
			state.put(FRAME, 1);
		}
		
		Integer frameNum = (Integer) state.get(FRAME);
		
		if (frameNum < 4)
			frameNum = frameNum + 1;
		else
			frameNum = 1;
		
		state.put(FRAME, frameNum);
		sendState(CLIENT_ID, "rField", fieldId, state);
		
		return true;
	}

}
