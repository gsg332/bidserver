package egovframework.com.bidserver.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.springframework.context.MessageSource;

public class MailUtil extends Authenticator {
	class MyAuthentication extends Authenticator {
	    PasswordAuthentication pa;
	    public MyAuthentication(String id, String pwd){
	    	
	        pa = new PasswordAuthentication(id, pwd);  //ex) ID:cafe24@cafe24.com PASSWD:1234
	    }

	    public PasswordAuthentication getPasswordAuthentication() {
	        return pa;
	    }
	}	
	
	public void sendMailStr(HashMap commandMap, MessageSource messageSource) throws Exception{
		
//		String serverUrl = messageSource.getMessage("server.url",null,Locale.KOREAN);
		try{
			
			Date today = new Date();
			  
		    SimpleDateFormat sdf = new SimpleDateFormat(new String("yyyy년 MM월 dd일"));
		    String todayStr = sdf.format(today);
			
			String msgText = "";
//			msgText ="<table style=\"width:668px; margin:0 auto; border:6px solid #5e6876; border-top:0; font-family: 'SimSun','Microsoft YaHei UI',Nanum Gothic,'돋움',Dotum,sans-serif;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">		<tbody><tr>			<td style=\"margin:0; padding:0;line-height:6px;\"><img src=\"http://"+serverUrl+"/static/images/email_header_top.gif\" alt=\"\" style=\"vertical-align:top;\"></td>		</tr>		<tr>			<td style=\"text-align:center;\"><a href=\"http://kmeili.com.cn/\" target=\"_blank\"><img src=\"http://"+serverUrl+"/static/images/email_header.gif\" alt=\"MEILI KOREA\"></a></td>		</tr>"		
//			+					commandMap.get("msgText").toString()
//			+"		<tr>"
//			+"			<td style=\"padding:0 34px; font-size:13px;\">"
//			+"				<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-top:1px solid #e6e6e6; border-bottom:1px solid #e6e6e6;\">"
//			+"					<tbody><tr>"
//			+"						<td colspan=\"7\" height=\"80px\">&nbsp;</td>"
//			+"					</tr>"
//			+"					<tr>"
//			+"						<td style=\"width:147px; background-color:#8a919b; height:32px; text-align:center; color:#fff; font-size:13px;\"><a style=\"color: rgb(255, 255, 255); text-decoration: none;\" href=\"http://"+medServerUrl+"\">网站首页</a></td>"
//			+"						<td width=\"3px\">&nbsp;</td>"
//			+"						<td style=\"width:147px; background-color:#8a919b; height:32px; text-align:center; color:#fff; font-size:13px;\"><a style=\"color: rgb(255, 255, 255); text-decoration: none;\" href=\"http://greenmedical.people.com.cn\">人民网绿色医疗观光网站</a></td>"
//			+"						<td width=\"3px\">&nbsp;</td>"
////			+"						<td style=\"width:147px; background-color:#8a919b; height:32px; text-align:center; color:#fff; font-size:13px;\"><a style=\"color: rgb(255, 255, 255); text-decoration: none;\" href=\"http://www.klaiba.com/\">k-laiba皮肤美容</a></td>"
//			+"						<td style=\"width:147px; background-color:#8a919b; height:32px; text-align:center; color:#fff; font-size:13px;\"><a style=\"color: rgb(255, 255, 255); text-decoration: none;\" href=\"http://"+serverUrl+"/cn/com/customer001.do\">帮助中心</a></td>"
//			+"					</tr>"
//			+"					<tr>"
//			+"						<td height=\"15px\">&nbsp;</td>"
//			+"					</tr>"
//			+"					<tr>"
//			+"						<td colspan=\"7\" style=\"font-size:13px; margin: 0; font-weight:normal; color:#888;\">这是"+todayStr+"向绿色医疗公益网咨询的用户发送的邮件。不同意接收广告推送邮件的会员也会收到本邮件。本邮件为发件专用，不可回复。</td>"
//			+"					</tr>"
//			+"					<tr>"
//			+"						<td height=\"20px\">&nbsp;</td>"
//			+"					</tr>"
//			+"				</tbody></table>"
//			+"			</td>"
//			+"		</tr>"
//			+"		<tr>"
//			+"			<td height=\"20px\">&nbsp;</td>"
//			+"		</tr>"
//			+"		<tr>"
//			+"			<td style=\"font-size:13px; padding:0px 34px 0 34px; font-weight:normal; color:#888;\">"
//			+"				<p style=\" margin: 0; padding: 0; font-weight:normal;\">网站运营：首尔市江南区新沙洞586-13，绿色医疗旅行社，营业执照号码：211-88-99533 </p>"
//			+"				<p style=\" margin: 0; padding: 0; font-weight:normal;\">咨询电话：82-2-540-1801 &nbsp; E-mail：<a href=\"mailto:info@greenmedicaltour.co.kr\" style=\"text-decoration:underline; color:#888;\">info@greenmedicaltour.co.kr</a></p>"
//			+"				<p style=\" margin: 0; padding: 0 0 40px; font-weight:normal;\">Copyrightⓒ 2014 绿色医疗旅行社, All rights reserved。</p>"
//			+"			</td>"
//			+"		</tr>"
//			+"		<tr>"
//			+"			<td height=\"20px\">&nbsp;</td>"
//			+"		</tr>"
//			+"	</tbody></table>";
			
			commandMap.put("msgText", msgText);
			
			sendMail(commandMap, null);
		}catch(Exception e){
		}
			
	}
	public void sendMailLink(HashMap commandMap, List<HashMap> bidInfo) throws Exception{
		
		try{
			Date today = new Date();
			
			String msgText =  commandMap.get("msgText").toString()+"<br/><br/>";;
			
			Multipart multipart = new MimeMultipart();
			
			if(bidInfo.size()>0){
				HashMap paramMap = (HashMap)bidInfo.get(0);
				
				for(int i=1;i<11;i++){
					
					if(paramMap.get("notice_spec_form"+i)!=null && ((String)paramMap.get("notice_spec_form"+i)).length()>0){
						
						String filename = paramMap.get("notice_spec_form"+i).toString();
			        	//String filename = "http://www.g2b.go.kr:8081/ep/co/fileDownload.do?fileTask=NOTIFY&fileSeq=20171122793::00::1::1";
						
			        	URL url = new URL(filename);
					    BufferedInputStream in = new BufferedInputStream(url.openConnection().getInputStream());
					    FileOutputStream fileOS = new FileOutputStream("temp" + i + ".tmp");
				        BufferedOutputStream bout = new BufferedOutputStream(fileOS);
				        int x;
				        while ((x = in.read()) != -1) bout.write(x);
			        	bout.flush();

					    File file = new File("temp" + i + ".tmp");
					        
					    DataSource source = new FileDataSource(file);
					    
					    BodyPart messageBodyPart = new MimeBodyPart();
					    messageBodyPart.setDataHandler(new DataHandler(source));
					    messageBodyPart.setFileName(MimeUtility.encodeText(paramMap.get("notice_spec_file_nm"+i).toString()));
					    multipart.addBodyPart(messageBodyPart);
					    
					    file.delete();
					        
						if(i!=1){
							msgText +="<br/>";
						}else{
							msgText +="첨부파일<br/>";
						}
						msgText +="<a href=\""+paramMap.get("notice_spec_form"+i)+"\" >"+paramMap.get("notice_spec_file_nm"+i)+"</a>";
					}
				}
				
			}
			
			msgText += "<br/><br/><br/><img src=\""+ commandMap.get("nameCardUrl").toString() +"\"/>";
			
			commandMap.put("msgText", msgText);
			
			sendMail(commandMap, multipart);
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

	public void sendMail(HashMap commandMap, Multipart multipart) throws Exception{
		String subject = commandMap.get("subject").toString();  //subject
		String msgText = commandMap.get("msgText").toString();  //message
//		String host = "smtp.gmail.com";              			//smtp mail server      
		String host = commandMap.get("emailHost").toString();              			//smtp mail server      
		String port = commandMap.get("emailPort").toString();              						//smtp mail server      
		String from = commandMap.get("email").toString();            //sender email address
		String to = commandMap.get("to").toString();           //receiver email address

		Properties props = new Properties();
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.auth","true");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);

		Authenticator auth = new MyAuthentication(commandMap.get("email").toString(), commandMap.get("emailPw").toString());
		Session sess = Session.getInstance(props, auth);

		try {
			Message msg = new MimeMessage(sess);
	        msg.setFrom(new InternetAddress(from));
	        InternetAddress[] address = {new InternetAddress(to)};
	        msg.setRecipients(Message.RecipientType.TO, address);
	        msg.setSubject(MimeUtility.encodeText(subject,"KSC5601","B"));
	        msg.setSentDate(new Date());
	        
	        if(multipart != null){
		        BodyPart messageBodyPart = new MimeBodyPart();
				messageBodyPart.setContent(msgText, "text/html;charset=utf-8");
				multipart.addBodyPart(messageBodyPart);
		        msg.setContent(multipart);
	        }else{
	        	msg.setContent(msgText, "text/html;charset=utf-8");//.setText(msgText);
	        }
	        
	        Transport.send(msg);
		} catch (MessagingException mex) {
			System.out.println(mex.getMessage()+"<br>");
			mex.printStackTrace();
		}
	}
}
