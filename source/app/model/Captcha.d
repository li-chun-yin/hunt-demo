module app.model.Captcha;

import hunt.entity;

@Table("captcha")
class Captcha : Model
{    
    mixin MakeModel;

    @AutoIncrement
    @PrimaryKey
    int seq;

    ushort type;
    
    string to;
    
    string code;

    ulong update_time;
}

enum CaptchaType {login = 1}
ushort GetCaptchaType(string type)
{
    if(type == "login")
    {
        return CaptchaType.login;
    }
    
    return 0;
}