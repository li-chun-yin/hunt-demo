module app.repository.ArticleRepository;

import hunt.framework;
import app.form.ArticleForm;
import app.model.Article;
import app.model.User;
import std.datetime.systime : Clock;

class ArticleRepository : EntityRepository!(Article, int)
{
    Article create(ArticleForm form, User user)
    {
        ulong unixtime      = Clock.currTime.toUnixTime();

        Article article     = new Article;
        article.title       = form.title;
        article.desc        = form.desc;
        article.image_id    = form.image_id;
        article.pv          = 0;
        article.create_time = unixtime;
        article.create_user = user.uid;
        article.update_time = unixtime;
        article.update_user = user.uid;

        insert(article);
        
        return article;
    }

    Article updateOne(Article article, ArticleForm form, User user)
    {
        ulong unixtime      = Clock.currTime.toUnixTime();        

        article.title       = form.title;
        article.desc        = form.desc;
        article.image_id    = form.image_id;
        article.update_time = unixtime;
        article.update_user = user.uid;
        
        update(article);
        
        return article;
    }
}