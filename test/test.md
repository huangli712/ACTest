# Summary of internal tests

## Standard tests

The following tests are designed for the ACTest + ACFlow toolkits.

* **A01**
    * Fermionic + Matsubara
    * Gaussian peaks

* **A02**
    * Fermionic + Matsubara
    * Delta peaks

* **A03**
    * Fermionic + Matsubara
    * Lorentzian peaks
    * Non-positive definite spectrum

* **A04**
    * Bosonic + Matsubara
    * Gaussian peaks

* **A05**
    * Bosonic + Matsubara
    * Delta peaks

* **A06**
    * Bosonic + Matsubara
    * Lorentzian peaks
    * Non-positive definite spectrum

* **A07**
    * ACT100 dataset
    * Fermionic + Bosonic + Matsubara
    * Gaussian + Delta + Lorentzian peaks
    * Positive definite spectrum + Non-positive definite spectrum

* **A08**
    * Fermionic + Matsubara
    * Random peaks

* **A09**
    * Fermionic + Imaginary time
    * Gaussian peaks
    * Exponentially correlated noise in imaginary time

* **A10**
    * Fermionic + Imaginary time
    * Gaussian peaks
    * Exponentially correlated noise in imaginary time
    * Multiple data bins per test

* **A11**
    * Fermionic + Matsubara
    * Random peaks
    * Matrix-valued Green's functions
    * Spectral functions with negative weights
    * A clone of **A08**

* **A12**
    * Fermionic + Imaginary time
    * Gaussian peaks
    * Exponentially correlated noise in imaginary time
    * Matrix-valued Green's functions
    * Spectral functions with negative weights
    * A clone of **A09**

## Experimental tests

The following tests are designed for the ACTest + MiniPole toolkits.

* **B01**
    * Fermionic + Matsubara
    * Gaussian peaks
    * A clone of **A01**

* **B02**
    * ACT100 dataset
    * Fermionic + Bosonic + Matsubara
    * Gaussian + Delta + Lorentzian peaks
    * Positive definite spectrum + Non-positive definite spectrum
    * A clone of **A07**
