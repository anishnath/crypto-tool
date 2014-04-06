package example


import scala.Array.canBuildFrom

object TestArray {

  def main(args: Array[String]) {

    /** Creates array with given dimensions */
    var array1 = Array.ofDim[Int](1)

    /** Creates a 2-dimensional array */
    var array2 = Array.ofDim[Int](2, 12)

    /** Creates a 3-dimensional array */
    var array3 = Array.ofDim[Int](3, 4, 4)

    /** Creates a 4-dimensional array */
    var array4 = Array.ofDim[Int](4, 4, 4, 6)

    PrintOneDArray(array1);
    println();
    PrintTwoDArray(array2);
    println();
    PrintThreeDArray(array3)

    /** Concating Array **/
    val a = Array(1, 2)
    val b = Array.ofDim[Int](2)
    val c = Array.concat(a, b)

    //Arrays are mutable, indexed collections of values
    val numbers = Array(1, 2, 3, 4)
    val first = numbers(0) // read the first element
    numbers(3) = 100 // replace the 4th array element with 100
    val biggerNumbers = numbers.map(_ * 2) // multiply all numbers by two
    println(numbers(1))

    /** Reversing the Array **/
    val arr = Array(1, 2, 3)
    val arrReversed = arr.reverse
    val seqReversed: Seq[Int] = arr.reverse
    println(arrReversed(0)) // This will Print 3

    //Creating Empty Array of Other DataType
    val emptyBooleanArray = new Array[Boolean](0)
    val emptyByteArray = new Array[Byte](0)
    val emptyCharArray = new Array[Char](0)
    val emptyDoubleArray = new Array[Double](0)
    val emptyFloatArray = new Array[Float](0)
    val emptyIntArray = new Array[Int](0)
    val emptyLongArray = new Array[Long](0)
    val emptyShortArray = new Array[Short](0)
    val emptyObjectArray = new Array[Object](0)
    
    

  }

  /**
   * Passing 1D array As Integer Argument
   */
  private def PrintOneDArray(oneDArray: Array[Int]): Unit = {
    oneDArray(0) = 1;
    println(oneDArray(0))

  }

  /**
   * Passing 2D array as Integer Argument
   */
  private def PrintTwoDArray(twoDArrayARgs: Array[Array[Int]]): Unit = {
    twoDArrayARgs(0)(0) = 2
    println(twoDArrayARgs(0)(0));
  }

  /**
   * Passing 3D array as Integer Argument
   */
  private def PrintThreeDArray(threeDArray: Array[Array[Array[Int]]]): Unit = {

    threeDArray(0)(0)(0) = 3
    for (i <- 0 to 2) {
      for (j <- 0 to 2) {
        for (k <- 0 to 2) {
          print(" " + threeDArray(i)(j)(k));
        }
      }
      println();
    }
  }

}