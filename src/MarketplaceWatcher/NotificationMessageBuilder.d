import std.datetime;
import std.format;

class NotificationMessageBuilder
{
    public this(Date date)
    {
        this.date = date;
    }

    public NotificationMessageBuilder addNotify(in string organization, in string contact, in string addon, in string edition, in string license)
    {
        text ~= format("* %s (%s) : %s ==> %s;%s\n", organization, contact, addon, edition, license);
        return this;
    }

    public bool isEmpty() const
    {
        return text.length == 0;
    }

    public string build()
    {
        return isEmpty() ? "Sorry, there are no new licenses :(" : "New licenses since " ~ date.toISOExtString() ~ ":\n\n" ~ text;
    }

    private string text;
    private Date date;
}