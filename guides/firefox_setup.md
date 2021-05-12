### Firefox Setup 
---
After installing firefox,get latest _better-fox User.js_ from :
- [Better-Fox](https://github.com/yokoffing/Better-Fox/blob/master/user.js)

Since this User.js don't enable the ```resistfingerprinting``` and ```webgl.diseable```,do enable them manually in _about:config_ by setting :
```sh
privacy.resistFingerprinting : true
webgl.disabled : true
```
Now change the preferences as :
```sh
Search Engine : DuckDuckGo
Enhanced Tracking Protection > Tracking content : Enable
Under Custom > Tracking : Change blocklist to level 2
Clear History on exit : true
Under History > Settings > Active logins+Cookies : Disable
```

---
> For further hardening :
####  User.js
> A user.js is a configuration file that can control hundreds of Firefox settings.
- [arkenfox](https://github.com/arkenfox/user.js)
- [pyllyukko](https://github.com/pyllyukko/user.js/)
- [Better-Fox](https://github.com/yokoffing/Better-Fox/blob/master/user.js)

####  Hardening Guides
> Harden firefox manually thus having a granular control
- [https://chrisx.xyz/blog/yet-another-firefox-hardening-guide/](https://chrisx.xyz/blog/yet-another-firefox-hardening-guide/)
- [https://teddit.net/r/privacytoolsIO/comments/mqy5u1/firefox_privacy_tweaks/](https://teddit.net/r/privacytoolsIO/comments/mqy5u1/firefox_privacy_tweaks/)

> Note : Enabling ```firstpartyisolate``` may render some of the extensions unusable
