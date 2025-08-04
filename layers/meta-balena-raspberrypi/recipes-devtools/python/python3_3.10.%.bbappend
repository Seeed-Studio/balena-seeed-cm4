do_configure:prepend() {
    export SETUPTOOLS_USE_DISTUTILS="stdlib"
}

do_compile:prepend() {
    export SETUPTOOLS_USE_DISTUTILS="stdlib"
}

do_install:prepend() {
    export SETUPTOOLS_USE_DISTUTILS="stdlib"
}
