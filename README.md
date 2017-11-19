# Plastweet
## A small plasmoid to post tweets directly from your Plasma desktop (WiP)
The primary goal of this project is to bring the ability to quickly send tweets without opening your browser or any other program. It has to be as simple and lightweight as possible.

### Tentative Design
<p align="center">
<img src="screenshots/preview.gif">
<img src="screenshots/plasmoid.png">
<img src="screenshots/text.png">
<img src="screenshots/charlimit.png">
<img src="screenshots/oauth-gui.png">
</p>

### Requirements
* [Twitcurl](https://github.com/gustawho/twitcurl)
* liboauth
* libcurl
* Extra CMake Modules
* Qt5 GraphicalEffects
* KF5 & Plasma, obviously

### Test
Currently, tweeting is the only available feature. Keep in mind that you need to register an application at [apps.twitter.com](https://apps.twitter.com) and set the appropriate values in plugin/backend.cpp.
```Bash
git clone https://github.com/gustawho/plastweet.git
cd plastweet && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DKDE_INSTALL_USE_QT_SYS_PATHS=ON ..
make
sudo make install
cd ..
kpackagetool5 -t Plasma/Applet --upgrade package && plasmoidviewer --applet package
```
Keep in mind that in order to use the media upload feature, you need to use the Twitcurl version linked in the previous section.

### Planned Features
* Add multiple pictures or video
* Change the API settings if needed
* Receive notifications on account interactions (mentions, for instance... Optional and still in discussion)
* Integration with "Online Accounts"
* Dialog to search and add GIFs
* Automatic threads
* Drafts
* Username auto-completion
* Highlight hashtags

### TODO:
* Handle errors
* Add a progress bar
* Tray indicator support
* Native notifications support
* Implement multiple media upload
* Safely store login details
* Spell checking support

<p align="center">
<img src="screenshots/made-with-kdevelop.png" width="50%">
</p>
