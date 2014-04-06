/**
 * Scala supports the notion of case classes.
 * Case classes are regular classes which export their constructor
 * parameters and which provide a
 *  recursive decomposition mechanism via pattern matching.
 */

case class CaseClass[A <: Seq[Int]](i: A, s: String) {
  def foo = 239
}

/**
 * Case classes are a special kind of class created using the keyword case. 
 * When the Scala compiler sees a case class,
 *  it automatically generates boilerplate code
 *  so you donÕt have to do it.
 */

abstract class Term
case class Var(name: String) extends Term
case class Fun(arg: String, body: Term) extends Term
case class App(f: Term, v: Term) extends Term


