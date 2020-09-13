function unzip_zip(src::String, dest::String=dirname(src))
    run(`unzip $src -d $dest`)
end

function unzip_tgz(src::String, dest::String)
    isdir(dest) || mkdir("$dest")
    run(`tar zxf $src -C $dest`)
end