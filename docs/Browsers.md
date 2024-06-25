---
label: Browsers
icon: browser
---

### Firefox Setup

[!file text="Better-Fox" target="blank"](https://github.com/yokoffing/Betterfox/blob/main/user.js)

[!file text="Firefox-UI-Fix" target="blank"](https://github.com/black7375/Firefox-UI-Fix/releases/latest)

### Search engine 
- [Mycroft (Google)](https://mycroftproject.com/install.html?id=118251&basename=anti-google&icontype=ico&name=G)

### Browser Configs

==-  Firefox Policies
[!file target="blank"](https://raw.githubusercontent.com/fynks/configs/main/browsers/policies.json)

> Should be placed in following paths:
> 
```bash
/etc/firefox/policies
```

```pwsh
C:\Program Files\Mozilla Firefox\distribution
```
===

==- LibreWolf Overrides
[!file target="blank"](https://raw.githubusercontent.com/fynks/configs/main/browsers/librewolf.overrides.cfg)

> Should be placed in:

```bash
$HOME/.librewolf/librewolf.overrides.cfg
```
===

==- Cookie Exception List

```uri
https://github.com
```

```uri
https://netlify.com
```

```uri
https://chat.openai.com
```

```uri
https://auth.openai.com
```

```uri
https://chatgpt.com
```

```uri
https://google.com
```

```uri
https://inoreader.com
```
==-

### Extensions

| **Extensions**     | **Firefox**                                                                       | **Chrome**                                                                                                  |
| :----------------- | :-------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------- |
| Ublock Origin      | [Get](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/)              | [Get](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)             |
| Bitwarden          | [Get](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/) | [Get](https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb) |
| Addy.io            | [Get](https://addons.mozilla.org/en-US/firefox/addon/addy_io/)                    | [Get](https://chrome.google.com/webstore/detail/addyio-anonymous-email-fo/iadbdpnoknmbdeolbapdackdcogdmjpe) |
| Tampermonkey       | [Get](https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/)               | [Get](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)              |
| LibRedirect        | [Get](https://addons.mozilla.org/firefox/addon/libredirect/)                      | [Get](https://libredirect.github.io/download_chromium.html)                                   |
| Firefox Containers | [Get](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)   | ---                                                                                                         |
| ImproveTube     | [Get](https://addons.mozilla.org/en-US/firefox/addon/youtube-addon/)               | [Get](https://chromewebstore.google.com/detail/improve-youtube-%F0%9F%8E%A7-for-yo/bnomihfieiccainjcjblhegjgglakjdd)                           |
| Sponsor Block      | [Get](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/)               | [Get](https://chrome.google.com/webstore/detail/mnjggcdmjocbbbhaepdhchncahnbgone)                           |

### Extension configs

[!file text="UBlock Origin" target="blank"](https://raw.githubusercontent.com/fynks/configs/main/browsers/u_block_origin_configs.txt)
[!file text="LibRedirect" target="blank"](https://raw.githubusercontent.com/fynks/configs/main/browsers/libredirect.json)
[!file text="ImproveTube" target="blank"](https://raw.githubusercontent.com/fynks/configs/main/browsers/improvedtube.json)

### Bookmarklets
- Light House
``` js
javascript:window.location='https://developers.google.com/speed/pagespeed/insights/?url='+encodeURI(window.location);
```
- G Translate
``` js
javascript:void(open('https://translate.google.co.in/translate?hl=en&sl=auto&tl=en&u='+location.href));
```
- Edit current page
```js
javascript:document.body.contentEditable = 'true'; document.designMode='on'; void 0
```
- Sub-reddits Extractor
```js
javascript:(function(){const subreddits=Array.from($('.subscription-box li a.title')).map(link=>link.textContent).join('\n');const textarea=document.createElement('textarea');textarea.value=subreddits;document.body.replaceWith(textarea);})();
```