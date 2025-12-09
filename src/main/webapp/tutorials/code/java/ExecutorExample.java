import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

class WorkerThread implements Runnable {
    private String message;

    public WorkerThread(String s) {
        this.message = s;
    }

    public void run() {
        System.out.println(Thread.currentThread().getName() + " (Start) message = " + message);
        processMessage();
        System.out.println(Thread.currentThread().getName() + " (End)");
    }

    private void processMessage() {
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

public class ExecutorExample {
    public static void main(String[] args) {

        // 1. Create a pool of 2 threads
        ExecutorService executor = Executors.newFixedThreadPool(2);

        // 2. Submit 5 tasks
        for (int i = 0; i < 5; i++) {
            Runnable worker = new WorkerThread("" + i);
            executor.execute(worker);
        }

        // 3. Shutdown
        executor.shutdown();

        try {
            // Wait for all tasks to finish
            while (!executor.awaitTermination(24L, TimeUnit.HOURS)) {
                System.out.println("Still waiting...");
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("\nFinished all threads");
    }
}
