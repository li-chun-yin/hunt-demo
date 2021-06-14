module app.controller.UserController;

import hunt.framework;

import std.format;

import app.repository.UserRepository;
import app.model.User;
import app.model.UserAccount;
import app.model.Captcha;
import app.message.ResultMessage;
import app.form.UserLoginForm;
import hunt.entity.domain.Condition;
import app.repository.CaptchaRepository;
import app.repository.UserAccountRepository;
import app.repository.UserRepository;
import app.exception.MessageException;
import std.conv;
import std.stdio;

/**
 *
 */
class UserController : Controller
{
    mixin MakeController;

    @Action
    Response login(UserLoginForm form)
    {
        auto resultMessage = new ResultMessage;
        resultMessage.data["token"] = "";

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

            CaptchaRepository captchaRepository = new CaptchaRepository;
            UserAccountRepository userAccountRepository = new UserAccountRepository;
            UserRepository userRepository = new UserRepository;
            User user;

            Captcha captcha = captchaRepository.findByEmailLogin(form.email);
            if(!captcha || captcha.code != form.captcha)
            {
                throw new MessageException(CODE.LOGIN_CAPTCHA_INVALID, "无效的验证码.");
            }

            UserAccount userAccount = userAccountRepository.findByEmail(form.email);
            if(!userAccount)
            {
                defaultEntityManager().getTransaction().begin();
                try
                {                    
                    user = userRepository.createByLogin(form);
                    userAccount = userAccountRepository.createByLogin(user, form);                    
                }
                catch(Throwable e)
                {
                    defaultEntityManager().getTransaction().rollback();
                    throw e;
                }
                defaultEntityManager().getTransaction().commit();
            }else{
                user = userRepository.findByUid(userAccount.uid);
                userRepository.updateByLogin(user, form);
            }

            Identity authUser = this.request.auth().signIn(user.uid, "NONEPASSWORD", false);
            if(authUser.isAuthenticated() == false)
            {
                throw new MessageException(CODE.LOGIN_FAILED, "Login failed!");
            }

            captchaRepository.removeByLogined(captcha);

            resultMessage.code = CODE.SUCCESS;
            resultMessage.message = "SUCCESS";
            resultMessage.data["token"] = this.auth.token();
        }
        catch(MessageException e)
        {
            resultMessage.code = e.getCode();
            resultMessage.message = e.getMessage();
        }
        catch(Exception e)
        {
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System exception";
        }
        return new JsonResponse(resultMessage);
    }

    @Action
    Response info()
    {
        // ResultMessage 是要返回的 json 消息体
        auto resultMessage = new ResultMessage;

        try
        {
            User user = this.user().claimAs!(User)("user");

            resultMessage.data["nick"] = user.nick;
            resultMessage.data["avatar"] = "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif";
            resultMessage.data["user_id"] = user.uid.to!string;
            resultMessage.data["roles"] = this.user().userDetails.roles;

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
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System exception";
        }
        
        return new JsonResponse(resultMessage);
    }

    @Action
    Response logout()
    {
        auto resultMessage = new ResultMessage;
        try
        {
            this.request().auth().signOut();

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
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System exception";
        }
        return new JsonResponse(resultMessage);
    }
}