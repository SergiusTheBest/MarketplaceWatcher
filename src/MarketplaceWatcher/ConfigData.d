import std.json;
import std.file;

class ConfigData
{
    public this(in string fileName)
    {
        auto jsonString = readText(fileName);
        auto json = parseJSON(jsonString);

        this.amUser = json["amUser"].str;
        this.amPassword = json["amPassword"].str;
        this.notifyEmail = json["notifyEmail"].str;
        this.senderSmtp = json["sender"]["smtp"].str;
        this.senderEmail = json["sender"]["email"].str;
        this.senderPassword = json["sender"]["password"].str;
    }

    public immutable string amUser;
    public immutable string amPassword;
    public immutable string notifyEmail;
    public immutable string senderSmtp;
    public immutable string senderEmail;
    public immutable string senderPassword;
}