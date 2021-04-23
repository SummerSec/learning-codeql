<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:2f81ba5083c4c0cfc9a77a286381daadbd30d9eb811a7a1b46eb35b3692c8e4f
size 865
=======
Path queries
============

Path queries provide information about the identified paths from sources to sinks. Paths can be examined in the Path Explorer view.

Use this template:

.. code-block:: ql

   /**
    * ... 
    * @kind path-problem
    */
   
   import semmle.code.<language>.dataflow.TaintTracking
   import DataFlow::PathGraph
   ...
   from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
   where cfg.hasFlowPath(source, sink)
   select sink, source, sink, "<message>"

.. note::

  To see the paths between the source and the sinks, we can convert the query to a path problem query. There are a few minor changes that need to be made for this to work–we need an additional import, to specify ``PathNode`` rather than ``Node``, and to add the source/sink to the query output (so that we can automatically determine the paths).
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
