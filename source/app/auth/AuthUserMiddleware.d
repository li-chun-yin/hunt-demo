module app.auth.AuthUserMiddleware;

import hunt.framework;
import app.exception.MessageException;
import app.message.ResultMessage;

/**
 *
 */
class AuthUserMiddleware : AuthMiddleware
{
    shared static this() {
        MiddlewareInterface.register!(typeof(this));
    }

    override protected bool onAccessable(Request request) {
        return true;
    }

    override protected Response onRejected(Request request) {
        ResultMessage resultMessage = new ResultMessage;
        resultMessage.code = CODE.UNLOGIN;
        resultMessage.message = "请先登录再操作";
        return new JsonResponse(resultMessage);
    }
}