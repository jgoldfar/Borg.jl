# Borg.jl

This package wraps the Borg MOEA; since the code is only available under a restricted license, it must be included manually into the appropriate location. The codebase supported by this package is slightly modified from the current (v1.8) borg-moea master; the necessary patches to the makefile are present under deps/: first, apply p1.patch, then p2.patch.

- Link or copy the Borg MOEA source code into <pkg-dir>/deps/src/borg-moea
- Run `Pkg.Build("Borg")`

See the examples directory for library usage.
