# Peaks

## Contents

```@contents
Pages = ["peak.md"]
Depth = 2
```

## Index

```@index
Pages = ["peak.md"]
```

## Types

```@docs
AbstractPeak
GaussianPeak
LorentzianPeak
DeltaPeak
RectanglePeak
```

## Base.* Functions

```@docs
Base.show(io::IO, 𝑝::GaussianPeak)
Base.show(io::IO, 𝑝::LorentzianPeak)
Base.show(io::IO, 𝑝::DeltaPeak)
Base.show(io::IO, 𝑝::RectanglePeak)
```
