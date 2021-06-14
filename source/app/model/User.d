module app.model.User;

import hunt.entity;

@Table("user")
class User : Model
{
    mixin MakeModel;

    @AutoIncrement
    @PrimaryKey
    int seq;

    string uid;

    string nick;

    string login_ip;

    ulong login_time;

    ulong create_time;

    ulong update_time;
}