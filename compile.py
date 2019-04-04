from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize
ext_modules = [
    Extension("my_module",  ["lib/my_module.py"]),
#   ... all your modules that need be compiled ...
]
setup(
    name = 'example',
    cmdclass = {'build_ext': build_ext},
    ext_modules = cythonize(ext_modules, compiler_directives = {'language_level': 3})
)