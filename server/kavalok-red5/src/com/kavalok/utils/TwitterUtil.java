package com.kavalok.utils;

//AUTHOR : Ethan

import twitter4j.AccountTotals;
import twitter4j.Twitter;
import twitter4j.User;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;

public final class TwitterUtil {

    public Integer followers;
    public Integer tweets;
    public String URL;


    public Integer getFollowers(String accessToken, String accessTokenSecret) {
        Twitter twitter = new TwitterFactory().getInstance();
        AccessToken a = new AccessToken(accessToken, accessTokenSecret);
        twitter.setOAuthConsumer("vb4ZNYT9ZVjwYKLR38nCGEpgY", "LJWD8UaoxFwK7e398MRYhHrTZ8HAwANGNjzmLyf2jdeuYnkcGH");
        twitter.setOAuthAccessToken(a);
        AccountTotals totals = null;
            followers = totals.getFollowers();
        return followers;
    }

    public String getProfilePicture(String accessToken, String accessTokenSecret) {
        Twitter twitter = new TwitterFactory().getInstance();
        AccessToken a = new AccessToken(accessToken, accessTokenSecret);
        twitter.setOAuthConsumer("vb4ZNYT9ZVjwYKLR38nCGEpgY", "LJWD8UaoxFwK7e398MRYhHrTZ8HAwANGNjzmLyf2jdeuYnkcGH");
        twitter.setOAuthAccessToken(a);
        User user = null;
        URL = user.getProfileImageURL();
        return URL;
    }

    public Integer getTweets(String accessToken, String accessTokenSecret) {
        Twitter twitter = new TwitterFactory().getInstance();
        AccessToken a = new AccessToken(accessToken, accessTokenSecret);
        twitter.setOAuthConsumer("vb4ZNYT9ZVjwYKLR38nCGEpgY", "LJWD8UaoxFwK7e398MRYhHrTZ8HAwANGNjzmLyf2jdeuYnkcGH");
        twitter.setOAuthAccessToken(a);
        AccountTotals totals = null;
            tweets = totals.getUpdates();
        return tweets;
    }

}