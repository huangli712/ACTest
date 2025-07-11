#!/usr/bin/env julia

haskey(ENV,"ACTEST_HOME") && pushfirst!(LOAD_PATH, ENV["ACTEST_HOME"])

using ACTest

welcome()
overview()
read_param()