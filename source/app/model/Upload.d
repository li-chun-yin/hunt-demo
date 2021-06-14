module app.model.Upload;

import hunt.entity;

@Table("upload")
class Upload : Model
{
    mixin MakeModel;

    @AutoIncrement
    @PrimaryKey
    int seq;

    string file_id;

    string original_name;

    string extension;

    string mime_type;

    ulong size;

    ushort type;

    string create_ip;

    ulong create_time;

    ulong update_time;
}

enum UploadType {image = 1}
ushort GetUploadType(string type)
{
    if(type == "image")
    {
        return UploadType.image;
    }
    
    return 0;
}