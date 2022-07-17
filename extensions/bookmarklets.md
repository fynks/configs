### Light House
``` js
javascript:window.location='https://developers.google.com/speed/pagespeed/insights/?url='+encodeURI(window.location);
```
### G Translate
``` js
javascript:void(open('https://translate.google.co.in/translate?hl=en&sl=auto&tl=en&u='+location.href));
```
### Edit current page
```js
javascript:document.body.contentEditable = 'true'; document.designMode='on'; void 0
```
### Sticky header remover
``` js
javascript:(function() {    document.querySelectorAll('*').forEach(function(n) {        var p = getComputedStyle(n).getPropertyValue('position');        if (p === 'fixed' || p === 'sticky') {            n.style.cssText += ' ; position: absolute !important;';        }    });})();
```
### Website diguiser
``` js
javascript:(function() { setInterval(function() { var link = document.querySelector("link[rel*='icon']") || document.createElement('link'); link.type = 'image/x-icon'; link.rel = 'shortcut icon'; link.href = 'https://www.google.com/s2/favicons?domain=google.com'; document.getElementsByTagName('head')[0].appendChild(link); document.title = "Google"; console.log("Stealth Activated");; }, 1000); })();
```
### Medium to Scribe Redirector
```js
javascript:(function(){var loc=location.href;loc=loc.replace('medium.com/','scribe.rip/'); location.replace(loc)})()
```

### Download YT Video
``` js
javascript:window.location='https://alltubedownload.net/info?url=%25url%25'.replace('%url%', encodeURIComponent(location.href));
```

