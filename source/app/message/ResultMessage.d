module app.message.ResultMessage;

import std.json;

class ResultMessage
{
    uint code = 0;
    string message;
    JSONValue data;
}