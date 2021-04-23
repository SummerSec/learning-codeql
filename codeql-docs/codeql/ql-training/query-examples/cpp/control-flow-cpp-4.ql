<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:f29be4e37d4200bffbef0719c617d041abda9f087c88fc413d08682972063049
size 179
=======
import cpp

predicate isReachable(BasicBlock bb) {
  bb instanceof EntryBasicBlock or
  isReachable(bb.getAPredecessor())
}

from BasicBlock bb
where not isReachable(bb)
select bb
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
