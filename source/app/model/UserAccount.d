module app.model.UserAccount;

import hunt.entity;

@Table("user_account")
class UserAccount : Model
{
    mixin MakeModel;

    @AutoIncrement
    @PrimaryKey
    int seq;

    ushort type;
    
    string value;

    string uid;
    
    ulong create_time;
}

enum UserAccountType {email = 1}
ushort GetUserAccountType(string type)
{
    if(type == "email")
    {
        return UserAccountType.email;
    }

    return 0;
}