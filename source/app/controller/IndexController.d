module app.controller.IndexController;

import hunt.framework;
import app.message.ResultMessage;
import app.exception.MessageException;

/**
 *
 */
class IndexController : Controller
{
    mixin MakeController;

    @Action
    string index()
    {
        view.setTemplatePath(config().staticfiles.location);
        return view.render("index");
    }

    @Action
    Response options()
    {
        auto resultMessage = new ResultMessage;
        resultMessage.code = CODE.SUCCESS;
        resultMessage.message = "ok";
        return new JsonResponse(resultMessage);
    }
}

