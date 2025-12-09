class Counter {
    private int count = 0;

    // WITHOUT 'synchronized', the result is unpredictable (Race Condition)
    // WITH 'synchronized', the result is always 2000.
    public synchronized void increment() {
        count++;
    }

    public int getCount() {
        return count;
    }
}

public class SyncExample {
    public static void main(String[] args) throws InterruptedException {

        Counter c = new Counter();

        // Create 1000 threads that all update the SAME counter
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++)
                c.increment();
        });

        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++)
                c.increment();
        });

        t1.start();
        t2.start();

        // Wait for both to finish
        t1.join();
        t2.join();

        System.out.println("Final Count: " + c.getCount());

        if (c.getCount() == 2000) {
            System.out.println("Success! No Race Condition.");
        } else {
            System.out.println("Fail! Race Condition occurred (Expected 2000).");
        }
    }
}
