# Inputs

The scripts in the ACTest toolkit require only one input file, which is **act.toml**. Below is a typical **act.toml** file with some omissions. In this **act.toml**, text following the **#** symbol is considered as a comment. It contains two sections: **[Test]** and **[Solver]**.

The **[Test]** section is mandatory, which controls generation of spectral functions and corresponding Green's functions. We would like to explain the relevant control parameters in the following text.

The **[Solver]** section is optional. Now it is used to configure the analytic continuation methods as implemented in the ACFlow toolkit. Only the **acflow.jl** script needs to read the **[Solver]** section. It will transfer these parameters to the ACFlow toolkit to customize the successive analytic continuation calculations. For possible parameters within the **[Solver]** section, please refer to the documentation of the ACFlow toolkit.

```toml
#
# Test: A01
#
# 1. Execute ../../util/acgen.jl act.toml.
# 2. Change solver = "MaxEnt" and modify the [Solver] section accordingly.
# 3. Execute ../../util/acflow.jl act.toml.
# 4. Execute ../../util/acplot.jl act.toml.
#

[Test]
solver  = "MaxEnt"
...

[Solver]
method = "chi2kink"
...
```
