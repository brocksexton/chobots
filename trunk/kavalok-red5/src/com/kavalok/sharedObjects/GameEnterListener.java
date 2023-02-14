package com.kavalok.sharedObjects;

import org.red5.server.api.so.ISharedObjectBase;

import com.kavalok.utils.SOUtil;
import com.kavalok.utils.timer.TimerUtil;

public class GameEnterListener extends SOListener {

	static private long gameId = 0;

	private static final String ID = "GameEnter";

	private int maxPlayers;

	public GameEnterListener(int maxPlayers) {
		super();
		this.maxPlayers = maxPlayers;
	}

	@Override
	public void onSharedObjectConnect(ISharedObjectBase sharedObject) {
		super.onSharedObjectConnect(sharedObject);
		if (getConnectedChars().size() == maxPlayers) {
			TimerUtil.callAfter(this, "callStartGame", 100);
		}
	}
	
	public void callStartGame()
	{
		String soName = DELIMITER + this.sharedObject.getName() + DELIMITER + gameId++;
		SOUtil
		.callSharedObject(this.sharedObject, ID, "rStartGame",
				soName);
	}

}
