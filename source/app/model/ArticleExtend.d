module app.model.ArticleExtend;

import hunt.entity;

@Table("article_extend")
class ArticleExtend : Model
{    
    mixin MakeModel;

    @AutoIncrement
    @PrimaryKey
    int seq;
    
    int article_seq;
    
    string content;
}