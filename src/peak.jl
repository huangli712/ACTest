#
# Project : Lily
# Source  : peak.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/13
#

function (𝑝::GaussianPeak)(ω::F64)
    return 𝑝.A * exp( -(ω - 𝑝.ϵ) ^ 2.0 / (2.0 * 𝑝.Γ ^ 2.0) )
end

function (𝑝::LorentzianPeak)(ω::F64)
    return 𝑝.A / π * 𝑝.Γ / ((ω - 𝑝.ϵ) ^ 2.0 + 𝑝.Γ ^ 2.0)
end

function (𝑝::RectanglePeak)(ω::F64)
end