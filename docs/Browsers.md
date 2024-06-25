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
javascript:(async function(){const username="John-DOE";const redditSavedUrl=`https://www.reddit.com/user/${username}/saved.json`;try{showLoadingSpinner();const savedPosts=await fetchAllSavedPosts(redditSavedUrl);hideLoadingSpinner();renderTable(savedPosts)}catch(error){console.error("Error fetching or rendering saved posts:",error);displayErrorMessage("Failed to load saved posts. Please try again later.")}async function fetchData(url){const response=await fetch(url);if(!response.ok){throw new Error(`Failed to fetch ${url}: ${response.status} ${response.statusText}`)}return response.json()}async function fetchAllSavedPosts(url){const posts=[];let after=null;do{const fetchUrl=after?`${url}?after=${after}`:url;console.log(`Fetching URL: ${fetchUrl}`);const response=await fetchData(fetchUrl);const extractedPosts=extractPosts(response);posts.push(...extractedPosts);after=response.data.after}while(after);return posts}function extractPosts(data){return data.data.children.filter(item=>item.kind==="t3").map(item=>({title:item.data.title,permalink:`https://www.reddit.com${item.data.permalink}`}))}function renderTable(posts){const container=document.createElement("div");container.classList.add("reddit-table-container");const searchInput=createSearchInput();const table=createTable(posts);const exportButton=createExportButton(posts);container.appendChild(searchInput);container.appendChild(table);container.appendChild(exportButton);const newTab=window.open("");newTab.document.body.innerHTML="";newTab.document.body.appendChild(container);const style=newTab.document.createElement("style");style.textContent=`body {font-family: Arial, sans-serif;padding: 20px;margin: 0;background-color: #f9f9f9;}.reddit-table-container%20{max-width:%20800px;margin:%2020px%20auto;padding:%2020px;background-color:%20#fff;border:%201px%20solid%20#ccc;border-radius:%208px;box-shadow:%200%202px%204px%20rgba(0,%200,%200,%200.1);}.search-input%20{width:%20100%;padding:%208px;margin-bottom:%2010px;box-sizing:%20border-box;border-radius:%204px;border:%201px%20solid%20#ccc;}.btn%20{display:%20inline-block;padding:%208px%2016px;margin-top:%2010px;font-size:%2014px;font-weight:%20600;text-align:%20center;text-decoration:%20none;background-color:%20#007bff;color:%20white;border:%20none;border-radius:%204px;cursor:%20pointer;}.btn:hover%20{background-color:%20#0056b3;}.reddit-posts-table%20{width:%20100%;border-collapse:%20collapse;margin-top:%2010px;}.reddit-posts-table%20th,%20.reddit-posts-table%20td%20{border:%201px%20solid%20#ddd;padding:%208px;text-align:%20left;}.loading-spinner%20{display:%20flex;justify-content:%20center;align-items:%20center;height:%20100vh;background-color:%20rgba(255,%20255,%20255,%200.8);position:%20fixed;top:%200;left:%200;width:%20100%;z-index:%201000;}.loading-spinner%20div%20{border:%204px%20solid%20#f3f3f3;border-top:%204px%20solid%20#3498db;border-radius:%2050%;width:%2040px;height:%2040px;animation:%20spin%202s%20linear%20infinite;}@keyframes%20spin%20{0%%20{%20transform:%20rotate(0deg);%20}100%%20{%20transform:%20rotate(360deg);%20}}`;newTab.document.head.appendChild(style)}function%20createTable(posts){const%20table=document.createElement("table");table.classList.add("reddit-posts-table");const%20thead=document.createElement("thead");const%20headerRow=document.createElement("tr");headerRow.appendChild(createCell("th","Title"));headerRow.appendChild(createCell("th","Actions"));thead.appendChild(headerRow);table.appendChild(thead);const%20tbody=document.createElement("tbody");posts.forEach(post=>{const%20row=document.createElement("tr");row.appendChild(createCell("td",post.title));const%20actionsCell=document.createElement("td");actionsCell.appendChild(createLink("Post",post.permalink,"_blank","post-link"));actionsCell.appendChild(document.createTextNode("%20|%20"));actionsCell.appendChild(createLink("Download",getDownloadUrl(post.permalink),"_blank","download-link"));row.appendChild(actionsCell);tbody.appendChild(row)});table.appendChild(tbody);return%20table}function%20createCell(type,textContent){const%20cell=document.createElement(type);cell.textContent=textContent;return%20cell}function%20createLink(text,href,target,className){const%20link=document.createElement("a");link.textContent=text;link.href=href;link.target=target;link.classList.add(className);return%20link}function%20createSearchInput(){const%20searchInput=document.createElement("input");searchInput.type="text";searchInput.id="search-input";searchInput.placeholder="Search%20by%20title";searchInput.classList.add("search-input");searchInput.addEventListener("input",function(){const%20searchTerm=this.value.toLowerCase();const%20rows=document.querySelectorAll(".reddit-posts-table%20tbody%20tr");rows.forEach(row=>{const%20title=row.querySelector("td:first-child").textContent.toLowerCase();row.style.display=title.includes(searchTerm)?"":"none"})});return%20searchInput}function%20createExportButton(posts){const%20exportButton=document.createElement("button");exportButton.id="export-button";exportButton.classList.add("btn");exportButton.textContent="Export";exportButton.addEventListener("click",function(){exportToTxt(posts)});return%20exportButton}function%20getDownloadUrl(permalink){const%20urlWithoutDomain=permalink.replace("https://www.reddit.com","");return`https://rapidsave.com${urlWithoutDomain}`}function%20exportToTxt(posts){const%20urls=posts.map(post=>getDownloadUrl(post.permalink)).join("\n");const%20blob=new%20Blob([urls],{type:"text/plain"});const%20url=URL.createObjectURL(blob);const%20a=document.createElement("a");a.href=url;a.download="reddit_saved_urls.txt";a.click();URL.revokeObjectURL(url)}function%20showLoadingSpinner(){const%20spinner=document.createElement("div");spinner.classList.add("loading-spinner");spinner.innerHTML='<div></div>';document.body.appendChild(spinner)}function%20hideLoadingSpinner(){const%20spinner=document.querySelector(".loading-spinner");if(spinner){spinner.remove()}}function%20displayErrorMessage(message){const%20container=document.createElement("div");container.classList.add("reddit-table-container");container.innerHTML=`<p>${message}</p>`;document.body.appendChild(container)}})();
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