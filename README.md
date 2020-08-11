![Screenshot](./img/preview.png)
# Plastweet
A small plasmoid to post tweets directly from your Plasma desktop (WiP)

<a href="https://www.kdevelop.org/" target="_blank"><img src="img/made-with-kdevelop.png" width="150"></a>
<a href="https://store.kde.org/p/1407433/" target="_blank"><img src="img/kde-store.png" width="150" style="padding-left:0.5rem;"></a>

The primary goal of this project is to bring the ability to quickly send tweets without opening your browser or any other program. It aims to be as simple and lightweight as possible.

## Features
Currently, posting tweet updates is the only available function. Although UI for adding images and videos is already there, it doesn't actually work with the JavaScript implementation (I'm working on it!).
However, you can still get this feature if you clone and compile the previous version (check the `cxx-backend` branch), but keep in mind that it requires additional dependencies and to be compiled.

## Installation
### User
- Install it directly from the KDE Store! (recommended)
- Copy or move the `package` directory inside `src` to `~/.local/share/plasma/plasmoids` (create the appropriate directories as needed).

### System-wide
Open a terminal in the cloned directory and run:
```bash
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
make
sudo make install
```

## Planned Features
- [ ] Attach images or video
- [ ] OAuth authentication
- [ ] Receive notifications on account interactions
- [ ] Integration with "Online Accounts"
- [ ] Dialog to search and add GIF images
- [ ] Automatic threads
- [ ] Drafts
- [ ] Username auto-completion
- [ ] Hashtag highlighting

## TODO
- [ ] Handle errors
- [ ] Add a progress bar
- [ ] Native notifications support
- [ ] Re-implement media upload
- [ ] Safely store login details
- [ ] Spell checking support

## Credits
* [twitter-lite](https://github.com/draftbit/twitter-lite) (MIT)
* [cross-fetch](https://github.com/lquixada/cross-fetch) (MIT, _twitter-lite dependency_)
* [crypto-js](https://github.com/brix/crypto-js) (MIT, _twitter-lite dependency_)
* [oauth-1.0a](https://github.com/ddo/oauth-1.0a) (MIT, _twitter-lite dependency_)
* [querystring](https://github.com/Gozala/querystring) (MIT, _twitter-lite dependency_)