module app.auth.AuthUserGuard;

import app.auth.Constants;
import app.auth.AuthUserService;
import hunt.framework;
import hunt.framework.auth.JwtToken;
import hunt.shiro.authc.AuthenticationToken;
import std.range;

/**
 *
 */
class AuthUserGuard : JwtGuard
{
    this()
    {
        super(new AuthUserService(), LOGINED_GUARD_NAME);
        this.tokenCookieName = LOGINED_TOKEN_NAME;
    }

    override AuthenticationToken getToken(Request request) {
        string tokenString = request.header(tokenCookieName);

        if (tokenString.empty)
        {
            return super.getToken(request);
        }

        return new JwtToken(tokenString, tokenCookieName);
    }
}