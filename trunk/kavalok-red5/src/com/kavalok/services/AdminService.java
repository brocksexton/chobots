package com.kavalok.services;

import com.kavalok.KavalokApplication;
import com.kavalok.dao.*;
import com.kavalok.dao.statistics.MoneyStatisticsDAO;
import com.kavalok.db.*;
import com.kavalok.db.statistics.MoneyStatistics;
import com.kavalok.dto.*;
import com.kavalok.dto.admin.FilterTO;
import com.kavalok.dto.stuff.StuffTypeTO;
import com.kavalok.messages.WordsCache;
import com.kavalok.permissions.AccessAdmin;
import com.kavalok.services.common.DataServiceBase;
import com.kavalok.user.UserAdapter;
import com.kavalok.user.UserManager;
import com.kavalok.user.UserUtil;
import com.kavalok.utils.ReflectUtil;
import com.kavalok.utils.StringUtil;
import com.kavalok.utils.TwitterUtil;
import com.kavalok.xmlrpc.AdminClient;
import com.kavalok.xmlrpc.RemoteClient;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.red5.io.utils.ObjectMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;

import java.sql.SQLException;
import java.util.*;

public class AdminService extends DataServiceBase {

    private static final Integer ALL = -1;

    private static final String LESS = "<";

    private static final String EQUALS = "=";

    private static final String GREATER = ">";

    private static final String LIKE = "like";

    private static final String MESSAGE_CLASS = "com.kavalok.messenger.commands.MailMessage";

    private static final String MOD_CLASS = "com.kavalok.remoting.commands.ModMessageCommand";

    private static final String CLASS_NAME = "className";

    private static final String PASSW_CHANGED = "passwordChanged";

    private static final String PASSW_INVALID = "invalidCurrentPassword";

    private static final String PASSW_CORRECT = "correctPassword";


    private UserAdapter userAdmin = UserManager.getInstance().getCurrentUser();

    private static Logger logger = LoggerFactory.getLogger(AdminService.class);

    // flushChatWordCaches, shortened...
    public void fcc() {
        if (!isAuthorized()) return;
        // TODO: incase our mods haxxor the panel, we really should check if they are level 100

        WordsCache.getInstance().reloadCaches();

    }


