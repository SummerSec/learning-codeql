<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:5061d96d177505563c6a70afd1bf20a4d1da3196cc1a53994cff1f05d6c8ee76
size 527
=======
.. code-block:: yaml

   name: my-query-tests
   version: 0.0.0
   libraryPathDependencies: my-custom-queries
   extractor: java
   tests: .

This ``qlpack.yml`` file states that ``my-query-tests`` depends on
``my-custom-queries``. It also declares that the CLI should use the
Java ``extractor`` when creating test databases.
Supported from CLI 2.1.0 onward, the ``tests: .`` line declares 
that all ``.ql`` files in the pack should be
run as tests when ``codeql test run`` is run with the 
``--strict-test-discovery`` option.
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
