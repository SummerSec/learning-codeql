.. _conversions-and-classes-in-cpp:

Conversions and classes in C and C++
====================================

You can use the standard CodeQL libraries for C and C++ to detect when the type of an expression is changed.

Conversions
-----------

In C and C++, conversions change the type of an expression. They may be implicit conversions generated by the compiler, or explicit conversions requested by the user.

Let's take a look at the `Conversion <https://codeql.github.com/codeql-standard-libraries/cpp/semmle/code/cpp/exprs/Cast.qll/type.Cast$Conversion.html>`__ class in the standard library:

-  ``Expr``

   -  ``Conversion``

      -  ``Cast``

         -  ``CStyleCast``
         -  ``StaticCast``
         -  ``ConstCastReinterpretCast``
         -  ``DynamicCast``

      -  ``ArrayToPointerConversion``
      -  ``VirtualMemberToFunctionPointerConversion``

Exploring the subexpressions of an assignment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Let us consider the following C code:

.. code-block:: cpp

   typedef signed int myInt;
   int main(int argc, char *argv[])
   {
       unsigned int i;
       i = (myInt)1;
       return 0;
   }

And this simple query:

.. code-block:: ql

   import cpp

   from AssignExpr a
   select a, a.getLValue().getType(), a.getRValue().getType()

The query examines the code for assignments, and tells us the type of their left and right subexpressions. In the example C code above, there is just one assignment. Notably, this assignment has two conversions (of type ``CStyleCast``) on the right side:

#. Explicit cast of the integer ``1`` to a ``myInt``.
#. Implicit conversion generated by the compiler, in preparation for the assignment, converting that expression into an ``unsigned int``.

The query actually reports the result:

.. code-block:: cpp

   ... = ... | unsigned int | int

It is as though the conversions are not there! The reason for this is that ``Conversion`` expressions do not wrap the objects they convert; instead conversions are attached to expressions and can be accessed using ``Expr.getConversion()``. The whole assignment in our example is seen by the standard library classes like this:

.. |arrow| unicode:: U+21b3

| ``AssignExpr, i = (myInt)1`` 
| |arrow| ``VariableAccess, i``
| |arrow|  ``Literal, 1``
|   |arrow|  ``CStyleCast, myInt (explicit)``
|     |arrow|  ``CStyleCast, unsigned int (implicit)``

Accessing parts of the assignment:

-  Left side—access value using ``Assignment.getLValue()``.
-  Right side—access value using ``Assignment.getRValue()``.
-  Conversions of the ``Literal`` on the right side—access both using calls to ``Expr.getConversion()``. As a shortcut, you can use ``Expr.GetFullyConverted()`` to follow all the way to the resulting type, or ``Expr.GetExplicitlyConverted()`` to find the last explicit conversion from an expression.

Using these predicates we can refine our query so that it reports the results that we expected:

.. code-block:: ql

   import cpp

   from AssignExpr a
   select a, a.getLValue().getExplicitlyConverted().getType(), a.getRValue().getExplicitlyConverted().getType()

The result is now:

.. code-block:: cpp

   ... = ... | unsigned int | myInt

We can refine the query further by adding ``Type.getUnderlyingType()`` to resolve the ``typedef``:

.. code-block:: ql

   import cpp

   from AssignExpr a
   select a, a.getLValue().getExplicitlyConverted().getType().getUnderlyingType(), a.getRValue().getExplicitlyConverted().getType().getUnderlyingType()

The result is now:

.. code-block:: cpp

   ... = ... | unsigned int | signed int

If you simply wanted to get the values of all assignments in expressions, regardless of position, you could replace ``Assignment.getLValue()`` and ``Assignment.getRValue()`` with ``Operation.getAnOperand()``:

.. code-block:: ql

   import cpp

   from AssignExpr a
   select a, a.getAnOperand().getExplicitlyConverted().getType()

Unlike the earlier versions of the query, this query would return each side of the expression as a separate result:

.. code-block:: cpp

   ... = ... | unsigned int
   ... = ... | myInt

.. pull-quote::

   Note
   
    In general, predicates named ``getAXxx`` exploit the ability to return multiple results (multiple instances of ``Xxx``) whereas plain ``getXxx`` predicates usually return at most one specific instance of ``Xxx``.

Classes
-------

Next we're going to look at C++ classes, using the following CodeQL classes:

-  ``Type``

   -  ``UserType``—includes classes, typedefs, and enums

      -  ``Class``—a class or struct

         -  ``Struct``—a struct, which is treated as a subtype of ``Class``
         -  ``TemplateClass``—a C++ class template

Finding derived classes
~~~~~~~~~~~~~~~~~~~~~~~

We want to create a query that checks for destructors that should be ``virtual``. Specifically, when a class and a class derived from it both have destructors, the base class destructor should generally be virtual. This ensures that the derived class destructor is always invoked. In the CodeQL library, ``Destructor`` is a subtype of ``MemberFunction``:

-  ``Function``

   -  ``MemberFunction``

      -  ``Constructor``
      -  ``Destructor``

Our starting point for the query is pairs of a base class and a derived class, connected using ``Class.getABaseClass()``:

.. code-block:: ql

   import cpp

   from Class base, Class derived
   where derived.getABaseClass+() = base
   select base, derived, "The second class is derived from the first."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505902347211/>`__

Note that the transitive closure symbol ``+`` indicates that ``Class.getABaseClass()`` may be followed one or more times, rather than only accepting a direct base class.

A lot of the results are uninteresting template parameters. You can remove those results by updating the ``where`` clause as follows:

.. code-block:: ql

   where derived.getABaseClass+() = base
     and not exists(base.getATemplateArgument())
     and not exists(derived.getATemplateArgument())

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505907047251/>`__

Finding derived classes with destructors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now we can extend the query to find derived classes with destructors, using the ``Class.getDestructor()`` predicate:

.. code-block:: ql

   import cpp

   from Class base, Class derived, Destructor d1, Destructor d2
   where derived.getABaseClass+() = base
     and not exists(base.getATemplateArgument())
     and not exists(derived.getATemplateArgument())
     and d1 = base.getDestructor()
     and d2 = derived.getDestructor()
   select base, derived, "The second class is derived from the first, and both have a destructor."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505901767389/>`__

Notice that getting the destructor implicitly asserts that one exists. As a result, this version of the query returns fewer results than before.

Finding base classes where the destructor is not virtual
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Our last change is to use ``Function.isVirtual()`` to find cases where the base destructor is not virtual:

.. code-block:: ql

   import cpp

   from Class base, Destructor d1, Class derived, Destructor d2
   where derived.getABaseClass+() = base
     and d1.getDeclaringType() = base
     and d2.getDeclaringType() = derived
     and not d1.isVirtual()
   select d1, "This destructor should probably be virtual."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505908156827/>`__

That completes the query.

There is a similar built-in `query <https://lgtm.com/rules/2158670642/>`__ on LGTM.com that finds classes in a C/C++ project with virtual functions but no virtual destructor. You can take a look at the code for this query by clicking **Open in query console** at the top of that page.

Further reading
---------------

.. include:: ../reusables/cpp-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
