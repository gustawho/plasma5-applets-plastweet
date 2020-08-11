![Screenshot](./img/preview.png)
# Plastweet
A small plasmoid to post tweets directly from your Plasma desktop (WiP)

<a href="https://www.kdevelop.org/" target="_blank"><img src="img/made-with-kdevelop.png" width="150"></a>
<a href="https://store.kde.org/p/1407433/" target="_blank"><img src="img/kde-store.png" width="150" style="padding-left:0.5rem;"></a>

The primary goal of this project is to bring the ability to quickly send tweets without opening your browser or any other program. It has to be as simple and lightweight as possible.

## Requirements
* [Twitcurl](https://github.com/gustawho/twitcurl)
* cURL
* Extra CMake Modules
* Qt5 GraphicalEffects
* KF5 & Plasma

## Installation
Currently, posting text statuses is the only available feature and as OAuth login isn't implemented yet, you need to register an application in [apps.twitter.com](https://apps.twitter.com) and configure the plasmoid accordingly.

### User
```Bash
git clone https://github.com/gustawho/plasma5-applets-plastweet.git
cd plasma5-applets-plastweet
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/.local -DKDE_INSTALL_USE_QT_SYS_PATHS=ON ..
make
make install
```

### System-wide
```Bash
git clone https://github.com/gustawho/plasma5-applets-plastweet.git
cd plasma5-applets-plastweet
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DKDE_INSTALL_USE_QT_SYS_PATHS=ON ..
make
sudo make install
```

## Planned Features
- [ ] OAuth authentication
- [ ] Receive notifications on account interactions
- [ ] "Online Accounts" integration
- [ ] Dialog to search and add GIFs
- [ ] Automatic threads
- [ ] Drafts
- [ ] Username auto-completion
- [ ] Highlight hashtags

## TODO:
- [ ] Gracefully handle errors
- [ ] Add a progress bar
- [ ] Tweet multiple pictures
- [ ] Safely store login details
- [ ] Spell checking support
