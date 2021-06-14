module app.repository.CaptchaRepository;

import hunt.framework;
import app.model.Captcha;
import app.form.CaptchaEmailForm;
import std.random : Random;
import std.random : uniform;
import std.datetime.systime : Clock;
import std.conv;

class CaptchaRepository : EntityRepository!(Captcha, int)
{
    Captcha findByEmailLogin(string email)
    {
        return _manager.createQuery!(Captcha)("SELECT c FROM Captcha c WHERE c.to = :email AND c.type=:type")
        .setParameter("email", email)
        .setParameter("type", GetCaptchaType("login"))
        .getSingleResult();
    }

    Captcha createByEmail(CaptchaEmailForm captchaEmailForm)
    {
        ulong unixtime      = Clock.currTime.toUnixTime();
        uint rndtime        = cast(uint)unixtime;
        auto rnd            = Random(rndtime);
        auto code           = uniform(100000, 999999, rnd);

        Captcha captcha     = new Captcha;
        captcha.type        = GetCaptchaType(captchaEmailForm.type);
        captcha.code        = code.to!string;
        captcha.to          = captchaEmailForm.email;
        captcha.update_time = unixtime;
        
        insert(captcha);
        
        return captcha;
    }

    void removeByLogined(Captcha captcha)
    {
        remove(captcha);
    }
}
