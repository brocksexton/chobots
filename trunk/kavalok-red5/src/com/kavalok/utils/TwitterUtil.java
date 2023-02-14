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
        twitter.setOAuthConsumer("O4EK20BEhSULYW8OMdmoBA", "CgUmciXyWrI9OO9NhItKODKikj9qsj7KfcJUw8xVAtI");
        twitter.setOAuthAccessToken(a);
        AccountTotals totals = null;
            followers = totals.getFollowers();
        return followers;
    }

    public String getProfilePicture(String accessToken, String accessTokenSecret) {
        Twitter twitter = new TwitterFactory().getInstance();
        AccessToken a = new AccessToken(accessToken, accessTokenSecret);
        twitter.setOAuthConsumer("O4EK20BEhSULYW8OMdmoBA", "CgUmciXyWrI9OO9NhItKODKikj9qsj7KfcJUw8xVAtI");
        twitter.setOAuthAccessToken(a);
        User user = null;
        URL = user.getProfileImageURL();
        return URL;
    }

    public Integer getTweets(String accessToken, String accessTokenSecret) {
        Twitter twitter = new TwitterFactory().getInstance();
        AccessToken a = new AccessToken(accessToken, accessTokenSecret);
        twitter.setOAuthConsumer("O4EK20BEhSULYW8OMdmoBA", "CgUmciXyWrI9OO9NhItKODKikj9qsj7KfcJUw8xVAtI");
        twitter.setOAuthAccessToken(a);
        AccountTotals totals = null;
            tweets = totals.getUpdates();
        return tweets;
    }

}