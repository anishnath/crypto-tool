/**
 * A method with implicit parameters can be applied to arguments
 * just like a normal method. In this case the
 * implicit label has no effect.
 * However, if such a method misses arguments for 
 * its implicit parameters,
 * such arguments will be automatically provided
 */

object implicitParam extends scala.App {
  def foo(i: Int)(implicit f: Float, d: Double) = 42
  
  implicit val v = 2f
  
  implicit val v1 = 2d
  
  foo(2)
  
}