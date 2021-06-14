module app.controller.ArticleController;

import hunt.framework;
import hunt.logging;
import std.format;
import std.conv;
import app.form.ArticleForm;
import app.model.User;
import app.model.Article;
import app.model.ArticleExtend;
import app.repository.UploadRepository;
import app.repository.ArticleRepository;
import app.repository.UserRepository;
import app.repository.ArticleExtendRepository;
import app.message.ResultMessage;
import app.exception.MessageException;
import std.stdio;
import std.json;

/**
 *
 */
class ArticleController : Controller
{
    mixin MakeController;

    @Action
    Response index()
    {
        int page = cast(int)(this.request().get("page", 1));
        int limit = cast(int)(this.request().get("limit", 10));
        string user_id = cast(string)(this.request().get("user_id", ""));

        ResultMessage resultMessage = new ResultMessage;
        ArticleRepository articleRepository = new ArticleRepository;
        UploadRepository uploadRepository = new UploadRepository;

        try
        {
            Condition condition = new Condition("1");
            if(user_id.length > 0){
                condition = condition.append(" AND create_user='"~user_id ~"'");   
            }
            
            Pageable pageable =  new Pageable(page - 1, limit);

            auto paginator = articleRepository.findAll(condition, pageable);

            auto articles = paginator.getContent();
            JSONValue[] items;
            foreach (article; articles)
            {
                JSONValue item;
                item["seq"]         = article.seq;
                item["title"]       = article.title;
                item["image"]       = ["url": uploadRepository.imageUrl(article.image_id), "id": article.image_id ];
                item["createtime"]  = article.create_time;
                item["desc"]        = article.desc;
                item["pv"]          = article.pv;
                items ~= item;                
            }

            resultMessage.code = CODE.SUCCESS;
            resultMessage.message = "SUCCESS";
            resultMessage.data["total"] = paginator.getTotalElements();
            resultMessage.data["items"] = items;
        }
        catch(MessageException e)
        {
            resultMessage.code = e.getCode();
            resultMessage.message = e.getMessage();
        }
        catch(Exception e)
        {
            logDebug(e.to!string);
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System exception";
        }
        return new JsonResponse(resultMessage);
    }

    @Action
    Response create(ArticleForm form)
    {
        auto resultMessage                              = new ResultMessage;
        User user                                       = this.user().claimAs!(User)("user");
        ArticleRepository articleRepository             = new ArticleRepository;
        ArticleExtendRepository articleExtendRepository = new ArticleExtendRepository;
        Article article;
        ArticleExtend articleExtend;

        try
        {
            auto valid = form.valid();
            if (!valid)
            {
                foreach (message; valid.messages())
                {
                    throw new MessageException(CODE.PATAMS_INVALID, message);
                }
            }

            defaultEntityManager().getTransaction().begin();
            try
            {                    
                article = articleRepository.create(form, user);
                articleExtend = articleExtendRepository.create(article, form);                    
            }
            catch(Throwable e)
            {
                defaultEntityManager().getTransaction().rollback();
                throw e;
            }
            defaultEntityManager().getTransaction().commit();

            resultMessage.code = CODE.SUCCESS;
            resultMessage.message = "SUCCESS";
            resultMessage.data["seq"]  = article.seq;
        }
        catch(MessageException e)
        {
            resultMessage.code = e.getCode();
            resultMessage.message = e.getMessage();
        }
        catch(Exception e)
        {
            logDebug(e.to!string);
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System exception";
        }
        return new JsonResponse(resultMessage);
    }

    @Action
    Response update(ArticleForm form)
    {
        int seq = cast(int)(this.request().post("seq", 0));

        auto resultMessage                              = new ResultMessage;
        User user                                       = this.user().claimAs!(User)("user");
        ArticleRepository articleRepository             = new ArticleRepository;
        ArticleExtendRepository articleExtendRepository = new ArticleExtendRepository;
        Article article;
        ArticleExtend articleExtend;

        try
        {
            if(seq < 1){
                throw new MessageException(CODE.PATAMS_INVALID, "没有参数seq");
            }
            auto valid = form.valid();
            if (!valid)
            {
                foreach (message; valid.messages())
                {
                    throw new MessageException(CODE.PATAMS_INVALID, message);
                }
            }

            article = articleRepository.find(seq);
            articleExtend = articleExtendRepository.findByArticleSeq(seq);

            defaultEntityManager().getTransaction().begin();
            try
            {                    
                article = articleRepository.updateOne(article, form, user);
                articleExtend = articleExtendRepository.updateOne(articleExtend, form);                    
            }
            catch(Throwable e)
            {
                defaultEntityManager().getTransaction().rollback();
                throw e;
            }
            defaultEntityManager().getTransaction().commit();

            resultMessage.code = CODE.SUCCESS;
            resultMessage.message = "SUCCESS";
        }
        catch(MessageException e)
        {
            resultMessage.code = e.getCode();
            resultMessage.message = e.getMessage();
        }
        catch(Exception e)
        {
            logDebug(e.to!string);
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System exception";
        }
        return new JsonResponse(resultMessage);
    }

    @Action
    Response detail()
    {
        auto resultMessage = new ResultMessage;
        int seq = cast(int)(this.request().get("seq", 0));

        try
        {
            UserRepository userRepository = new UserRepository;
            UploadRepository uploadRepository = new UploadRepository;
            ArticleRepository articleRepository = new ArticleRepository;
            ArticleExtendRepository articleExtendRepository = new ArticleExtendRepository;
            Article article = articleRepository.find(seq);
            ArticleExtend articleExtend = articleExtendRepository.findByArticleSeq(seq);
            User user = userRepository.findByUid(article.create_user);
            string image_url = uploadRepository.imageUrl(article.image_id);

            resultMessage.code = CODE.SUCCESS;
            resultMessage.message = "SUCCESS";
            resultMessage.data["seq"]           = article.seq;
            resultMessage.data["title"]         = article.title;
            resultMessage.data["desc"]          = article.desc;
            resultMessage.data["content"]       = articleExtend.content;
            resultMessage.data["image"]         = ["id": article.image_id, "url": image_url];
            resultMessage.data["createtime"]    = article.create_time;
            resultMessage.data["author"]        = user.nick;
            resultMessage.data["updatetime"]    = article.update_time;
        }
        catch(MessageException e)
        {
            resultMessage.code = e.getCode();
            resultMessage.message = e.getMessage();
        }
        catch(Exception e)
        {
            logDebug(e.to!string);
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System exception";
        }
        return new JsonResponse(resultMessage);
    }
}