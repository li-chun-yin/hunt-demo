module app.repository.UploadRepository;

import hunt.framework;
import app.model.Upload;
import app.form.CaptchaEmailForm;
import std.random : Random;
import std.random : uniform;
import std.datetime.systime : Clock;
import std.conv;
import std.uuid;
import std.array;
import std.string;
import hunt.framework.file.UploadedFile;

class UploadRepository : EntityRepository!(Upload, int)
{
    string genUid()
    {
        ulong unixtime      = Clock.currTime.toUnixTime();
        uint rndtime        = cast(uint)unixtime;
        auto rnd            = Random(rndtime);
        string uid          = randomUUID(rnd).toString();
        return uid.replace("-", "");
    }

    string imagePath(string file_id)
    {
        return config().upload.path.stripRight("/") ~ "/" ~ file_id;
    }

    string imageUrl(string file_id)
    {
        return config().application.baseUrl.stripRight("/") ~ '/' ~ imagePath(file_id);
    }

    Upload findByFileId(string file_id)
    {
        return _manager.createQuery!(Upload)("SELECT t FROM Upload t WHERE  t.file_id = :file_id")
        .setParameter("file_id", file_id)
        .getSingleResult();
    }

    Upload createByUploadImage(UploadedFile file)
    {
        ulong unixtime          = Clock.currTime.toUnixTime();
        Upload upload           = new Upload;
        upload.file_id          = genUid();
        upload.original_name    = file.originalName();
        upload.extension        = file.extension();
        upload.mime_type        = file.mimeType();
        upload.size             = file.size();
        upload.type             = GetUploadType("image");
        upload.create_ip        = request().ip();
        upload.create_time      = unixtime;
        upload.update_time      = unixtime;
        
        insert(upload);
        
        return upload;
    }
}
