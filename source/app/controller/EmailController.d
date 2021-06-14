module app.controller.EmailController;

import hunt.framework;
import std.net.curl;
import app.message.ResultMessage;
import app.form.CaptchaEmailForm;
import std.stdio;
import std.format;
import app.repository.CaptchaRepository;
import app.repository.UserAccountRepository;
import app.model.Captcha;
import app.model.UserAccount;
import std.json;
import app.exception.MessageException;

class EmailController : Controller
{
    mixin MakeController;
    
    @Action
    Response captcha(CaptchaEmailForm form)
    {
        auto resultMessage = new ResultMessage;  
        resultMessage.data["is_first_login"] = false;

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

            string email                        = form.email;
            CaptchaRepository captchaRepository = new CaptchaRepository;
            Captcha captcha; 
            captcha = captchaRepository.findByEmailLogin(email);
            if(!captcha){
                captcha = captchaRepository.createByEmail(form);
            }

            UserAccountRepository userAccountRepository = new UserAccountRepository; 
            UserAccount userAccount = userAccountRepository.findByEmail(email);
            if(!userAccount)
            {
                resultMessage.data["is_first_login"] = true;
            }

            ApplicationConfig conf = config();

            string host = conf.mail.smtp.host;
            string protocol = conf.mail.smtp.protocol;
            ushort port = conf.mail.smtp.port;
            string user = conf.mail.smtp.user;
            string password = conf.mail.smtp.password;
            auto smtp = SMTP(format("smtp://%s", host));
            smtp.setAuthentication(user, password);
            smtp.mailTo(captcha.to);
            smtp.mailFrom(user);
            smtp.message(format("Subject:test\r\n\r\nyour captcha is %s", captcha.code));
            smtp.perform();
            
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
            resultMessage.message = "failed";
        }

        return new JsonResponse(resultMessage);
    }
}