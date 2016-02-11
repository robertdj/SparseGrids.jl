deps_dir = joinpath(Pkg.dir("Deldir"), "deps")
cd(joinpath(deps_dir, "Fortran"))

fortran_files = ["acchk", "addpt", "adjchk", "binsrt", "circen", "cross", "delet", "delet1", "delout", "delseg", "dirout", "dirseg", "dldins", "initad", "insrt", "insrt1", "intri", "locn", "master", "mnnd", "pred", "qtest", "qtest1", "stoke", "succ", "swap", "testeq", "triar", "trifnd"]

for name in fortran_files
	run(`gfortran -fPIC -O3 -pipe -g -c $name.f -o $name.o`)
end

deldir_path = joinpath(deps_dir, "deldir.so")
run(`gfortran -shared -O3 -o $deldir_path $fortran_files.o`)

