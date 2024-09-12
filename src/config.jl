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

"""
    _v(key::String, val::Array{Any,1})

Verify the value array. Called by chk_dict() function only.

### Arguments
* key -> Key of parameter.
* val -> Value of parameter.

### Returns
N/A

See also: [`chk_dict`](@ref).
"""
@inline function _v(key::String, val::Array{Any,1})
    # To check if the value is updated
    if isa(val[1], Missing) && val[2] > 0
        error("Sorry, key ($key) shoule be set")
    end

    # To check if the type of value is correct
    if !isa(val[1], Missing) && !isa(val[1], eval(val[3]))
        error("Sorry, type of key ($key) is wrong")
    end
end

"""
    get_t(key::String)

Extract configurations from dict: PTEST.

### Arguments
* key -> Key of parameter.

### Returns
* value -> Value of parameter.

See also: [`PTEST`](@ref).
"""
@inline function get_t(key::String)
    if haskey(PTEST, key)
        PBASE[key][1]
    else
        error("Sorry, PTEST does not contain key: $key")
    end
end
