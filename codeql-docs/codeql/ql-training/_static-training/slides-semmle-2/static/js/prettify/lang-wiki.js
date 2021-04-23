<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:c4050d97867d28f0cd7703398c8dbbcb6097b8f4f4c71c96ebe5e4783b69e389
size 543
=======
PR.registerLangHandler(PR.createSimpleLexer([["pln",/^[\d\t a-gi-z\xa0]+/,null,"\t Â\xa0abcdefgijklmnopqrstuvwxyz0123456789"],["pun",/^[*=[\]^~]+/,null,"=*~^[]"]],[["lang-wiki.meta",/(?:^^|\r\n?|\n)(#[a-z]+)\b/],["lit",/^[A-Z][a-z][\da-z]+[A-Z][a-z][^\W_]+\b/],["lang-",/^{{{([\S\s]+?)}}}/],["lang-",/^`([^\n\r`]+)`/],["str",/^https?:\/\/[^\s#/?]*(?:\/[^\s#?]*)?(?:\?[^\s#]*)?(?:#\S*)?/i],["pln",/^(?:\r\n|[\S\s])[^\n\r#*=A-[^`h{~]*/]]),["wiki"]);
PR.registerLangHandler(PR.createSimpleLexer([["kwd",/^#[a-z]+/i,null,"#"]],[]),["wiki.meta"]);
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
