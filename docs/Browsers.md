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
- Reddown
```js
javascript:void%20function(){(async%20function(){async%20function%20a(a){const%20b=await%20fetch(a);if(!b.ok)throw%20new%20Error(`Failed%20to%20fetch%20${a}:%20${b.status}%20${b.statusText}`);return%20b.json()}async%20function%20b(b){const%20d=[];let%20e=null;do{const%20f=e%3F`${b}%3Fafter=${e}`:b;console.log(`Fetching%20URL:%20${f}`);const%20g=await%20a(f),h=c(g);d.push(...h),e=g.data.after}while(e);return%20d}function%20c(a){return%20a.data.children.filter(a=%3E%22t3%22===a.kind).map(a=%3E({title:a.data.title,permalink:`https://www.reddit.com${a.data.permalink}`}))}function%20d(a){const%20b=e(a),c=i(a),d=h(b);j(b,d,c)}function%20e(a){const%20b=document.createElement(%22table%22);b.classList.add(%22reddit-posts-table%22);const%20c=document.createElement(%22thead%22),d=document.createElement(%22tr%22);d.appendChild(f(%22th%22,%22Title%22)),d.appendChild(f(%22th%22,%22Actions%22)),c.appendChild(d),b.appendChild(c);const%20e=document.createElement(%22tbody%22);return%20a.forEach(a=%3E{const%20b=document.createElement(%22tr%22);b.appendChild(f(%22td%22,a.title));const%20c=document.createElement(%22td%22);c.appendChild(g(%22Post%22,a.permalink,%22_blank%22,%22post-link%22)),c.appendChild(document.createTextNode(%22%20|%20%22)),c.appendChild(g(%22Download%22,k(a.permalink),%22_blank%22,%22download-link%22)),b.appendChild(c),e.appendChild(b)}),b.appendChild(e),b}function%20f(a,b){const%20c=document.createElement(a);return%20c.textContent=b,c}function%20g(a,b,c,d){const%20e=document.createElement(%22a%22);return%20e.textContent=a,e.href=b,e.target=c,e.classList.add(d),e}function%20h(a){const%20b=document.createElement(%22input%22);return%20b.type=%22text%22,b.placeholder=%22Search%20by%20title%22,b.classList.add(%22search-input%22),b.addEventListener(%22input%22,function(){const%20b=this.value.toLowerCase();a.querySelectorAll(%22tbody%20tr%22).forEach(a=%3E{const%20c=a.querySelector(%22td:first-child%22).textContent.toLowerCase();a.style.display=c.includes(b)%3F%22%22:%22none%22})}),b}function%20i(a){const%20b=document.createElement(%22button%22);return%20b.textContent=%22Export%22,b.addEventListener(%22click%22,function(){l(a)}),b}function%20j(a,b,c){const%20d=document.createElement(%22div%22);d.classList.add(%22reddit-table-container%22),d.appendChild(b),d.appendChild(a),d.appendChild(c);const%20e=window.open(%22%22);e.document.body.innerHTML=%22%22,e.document.body.appendChild(d);const%20f=e.document.createElement(%22style%22);f.textContent=`%20%20%20%20%20%20%20%20%20%20%20%20body%20{%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20font-family:%20Arial,%20sans-serif;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20padding:%2020px;%20%20%20%20%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20%20%20%20%20.reddit-table-container%20{%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20max-width:%20800px;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20margin:%200%20auto;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20border:%201px%20solid%20%23ccc;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20padding:%2020px;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20background-color:%20%23f9f9f9;%20%20%20%20%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20%20%20%20%20.reddit-posts-table%20{%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20width:%20100%25;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20border-collapse:%20collapse;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20margin-top:%2010px;%20%20%20%20%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20%20%20%20%20.reddit-posts-table%20th,%20.reddit-posts-table%20td%20{%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20border:%201px%20solid%20%23ddd;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20padding:%208px;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20text-align:%20left;%20%20%20%20%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20%20%20%20%20.search-input%20{%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20width:%20100%25;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20padding:%208px;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20margin-bottom:%2010px;%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20box-sizing:%20border-box;%20%20%20%20%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20%20%20%20%20.post-link,%20.download-link%20{%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20margin-right:%205px;%20%20%20%20%20%20%20%20%20%20%20%20}%20%20%20%20%20%20%20%20`,e.document.head.appendChild(f)}function%20k(a){const%20b=a.replace(%22https://www.reddit.com%22,%22%22);return`https://rapidsave.com${b}`}function%20l(b){const%20c=b.map(a=%3Ek(a.permalink)).join(%22\n%22),d=new%20Blob([c],{type:%22text/plain%22}),e=URL.createObjectURL(d),f=document.createElement(%22a%22);f.href=e,f.download=%22reddit_saved_urls.txt%22,f.click(),URL.revokeObjectURL(e)}try{const%20a=await%20b(`https://www.reddit.com/user/${%22JHON_DOE%22}/saved.json`);d(a)}catch(a){console.error(%22Error%20fetching%20or%20rendering%20saved%20posts:%22,a)}})()}();
```
(Replace username)

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