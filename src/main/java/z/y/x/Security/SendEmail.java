package z.y.x.Security;

import z.y.x.r.LoadPropertyFileFunctionality;
import z.y.x.urlshortner.ConnectionFactory;

import javax.mail.*;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;


/**
 *
 * @author anishnath
 *
 */
public class SendEmail {

	private static final String DB_URL = "jdbc:sqlite:"
			+ LoadPropertyFileFunctionality.getConfigProperty().get("sqlite");

	   // Replace sender@example.com with your "From" address.
    // This address must be verified.
    static final String FROM = "noreply@8gwifi.org";
    static final String FROMNAME = "8gwifi.org";


    // Replace smtp_username with your Amazon SES SMTP user name.
    static final String SMTP_USERNAME = System.getenv("SMTP_USERNAME");

    // Replace smtp_password with your Amazon SES SMTP password.
    static final String SMTP_PASSWORD = System.getenv("SMTP_PASSWORD");

    // The name of the Configuration Set to use for this message.
    // If you comment out or remove this variable, you will also need to
    // comment out or remove the header below.
    //static final String CONFIGSET = "ConfigSet";

    // Amazon SES SMTP host name. This example uses the US West (Oregon) region.
    // See https://docs.aws.amazon.com/ses/latest/DeveloperGuide/regions.html#region-endpoints
    // for more information.
    static final String HOST = System.getenv("HOST");

    // The port you will connect to on the Amazon SES SMTP endpoint.
    static final int PORT = 587;;



	public boolean isValidEmail(final String email)
	{
		String ePattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(ePattern);
        java.util.regex.Matcher m = p.matcher(email);
        return m.matches();

	}

	public void sendEmail(String subject, String body1, String body_h, String body2, String body_h2, String body3, String body_h3, String body4, String body_h4, final String email_to,String url) throws Exception
	{

		StringBuilder builder = new StringBuilder();
		builder.append("<b>"+body_h+"</b>");
		builder.append("<br>");
		String arr[]=body1.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		builder.append("<b>"+body_h2+"</b>");
		builder.append("<br>");
		arr=body2.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		builder.append("<b>"+body_h3+"</b>");
		builder.append("<br>");
		arr=body3.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		builder.append("<b>"+body_h4+"</b>");
		builder.append("<br>");
		arr=body4.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}

