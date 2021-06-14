module app.auth.AuthUserServiceProvider;

import hunt.framework;
import app.auth.AuthUserService;
import app.auth.AuthUserGuard;
import poodinis;

/**
 * 
 */
class AuthUserServiceProvider : AuthServiceProvider
{
    override void boot() {
        AuthService authService = container().resolve!AuthService();

        authService.addGuard(new AuthUserGuard);

        authService.boot();
    }
}