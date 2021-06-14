module app.repository.ArticleExtendRepository;

import hunt.framework;
import app.form.ArticleForm;
import app.model.Article;
import app.model.ArticleExtend;

class ArticleExtendRepository : EntityRepository!(ArticleExtend, int)
{
    ArticleExtend findByArticleSeq(int article_seq)
    {
        return _manager.createQuery!(ArticleExtend)("SELECT t FROM ArticleExtend t WHERE  t.article_seq = :article_seq")
        .setParameter("article_seq", article_seq)
        .getSingleResult();
    }

    ArticleExtend create(Article article, ArticleForm form)
    {
        ArticleExtend articleExtend = new ArticleExtend;
        articleExtend.article_seq   = article.seq;
        articleExtend.content       = form.content;

        insert(articleExtend);
        
        return articleExtend;
    }

    ArticleExtend updateOne(ArticleExtend articleExtend, ArticleForm form)
    {
        articleExtend.content       = form.content;
        
        update(articleExtend);
        
        return articleExtend;
    }
}