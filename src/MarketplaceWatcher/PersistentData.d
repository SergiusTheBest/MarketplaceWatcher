import std.json;
import std.file;
import std.datetime;

class PersistentData
{
    public static PersistentData load(in string fileName)
    {
        auto self = new PersistentData();

        if (exists(fileName))
        {
            auto jsonString = readText(fileName);
            auto json = parseJSON(jsonString);

            self.latestDate = Date.fromISOExtString(json["latestDate"].str);
        }

        return self;
    }

    public void save(in string fileName)
    {
        auto json = JSONValue(["latestDate" : JSONValue(latestDate.toISOExtString())]);

        if (exists(fileName))
        {
            remove(fileName);
        }

        write(fileName, json.toPrettyString());
    }

    public Date latestDate = Date(0, 1, 1);
}