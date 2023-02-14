package com.kavalok.sharedObjects;

import java.util.ArrayList;
import java.util.Date;

import org.red5.server.api.so.ISharedObject;

import com.kavalok.KavalokApplication;

public class AdminSO {

    private static final String ADMIN_SHARED_OBJECT = "admin_shared_object";

    public AdminSO() {
        super();
    }

    public void logUserMessage(String login, String message) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(login);
        args.add(message);
        getSharedObject().sendMessage("onUserMessage", args);
    }

    public void logUserReport(String login, Integer userId, String message, Integer id) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(login);
        args.add(userId);
        args.add(message);
        args.add(id);
        getSharedObject().sendMessage("onUserReport", args);
    }

    public void logMessage(String message) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(message);
        getSharedObject().sendMessage("onMessage", args);
    }

    public void logAdminMessage(String login, String server, String message) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(login);
        args.add(server);
        args.add(message);
        getSharedObject().sendMessage("onAdminMessage", args);
    }

    public void logBadWord(String login, Integer userId, String server, String word, String message, String type) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(login);
        args.add(userId);
        args.add(server);
        args.add(word);
        args.add(message);
        args.add(type);
        getSharedObject().sendMessage("onBadWord", args);
    }

    public void logModAction(String login, String action, String date) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(login);
        args.add(action);
        args.add(date);
        getSharedObject().sendMessage("onModeratorAction", args);
    }

    public void logChatMessage(String login, String message, String sharedObjId) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(login);
        args.add(message);
        args.add(sharedObjId);
        getSharedObject().sendMessage("onChatMessage", args);
    }

    public void logUserEnter(String login, String server, Boolean firstLogin) {
        ArrayList<Object> args = new ArrayList<Object>();
        args.add(login);
        args.add(server);
        args.add(firstLogin);
        getSharedObject().sendMessage("onEnterGame", args);
    }

    private ISharedObject getSharedObject() {
        return KavalokApplication.getInstance().createSharedObject(ADMIN_SHARED_OBJECT);
    }


}
