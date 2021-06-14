module app.controller.UploadController;

import hunt.framework;
import app.message.ResultMessage;
import app.exception.MessageException;
import app.model.Upload;
import app.repository.UploadRepository;
import hunt.framework.file.UploadedFile;
import hunt.logging;
import std.stdio;
import std.conv;

class UploadController : Controller
{
    mixin MakeController;

    @Action
    Response create()
    {
        // ResultMessage 是要返回的 json 消息体
        auto resultMessage = new ResultMessage;

        try
        {
            if(request.hasFile("file") == false)
            {
                throw new MessageException(CODE.UPLOAD_FAILED, "请选择文件.");
            }

            UploadedFile file = request.file("file");

            if(file.isValid() == false)
            {
                throw new MessageException(CODE.UPLOAD_FAILED, file.getErrorMessage());    
            }

            Upload upload;
            UploadRepository uploadRepository = new UploadRepository;
            defaultEntityManager().getTransaction().begin();
            try
            {                    
                upload = uploadRepository.createByUploadImage(file);

                string path = uploadRepository.imagePath(upload.file_id);

                if(file.store(path) == false){
                    throw new MessageException(CODE.UPLOAD_FAILED, "图片上传失败.");
                }
            }
            catch(Throwable e)
            {
                defaultEntityManager().getTransaction().rollback();
                throw e;
            }
            defaultEntityManager().getTransaction().commit();

            resultMessage.code          = CODE.SUCCESS;
            resultMessage.message       = "SUCCESS";
            resultMessage.data["id"]    = upload.file_id;
            resultMessage.data["url"]   = uploadRepository.imageUrl(upload.file_id);
        }
        catch(MessageException e)
        {
            resultMessage.code = e.getCode();
            resultMessage.message = e.getMessage();
        }
        catch(Exception e)
        {
            logDebug(e.to!string);
            resultMessage.code = CODE.ERROR;
            resultMessage.message = "System Exception";
        }
        
        return new JsonResponse(resultMessage);
    }
}