module app.auth.AuthUserService;

import hunt.framework;
import app.repository.UserAccountRepository;
import app.repository.UserRepository;
import std.stdio;
import app.model.User;

/**
 *
 */
class AuthUserService : UserService
{
    private UserRepository _userRepository;

    this()
    {
        _userRepository = new UserRepository;
    }

    // 暂时我使用email加验证码登录，所以用不到password 这里的name是通过email去数据库读取的uid
    UserDetails authenticate(string name, string password)
    {
        return getByName(name);
    }

    // 这里的name是通过email去数据库读取的uid
    UserDetails getByName(string name)
    {
        auto user = _userRepository.findByUid(name);
        if(user){
            UserDetails detail = new UserDetails;
            detail.id = user.seq;
            detail.name = user.uid;
            detail.roles ~= "LOGINED";
            // authUser.permissions ~= "";
            detail.salt = "NONEPASSWORD";
            detail.addClaim("user", user);
            return detail;
        }
        return null;
    }

    // deprecated("This method will be removed in next release.")
    string getSalt(string name, string password)
    {
        return "NONEPASSWORD";
    }

    // deprecated("This method will be removed in next release.")
    UserDetails getById(ulong id)
    {
        return null;
    }
}
