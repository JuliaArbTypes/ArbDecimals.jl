## ArbDecimals.jl
=========== 
#### reliable and performant extended precision floating point math

Jeffrey Sarnoff © 2016 Sep 15 in New York, USA
## ArbDecimals.jl
=========== 
#### reliable and performant extended precision floating point math

Jeffrey Sarnoff © 2016 Sep 15 in New York, USA

=========== 

### overview

ArbDecimals exports a floating point type realized for the decimal digit resolutions named:    
Dec25, Dec50, Dec75, Dec100, Dec150, Dec200, Dec250, Dec300, Dec350, Dec400, Dec450, Dec500.

Most of Julia's arithmetic and elementary functions work. These functions are exported too:   
     pow, root, sincos, sinhcosh, rgamma, polylog, agm.

All math is performed at twice the nominal precision.  This is managed internally, and
the user only need know that there is very strong numerical backstopping in support of
delivering highly reliable results with desireable performance.

Results for most scalar and vector computations are quite reliable.  
With matrices, det, chol, lu work well; eigenvals and svdvals need interval algorithms to work.



### installation

ArbDecimals depends on ArbFloats, which needs Nemo.  It is best to add these packages one at a time:
```
Pkg.add("Nemo")   # expect much compilation
using Nemo
quit()

Pkg.add("ArbFloats")
using ArbFloats
quit()

Pkg.add("ArbDecimals")
using ArbDecimals
quit()
```


=========== 

### overview

ArbDecimals exports a floating point type realized for the decimal digit resolutions named:    
Dec25, Dec50, Dec75, Dec100, Dec150, Dec200, Dec250, Dec300, Dec350, Dec400, Dec450, Dec500.

Most of Julia's arithmetic and elementary functions work. These functions are exported too:   
     pow, root, sincos, sinhcosh, rgamma, polylog, agm.

All math is performed at twice the nominal precision.  This is managed internally, and
the user only need know that there is very strong numerical backstopping in support of
delivering highly reliable results with desireable performance.

Results for most scalar and vector computations are quite reliable.  
With matrices, det, chol, lu work well; eigenvals and svdvals need interval algorithms to work.



### installation

ArbDecimals depends on ArbFloats, which needs Nemo.  It is best to add these packages one at a time:
```
Pkg.add("Nemo")   # expect much compilation
using Nemo
quit()

Pkg.add("ArbFloats")
using ArbFloats
quit()

#Pkg.add("ArbDecimals")
Pkg.clone("https://github.com/JuliaArbTypes/ArbDecimals.jl")
using ArbDecimals
quit()
```

