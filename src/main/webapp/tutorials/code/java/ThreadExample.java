class Runner1 implements Runnable {
    public void run() {
        for (int i = 0; i < 5; i++) {
            System.out.println("Runner 1: " + i);
            try {
                Thread.sleep(500); // Sleep for 500ms
            } catch (InterruptedException e) {
                System.out.println(e);
            }
        }
    }
}

class Runner2 implements Runnable {
    public void run() {
        for (int i = 0; i < 5; i++) {
            System.out.println("Runner 2: " + i);
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                System.out.println(e);
            }
        }
    }
}

public class ThreadExample {
    public static void main(String[] args) {

        // Create two threads
        Thread t1 = new Thread(new Runner1());
        Thread t2 = new Thread(new Runner2());

        // Start them concurrently
        System.out.println("--- Starting Threads ---");
        t1.start();
        t2.start();

        // Notice that the output will be interleaved
        // Because they run in parallel (depending on CPU availability)
    }
}
