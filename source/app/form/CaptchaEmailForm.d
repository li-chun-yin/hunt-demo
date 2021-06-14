module app.form.CaptchaEmailForm;

import hunt.framework;

class CaptchaEmailForm : Form
{
    mixin MakeForm;

    @Email
    string email;

    @NotEmpty
    string type;
}