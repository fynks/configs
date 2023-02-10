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
### Medium to Scribe Redirector
```js
javascript:(function(){var loc=location.href;loc=loc.replace('medium.com/','scribe.rip/'); location.replace(loc)})()
```
