#DANCEPARTY911
=============

A simple DJ app that loads two playlists simultaneously on one screen in two columns. When you play a track on the left side you are free to scroll and queue a track on the right (and vice-versa).

##UPDATE 10/28/13

Due to some frustrating roadblocks regarding my preferred SoundManager2 API (JavaScript) and the Spotify API (C.. ugh.). I've decided to gut the js front-end and have it read .json for playlist content, essentially making dp911 an API for playlist control.

**A separate application for creating json files will be built in Rails.** Starting first with the Soundcloud API (easier!).

In the future I hope to build several modules using various APIs that can return dp911-readable json files. 

##BASIC FUNCTIONALITY

+ As a user I'd like to view all of my tracks in playlist form.
+ As a user I'd like to play those tracks.
+ As a user I'd like to add/remove tracks from a playlist.
+ As a user I'd like to view those tracks using danceparty911.
+ As a user I'd like to save playlists.

----------
- As a user I'd like to view two playlists of mp3s, side by side.
- As a user I'd like to retrieve a playlist using Spotify and/or Dropbox.
- As a user I'd like to choose a Spotify or Dropbox user and retrieve their playlist.
- As a user I'd like to easily read music files by retrieving artist and title information.
- As a user I'd like to click to pause and load an mp3 and click again to play.
- As a user I'd like to stream playback of two mp3s simultaneously.
- As a user I'd like to easily use this application on a mobile device.

**Models**: User, Track, Playlist

**Associations:**
- Playlist has_many :tracks 
- Track belongs_to :playlist 
- User has_many :playlists 
- User has_many :tracks 

##USER ACCOUNT ABILITIES

Though the app could be used without logging in, user accounts would be beneficial for caching playlists and saving authentication data.

##WISH LIST

Here are several features that I'd like to include beyond Basic Functionality.

- Crossfade
- Sort / Search
- Mono-conversion with left/right preview/live functionality (would require a 1/8" phono splitter)
- Queue suggestions
- Suggestions based on data provided by user (i.e. The Rapture was cool when you went to college, and this party has a similar age group, play that.
- Social-network party login for automatic party demographic detection.
- BPM detection
- Strobe light that flashes at BPM interval.