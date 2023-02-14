package com.kavalok.mail;
import java.util.Properties;
 
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.activation.DataHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.kavalok.KavalokApplication;
 
public final class Emailer {

    private static Logger logger = LoggerFactory.getLogger(Emailer.class);
 
	public void sendEmail(Properties properties, String toEmailAddr, String subject, String body) {
    Properties currentProperties = (Properties) properties.clone();
        final String RETURN_PATH_FORMAT = "bounce+chp.e%1$s@em1.chobots.net";
		final String username = "support@chobots.net";
		final String password = "vinDictive&3098hn";
		String md5;
 
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		try {
		md5 = getMd5(toEmailAddr);
        props.put("mail.smtp.from", String.format(RETURN_PATH_FORMAT, md5));// set
                                                                                      // return-path
                                                                                      // header
                                                                                      // to
                                                                                      // track
                                                                                      // email
                                                                                      // bounces
 
       } catch(NoSuchAlgorithmException e){
         logger.error(e.getMessage(), e);
       }
		Session session = Session.getInstance(props,
		  new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		  });
 
		try {
 
			MimeMessage message = new MimeMessage(session);
			message.addFrom(InternetAddress.parse(KavalokApplication.getInstance().getApplicationConfig()
          .getEmailsenderName()
          + "<" + KavalokApplication.getInstance().getApplicationConfig().getEmailsenderAddress() + ">"));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmailAddr));
			message.setSubject(subject, MailUtil.ENCODING);
			message.setText(body, MailUtil.ENCODING);
			message.setDataHandler(new DataHandler(new ByteArrayDataSource(body, "text/plain")));
            message.setHeader("Content-Type", "text/plain; charset=UTF-8");
            message.saveChanges();
			Transport.send(message);
           } catch (Exception e) {
           logger.error("Cannot send email. ", e);
           logger.error("Mail send failed");
           }
         }

private String getMd5(String toEmailAddr) throws NoSuchAlgorithmException {
    MessageDigest m = MessageDigest.getInstance("MD5");
    m.update(toEmailAddr.getBytes(), 0, toEmailAddr.length());
    String md5 = new BigInteger(1, m.digest()).toString(16);
    while (md5.length() < 32)
      md5 = "0" + md5;
    return md5;
  }
}