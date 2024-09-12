#
# Project : Lily
# Source  : config.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/12
#

"""
    inp_toml(f::String, necessary::Bool)

Parse the configuration file (in toml format). It reads the whole file.

### Arguments
* f -> Filename of configuration.
* necessary -> If it is true and configuration is absent, raise an error.

### Returns
* dict -> A Dictionary struct that contains all the key-value pairs.
"""
function inp_toml(f::String, necessary::Bool)
    if isfile(f)
        dict = TOML.parsefile(f)
        return dict
    else
        if necessary
            error("Please make sure that the file $f really exists")
        else
            nothing
        end
    end
end

"""
    fil_dict(cfg::Dict{String,Any})

Transfer configurations from dict `cfg` to internal dict (`PTEST`). In
other words, all the relevant internal dicts should be filled / updated
in this function.

### Arguments
* cfg -> A dict struct that contains all the configurations (from act.toml).

### Returns
N/A
"""
function fil_dict(cfg::Dict{String,Any})
    for key in keys(cfg)
        if haskey(PTEST, key)
            PTEST[key][1] = cfg[key]
        else
            error("Sorry, $key is not supported currently")
        end
    end
end
