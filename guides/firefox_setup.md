### Firefox Setup 
---
- After installing firefox,get latest _better-fox User.js_ from :
[Better-Fox](https://github.com/yokoffing/Better-Fox/blob/master/user.js)

- Fix firefox proton design by adding: 
[Firefox-UI-Fix](https://github.com/black7375/Firefox-UI-Fix)

Now change the preferences as :
```sh
Search Engine : DuckDuckGo
Clear History on exit : true
Under History > Settings > Active logins+Cookies : Disable
```
Add following to show close button only will hovering a background tab
```css
  /*=== Only show close buttons on background tabs when hovering with the mouse ===*/
.tabbrowser-tab:not([visuallyselected]) .tab-close-button {
  visibility: collapse !important;
  opacity: 0;
}
.tabbrowser-tab:hover .tab-close-button {
  visibility: visible !important;
  opacity: 1;
}

/* Animate */
@media (prefers-reduced-motion: no-preference) {
  /* Fade out */
  .tabbrowser-tab:not([visuallyselected]) .tab-close-button {
    transition: opacity 0.1s var(--animation-easing-function) !important;
  }

  /* Fade in */
  .tabbrowser-tab:hover .tab-close-button {
    transition: opacity 0.25s var(--animation-easing-function) !important;
  }
}
```

---
> For further hardening :
####  User.js
> A user.js is a configuration file that can control hundreds of Firefox settings.
- [arkenfox](https://github.com/arkenfox/user.js)
- [pyllyukko](https://github.com/pyllyukko/user.js/)

####  Hardening Guides
> Harden firefox manually thus having a granular control
- [https://chrisx.xyz/blog/yet-another-firefox-hardening-guide/](https://chrisx.xyz/blog/yet-another-firefox-hardening-guide/)
- [https://12bytes.org/articles/tech/firefox/firefoxgecko-configuration-guide-for-privacy-and-performance-buffs/](https://12bytes.org/articles/tech/firefox/firefoxgecko-configuration-guide-for-privacy-and-performance-buffs/)
- [https://teddit.net/r/privacytoolsIO/comments/mqy5u1/firefox_privacy_tweaks/](https://teddit.net/r/privacytoolsIO/comments/mqy5u1/firefox_privacy_tweaks/)

