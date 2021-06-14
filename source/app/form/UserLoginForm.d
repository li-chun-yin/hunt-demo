module app.form.UserLoginForm;

import hunt.framework;

class UserLoginForm : Form
{
    mixin MakeForm;

    @NotEmpty("Please enter email.")
    string email;

    @NotEmpty("Please enter captcha.")
    string captcha;

    @Length(0, 45, "Nick too long.")
    string nick;
}