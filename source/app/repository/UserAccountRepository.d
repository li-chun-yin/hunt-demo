module app.repository.UserAccountRepository;

import hunt.framework;
import app.model.User;
import app.model.UserAccount;
import app.form.UserLoginForm;
import std.datetime.systime : Clock;

class UserAccountRepository : EntityRepository!(UserAccount, ulong)
{
    UserAccount findByEmail(string email)
    {
        return _manager.createQuery!(UserAccount)("SELECT ua FROM UserAccount ua WHERE  ua.type = :type AND ua.value = :email")
        .setParameter("email", email)
        .setParameter("type", GetUserAccountType("email"))
        .getSingleResult();
    }

    UserAccount createByLogin(User user, UserLoginForm userLoginForm)
    {
        UserAccount userAccount = new UserAccount;
        userAccount.type        = GetUserAccountType("email");
        userAccount.value       = userLoginForm.email;
        userAccount.uid         = user.uid;
        userAccount.create_time = Clock.currTime.toUnixTime();
        
        insert(userAccount);
        
        return userAccount;
    }
}