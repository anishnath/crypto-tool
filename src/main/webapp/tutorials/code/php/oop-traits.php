<?php
// Traits - Code Reuse

trait Timestampable
{
    public $createdAt;
    public $updatedAt;

    public function setTimestamps()
    {
        $this->createdAt = date('Y-m-d H:i:s');
        $this->updatedAt = date('Y-m-d H:i:s');
    }

    public function updateTimestamp()
    {
        $this->updatedAt = date('Y-m-d H:i:s');
    }
}

trait Loggable
{
    public function log($message)
    {
        echo "[" . date('H:i:s') . "] $message\n";
    }
}

class Post
{
    use Timestampable, Loggable;

    public $title;
    public $content;

    public function __construct($title, $content)
    {
        $this->title = $title;
        $this->content = $content;
        $this->setTimestamps();
        $this->log("Post created: $title");
    }
}

$post = new Post("Hello World", "This is my first post");
echo "Created: " . $post->createdAt . "\n";
$post->log("Post viewed");
