module app.model.Article;

import hunt.entity;

@Table("article")
class Article : Model
{    
    mixin MakeModel;

    @AutoIncrement
    @PrimaryKey
    int seq;
    
    string title;
    
    string desc;

    string image_id;

    ulong pv;

    ulong create_time;

    string create_user;

    ulong update_time;

    string update_user;
}