<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:78436b5430eb6d5b4c866862bdb27ce06cf65135c1d32f457f823feb83a8c85e
size 1941
=======
"""
    Custom Pygments lexer for highlighting QL code.
    
    Based on instructions from http://pygments.org/docs/lexerdevelopment/.
"""

import re

from pygments.lexer import RegexLexer, words
from pygments.token import Operator, Punctuation, Keyword, Comment, \
    Name, Number, String, Text

class QLLexer(RegexLexer):

    name = 'QL'
    aliases = ['ql']
    filenames = ['*.ql','*.qll']
    mimetype = ['text/x-ql']

    flags = re.MULTILINE

    tokens = {
        'root': [
            (r'\r\n|\r|\n', Text),
            (r'\s+', Text),
            (r'\"([^\\\"\n\r\t]|\\[\"nrt\\])*\"', String),
            (r'[0-9]+(\.[0-9])?', Number),
            (r'[,;.()\[\]{}]', Punctuation),
            # Comments (one-line, multiline, and QLDoc)
            (r'\/\/.*$', Comment.Single),
            (r'\/\*([^\*][\s\S]*?)?\*\/', Comment.Multiline),
            (r'\/\*(?!\*\/)\*[\s\S]*?\*\/', Comment.Preproc),
            # Operators
            (r'<=|>=|!=|\.\.|::|[<>=\-\/*%+|]', Operator),
            # Keywords
            (r'\b(boolean|date|float|int|string)\b', Keyword.Type),
            (r'\b(abstract|cached|deprecated|external|final|library|override|private|query'
             r'|(pragma|language|bindingset)\[\w*(,\s*\w*)*\])\s', 
             Keyword.Reserved),
            (words((
                'and', 'any', 'as', 'asc', 'avg', 'by', 'class','concat', 'count',
                'desc', 'else', 'exists', 'extends', 'false', 'forall', 
                'forex', 'from', 'if', 'implies', 'import', 'in', 'instanceof',
                'max', 'min', 'module', 'newtype', 'not', 'none', 'or', 'order', 
                'predicate', 'rank', 'result', 'select', 'strictconcat', 
                'strictcount', 'strictsum', 'sum', 'super', 'then', 'this', 
                'true', 'unique', 'where'), prefix=r'\b', suffix=r'\b'),
             Keyword),
            # Identifiers
            (r'@?\w', Name),
        ]
    }
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
