import std.net.curl;

public char[] fetchCsv(in string amUser, in string amPassword)
{
    char[] csv;
    csv.reserve(1000000);

    auto http = HTTP("https://marketplace.atlassian.com/rest/1.0/vendors/1210664/license/report");
    http.setAuthentication(amUser, amPassword);
    http.onReceive = (ubyte[] data) { csv ~= data; return data.length; };
    http.perform();

    return csv;
}