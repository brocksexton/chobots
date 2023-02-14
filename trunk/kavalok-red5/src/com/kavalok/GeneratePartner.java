package com.kavalok;

import java.util.ArrayList;
import java.util.List;

public class GeneratePartner {

  private static String[] banners = { 
    "banner_135_600.swf", 
    "banner_160_600.swf", 
    "banner_190_100.swf",
    "banner_300_80.swf", 
    "banner_first_135_600.swf", 
    "banner_first_160_600.swf", 
    "banner_games_135_600.swf",
    "banner_games_160_600.swf", 
    "banner_graffity_300_250.swf", 
    "banner_last_135_600.swf", 
    "banner_last_160_600.swf", 
    "banner_405_75.swf" };

  private static String parterName = "mdsonk";
//  insert into Partner(login, password) values('mdsonk', SUBSTRING(MD5(RAND()),15);

  public static void main(String[] args) {

    System.out.println("<html>");
    System.out.println("<head>");
    System.out.println("<title>Chobots - Your Family Game! - " + parterName + "</title>");
    System.out.println("</head>");
    System.out.println("<body>");
    System.out.println("");
    System.out.println("<!-- Chobots flash place tart -->");
    System.out.println("<div align=\"center\">");
    System.out.println("  <div id=\"ch_game_content\">");
    System.out.println("  </div>");
    System.out.println("  <p align=\"center\"><font face=\"Verdana\" size=\"2\">");
    System.out.println("  <a href=\"http://www.chobots.com/contact_us.html\">Chobots Support</a> |");
    System.out.println("  <a href=\"http://www.chobots.com/privacy.html\">Privacy Policy</a> | ");
    System.out.println("  <a href=\"http://www.chobots.com/terms.html\">Terms and Conditions</a></font></p>");
    System.out.println("</div>");
    System.out.println("<!-- Chobots flash place end -->");
    System.out.println("");
    System.out.println("<!-- Chobots install script start -->");
    System.out
        .println("<script src=\"http://www.chobots.com/javascripts/partner.js\" type=\"text/javascript\"></script>");
    System.out.println("<script type=\"text/javascript\">");
    System.out.println("//<![CDATA[");
    System.out
        .println("   var _ch_p_={\"width\":\"902\", \"height\":\"512\", \"bgcolor\":\"#0066CC\", \"mppc_partner\":\""
            + parterName
            + "\", \"locale\":\"enUS\", \"enable_tracking\":false, \"content_holder\":\"ch_game_content\"};");
    System.out.println("   ch_p_install_swf(\"www.chobots.com\", _ch_p_); //]]> ");
    System.out.println("</script>");
    System.out.println("<!-- Chobots install script end -->");
    System.out.println("");
    System.out.println("</body>");
    System.out.println("</html>");

    System.out.println("");
    System.out.println("");
    System.out.println("");
    System.out.println("<html>");
    System.out.println("<head>");
    System.out.println("<title>Chobots - Your Family Game! - " + parterName + "</title>");
    System.out.println("</head>");
    System.out.println("<body>");
    System.out.println("");
    System.out.println("<!-- Chobots flash place tart -->");
    System.out.println("<div align=\"center\">");
    System.out.println("  <div id=\"ch_game_content\">");
    System.out.println("  </div>");
    System.out.println("  <p align=\"center\"><font face=\"Verdana\" size=\"2\">");
    System.out.println("  <a href=\"http://www.chobots.com/contact_us.html\">Chobots Support</a> |");
    System.out.println("  <a href=\"http://www.chobots.com/privacy.html\">Privacy Policy</a> | ");
    System.out.println("  <a href=\"http://www.chobots.com/terms.html\">Terms and Conditions</a></font></p>");
    System.out.println("</div>");
    System.out.println("<!-- Chobots flash place end -->");
    System.out.println("");
    System.out.println("<!-- Chobots install script start -->");
    System.out
        .println("<script src=\"http://www.chobots.com/javascripts/partner.js\" type=\"text/javascript\"></script>");
    System.out.println("<script type=\"text/javascript\">");
    System.out.println("//<![CDATA[");
    System.out
        .println("   var _ch_p_={\"width\":\"902\", \"height\":\"512\", \"bgcolor\":\"#0066CC\", \"mppc_partner\":\""
            + parterName
            + "\", \"locale\":\"enUS\", \"enable_tracking\":false, \"content_holder\":\"ch_game_content\", \"homepageurl\":\"http://URL_TO_CHOBOTS_ON_YOUR_SITE\"};");
    System.out.println("   ch_p_install_swf(\"www.chobots.com\", _ch_p_); //]]> ");
    System.out.println("</script>");
    System.out.println("<!-- Chobots install script end -->");
    System.out.println("");
    System.out.println("</body>");
    System.out.println("</html>");

    System.out.println("");
    System.out.println("");
    System.out.println("");

    for (int i = 0; i < banners.length; i++) {

      String bannerName = banners[i];

      List<Integer> indexes = new ArrayList<Integer>();
      int lastIndex = -1;
      while (bannerName.indexOf("_", lastIndex) >= 0) {
        lastIndex = bannerName.indexOf("_", lastIndex);
        indexes.add(lastIndex);
        lastIndex++;
      }

      String width = bannerName.substring(indexes.get(indexes.size() - 2) + 1, indexes.get(indexes.size() - 1));
      String height = bannerName.substring(indexes.get(indexes.size() - 1) + 1, bannerName.indexOf(".swf"));

      System.out.println("Banner " + width + "x" + height+"<br>");
      System.out.println("<!-- Banner " + width + "x" + height + "-->");
      System.out.println("<object width=\"" + width + "\" height=\"" + height + "\">");
      System.out.println("  <param name=\"movie\" value=\"http://www.chobots.com/game/resources/banners/" + bannerName
          + "\"/>");
      System.out.println("  <param name=\"FlashVars\" value=\"url=http://www.chobots.com/?partner=" + parterName
          + "\">");
      System.out.println("  <embed width=\"" + width + "\" height=\"" + height + "\"");
      System.out.println("    src=\"http://www.chobots.com/game/resources/banners/" + bannerName + "\"");
      System.out.println("    FlashVars=\"url=http://www.chobots.com/?partner=" + parterName + "\"/>");
      System.out.println("</object>");
      System.out.println("<br>");
      System.out.println("");
      System.out.println("");
    }

  }
}
