module app.repository.UserRepository;

import hunt.framework;
import app.form.UserLoginForm;
import app.model.User;
import std.random;
import std.array;
import std.uuid;
import std.datetime.systime : Clock;

class UserRepository : EntityRepository!(User, int)
{
    string genUid()
    {
        ulong unixtime      = Clock.currTime.toUnixTime();
        uint rndtime        = cast(uint)unixtime;
        auto rnd            = Random(rndtime);
        string uid          = randomUUID(rnd).toString();
        return uid.replace("-", "");
    }

    User findByUid(string uid)
    {
        return _manager.createQuery!(User)("SELECT u FROM User u WHERE  u.uid = :uid")
        .setParameter("uid", uid)
        .getSingleResult();
    }

    User createByLogin(UserLoginForm userLoginForm)
    {
        ulong unixtime      = Clock.currTime.toUnixTime();
        
        User user               = new User;
        user.uid                = genUid();
        user.nick               = userLoginForm.nick;
        user.login_ip           = request().ip();
        user.login_time         = unixtime;
        user.create_time        = unixtime;
        user.update_time        = unixtime;

        insert(user);
        
        return user;
    }

    User updateByLogin(User user, UserLoginForm userLoginForm)
    {
        ulong unixtime          = Clock.currTime.toUnixTime();        

        user.login_ip           = request().ip();
        user.login_time         = unixtime;
        user.update_time        = unixtime;
        
        update(user);
        
        return user;
    }
}