    public String changePassword(String oldPassword, String newPassword) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);

        if (!user.getPassword().equals(oldPassword)) {
            return PASSW_INVALID;
        } else {
            user.setPassword(newPassword);
            userDAO.makePersistent(user);
            return PASSW_CHANGED;
        }

    }

    // lol, keeps da n00bs out
    public Boolean C() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        if (!user.isModerator()) {
            //userAdmin.goodBye("hack", false);
            // new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack mod panel");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack mod panel", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else {
            return true;
        }
    }

    public Boolean changeSecurePassword(String pass) {
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(id);


        if (user.getPassword().equals(pass)) {
            return false;
        } else {
            user.setPassword(pass);
            user.setResetPass(false);
            userDAO.makePersistent(user);
            return true;
        }


    }

    public Boolean nSa240p(Boolean agent) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);

        if (!user.isAgent()) {
            userAdmin.goodBye("hack", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack agent");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack agent", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else {
            return true;
        }
    }

    public String getAdminConnected() {
        String finString = "";
 /*  for (Iterator<IClient> clients = KavalokApplication.getInstance().getClients().iterator(); clients.hasNext();) {
     IClient client = clients.next();
     UserAdapter user = (UserAdapter) client.getAttribute(UserManager.ADAPTER);

         if(user.getAccessType() == AccessAdmin.class){
          Admin admin = new AdminDAO(getSession()).findById(user.getUserId());
          finString = finString + admin.getRealName() + ", ";
         }
      }*/

        for (UserAdapter user : UserManager.getInstance().getUsers()) {
            if (user.getAccessType() == AccessAdmin.class) {
                Admin admin = new AdminDAO(getSession()).findById(user.getUserId());
                finString = finString + admin.getRealName() + ", ";

            }
        }

        return finString;
    }

    public void S4sP(String alalal1, String alalal2, String item) {
        ClientError adminLog = new ClientError("GIFT SENT: from " + alalal1 + " to " + alalal2 + " item: " + item, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        new ClientErrorDAO(getSession()).makePersistent(adminLog);

    }

    public List<StickersTO> getCharStickers(Integer hserId){
          StickersDAO stickersDAO = new StickersDAO(getSession());
    List<Stickers> stickers = stickersDAO.findByUser(hserId.longValue());

      List<StickersTO> tos = ReflectUtil.convertBeansByConstructor(stickers, StickersTO.class);
      return tos;

    }

    //stickersTO - stickers that are owned by users
    //stickerstypeto - list of all existing stickers

    public List<StickerTypeTO> findStickers(){
      List<StickerType> stickerType = new StickerTypeDAO(getSession()).findAll();
      List<StickerTypeTO> tos = ReflectUtil.convertBeansByConstructor(stickerType, StickerTypeTO.class);
      return tos;
    }

    public List<LottoTO> getLotto() {
    List<Lottery> lottery = new LotteryDAO(getSession()).findEnabled();
      List<LottoTO> tos = ReflectUtil.convertBeansByConstructor(lottery, LottoTO.class);
      return tos;
    }

    public Integer getLottoEntries(){
     LotteryResult lotteryResult = new LotteryResultDAO(getSession()).findByLogin(userAdmin.getLogin());
      return lotteryResult == null ? 0 : lotteryResult.getEntries();
    }

    public String enterLotto(Integer lotteryId, Integer entries){
    LotteryDAO lotteryDAO = new LotteryDAO(getSession());
    Lottery lottery = lotteryDAO.findById(lotteryId.longValue());

	
	Integer cmt = 1;
	for(cmt = 1; cmt <= entries; cmt++){
    LotteryResultDAO lotteryResultDAO = new LotteryResultDAO(getSession());

    LotteryResult lottoResult = lotteryResultDAO.findByLogin(userAdmin.getLogin());

    if(lottoResult == null){    
    LotteryResult lotteryEntry = new LotteryResult(userAdmin.getLogin(), userAdmin.getUserId(), lotteryId.longValue(), lottery.getTicketPrice(), 1);
    lotteryResultDAO.makePersistent(lotteryEntry);
    } else {
        lottoResult.setEntries(lottoResult.getEntries() + 1);
        lotteryResultDAO.makePersistent(lottoResult);
    }
	}

    lottery.setTotalEntries(lottery.getTotalEntries() + entries);
    lotteryDAO.makePersistent(lottery);

    Long id = userAdmin.getUserId();
    GameCharDAO gameCharDAO = new GameCharDAO(getSession());
    GameChar gameChar = gameCharDAO.findByUserId(id);
	Integer price = lottery.getTicketPrice() * entries;
    gameChar.setMoney(gameChar.getMoney() - price);
    gameCharDAO.makePersistent(gameChar);

    return "success";
    }
    

    public List<AnimTO> getAnim() {
        List<Anim> anims = new AnimDAO(getSession()).findEnabled();
        List<AnimTO> tos = ReflectUtil.convertBeansByConstructor(anims, AnimTO.class);
        // fillTos(anims, tos);
        return tos;
    }

    public List<NewsTO> getNews() {
        List<News> newses = new NewsDAO(getSession()).findShowing();
        List<NewsTO> nos = ReflectUtil.convertBeansByConstructor(newses, NewsTO.class);
        // fillTos(anims, tos);
        return nos;
    }

    public Boolean verifyStatus(Boolean agent, Boolean moderator, Boolean artist, Boolean dev, Boolean citizen, String body, String chatColor, String team) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        GameCharDAO gameCharDAO = new GameCharDAO(getSession());
        GameChar gameChar = gameCharDAO.findByUserId(id);

        if (!agent.equals(user.isAgent())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack agent");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack agent", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else if (!moderator.equals(user.isModerator())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack moderator");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack moderator", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else if (!artist.equals(user.isArtist())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack artist");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack artist", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else if (!dev.equals(user.isDev())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack dev");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack dev", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else if (!citizen.equals(user.isCitizen())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack citizen");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack citizen", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else if (!body.equals(gameChar.getBody())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack body");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack body", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else if (!chatColor.equals(gameChar.getChatColor())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack chat color");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack chat color", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else if (!team.equals(user.getTeam())) {
            userAdmin.goodBye("Tried to hack.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack PCcolor");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack PCColor", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        } else {


            return true;
        }
    }

    public void saveNews(String date1, String date2, String date3, String date4, String event1, String event2, String event3, String event4, String image1, String image2, String image3, String image4, String featured) {
        // saveNews1(date1, event1, image1, featured);
        //saveNews2(date2, event2, image2, featured);
        //saveNews3(date3, event3, image3, featured);
        Integer id1 = 1;
        Integer id2 = 2;
        Integer id3 = 3;
        Integer id4 = 4;
        //saveNews4(date4, event4, image4, featured);
        NewsDAO newsDAO1 = new NewsDAO(getSession());
        News news1 = newsDAO1.findByNum(1);
        news1.setDates(date1);
        news1.setInfo(event1);
        news1.setImage(image1);
        news1.setCharName(featured);
        newsDAO1.makePersistent(news1);
        //hiii
        NewsDAO newsDAO2 = new NewsDAO(getSession());
        News news2 = newsDAO2.findByNum(2);
        news2.setDates(date1);
        news2.setInfo(event1);
        news2.setImage(image1);
        news2.setCharName(featured);
        newsDAO2.makePersistent(news2);
        //hiii
        NewsDAO newsDAO3 = new NewsDAO(getSession());
        News news3 = newsDAO3.findByNum(3);
        news3.setDates(date1);
        news3.setInfo(event1);
        news3.setImage(image1);
        news3.setCharName(featured);
        newsDAO3.makePersistent(news3);
        //hiii
        NewsDAO newsDAO4 = new NewsDAO(getSession());
        // News news4 = newsDAO4.findById(id4.longValue());
        News news4 = newsDAO4.findByNum(4);
        news4.setDates(date1);
        news4.setInfo(event1);
        news4.setImage(image1);
        news4.setCharName(featured);
        newsDAO4.makePersistent(news4);
    }

    public Boolean Q(String username) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);

        if (userAdmin.getLogin().equals(reverseMe(username))) {
            return true;
        } else {
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack acc");
            userAdmin.goodBye("Entered incorrect password.", false);
            ClientError adminLog = new ClientError("Tried to hack username", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        }
    }

    public String nPK() {
        return userAdmin.newPrivKeyAlone();
    }

    public Boolean GHzWPr35ZdfMm(Integer userId, String userName) {
        UserDAO userDAO = new UserDAO(getSession());
        User user = userDAO.findById(userId.longValue());

        if (reverseMe(userName).equals(userAdmin.getLogin())) {
            // doNothing();
            userAdmin.newPrivKey();
            return true;
        } else {

            userAdmin.goodBye("Entered incorrect password.", false);
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "Banned by Server: User id " + userAdmin.getUserId() + " tried to log into " + userName);
            ClientError adminLog = new ClientError("User logged in with INCORRECT password in-game", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;

        }
    }

    public String reverseMe(String s) {
        StringBuilder sb = new StringBuilder();
        for (int i = s.length() - 1; i >= 0; --i)
            sb.append(s.charAt(i));
        return sb.toString();
    }

    public void doNothing() {

    }

    public List<ModTO> findModerators() {
        List<User> users = new UserDAO(getSession()).findModerators();
        List<ModTO> nos = ReflectUtil.convertBeansByConstructor(users, ModTO.class);
        return nos;

    }

    public List<ModTO> findAgents() {
        List<User> users = new UserDAO(getSession()).findAgents();
        List<ModTO> nos = ReflectUtil.convertBeansByConstructor(users, ModTO.class);
        return nos;

    }

    public List<ModTO> findJournalists() {
        List<User> users = new UserDAO(getSession()).findJournalists();
        List<ModTO> nos = ReflectUtil.convertBeansByConstructor(users, ModTO.class);
        return nos;

    }

    public String getTeam() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        return user.getTeam();
    }

    public Long getAdminID() {
        return userAdmin.getUserId();
    }


    public Boolean getIsCitizen() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        return user.isCitizen();
    }

    public String getBadgeNum(Integer userId) {
        User user = new UserDAO(getSession()).findById(userId.longValue());
        return user.getBadgeNum();
    }

    public String getCharBadges(Integer userId) {
        User user = new UserDAO(getSession()).findById(userId.longValue());
        return user.getCharBadges();
    }

    public String getPurchasedData() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        return user.getPurchasedBodies() + "#" + user.getPurchasedBubbles();
    }

    public Boolean getDarkness() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        return user.isDarkness();
    }

    public int getColour() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        return user.getUIColour();
    }

    public Boolean verifyItemOwner(Integer itemId) {
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        GameCharDAO gameCharDAO = new GameCharDAO(getSession());
        GameChar gameChar = gameCharDAO.findByUserId(id);
        StuffItem stuffitem = new StuffItemDAO(getSession()).findByCharId(itemId.longValue());
        if (stuffitem.getGameChar() == gameChar)
            return true;
        else
            return false;
    }

    public void setDarkness(Boolean darkness) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        user.setDarkness(darkness);
        userDAO.makePersistent(user);
    }

    public Boolean validateModerator(String username, String password) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);

        if (!(user.getPassword().equals(password))) {
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack moderator");
            userAdmin.goodBye("Entered incorrect password.", false);
            ClientError adminLog = new ClientError("User-mod entered INCORRECT password in-game", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        }

        if (!user.isModerator()) {
            new UserUtil().saveIPBan(getSession(), userAdmin.getConnection().getRemoteAddress(), true, "[SERVER]: user" + userAdmin.getLogin() + " tried to hack moderator");
            userAdmin.goodBye("Entered incorrect password.", false);
            ClientError adminLog = new ClientError("[Hack] Tried to hack mod status", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        }


        return true;
    }


    public void logUserName(String charId) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        user.setNameHistory(charId);
        userDAO.makePersistent(user);
    }

    public String getAltAcc() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);
        return user.getAltAcc();
    }


    public Integer getPermissionLevel(String login) {
        Admin admin = new AdminDAO(getSession()).findByLogin(login);
        return admin == null ? 0 : admin.getPermissionLevel();
    }

    public String getPanelName(String login) {
        Admin admin = new AdminDAO(getSession()).findByLogin(login);
        userAdmin.setPanelName(admin.getRealName());
        return admin == null ? "Undefined" : admin.getRealName();


    }

    public String claimToken(String tokey, String username) {
        TokensDAO tokensDAO = new TokensDAO(getSession());
        Tokens token;
        if (tokensDAO.findByCode(tokey) == null) {
            return "tokenNotFound";
        } else {
            token = tokensDAO.findByCode(tokey);

            if (!token.isAvailable()) {
                return "notAvailable";
            } else if (token.getCount() < 1) {
                return "noMoreLeft";
            } else if (token.getClaimedBy().indexOf("#" + username + "#") > 0) {
                return "alreadyClaimed";
            } else {
                token.setCount(token.getCount() - 1);
                token.setClaimedBy(token.getClaimedBy() + "#" + username + "#");
                return token.getCode();
            }
        }


    }

    public Boolean getMagic(String login) {
        Admin admin = new AdminDAO(getSession()).findByLogin(login);
        return true;
    }

    public void moveUsers(Integer fromId, Integer toId) {
        if (!isAuthorized()) return;
        Server server = new ServerDAO(getSession()).findById(Long.valueOf(fromId));
        Server toServer = new ServerDAO(getSession()).findById(Long.valueOf(toId));
        new RemoteClient(server).sendCommandToAll("ReconnectCommand", toServer.getName());
    }

    public Boolean isAuthorized() {
        if (!userAdmin.getAdminStatus()) {
            ClientError adminLog = new ClientError("HACKING attempt detected", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            userAdmin.goodBye("Hacking attempt detected", false);
            return false;
        } else {
            return true;
        }

    }

    public PagedResult<AdminMessageTO> getAdminMessages(Integer firstResult, Integer maxResults) {
        AdminMessageDAO adminMessageDAO = new AdminMessageDAO(getSession());
        Integer size = adminMessageDAO.findNotProcessed().size();
        List<AdminMessage> list = adminMessageDAO.findNotProcessed(firstResult, maxResults);
        ArrayList<AdminMessageTO> result = new ArrayList<AdminMessageTO>();
        for (AdminMessage adminMessage : list) {
            result.add(new AdminMessageTO(adminMessage));
        }
        return new PagedResult<AdminMessageTO>(size, result);
    }

    public void setMessageProcessed(Integer id) {
        AdminMessage message = new AdminMessageDAO(getSession()).findById(new Long(id), false);
        message.setProcessed(true);
       new RemoteClient(getSession(), message.getUser()).sendCommand("NotificationCommand", "A moderator has viewed the message you sent.");



    }


    public void addPanelLog(String username, String message, String date) {
        //  ClientError adminLog = new ClientError(username + " IN GAME: " + message , userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
        new AdminClient(getSession()).logModAction(username, message, date);

    }

    public Boolean isAMod() {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);

        if (!user.isModerator()) {
            saveIPBan(userAdmin.getConnection().getRemoteAddress(), true, "Hacking attempt detected by system");
            userAdmin.goodBye("Hacking attempt detected. Naughty chobot!", false);
            return false;
        } else {
            return true;
        }

    }

    public Boolean isAuthorizedMod() {
        if (userAdmin.isModerator()) {

            return true;
        } else {
            userAdmin.goodBye("Hacking attempt detected", false);
            return false;
        }
    }

    public Boolean isAuthorizedBody() {
        if (userAdmin.isBoughtBody()) {

            return true;
        } else {
            userAdmin.goodBye("Hacking attempt detected", false);
            return false;
        }
    }

    public void setBanDate(Integer userId, Date banDate) {
        if (!isAuthorized()) return;
        User user = new UserDAO(getSession()).findById(userId.longValue());
        BanDAO banDAO = new BanDAO(getSession());
        Ban ban = new UserUtil().getBanModel(banDAO, user);
        ban.setBanCount(1);
        ban.setBanDate(banDate);
        banDAO.makePersistent(ban);

        // Integer banPeriod = BanUtil.getBanPeriod(ban);
        new RemoteClient(getSession(), user).sendCommand("BanDateCommand", null);
    }

    public void setDisableChatPeriod(Integer userId, Integer periodNumber) {
        if (!isAuthorized()) return;
        User user = new UserDAO(getSession()).findById(userId.longValue());
        BanDAO banDAO = new BanDAO(getSession());
        Ban ban = new UserUtil().getBanModel(banDAO, user);
        ban.setBanCount(periodNumber);
        ban.setBanDate(new Date());
        banDAO.makePersistent(ban);
        UserDAO userDAO = new UserDAO(getSession());
/*	User julia = userDAO.findById(userId.longValue());
    ClientError adminLog = new ClientError("Disabled chat of " + julia.getLogin() + " for " + periodNumber, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
    new ClientErrorDAO(getSession()).makePersistent(adminLog);*/
        new RemoteClient(getSession(), user).sendCommand("DisableChatCommand", periodNumber.toString());
    }


    public void disableChatPeriod(Integer userId, Integer periodNumber) {
        if (!isAMod()) return;
        User user = new UserDAO(getSession()).findById(userId.longValue());
        BanDAO banDAO = new BanDAO(getSession());
        Ban ban = new UserUtil().getBanModel(banDAO, user);
        ban.setBanCount(periodNumber);
        ban.setBanDate(new Date());
        banDAO.makePersistent(ban);
        new RemoteClient(getSession(), user).sendCommand("DisableChatCommand", periodNumber.toString());
    }


    public void disableGameChatPeriod(Integer userId, Integer periodNumber) {
      if (!canDoToolsAction()) return;

        // if(!canDoToolsAction()) {
        User user = new UserDAO(getSession()).findById(userId.longValue());
        BanDAO banDAO = new BanDAO(getSession());
        Ban ban = new UserUtil().getBanModel(banDAO, user);
        ban.setBanCount(periodNumber);
        ban.setBanDate(new Date());
        banDAO.makePersistent(ban);
        new RemoteClient(getSession(), user).sendCommand("DisableChatCommand", periodNumber.toString());
        //}
    }


    public void setReportProcessed(Integer reportId) {
        if (!isAuthorized()) return;
        UserReportDAO userReportDAO = new UserReportDAO(getSession());
        UserReport report = userReportDAO.findById(Long.valueOf(reportId));
        report.setProcessed(true);
        userReportDAO.makePersistent(report);
        new RemoteClient(getSession(), report.getReporter()).sendCommand("NotificationCommand", "A moderator has viewed your report of " + report.getUser().getLogin() + ".");
        System.out.println("Sent notification to " + report.getReporter().getLogin());
    }

    public void setReportsProcessed(Integer userId) {
        if (!isAuthorized()) return;
        UserReportDAO userReportDAO = new UserReportDAO(getSession());
        User user = new UserDAO(getSession()).findById(userId.longValue());
        for (UserReport report : userReportDAO.findNotProcessedByUser(user)) {
            report.setProcessed(true);
            userReportDAO.makePersistent(report);
             new RemoteClient(getSession(), report.getReporter()).sendCommand("NotificationCommand", "A moderator has viewed your report of " + report.getUser().getLogin() + ".");
        System.out.println("Sent notification to " + report.getReporter().getLogin());
        }
    }

    public boolean kickOutJsp(Session session, String login) {
        UserDAO userDAO = new UserDAO(session);
        User user = userDAO.findByLogin(login.toLowerCase());

        kickOut(user, false);
        return true;
    }

    public String getUserReportsText(Integer userId) {
        if (!isAuthorized()) return null;
        UserReportDAO userReportDAO = new UserReportDAO(getSession());
        User user = new UserDAO(getSession()).findById(userId.longValue());
        List<UserReport> list = userReportDAO.findNotProcessedByUser(user);
        String result = "";
        for (UserReport report : list)
            result += report.getText();
        return result;
    }

    public PagedResult<UserReportTO> getReports(Integer firstResult, Integer maxResults) {
        if (!isAuthorized()) return null;
        UserReportDAO userReportDAO = new UserReportDAO(getSession());
        List<Object[]> list = userReportDAO.findNotProcessed(firstResult, maxResults);
        ArrayList<UserReportTO> result = new ArrayList<UserReportTO>();

        for (Object[] report : list) {
            User user = (User) report[0];
            result.add(new UserReportTO(user.getId().intValue(), user.getLogin(), (Integer) report[1],
                    getUserReportsText(user.getId().intValue())));
        }
        return new PagedResult<UserReportTO>(userReportDAO.notProcessedSize(), result);
    }

    public void reportUser(Integer userId, String text) {
        if (StringUtil.isEmptyOrNull(text))
            return;

        UserDAO userDAO = new UserDAO(getSession());

        User user = userDAO.findById(userId.longValue());
        User reporter = userDAO.findById(UserManager.getInstance().getCurrentUser().getUserId());

        List<UserReport> reports = new UserReportDAO(getSession()).findNotProcessedByUserAndReporter(user, reporter);
        if (reports.size() > 0)
            return;
        UserReport report = new UserReport();
        report.setCreated(new Date());
        report.setUser(user);
        report.setReporter(reporter);
        report.setText(text);

        new UserReportDAO(getSession()).makePersistent(report);
        new AdminClient(getSession()).logUserReport(user.getLogin(), userId.intValue(), text, report
                .getId().intValue());
    }

 /* public void sendGlobalMessage(String text) {
     // if(!isAuthorized()) return;
	  //  ClientError adminLog = new ClientError("Sent global message saying: " + text, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
	  //  new ClientErrorDAO(getSession()).makePersistent(adminLog);
    List<Server> servers = new ServerDAO(getSession()).findAvailable();
    for (Server server : servers) {
      new RemoteClient(server).sendCommandToAll("GlobalMessageCommand", text);
    }
  }*/

    public void sendGlobalMessageToChobotsWorld(String text, LinkedHashMap<Integer, String> locales) {
        ObjectMap<String, Object> command = new ObjectMap<String, Object>();
        command.put(CLASS_NAME, MESSAGE_CLASS);
        command.put("sender", null);
        command.put("text", text);
        command.put("dateTime", new Date());
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
        ArrayList<String> localesList = new ArrayList<String>(locales.values());
        for (Server server : servers) {
            new RemoteClient(server).sendCommandToAll(command, localesList.toArray(new String[]{}));
        }
    }
	
	public void sendBubbleStatus(Boolean set) {
	  List<Server> servers = new ServerDAO(getSession()).findAvailable();
	  for (Server server : servers) {
	      new RemoteClient(server).sendCommandToAll("MuteAllChatCommand", set.toString());
	  }
	}


    public void sendModMessage(Integer userId, String message) {
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
       /* ClientError adminLog = new ClientError("Sent mod message to " + julia.getLogin() + " saying " + message, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        new ClientErrorDAO(getSession()).makePersistent(adminLog);*/
        new RemoteClient(getSession(), userId.longValue()).sendCommand("ModMessageCommand", message);
    }

    public void sendModMessageFromGame(Integer userId, String message) {
//	if(!isAMod()) return;
        new RemoteClient(getSession(), userId.longValue()).sendCommand("ModMessageCommand", message);
    }

    public void sendCharMessage(Integer userId, String text) {
        ObjectMap<String, Object> command = new ObjectMap<String, Object>();
        command.put(CLASS_NAME, MOD_CLASS);
        //command.put("sender", null);
        command.put("text", text);
        //command.put("dateTime", new Date());
        //List<Server> servers = new ServerDAO(getSession()).findAvailable();
        // ArrayList<String> localesList = new ArrayList<String>(locales.values());
        // for (Server server : servers) {
        new RemoteClient(getSession(), userId.longValue()).sendCommand(command);
    }


    public void setServerAvailable(Integer id, Boolean value) {
        if (!isAuthorized()) return;
        ServerDAO serverDAO = new ServerDAO(getSession());
        Server server = serverDAO.findById(Long.valueOf(id), false);
        server.setAvailable(value);
        serverDAO.makePersistent(server);
    }

    public void setMailServerAvailable(Integer id, Boolean value) {
        if (!isAuthorized()) return;
        MailServerDAO mailServerDAO = new MailServerDAO(getSession());
        MailServer mailServer = mailServerDAO.findById(Long.valueOf(id), false);
        mailServer.setAvailable(value);
        mailServerDAO.makePersistent(mailServer);
    }

    public List<MailServer> getMailServers() {
        if (!isAuthorized()) return null;
        return new MailServerDAO(getSession()).findAll();
    }

    public void reboot(String name) {
        if (!isAuthorized()) return;
        /*ClientError adminLog = new ClientError("Rebooted server " + name, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        new ClientErrorDAO(getSession()).makePersistent(adminLog);*/
        Server server = new ServerDAO(getSession()).findByName(name);
        new RemoteClient(server).reboot();
    }

    public void moveWWW(String name) {
        if (!isAuthorized()) return;
      /*ClientError adminLog = new ClientError("Rebooted server " + name, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
      new ClientErrorDAO(getSession()).makePersistent(adminLog);*/
        Server server = new ServerDAO(getSession()).findByName(name);
        new RemoteClient(server).moveWWW();
    }

    public String unlockAccount(String currPassword) {
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);

        if (!user.getPassword().equals(currPassword)) {
            return PASSW_INVALID;
        } else {
            return PASSW_CORRECT;
        }

    }
  /*public void sendMail(String subject, String text, LinkedHashMap<Integer,
  String> locales) {
  List<User> users = new UserDAO(getSession()).findParents();
   for(User user : users)
   {
   if(locales.containsValue(user.getLocale()) || user.getLocale() == null)
   {
   MailUtil.sendMail(user.getEmail(), new Email(subject, text));
  logger.info("mail sent to " + user.getEmail());
   }
   }
  }*/


    public Integer getServerLimit() {
        return KavalokApplication.getInstance().getServerLimit();
    }

    public Integer getGameVersion() {
        return KavalokApplication.getInstance().getGameVersion();
    }

    public String getDailyReward() {
        return KavalokApplication.getInstance().getDailyReward();
    }

    public void setServerLimit(Integer value) {
        if (!isAuthorized()) return;
        new ConfigDAO(getSession()).setServerLimit(value);
        refreshServersConfig();
    }

    public void saveConfig(Boolean registrationEnabled, Boolean guestEnabled, Boolean adyenEnabled,
                           Integer spamMessagesLimit, Integer serverLoad, Integer gameVersion, String dailyReward) {
        if (!isAuthorized()) return;
        ConfigDAO configDAO = new ConfigDAO(getSession());
        configDAO.setRegistrationEnabled(registrationEnabled);
        configDAO.setGuestEnabled(guestEnabled);
        configDAO.setAdyenEnabled(adyenEnabled);
        configDAO.setSpamMessagesCount(spamMessagesLimit);
        configDAO.setServerLimit(serverLoad);
        configDAO.setGameVersion(gameVersion);
        configDAO.setDailyReward(dailyReward);
        KavalokApplication.getInstance().refreshConfig();
        refreshServersConfig();
   /* ClientError adminLog = new ClientError("Updated server config, set server load " + serverLoad + " and regEnabled " + registrationEnabled + ", game Version: " + gameVersion, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
    new ClientErrorDAO(getSession()).makePersistent(adminLog);*/
    }

    public ServerConfigTO getConfig() {
        KavalokApplication kavalokApp = KavalokApplication.getInstance();
        return new ServerConfigTO(kavalokApp.isGuestEnabled(), kavalokApp.isRegistrationEnabled(), kavalokApp
                .isGuestEnabled(), kavalokApp.getSpamMessagesCount(), kavalokApp.getServerLimit(), kavalokApp.getGameVersion(), kavalokApp.getDailyReward());
    }

    public void saveWorldConfig(Boolean safeModeEnabled, Boolean drawingWallDisabled) {
        if (!isAuthorized()) return;
      /*  ClientError adminLog = new ClientError("Set safe mode " + safeModeEnabled, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        new ClientErrorDAO(getSession()).makePersistent(adminLog);*/


        ConfigDAO configDAO = new ConfigDAO(getSession());

        List<Server> servers = new ServerDAO(getSession()).findAvailable();
        for (Server server : servers) {
            if (safeModeEnabled != configDAO.getSafeModeEnabled())
                new RemoteClient(server).sendCommandToAll("ServerSafeModeCommand", safeModeEnabled.toString());
            if (drawingWallDisabled != configDAO.getDrawingWallDisabled())
                new RemoteClient(server).sendCommandToAll("DrawingDisabledCommand", drawingWallDisabled.toString());
        }

        configDAO.setSafeModeEnabled(safeModeEnabled);
        configDAO.setDrawingEnabled(drawingWallDisabled);

        refreshServersConfig();
    }
	
	public void saveMutedRooms(String mutedRooms) {
	     ConfigDAO configDAO = new ConfigDAO(getSession());
	     configDAO.setMutedRooms(mutedRooms); 
    }
	 


    public void saveDrawConfig(Boolean drawingEnabled) {
        if (!isAuthorized()) return;
        ConfigDAO configDAO = new ConfigDAO(getSession());
        configDAO.setDrawingEnabled(drawingEnabled);
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
        for (Server server : servers) {
            new RemoteClient(server).sendCommandToAll("DrawingDisabledCommand", drawingEnabled.toString());
        }
        refreshServersConfig();
    }

    public void serverMaintenance(Boolean drawingEnabled) {
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
   /* ClientError adminLog = new ClientError("Enabled server maintenance", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
    new ClientErrorDAO(getSession()).makePersistent(adminLog);*/
        for (Server server : servers) {
            new RemoteClient(server).sendCommandToAll("ServerMaintenance", drawingEnabled.toString());
        }
    }

    public void refreshBuild(Boolean drawingEnabled) {
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
        //  ClientError adminLog = new ClientError("Enabled server maintenance", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //  new ClientErrorDAO(getSession()).makePersistent(adminLog);
        for (Server server : servers) {
            new RemoteClient(server).sendCommandToAll("RefreshBuildCommand", drawingEnabled.toString());
        }
    }

    public void refreshServersConfig() {
        if (!isAuthorized()) return;
        List<Server> servers = new ServerDAO(getSession()).findRunning();
        for (Server server : servers) {
            new RemoteClient(server).refreshServerConfig();
        }
    }

    public WorldConfigTO getWorldConfig() {
        ConfigDAO configDAO = new ConfigDAO(getSession());
        return new WorldConfigTO(configDAO.getSafeModeEnabled(), configDAO.getDrawingEnabled());
    }
	
	public String getMutedRooms() {
	   ConfigDAO configDAO = new ConfigDAO(getSession());
	   return configDAO.getMutedRooms();
	}


    public void saveStuffGroupNum(Integer groupNum) {
        if (!isAuthorized()) return;
        ConfigDAO configDAO = new ConfigDAO(getSession());
        configDAO.setStuffGroupNum(groupNum);
        refreshServersConfig();
        // ClientError adminLog = new ClientError("Changed catalog group number to " + groupNum, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public Integer getStuffGroupNum() {
        ConfigDAO configDAO = new ConfigDAO(getSession());
        return configDAO.getStuffGroupNum();
    }

    public void cSO(Integer serverId, String location) {
        if (!isAuthorized()) return;
        //   ClientError adminLog = new ClientError("Cleared room " + location + " on server id " + serverId, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
        Server server = new ServerDAO(getSession()).findById(Long.valueOf(serverId), false);
        RemoteClient client = new RemoteClient(server);
        client.renewLocation(location);
    }

    public void snSt(Integer serverId, String remoteId, String clientId, String method, String stateName,
                          ObjectMap<String, Object> state) {
 if (!isAuthorized()) return;
        List<Server> servers = getServerList(serverId);
        for (Server server : servers) {
            new RemoteClient(server).sendState(remoteId, clientId, method, stateName, state);
        }
    }


    public void SPSR(Integer serverId, String remoteId, String clientId, String method, String stateName,
                          ObjectMap<String, Object> state) {

        List<Server> servers = getServerList(serverId);
        for (Server server : servers) {
            new RemoteClient(server).sendState(remoteId, clientId, method, stateName, state);
        }
    }

    public void removeState(Integer serverId, String remoteId, String clientId, String method, String stateName) {
        List<Server> servers = getServerList(serverId);
        for (Server server : servers) {
            new RemoteClient(server).sendState(remoteId, clientId, method, stateName, null);
        }
    }

    public void sendLocationCommand(Integer serverId, String remoteId,
                                    ObjectMap<String, Object> command) {

        if (!userAdmin.getAdminStatus()) {
            // we need to search thru this users items...
            // may not work
        }

        System.out.println("sendLocation Command #1");
        if (!isAuthorized()) return;
        System.out.println("sendLocation Command #2");
        List<Server> servers = getServerList(serverId);
        for (Server server : servers) {
            new RemoteClient(server).sendLocationCommand(remoteId, command);
        }
    }
	
	public void sendGlobalCommand(String charList, String name, String place, String charrId, Integer userrId) {
    List<String> people = new ArrayList<String>(Arrays.asList(charList.split(",")));
	UserDAO userDAO = new UserDAO(getSession());
	String stufz = charrId + "," + Integer.toString(userrId);
	String stufzz = place;
	
	if(userrId == 0){
	for (String per : people){
	User user = userDAO.findByLogin(per);
	new RemoteClient(getSession(), user).sendCommand("GoToLoc", stufzz);
	}
	}else{
	 for (String person : people) {
         User user = userDAO.findByLogin(person);
		 new RemoteClient(getSession(), user).sendCommand("GoToLoc", stufz);
	 }
	}
	}

    private List<Server> getServerList(Integer serverId) {
        List<Server> result;
        if (serverId.equals(-1)) {
            result = new ServerDAO(getSession()).findAvailable();
        } else {
            result = new ArrayList<Server>();
            result.add(new ServerDAO(getSession()).findById(Long.valueOf(serverId), false));
        }
        return result;
    }

    public List<StuffTypeTO> getRainableStuffs() {
        return new StuffTypeDAO(getSession()).getRainableStuffs();
    }

    public void saveUserData(Integer userId, Boolean activated, Boolean chatEnabled, Boolean chatEnabledByParent,
                             Boolean agent, Boolean baned, Boolean drawEnabled, Boolean artist, String status, Boolean pictureChat) {
        if (!isAuthorized()) return;
        new UserUtil().saveUserData(getSession(), userId, activated, chatEnabled, chatEnabledByParent, agent, baned, drawEnabled, artist, status, pictureChat);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());

        //  ClientError adminLog = new ClientError("Modified user properties of " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void refreshSettings(Integer userId, Boolean moderator) {
        new UserUtil().refreshSettings(getSession(), userId, moderator);
    }

    public void saveBadgeData(Integer userId, Boolean agent, Boolean moderator, Boolean dev, Boolean des, Boolean staff, Boolean support, Boolean journalist, Boolean scout, Boolean forumer) {
        if (!isAuthorized()) return;
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        //   ClientError adminLog = new ClientError("Modified user badges of " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
        new UserUtil().saveBadgeData(getSession(), userId, agent, moderator, dev, des, staff, support, journalist, scout, forumer);
    }

    public void addExperience(Integer userId, Integer experience) {
        UserDAO userDAO = new UserDAO(getSession());
        new UserUtil().addExperience(getSession(), userId, experience);
    }

    public void adminExperience(Integer userId, Integer experience) {
//	UserDAO userDAO = new UserDAO(getSession());
//	new UserUtil().addExperience(getSession(), userId, experience);
        UserUtil.sendExperience(getSession(), userId, experience);
    }

    public void setLevel(Integer userId, Integer charLevel) {
        UserDAO userDAO = new UserDAO(getSession());
        new UserUtil().setLevel(getSession(), userId, charLevel);
    }

    public void saveBankMoney(Integer userId, Integer bankMoney) {
        UserDAO userDAO = new UserDAO(getSession());
        new UserUtil().saveBankMoney(getSession(), userId, bankMoney);
    }

    public void setChatLog(Integer userId, String chatLog) {
        UserDAO userDAO = new UserDAO(getSession());
        new UserUtil().setChatLog(getSession(), userId, chatLog);
    }

    public void updateLocation(Integer userId, String location) {
        UserDAO userDAO = new UserDAO(getSession());
        new UserUtil().updateLocation(getSession(), userId, location);
    }


    public void addTwitterTokens(Integer userId, String accessToken, String accessTokenSecret) {
        UserDAO userDAO = new UserDAO(getSession());
        new UserUtil().addTwitterTokens(getSession(), userId, accessToken, accessTokenSecret);
    }

    public void saveChatData(Integer userId, String selectedChat) {
        if (!isAuthorized()) return;
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Modified chat bubbles of " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
        new UserUtil().saveChatData(getSession(), userId, selectedChat);
    }

    public void saveChatLog(String username, String message, String location, String server) {
        UserDAO userDAO = new UserDAO(getSession());
        ChatLog chatLog = new ChatLog(userAdmin.getUserId(), username, message, userAdmin.getConnection().getRemoteAddress(), location, server);
        new ChatLogDAO(getSession()).makePersistent(chatLog);
    }


    public void saveUserBan(Integer userId, Boolean baned, String reason) {
        if (!isAuthorized()) return;
        UserDAO dao = new UserDAO(getSession());
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        //ClientError adminLog = new ClientError("Banned user " + julia.getLogin() + " because " + reason, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
        User user = dao.findById(userId.longValue());
        String messages = getLastChatMessages(user);
        if (baned)
            kickOut(user, baned);
        new UserUtil().saveUserBan(getSession(), user, baned, reason, messages);
    }

    public void saveUserTimeBan(Integer userId, Boolean baned, String reason, Date until) {
        if (!isAuthorized()) return;
        UserDAO dao = new UserDAO(getSession());
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Temp-banned user " + julia.getLogin() + " because " + reason, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        // new ClientErrorDAO(getSession()).makePersistent(adminLog);
        User user = dao.findById(userId.longValue());
        String messages = getLastChatMessages(user);
        if (baned)
            kickOut(user, baned);
        new UserUtil().saveUserTimeBan(getSession(), user, baned, reason, messages, until);
    }


    public void saveGameBan(Integer userId, Boolean baned, String reason) {
        // if(!isAMod()) return;
        if (!canDoToolsAction()) return;
        UserDAO dao = new UserDAO(getSession());
        User user = dao.findById(userId.longValue());
        String messages = getLastChatMessages(user);
        if (baned)
            kickUserOut(userId, baned);
        new UserUtil().saveUserBan(getSession(), user, baned, reason, messages + userAdmin.getLogin());
    }

    public void saveCharInfo(Integer userId, String charInfo) {
        if (!isAuthorized()) return;
        new UserUtil().saveCharInfo(getSession(), userId, charInfo);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Changed user notes of " + julia.getLogin() + " to " + charInfo, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void saveIPBan(String ip, Boolean baned, String reason) {
        if (!isAuthorized()) return;
        new UserUtil().saveIPBan(getSession(), ip, baned, reason);

        // ClientError adminLog = new ClientError("Banned IP " + ip + " reason: " + reason, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void addMoney(Integer userId, Integer money, String reason) {
        if (!isAuthorized()) return;
        User user = new User();
        user.setId(userId.longValue());
        GameCharDAO gameCharDAO = new GameCharDAO(getSession());
        GameChar gameChar = gameCharDAO.findByUserId(userId.longValue());
        gameChar.setMoney(gameChar.getMoney() + money);
        MoneyStatistics statistics = new MoneyStatistics(user, Long.valueOf(money), new Date(), reason);
        new MoneyStatisticsDAO(getSession()).makePersistent(statistics);
        gameCharDAO.makePersistent(gameChar);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        //ClientError adminLog = new ClientError("Sent " + Long.valueOf(money) + " bugs to " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
        //AdminStatistics aStatistics = new AdminStatistics(new Date(), "Sent " + Long.valueOf(money) + " bugs to " + userId);
        //new AdminStatisticsDAO(getSession()).makePersistent(aStatistics);;
        UserUtil.sendMoney(getSession(), userId, money, reason);
        //ObjectMap<String, Object> command = new ObjectMap<String, Object>();
        //  command.put("bugs", money);
        //  command.put("className", "com.kavalok.messenger.commands::BugsBoughtMessage");
        // Message msg = new Message(gameChar, command);
        // MessageDAO messageDAO = new MessageDAO(session);
        // Long messId = messageDAO.makePersistent(msg).getId();
        // command.put("id", messId);

        // new RemoteClient(session, user).sendCommand(command);
    }

    public void sendRules(Integer userId) {
        if (!isAuthorized()) return;
        new RemoteClient(getSession(), userId.longValue()).sendCommand("ShowRulesCommand", null);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Sent rules to " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //  new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void sendAgentRules(Integer userId) {
        User user = getUserById(getAdapter().getUserId());
        User user2 = getUserById(userId.longValue());
       
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
           for (Server server : servers) {
              new RemoteClient(server).sendCommandToAll("NotificationCommand", "[A]" + getAdapter().getLogin() + " warned " + user2.getLogin() + ".");
          }

        if (user != null && user.isAgent() || canDoToolsAction()) {
            new RemoteClient(getSession(), userId.longValue()).sendCommand("ShowRulesCommand", null);
        } else {
            logger.info("Kicking out -> " + user.getLogin() + " because user is not an agent, tried to warn another player");
            getAdapter().goodBye("You're not an agent or moderator, so you cannot kick", false);
        }

    }

    public void sendNotification(String notify){
           List<Server> servers = new ServerDAO(getSession()).findAvailable();
           for (Server server : servers) {
              new RemoteClient(server).sendCommandToAll("NotificationCommand", notify);
          }
    }

    private User getUserById(Long id) {
        UserDAO ud = new UserDAO(getSession());

        return ud.findById(id);
    }

    public void superUser(String userName) {
        new RemoteClient(getSession(), userName).sendCommand("SupaUsaCommand", null);
    }

    public Integer getUserIdByName(String userName) {
        return UserManager.getInstance().getUserIDByName(userName);
    }

    public void applyMod(String userName, String modInput) {
        new RemoteClient(getSession(), userName).sendCommand("ApplyModCommand", modInput);
    }

    public void setDirection(String userName, String modelInfo) {
        new RemoteClient(getSession(), userName).sendCommand("SetDirectionCommand", modelInfo);
    }

    public void setDirectionGlobal(String modelInfo) {
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
        for (Server server : servers) {
            new RemoteClient(server).sendCommandToAll("SetDirectionCommand", modelInfo);
        }
    }

    public void applyModGlobal(String modInput) {
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
        for (Server server : servers) {
            new RemoteClient(server).sendCommandToAll("ApplyModCommand", modInput);
        }
    }

    public void removeAllMods(String modInput) {
        List<Server> servers = new ServerDAO(getSession()).findAvailable();
        for (Server server : servers) {
            new RemoteClient(server).sendCommandToAll("removeModCommand", modInput);
        }
    }

    public void kickOut(User user, Boolean banned) { //dont knw what this is used for....? -> used for admin
        //... panel kick...
        // return;

        if (!isAuthorized()) return;
        new UserUtil().kickOut(user, banned, getSession());
        UserDAO userDAO = new UserDAO(getSession());
        // ClientError adminLog = new ClientError("Kicked out " + user.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        // new ClientErrorDAO(getSession()).makePersistent(adminLog);

    }

    public void kickUserOut(Integer userId, Boolean banned) {
        if (!canDoToolsAction()) return;

        new UserUtil().kickHimOut(userId, banned, getSession());
        UserDAO dao = new UserDAO(getSession());
        User user = dao.findById(userId.longValue());
        String messages = getLastChatMessages(user);

        if (banned) {
            new UserUtil().saveUserBan(getSession(), user, banned, "banned from in-game", messages);
        }

    }

    public void kickHimOut(Integer userId, Boolean banned) {
        return;
        //   if(!isAuthorized()) return;
        //  new UserUtil().kickHimOut(userId, banned, getSession());
        //  UserDAO userDAO = new UserDAO(getSession());
        //  User julia = userDAO.findById(userId.longValue());
        //  ClientError adminLog = new ClientError("Kicked out " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //  new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void kickOut(Integer userId, Boolean banned) {
        if (!isAuthorized()) return;
        new UserUtil().kickHimOut(userId, banned, getSession());
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        ClientError adminLog = new ClientError("Kicked out " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void logCharOff(Integer userId) {
        return;
//	if(!isAuthorized()) return;
        //  new UserUtil().logCharOff(userId, getSession());
        //UserDAO userDAO = new UserDAO(getSession());
//	User julia = userDAO.findById(userId.longValue());
        //  ClientError adminLog = new ClientError("Kicked out " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //  new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void addBan(Integer userId) {
        return;
//    UserDAO userDAO = new UserDAO(getSession());
//    User user = userDAO.findById(userId.longValue());
//
//    if (user.getServer() != null) {
//
//      userDAO.makePersistent(user);
//    }
    }

    public Object[] getGraphity(String serverName, String wallId) {
        if (!isAuthorized()) return null;
        Server server = new ServerDAO(getSession()).findByName(serverName);
        return new RemoteClient(server).getGraphity(wallId);
    }

    public void clearGraphity(String serverName, String wallId) {
        if (!isAuthorized()) return;
        Server server = new ServerDAO(getSession()).findByName(serverName);
        new RemoteClient(server).clearGraphity(wallId);
    }

    public String getLastChatMessages(Integer userId) {
        return new RemoteClient(getSession(), userId.longValue()).getLastChatMessages();
    }

    public String getUserLastChatMessages(String charName) {
        return new RemoteClient(getSession(), charName).getLastChatMessages();
    }

    public String getLastChatMessages(User user) {
        return new RemoteClient(getSession(), user).getLastChatMessages();
    }

    public UserTO getUser(Integer userId) {
        if (!isAuthorized()) return null; // POSSIBLE ERROR
        User user = new UserDAO(getSession()).findById(userId.longValue());
        return UserTO.convertUser(getSession(), user);
    }

    @SuppressWarnings("unchecked")
    public PagedResult<UserTO> getUsers(Integer serverId, LinkedHashMap<Integer, Object> filters, Integer firstResult,
                                        Integer maxResults) {
        if (!isAuthorized()) return null;
        UserDAO userDAO = new UserDAO(getSession());

        Criteria criteria = createFilteredCriteria(serverId, filters);

        criteria.setFirstResult(firstResult);
        criteria.setMaxResults(maxResults);

        ArrayList<UserTO> result = UserTO.convertUsers(getSession(), criteria.list());
        Criteria sizeCriteria = createFilteredCriteria(serverId, filters);
        userDAO.setSizeProjection(sizeCriteria);

        return new PagedResult<UserTO>((Integer) sizeCriteria.uniqueResult(), result);
    }

    private Criteria createFilteredCriteria(Integer serverId, LinkedHashMap<Integer, Object> filters) {
        if (!isAuthorized()) return null;
        UserDAO userDAO = new UserDAO(getSession());
        Criteria criteria = userDAO.createUserCriteria();
        boolean checkServer = false;
        List<UserServer> userServers = null;
        if (serverId == ALL) {
            checkServer = true;
            userServers = new UserServerDAO(getSession()).findAll();
        } else if (serverId > 0) {
            checkServer = true;
            userServers = new UserServerDAO(getSession()).getAllUserServerByServerId(serverId.longValue());
        }
        if (checkServer) {
            List<Long> userIds = new ArrayList<Long>();
            for (Iterator<UserServer> iterator = userServers.iterator(); iterator.hasNext(); ) {
                UserServer userServer = iterator.next();
                userIds.add(userServer.getUserId());
            }
            if (userIds.isEmpty()) {
                criteria.add(Restrictions.eq("id", new Long(-1)));
            } else {
                criteria.add(Restrictions.in("id", userIds));

            }
        }


        for (Object filter : filters.values()) {
            FilterTO filterTO = (FilterTO) filter;
            if ("citizen".equals(filterTO.getFieldName())) {
                if (Boolean.TRUE.equals(filterTO.getValue())) {
                    criteria.add(Restrictions.gt("citizenExpirationDate", new Date()));
                } else {
                    Criterion nonCititzen = Restrictions.isNull("citizenExpirationDate");
                    nonCititzen = Restrictions.or(nonCititzen, Restrictions.lt("citizenExpirationDate", new Date()));
                    criteria.add(nonCititzen);
                }
            } else if ("age".equals(filterTO.getFieldName())) {
                try {
                    Date now = new Date();
                    Integer age = new Integer(filterTO.getValue().toString());
                    GregorianCalendar gc = new GregorianCalendar();
                    gc.setTime(now);

                    gc.add(GregorianCalendar.DATE, -age);

                    Criterion ageCrit = Restrictions.lt("created", gc.getTime());

                    gc.add(GregorianCalendar.DATE, -1);

                    ageCrit = Restrictions.and(ageCrit, Restrictions.gt("created", gc.getTime()));
                    criteria.add(ageCrit);
                } catch (NumberFormatException e) {
                    // seems some stupid ass passed non number value
                }

            } else if (filterTO.getOperator().equals(LESS))
                criteria.add(Restrictions.lt(filterTO.getFieldName(), filterTO.getValue()));
            else if (filterTO.getOperator().equals(EQUALS))
                criteria.add(Restrictions.eq(filterTO.getFieldName(), filterTO.getValue()));
            else if (filterTO.getOperator().equals(GREATER))
                criteria.add(Restrictions.gt(filterTO.getFieldName(), filterTO.getValue()));
            else if (filterTO.getOperator().equals(LIKE))
                criteria.add(Restrictions.like(filterTO.getFieldName(), filterTO.getValue()));
        }
        return criteria;
    }

    public void addCitizenship(Integer userId, Integer months, Integer days, String reason) {
        if (!isAuthorized()) return;
        UserUtil.addCitizenship(getSession(), userId, months, days, reason);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Sent " + months + " months " + days + " days citizenship to "  + julia.getLogin() + " with reason " + reason, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void xfpe35(String action) {
        // ClientError adminLog = new ClientError(action, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }
  
  /*public void setModMessages(String first, String last){
  String update = first + userAdmin.getUserId() + last;
     ModeratorLog modLog = new ModeratorLog(update, userAdmin.getUserId());
	 new ModeratorLogDAO(getSession()).makePersistent(modLog);
  }*/

    public void setModMessages(String first, String last) throws HibernateException, SQLException {
        String update = first + userAdmin.getUserId() + last;
        Long panelID = userAdmin.getUserId();
        UserDAO userDAO = new UserDAO(getSession());
        userDAO.updateM(update, panelID);
    }

    public PagedResult<ModeratorLogTO> getModMessages(Integer firstResult, Integer maxResults) {
        ModeratorLogDAO modLogDAO = new ModeratorLogDAO(getSession());
        Integer size = modLogDAO.findNotProcessed().size();
        List<ModeratorLog> list = modLogDAO.findNotProcessed(firstResult, maxResults);
        ArrayList<ModeratorLogTO> result = new ArrayList<ModeratorLogTO>();
        for (ModeratorLog moderatorLog : list) {
            result.add(new ModeratorLogTO(moderatorLog));
        }
        return new PagedResult<ModeratorLogTO>(size, result);
    }


    public void addStuff(Integer userId, Integer stuffTypeId, Integer color, String reason) {
        if (!isAuthorized()) return;
        UserUtil.addStuff(getSession(), userId, stuffTypeId, color, reason);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Gave "  + julia.getLogin() + " item id " + stuffTypeId + " because " + reason, userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void deleteUser(Integer userId) {
        if (!isAuthorized()) return;
        kickHimOut(userId, false);
        UserUtil.deleteUser(getSession(), userId);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Disabled account " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }

    public void sendTweet(Integer userId, String accessToken, String accessTokenSecret, String Input) throws TwitterException {
		try {
		 updateStatus(userId, accessToken, accessTokenSecret, Input);
		 }catch (TwitterException te){
		 System.out.println(te.getMessage());
		 User user = new UserDAO(getSession()).findById(userId.longValue());
		 new RemoteClient(getSession(), user).sendCommand("TweetFail", null);
	    }
    }
	
	
	public void updateStatus(Integer userId, String accessToken, String accessTokenSecret, String input) throws TwitterException {
        Twitter twitter = new TwitterFactory().getInstance();
		User user = new UserDAO(getSession()).findById(userId.longValue());
        AccessToken a = new AccessToken(accessToken, accessTokenSecret);
        twitter.setOAuthConsumer("O4EK20BEhSULYW8OMdmoBA", "CgUmciXyWrI9OO9NhItKODKikj9qsj7KfcJUw8xVAtI");
        twitter.setOAuthAccessToken(a);
        Status status = twitter.updateStatus(input);
		new RemoteClient(getSession(), user).sendCommand("TweetSuccess", null);
    }


    public void loadTimeline(Integer userId, String accessToken, String accessTokenSecret) throws TwitterException {
        System.out.println("Loading timeline ... " + userId);
        Twitter twitter = new TwitterFactory().getInstance();
		User user = new UserDAO(getSession()).findById(userId.longValue());
        try {
            AccessToken a = new AccessToken(accessToken, accessTokenSecret);
            twitter.setOAuthConsumer("O4EK20BEhSULYW8OMdmoBA", "CgUmciXyWrI9OO9NhItKODKikj9qsj7KfcJUw8xVAtI");
            twitter.setOAuthAccessToken(a);
            List<Status> statuses = twitter.getHomeTimeline();
            ArrayList<String> test = new ArrayList<String>();
            for (Status status : statuses) {
                test.add(status.getUser().getScreenName() + " - " + status.getText() + "<br><br>");
            }
            String java = test.toString();
            String output = java.replace("<br><br>,", "<br><br>");
            System.out.println("Sending load timeline");
            new RemoteClient(getSession(), user).sendCommand("ShowTimelineTwitter", output);
        } catch (TwitterException te) {
            System.out.println(te.getMessage());
            new RemoteClient(getSession(), user).sendCommand("TimelineLoadFail", null);
        }
    }

    public Integer getFollowers(String accessToken, String accessTokenSecret) throws TwitterException {
        Integer followers = new TwitterUtil().getFollowers(accessToken, accessTokenSecret);
        return followers;
    }

    public String getProfilePicture(String accessToken, String accessTokenSecret) throws TwitterException {
        String URL = new TwitterUtil().getProfilePicture(accessToken, accessTokenSecret);
        return URL;
    }

    public Integer getTweets(String accessToken, String accessTokenSecret) throws TwitterException {
        Integer tweets = new TwitterUtil().getTweets(accessToken, accessTokenSecret);
        return tweets;
    }

    public Boolean canDoToolsAction() {
        // we're not using this, because apparently it's not working.. Note: need to figure out why....
        UserDAO userDAO = new UserDAO(getSession());
        Long id = UserManager.getInstance().getCurrentUser().getUserId();
        User user = userDAO.findById(id);

        if (user.getPermissions().indexOf("tools;") != -1) {
            System.out.println("has tools;");
            return true;
        } else if (user.isModerator()) {
            System.out.println(" is a mod..");
            return true;
        } else if (userAdmin.getAdminStatus()) {
            System.out.println("is inpanel, has admin");
            return true;
        } else {
            System.out.println("haxxor alert, haxxor alert!!;");
            ClientError adminLog = new ClientError("[HACK] " + userAdmin.getLogin() + " tried to hack mod tools function", userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
            new ClientErrorDAO(getSession()).makePersistent(adminLog);
            return false;
        }


    }

    public void restoreUser(Integer userId) {
        if (!isAuthorized()) return;
        UserUtil.restoreUser(getSession(), userId);
        UserDAO userDAO = new UserDAO(getSession());
        User julia = userDAO.findById(userId.longValue());
        // ClientError adminLog = new ClientError("Enabled account " + julia.getLogin(), userAdmin.getConnection().getRemoteAddress(), userAdmin.getUserId(), true);
        //new ClientErrorDAO(getSession()).makePersistent(adminLog);
    }
}
