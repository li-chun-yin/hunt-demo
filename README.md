hunt-demo
============================================

* 本项目是基于[hunt-skeleton](https://github.com/huntlabs/hunt-skeleton.git)，构建的Dlang Hunt-Framkwork 演示程序。包含了以下功能模块：
    
    * 基本的数据增删该查
    
    * 自定义用户登录权限验证（目前系统内仅判断是否登录）

    * 文件上传

    * 发送简单的Email

    * 其他[Hunt-Framkwork](https://github.com/huntlabs/hunt-framework-docs)的基本使用

* 本项目用前后端分离的思路开发的，前端代码是 https://github.com/li-chun-yin/uniapp-ui 。

  * 前端通过npm build得到的H5资源被复制到 hunt-demo/wwwroot 下


试运行
---------------------------------------------------------------------------

拉取代码后，先要初始化并配置好数据库相关信息。

* 初始化数据库sql文件 hunt-demo/_dev/init.sql

* 配置 hunt-demo/config/application.conf

```bash
git clone https://github.com/li-chun-yin/hunt-demo.git
cd hunt-demo
dub run
```

