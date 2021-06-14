import hunt.framework;
import app.auth.AuthUserServiceProvider;
import app.auth.Constants;
import app.auth.AuthUserMiddleware;

/**
 *
 */
void main(string[] args)
{
    Application app = Application.instance();

    app.booting((){
        app.register!AuthUserServiceProvider;
    });

    app.booted((){
        RouteGroup userGroup = app.route().group();
        userGroup.guardName = LOGINED_GUARD_NAME;
        userGroup.withMiddleware(AuthUserMiddleware.stringof);
        userGroup.get("index.index").withoutMiddleware(AuthUserMiddleware.stringof);
        userGroup.get("article.index").withoutMiddleware(AuthUserMiddleware.stringof);
        userGroup.get("article.detail").withoutMiddleware(AuthUserMiddleware.stringof);
        userGroup.get("email.captcha").withoutMiddleware(AuthUserMiddleware.stringof);
        userGroup.get("user.login").withoutMiddleware(AuthUserMiddleware.stringof);
        userGroup.get("user.logout").withoutMiddleware(AuthUserMiddleware.stringof);
    });
    
    app.run(args);
}