		sendEmail(subject, builder.toString(), email_to, url);

	}

	public void sendEmail(String subject, String body1, String body_h, String body2, String body_h2, String body3, String body_h3, final String email_to,String url) throws Exception
	{

		StringBuilder builder = new StringBuilder();
		builder.append("<b>"+body_h+"</b>");
		builder.append("<br>");
		String arr[]=body1.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		builder.append("<b>"+body_h2+"</b>");
		builder.append("<br>");
		arr=body2.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		builder.append("<b>"+body_h3+"</b>");
		builder.append("<br>");
		arr=body3.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		sendEmail(subject, builder.toString(), email_to, url);

	}

	public void sendEmail(String subject, String body1, String body_h, String body2, String body_h2, final String email_to,String url) throws Exception
	{

		StringBuilder builder = new StringBuilder();
		builder.append("<b>"+body_h+"</b>");
		builder.append("<br>");
		String arr[]=body1.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		builder.append("<b>"+body_h2+"</b>");
		builder.append("<br>");
		arr=body2.split("\n");
		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}
		builder.append("<br>");
		sendEmail(subject, builder.toString(), email_to, url);


	}


	public void sendEmail(String subject, String body, String body2, final String email_to,String url) throws Exception
	{

		String arr[]=body.split("\n");

		StringBuilder builder = new StringBuilder();

		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}

		builder.append("<hr>");

		builder.append("<br>");
		builder.append("Input Message</br>");
		builder.append("<pre>" + body2 +  "</pre>");
		builder.append("<br>");

		body = builder.toString();

		//String.join(delimiter, elements)
		String BODY = String.join(
	    	    System.getProperty("line.separator"),
	    	    "<h1>"+subject+"</h1>",
	    	    "<code>" + body + "</code>",
	    	    "<hr><p>This email was sent by 8gwifi.org using the ",
	    	    " <a href='https://8gwifi.org/"+url+"'>PGPEncryption</a>.",
	    	    "<p>For Support/Donation Please buy my 9 books <a href='https://leanpub.com/b/9book'>from Leanpub</a> <br> <a href=\"https://leanpub.com/b/9book\"><img class=\"img-thumbnail\" src=\"https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/images/site/9_book_for__9.png\" width=\"300\" height=\"200\" ></a><br>this will help me pay the Infra costs and bring more tools </p>",
				"<p>You can follow me <a href='https://twitter.com/anish2good'>@twitter</a></p>"
	    	    );

		sendEmail(subject, email_to, BODY);
    }


	public void sendEmail(String subject,  String body, final String email_to,String url) throws Exception
	{

		String arr[]=body.split("\n");

		StringBuilder builder = new StringBuilder();

		for (int i = 0; i < arr.length; i++) {
			String temp = arr[i];
			builder.append(temp);
			builder.append("<br>");
		}

		body = builder.toString();
		String joined2 = String.join(",", arr);

		//String.join(delimiter, elements)
		String BODY = String.join(
	    	    System.getProperty("line.separator"),
	    	    "<h1>"+subject+"</h1>",
	    	    "<code>" + body + "</code>",
	    	    "<hr><p>This email was sent by 8gwifi.org using the ",
	    	    " <a href='https://8gwifi.org/"+url+"'>"+url+"</a></p>",
	    	    "<p>For Support/Donation Please buy my 9 books <a href='https://leanpub.com/b/9book'>from Leanpub</a> <br> <a href=\"https://leanpub.com/b/9book\"><img class=\"img-thumbnail\" src=\"https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/images/site/9_book_for__9.png\" width=\"300\" height=\"200\" ></a><br>this will help me pay the Infra costs and bring more tools </p>",
				"<p>You can follow me <a href='https://twitter.com/anish2good'>@twitter</a></p>"
	    	    );

		sendEmail(subject, email_to, BODY);
		collectEMAIL(email_to, url);
    }

	public void sendRawHtml(String subject , String body , String email_to, String url) throws Exception
	{
		String BODY = String.join(
				System.getProperty("line.separator"),
				"<h1>"+subject+"</h1>",
				body  ,
				"<hr><p>This email was sent by 8gwifi.org using the ",
				" <a href='https://8gwifi.org/"+url+"'>"+url+"</a></p>",
				"<p>For Support/Donation Please buy my 9 books <a href='https://leanpub.com/b/9book'>from Leanpub</a> <br> <a href=\"https://leanpub.com/b/9book\"><img class=\"img-thumbnail\" src=\"https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/images/site/9_book_for__9.png\" width=\"300\" height=\"200\" ></a><br>this will help me pay the Infra costs and bring more tools </p>",
				"<p>You can follow me <a href='https://twitter.com/anish2good'>@twitter</a></p>"
		);

		sendEmail(subject, email_to, BODY);
		collectEMAIL(email_to, url);
	}

	private void sendEmail(String subject, final String email_to, String BODY)
			throws MessagingException, UnsupportedEncodingException, AddressException, NoSuchProviderException {
		Properties props = System.getProperties();
    	props.put("mail.transport.protocol", "smtp");
    	props.put("mail.smtp.port", PORT);
    	props.put("mail.smtp.starttls.enable", "true");
    	props.put("mail.smtp.auth", "true");

        // Create a Session object to represent a mail session with the specified properties.
    	Session session = Session.getDefaultInstance(props);

        // Create a message with the specified information.
        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM,FROMNAME));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(email_to));
        msg.setSubject(subject);



        msg.setContent(BODY,"text/html; charset=UTF-8");

        // Add a configuration set header. Comment or delete the
        // next line if you are not using a configuration set
        //msg.setHeader("X-SES-CONFIGURATION-SET", CONFIGSET);

        // Create a transport.
        Transport transport = session.getTransport();

        // Send the message.
        try
        {
            System.out.println("Sending...to " + email_to);

            // Connect to Amazon SES using the SMTP username and password you specified above.
            transport.connect(HOST, SMTP_USERNAME, SMTP_PASSWORD);

            // Send the email.
            transport.sendMessage(msg, msg.getAllRecipients());

        }
        catch (Exception ex) {
            System.out.println("The email was not sent." + email_to);
            System.out.println("Error message: " + ex.getMessage());
        }
        finally
        {
            // Close and terminate the connection.
            try {
				transport.close();
			} catch (MessagingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
	}

	private void  collectEMAIL(String email_to, String url) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			// Check if the URL is already in the database
			connection = ConnectionFactory.getConnection();
			String query = "INSERT INTO email_collect (email_to, url) VALUES (?, ?)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, email_to);
			preparedStatement.setString(2, url);
			preparedStatement.executeUpdate();
		} catch (Exception e) {

		} finally {
			try {
				if (resultSet != null)
					resultSet.close();
				if (preparedStatement != null)
					preparedStatement.close();
				if (connection != null)
					ConnectionFactory.closeConnection(connection);
			} catch (SQLException e) {
				e.printStackTrace(); // Handle the exception properly in a real application
			}
		}
	}
}


