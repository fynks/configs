---
label: Browsers
icon: browser
order: 80
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
[!file text="Tampermonkey Script" target="blank"](https://raw.githubusercontent.com/fynks/configs/main/browsers/tampermonkey_scripts.zip)


### Blocklists
- Reddit
```js
! Reddit Award button
www.reddit.com,sh.reddit.com##award-button
```
```js
! Promoted Links
www.reddit.com##.promotedlink
```

### Bookmarklets
- Reddown
```js
javascript:(async()=>{const username="Your_USERNAME";const redditSavedUrl=`https://www.reddit.com/user/${username}/saved.json`;try{const savedPosts=await fetchAllSavedPosts(redditSavedUrl);renderTable(savedPosts)}catch(error){showNotification("Error fetching or rendering saved posts. Please try again.");console.error("Error fetching or rendering saved posts:",error)}async function fetchData(url,timeout=5e3){const controller=new AbortController,id=setTimeout(()=>controller.abort(),timeout),response=await fetch(url,{signal:controller.signal});if(clearTimeout(id),!response.ok)throw new Error(`Failed to fetch ${url}: ${response.status} ${response.statusText}`);return response.json()}async function fetchAllSavedPosts(url){const posts=[];let after=null;do{const fetchUrl=after?`${url}?after=${after}`:url;console.log(`Fetching URL: ${fetchUrl}`);const response=await fetchData(fetchUrl),extractedPosts=extractPosts(response);posts.push(...extractedPosts),after=response.data.after}while(after);return posts}function extractPosts(data){return data.data.children.filter(item=>"t3"===item.kind).map(item=>({title:item.data.title,permalink:`https://www.reddit.com${item.data.permalink}`,subreddit:item.data.subreddit,thumbnail:item.data.thumbnail}))}function renderTable(posts){const container=document.createElement("div");container.classList.add("reddit-table-container");const table=createTable(posts),searchInput=createSearchInput(table),subredditFilter=createSubredditFilter(table,posts),exportButton=createExportButton(posts);container.appendChild(searchInput),container.appendChild(subredditFilter),container.appendChild(table),container.appendChild(exportButton);let newTab=window.open("");if(!newTab||newTab.closed||void 0===newTab.closed)showNotification("Please allow popups for this website.");else{newTab.document.body.innerHTML="",newTab.document.body.appendChild(container);const style=document.createElement("style");style.textContent=getStyles(),newTab.document.head.appendChild(style)}}function createTable(posts){const table=document.createElement("table");table.classList.add("reddit-posts-table");const thead=document.createElement("thead"),headerRow=document.createElement("tr");headerRow.appendChild(createCell("th","Title")),headerRow.appendChild(createCell("th","Subreddit")),headerRow.appendChild(createCell("th","Thumbnail")),headerRow.appendChild(createCell("th","Actions")),thead.appendChild(headerRow),table.appendChild(thead);const tbody=document.createElement("tbody");return posts.forEach(post=>{const row=document.createElement("tr");row.appendChild(createCell("td",post.title)),row.appendChild(createCell("td",post.subreddit)),row.appendChild(createThumbnailCell(post.thumbnail));const actionsCell=document.createElement("td");actionsCell.appendChild(createLink("Post",post.permalink,"_blank","post-link")),actionsCell.appendChild(document.createTextNode(" | ")),actionsCell.appendChild(createLink("Download",getDownloadUrl(post.permalink),"_blank","download-link")),row.appendChild(actionsCell),tbody.appendChild(row)}),table.appendChild(tbody),table}function createCell(type,textContent){const cell=document.createElement(type);return cell.textContent=textContent,cell}function createThumbnailCell(thumbnailUrl){const cell=document.createElement("td"),img=document.createElement("img");return img.src=["default","self",""].includes(thumbnailUrl)?"https://via.placeholder.com/50":thumbnailUrl,img.alt="Thumbnail",img.style.width="50px",img.style.height="50px",cell.appendChild(img),cell}function createLink(text,href,target,className){const link=document.createElement("a");return link.textContent=text,link.href=href,link.target=target,link.classList.add(className),link}function createSearchInput(table){const searchInput=document.createElement("input");return searchInput.type="text",searchInput.placeholder="Search by title",searchInput.classList.add("search-input"),searchInput.addEventListener("input",()=>{const searchTerm=searchInput.value.toLowerCase();table.querySelectorAll("tbody tr").forEach(row=>{const title=row.querySelector("td:first-child").textContent.toLowerCase();row.style.display=title.includes(searchTerm)?"":"none"})}),searchInput}function createSubredditFilter(table,posts){const subredditFilter=document.createElement("select");subredditFilter.classList.add("subreddit-filter");const allOption=document.createElement("option");allOption.value="",allOption.textContent="All Subreddits",subredditFilter.appendChild(allOption),[...new Set(posts.map(post=>post.subreddit))].forEach(subreddit=>{const option=document.createElement("option");option.value=subreddit,option.textContent=subreddit,subredditFilter.appendChild(option)});return subredditFilter.addEventListener("change",()=>{const selectedSubreddit=subredditFilter.value;table.querySelectorAll("tbody tr").forEach(row=>{const subreddit=row.querySelector("td:nth-child(2)").textContent;row.style.display=!selectedSubreddit||subreddit===selectedSubreddit?"":"none"})}),subredditFilter}function createExportButton(posts){const exportButton=document.createElement("button");return exportButton.textContent="Export",exportButton.classList.add("export-button"),exportButton.addEventListener("click",()=>exportToTxt(posts)),exportButton}function exportToTxt(posts){const urls=posts.map(post=>getDownloadUrl(post.permalink)).join("\n"),blob=new Blob([urls],{type:"text/plain"}),url=URL.createObjectURL(blob),a=document.createElement("a");a.href=url,a.download="reddit_saved_urls.txt",a.click(),URL.revokeObjectURL(url)}function getDownloadUrl(permalink){return`https://rapidsave.com${permalink.replace("https://www.reddit.com","")}`}function showNotification(message){const notification=document.createElement("div");notification.classList.add("notification"),notification.textContent=message,document.body.appendChild(notification),setTimeout(()=>notification.remove(),3e3)}function getStyles(){return"body{font-family:Arial,sans-serif;padding:20px;background-color:#f9f9f9;color:#333}.reddit-table-container{max-width:800px;margin:0%20auto;border:1px%20solid%20#ccc;padding:20px;background-color:#fff;box-shadow:0%204px%208px%20rgba(0,0,0,.1);border-radius:8px;display:flex;flex-direction:column;gap:15px}.reddit-posts-table{width:100%;border-collapse:collapse;margin-top:10px}.reddit-posts-table%20th,.reddit-posts-table%20td{border:1px%20solid%20#ddd;padding:12px;text-align:left}.reddit-posts-table%20th{background-color:#f2f2f2}.search-input,.subreddit-filter{width:100%;padding:10px;margin-bottom:15px;border:1px%20solid%20#ccc;border-radius:4px;box-sizing:border-box;background-color:#fff;color:#333}.subreddit-filter%20option{background-color:#fff;color:#333}.post-link,.download-link{margin-right:5px;color:#0079d3;text-decoration:none}.post-link:hover,.download-link:hover{text-decoration:underline}.export-button{padding:10px%2015px;border:none;border-radius:4px;background-color:#0079d3;color:#fff;cursor:pointer;font-size:14px}.export-button:hover{background-color:#005ea2}.notification{position:fixed;top:10px;right:10px;background-color:#ff4d4d;color:white;padding:10px;border-radius:5px;box-shadow:0px%200px%2010px%20rgba(0,0,0,.1)}}"}})();
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

### Console scripts
- Adguard dns blocklist extractor
```js
(() => {
  const urlCountMap = new Map();

  const extractUrls = (containers, selectors) => {
    containers.forEach(container => {
      selectors.forEach(selector => {
        container.querySelectorAll(selector).forEach(el => {
          const url = el.querySelector('span span')?.textContent?.trim();
          if (url) {
            urlCountMap.set(url, (urlCountMap.get(url) || 0) + 1);
          }
        });
      });
    });
  };

  const createTableRows = (data) => data
    .map(([url, count]) => `
      <tr>
        <td>${url}</td>
        <td>${count}</td>
      </tr>
    `)
    .join('');

  const createStyles = () => `
    :root {
      --primary-color: #3498db;
      --secondary-color: #2c3e50;
      --background-color: #ecf0f1;
      --text-color: #34495e;
    }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 20px;
      background-color: var(--background-color);
      color: var(--text-color);
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }
    .container {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      padding: 20px;
      width: 90%;
      max-width: 800px;
      max-height: 80vh;
      overflow-y: auto;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    th, td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #e0e0e0;
    }
    th {
      background-color: var(--primary-color);
      color: white;
      position: sticky;
      top: 0;
    }
    tbody tr:hover {
      background-color: #f5f5f5;
    }
    button {
      background-color: var(--primary-color);
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    button:hover {
      background-color: var(--secondary-color);
    }
    .button-container {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
    }
    @media (max-width: 600px) {
      .container {
        padding: 10px;
      }
      th, td {
        padding: 8px;
      }
    }
  `;

  const createHtml = (tableRows) => `
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>URLs Extractor</title>
        <style>${createStyles()}</style>
      </head>
      <body>
        <div class="container">
          <table>
            <thead>
              <tr>
                <th>URL</th>
                <th>Count</th>
              </tr>
            </thead>
            <tbody>${tableRows}</tbody>
          </table>
          <div class="button-container">
            <button id="copyButton">Copy All URLs</button>
            <button id="closeButton">Close</button>
          </div>
        </div>
      </body>
    </html>
  `;

  const openTableInNewTab = (html) => {
    const newTab = window.open('', '_blank');
    if (newTab) {
      newTab.document.write(html);
      newTab.document.close();
      
      const copyButton = newTab.document.getElementById('copyButton');
      const closeButton = newTab.document.getElementById('closeButton');
      
      copyButton.addEventListener('click', () => {
        const urls = Array.from(urlCountMap.keys()).join('\n');
        newTab.navigator.clipboard.writeText(urls)
          .then(() => newTab.alert('URLs copied to clipboard!'))
          .catch(err => newTab.alert(`Failed to copy text: ${err}`));
      });
      
      closeButton.addEventListener('click', () => newTab.close());
    } else {
      console.error('Failed to open new tab. Please check your pop-up blocker settings.');
    }
  };

  const processData = () => {
    const containerSelectors = [
      '.NDyTl3bSh1i7vIE_dI7d .U9oFX9k2Qdf8nih5nNd1', 
      '.PiaOIXraYgKQwMi_mmm0 tbody tr.Dw78YcZQ2Inw4yMRUxCw'
    ];
    const urlSelectors = [
      '.omsurzVOmAZ54IlFMpMg > .gF9nuCXPT6GMQCU91nBw > span:nth-child(2)',
      '.yG8a8SfpBYd8D4Tg1S5Z.O4Kp_lIyU_4AkOKhpBAE .QkbwpPoPJOqPmlrwG1zh'
    ];

    const containers = containerSelectors.flatMap(selector => [...document.querySelectorAll(selector)]);
    extractUrls(containers, urlSelectors);

    if (urlCountMap.size > 0) {
      const tableRows = createTableRows(Array.from(urlCountMap.entries()));
      const html = createHtml(tableRows);
      openTableInNewTab(html);
    } else {
      alert('No entries found to process.');
    }
  };

  try {
    processData();
  } catch (error) {
    console.error('An error occurred:', error);
    alert('An error occurred while processing the data. Please check the console for more details.');
  }
})();
```