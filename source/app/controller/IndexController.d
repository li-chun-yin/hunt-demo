module app.controller.IndexController;

import hunt.framework;
import app.message.ResultMessage;

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
        resultMessage.code = 20000;
        resultMessage.message = "ok";
        return new JsonResponse(resultMessage);
    }
}

