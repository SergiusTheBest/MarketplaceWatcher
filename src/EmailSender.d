import std.net.curl;

void sendEmail(in string server, in string user, in string password, in string destination, in string subject, in string message)
{
    auto smtp = SMTP("smtps://" ~ server);
    smtp.setAuthentication(user, password);
    smtp.mailTo = [destination];
    smtp.message = "Subject: " ~ subject ~ "\n" 
        ~ "From: MarketplaceWatcher <" ~ user ~ ">\n" 
        ~ "\n" 
        ~ message;
    smtp.perform();
}