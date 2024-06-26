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
javascript:(async()=>{const username="YOUR_USERNAME";const redditSavedUrl=`https://www.reddit.com/user/${username}/saved.json`;try{const savedPosts=await fetchAllSavedPosts(redditSavedUrl);renderTable(savedPosts)}catch(error){showNotification("Error fetching or rendering saved posts. Please try again.");console.error("Error fetching or rendering saved posts:",error)}async function fetchData(url,timeout=5000){const controller=new AbortController();const id=setTimeout(()=>controller.abort(),timeout);const response=await fetch(url,{signal:controller.signal});clearTimeout(id);if(!response.ok){throw new Error(`Failed to fetch ${url}: ${response.status} ${response.statusText}`)}return response.json()}async function fetchAllSavedPosts(url){const posts=[];let after=null;do{const fetchUrl=after?`${url}?after=${after}`:url;console.log(`Fetching URL: ${fetchUrl}`);const response=await fetchData(fetchUrl);const extractedPosts=extractPosts(response);posts.push(...extractedPosts);after=response.data.after}while(after);return posts}function extractPosts(data){return data.data.children.filter(item=>item.kind==="t3").map(item=>({title:item.data.title,permalink:`https://www.reddit.com${item.data.permalink}`}))}function renderTable(posts){const table=createTable(posts);const exportButton=createExportButton(posts);const searchInput=createSearchInput(table);displayTable(table,searchInput,exportButton)}function createTable(posts){const table=document.createElement("table");table.classList.add("reddit-posts-table");table.setAttribute("role","table");const thead=document.createElement("thead");const headerRow=document.createElement("tr");headerRow.setAttribute("role","row");headerRow.appendChild(createCell("th","Title"));headerRow.appendChild(createCell("th","Actions"));thead.appendChild(headerRow);table.appendChild(thead);const tbody=document.createElement("tbody");posts.forEach(post=>{const row=document.createElement("tr");row.setAttribute("role","row");row.appendChild(createCell("td",post.title));const actionsCell=document.createElement("td");actionsCell.appendChild(createLink("Post",post.permalink,"_blank","post-link"));actionsCell.appendChild(document.createTextNode(" | "));actionsCell.appendChild(createLink("Download",getDownloadUrl(post.permalink),"_blank","download-link"));row.appendChild(actionsCell);tbody.appendChild(row)});table.appendChild(tbody);return table}function createCell(type,textContent){const cell=document.createElement(type);cell.textContent=textContent;cell.setAttribute("role",type==="th"?"columnheader":"cell");return cell}function createLink(text,href,target,className){const link=document.createElement("a");link.textContent=text;link.href=href;link.target=target;link.classList.add(className);return link}function createSearchInput(table){const searchInput=document.createElement("input");searchInput.type="text";searchInput.placeholder="Search by title";searchInput.classList.add("search-input");searchInput.setAttribute("aria-label","Search by title");searchInput.addEventListener("input",()=>{const searchTerm=searchInput.value.toLowerCase();table.querySelectorAll("tbody tr").forEach(row=>{const title=row.querySelector("td:first-child").textContent.toLowerCase();row.style.display=title.includes(searchTerm)?"":"none"})});return searchInput}function createExportButton(posts){const exportButton=document.createElement("button");exportButton.textContent="Export";exportButton.classList.add("export-button");exportButton.addEventListener("click",()=>exportToTxt(posts));return exportButton}function displayTable(table,searchInput,exportButton){const tableContainer=document.createElement("div");tableContainer.classList.add("reddit-table-container");tableContainer.appendChild(searchInput);tableContainer.appendChild(table);tableContainer.appendChild(exportButton);let newTab=window.open("");if(!newTab||newTab.closed||typeof newTab.closed==='undefined'){showNotification("Please allow popups for this website.")}else{newTab.document.body.innerHTML="";newTab.document.body.appendChild(tableContainer);const style=newTab.document.createElement("style");style.textContent=`body{font-family:Arial,sans-serif;padding:20px;background-color:#f5f5f5}.reddit-table-container{max-width:800px;margin:0%20auto;border:1px%20solid%20#ccc;padding:20px;background-color:#ffffff;box-shadow:0%204px%208px%20rgba(0,0,0,0.1);border-radius:8px;display:flex;flex-direction:column;gap:15px}.reddit-posts-table{width:100%;border-collapse:collapse;margin-top:10px}.reddit-posts-table%20th,.reddit-posts-table%20td{border:1px%20solid%20#ddd;padding:12px;text-align:left}.reddit-posts-table%20th{background-color:#f8f8f8}.search-input{width:100%;padding:10px;margin-bottom:15px;border:1px%20solid%20#ccc;border-radius:4px;box-sizing:border-box}.post-link,.download-link{margin-right:5px;color:#007BFF;text-decoration:none}.post-link:hover,.download-link:hover{text-decoration:underline}.export-button{padding:10px%2015px;border:none;border-radius:4px;background-color:#28a745;color:#fff;cursor:pointer;font-size:14px}.export-button:hover{background-color:#218838}`;newTab.document.head.appendChild(style)}}function%20getDownloadUrl(permalink){const%20urlWithoutDomain=permalink.replace("https://www.reddit.com","");return`https://rapidsave.com${urlWithoutDomain}`}function%20exportToTxt(posts){const%20urls=posts.map(post=>getDownloadUrl(post.permalink)).join("\n");const%20blob=new%20Blob([urls],{type:"text/plain"});const%20url=URL.createObjectURL(blob);const%20a=document.createElement("a");a.href=url;a.download="reddit_saved_urls.txt";a.click();URL.revokeObjectURL(url)}function%20showNotification(message){const%20notification=document.createElement("div");notification.classList.add("notification");notification.textContent=message;document.body.appendChild(notification);setTimeout(()=>notification.remove(),3000)}})();
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