function unzip_zip(zipfile::String)
    f = replace(zipfile, ".zip"=>"")
    run(`unzip $f`)
end

function unzip_tgz(filename::String, dir::String)
    isdir(dir) || mkdir("$dir")
    run(`tar zxf $filename -C $dir`)
end