# Exercise: Media Player
# Create a polymorphic media player system

# Base class provided
class MediaFile:
    def __init__(self, filename, duration):
        self.filename = filename
        self.duration = duration  # in seconds

    def play(self):
        raise NotImplementedError("Subclass must implement")

    def get_info(self):
        return f"{self.filename} ({self.duration}s)"


# 1. Create an AudioFile class that inherits from MediaFile
#    - Override play() to return "Playing audio: {filename}"
#    - Add a 'bitrate' attribute (e.g., 320)
#    - Override get_info() to include bitrate
# Your code here:


# 2. Create a VideoFile class that inherits from MediaFile
#    - Override play() to return "Playing video: {filename}"
#    - Add 'resolution' attribute (e.g., "1920x1080")
#    - Override get_info() to include resolution
# Your code here:


# 3. Create an ImageFile class (NOT inheriting from MediaFile)
#    This demonstrates duck typing - same interface, no inheritance
#    - __init__ takes filename and dimensions (e.g., "800x600")
#    - play() returns "Displaying image: {filename}"
#    - get_info() returns "{filename} ({dimensions})"
# Your code here:


# 4. Create a play_all function that takes a list of media items
#    and calls play() on each one (duck typing in action)
# Your code here:


# 5. Create a total_duration function that takes a list of media
#    and returns total duration (only for items that have duration)
#    Use duck typing with try/except
# Your code here:



# Test your implementation:
# media_library = [
#     AudioFile("song.mp3", 180, 320),
#     VideoFile("movie.mp4", 7200, "1920x1080"),
#     ImageFile("photo.jpg", "4000x3000"),
#     AudioFile("podcast.mp3", 3600, 128),
# ]

# print("=== Media Library ===")
# for media in media_library:
#     print(media.get_info())

# print("\n=== Playing All ===")
# play_all(media_library)

# print(f"\n=== Total Duration ===")
# print(f"Total: {total_duration(media_library)} seconds")
