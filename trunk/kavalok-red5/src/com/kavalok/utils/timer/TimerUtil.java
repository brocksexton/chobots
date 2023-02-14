package com.kavalok.utils.timer;

import java.util.List;
import java.util.Timer;

public class TimerUtil {

	public static void callAfter(Object target, String methodName, List<Object> args, int delay) {
		Timer timer = new Timer(target + " " + methodName);
		timer.schedule(new ReflectionTimerTask(timer, target, methodName, args), delay);
	}

	public static void callAfter(Object target, String methodName, int delay) {
		Timer timer = new Timer(target + " " + methodName);
		timer.schedule(new ReflectionTimerTask(timer, target, methodName), delay);
	}

}
