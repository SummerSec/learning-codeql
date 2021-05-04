class MyAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {// pred 先前 Previously  succ 先后 Successively
    exists( | | )
  }
}