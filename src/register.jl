datasets() = datasets(Dataset)

function datasets(dt::Type{<:Dataset})
    if isconcretetype(dt)
        return [dt]
    elseif isabstracttype(dt)
        ds = [datasets(s) for s in subtypes(dt)]
        return collect(Iterators.flatten(ds))
    end
end

function init_dataset(dataset::Type{<:Dataset})
    register(DataDep(
        dataset_name(dataset),
        dataset_message(dataset),
        dataset_remote_path(dataset),
        dataset_checksum(dataset);
        post_fetch_method=dataset_preprocess(dataset),
    ))
end

function init_dataset(::Type{Dataset})
    for dataset in datasets()
        init_dataset(dataset)
    end
end
