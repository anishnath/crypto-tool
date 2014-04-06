package example

object exceptions {

  def method2 = try {
    println("Hello, world");
  } catch {
    case e: Exception => println("Exception Thrown" + e.getMessage())
    case _: Error => println("File error");
    case t: Throwable => Console.println("Unknown error" + t.getMessage());
  }

  def tryFinallyTry: Unit = {
    try {
      ()
    } finally {
      try {
        sys.error("a");
      } catch {
        case _: Throwable => println("Silently ignore exception in finally");
      }
    }
  }

  def method4 = try {
    println("..");
  } catch {
    case _: Throwable => sys.error("..");
  }

  def nested1: Unit = try {
    try {
      sys.error("nnnnoooo");
    } finally {
      println("Innermost finally");
    }
  } finally {
    println("Outermost finally");
  }

  def tryCatchInFinally: Unit = {
    try {
      println("Try")
    } catch {
      case e: java.io.IOException =>
        throw e
    } finally {
      val x = 10
      if (x != 10) {
        try { println("Fin"); } catch { case e: java.io.IOException => ; }
      }
    }
  }

  def tryThrowFinally: Unit = {
    try {
      print("A")
      throw new Exception
    } catch {
      case e: Exception =>
        print("B")
        throw e
    } finally {
      println("C")
    }
  }

   def returnInBodyAndInFinally2: Unit = try {
    try {
      println("Normal execution...");
      return
      println("non reachable code");
    } finally {
      try {
       println("inner finally");
        return
      } finally {
        println("finally inside finally");
      }
    }
  } finally {
    println("Outer finally");
    return
  }

  
  
  def main(args: Array[String]) {
    exceptions.tryCatchInFinally
    exceptions.method2
  }

}

 