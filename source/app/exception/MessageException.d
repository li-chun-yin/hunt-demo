module app.exception.MessageException;

import std.stdio;

class MessageException : Exception
{
    private int _code;

    @nogc @safe pure nothrow this(int exception_code, string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
        
        _code = exception_code;
    }

    int getCode()
    {
        return _code;
    }

    string getMessage()
    {
        return msg;
    }
}

enum CODE {
    ERROR = 999999,
    SUCCESS = 20000,
    PATAMS_INVALID = 40000,
    UNLOGIN = 40001,
    LOGIN_CAPTCHA_INVALID = 50000,
    LOGIN_FAILED = 50001,
    UPLOAD_FAILED = 60000
}