module app.form.ArticleForm;

import hunt.framework;

class ArticleForm : Form
{
    mixin MakeForm;

    @Length(1, 45, "标题只能是1到45个字符.")
    string title;

    @Length(1, 255, "文章描述只能是1到255个字符.")
    string desc;

    @NotEmpty("请上传文章封面图片.")
    string image_id;

    @Length(1, 21843, "文章内容过大或为空.")
    string content;
}