<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:98a21ef03cb4dc7e88c57907147391925b85d3c4cdb49f6eb8c180f0a32341a1
size 639
=======
The CodeQL CLI currently extracts data from additional, external files in a 
different way to the legacy QL tools. For example, when you run ``codeql database create`` 
the CodeQL CLI extracts data from some relevant XML files for Java and C#, but not 
for the other supported languages, such as JavaScript. This means that CodeQL databases 
created using the CodeQL CLI may be slightly different from those obtained from LGTM.com or 
created using the legacy QL command-line tools. As such, analysis results generated from
databases created using the CodeQL CLI may also differ from those generated from
databases obtained from elsewhere.
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
