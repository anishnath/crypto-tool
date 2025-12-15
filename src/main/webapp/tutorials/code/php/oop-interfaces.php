<?php
// Interfaces

// Interface - contract that classes must follow
interface PaymentInterface
{
    public function processPayment($amount);
    public function refund($transactionId);
}

class CreditCardPayment implements PaymentInterface
{
    public function processPayment($amount)
    {
        echo "Processing credit card payment: $$amount\n";
        return true;
    }

    public function refund($transactionId)
    {
        echo "Refunding transaction: $transactionId\n";
        return true;
    }
}

class PayPalPayment implements PaymentInterface
{
    public function processPayment($amount)
    {
        echo "Processing PayPal payment: $$amount\n";
        return true;
    }

    public function refund($transactionId)
    {
        echo "Refunding PayPal transaction: $transactionId\n";
        return true;
    }
}

// Multiple interfaces
interface Loggable
{
    public function log($message);
}

class AdvancedPayment implements PaymentInterface, Loggable
{
    public function processPayment($amount)
    {
        $this->log("Payment processed: $$amount");
        return true;
    }

    public function refund($transactionId)
    {
        $this->log("Refund processed: $transactionId");
        return true;
    }

    public function log($message)
    {
        echo "[LOG] $message\n";
    }
}

$cc = new CreditCardPayment();
$cc->processPayment(100);

$advanced = new AdvancedPayment();
$advanced->processPayment(200);
