<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:dd8dc200414e11e0f18670944f9b9e86058cf3d17b55c83eea957d5fe87d5532
size 208
=======
import cpp

from LocalVariable lv, ControlFlowNode def
where
  def = lv.getAnAssignment() and
  not exists(VariableAccess use |
    use = lv.getAnAccess() and
    use = def.getASuccessor+()
  )
select lv, def
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
