using BinDeps

@BinDeps.setup

const libborg = library_dependency("libborg")

const borgsrcpath = joinpath(dirname(@__FILE__), "src", "borg-moea")
const borglibdir = libdir(libborg)
const borgincdir = joinpath(usrdir(libborg),"include")
const suffix = @osx? "dylib" : "so"
const borglib = joinpath(borgsrcpath, string("libborg.", suffix))

provides(SimpleBuild,
(@build_steps begin
  (@build_steps begin
  ChangeDirectory(borgsrcpath)
  `make shared`
  end)
  CreateDirectory(borglibdir)
  `cp $(borglib) $(borglibdir)`
end), libborg, os = :Unix)
  # cp(joinpath(borgpath, ))

@BinDeps.install Dict(:libborg => :libborg)

# To build the frontend, necessary for running example 01-dtlz2-run.sh, run
# `make frontend` in the borg-moea directory.
