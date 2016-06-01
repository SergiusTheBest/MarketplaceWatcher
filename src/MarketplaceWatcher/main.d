import std.stdio;
import std.csv;
import std.datetime;
import ConfigData;
import PersistentData : PersistentData;
import NotificationMessageBuilder;
static import MarketplaceClient;
static import EmailSender;

int main(string[] argv)
{
    writeln("Reading configs...");

    immutable string kPersistanceDataConfig = "MarketplaceWatcher-data.json";
    auto configData = new ConfigData("config.json");
    auto persistanceData = PersistentData.load(kPersistanceDataConfig);    

    writeln("Fetching CSV data...");
    auto csvData = MarketplaceClient.fetchCsv(configData.amUser, configData.amPassword);

    auto messageBuilder = new NotificationMessageBuilder(persistanceData.latestDate);
    Date newLatestDate = persistanceData.latestDate;

    foreach (record; csvReader!(string[string])(csvData, null))
    {
        auto date = Date.fromISOExtString(record["startDate"]);

        if (date > persistanceData.latestDate)
        {
            if (date > newLatestDate)
            {
                newLatestDate = date;
            }

            messageBuilder.addNotify(record["organisationName"], record["technicalContactEmail"], record["addOnName"], record["edition"], record["licenseType"]);
        }
    }

    writeln("----------------------------------");

    auto message = messageBuilder.build();
    writeln(message);

    if (!messageBuilder.isEmpty())
    {
        EmailSender.sendEmail(configData.senderSmtp, configData.senderEmail, configData.senderPassword, configData.notifyEmail, "Good news, there are new addon licenses", message);
    }

    if (newLatestDate > persistanceData.latestDate)
    {
        persistanceData.latestDate = newLatestDate;
        persistanceData.save(kPersistanceDataConfig);
    }

    return 0;
}