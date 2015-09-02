chrome.browserAction.onClicked.addListener(function(tab) {
  var lastWindowId;
  chrome.windows.getCurrent(function(window) {
    lastWindowId = window.id;
  });

  var opts = {
    width: 200,
    height: 200,
    left: 200,
    top: 200,
    url: chrome.runtime.getURL('tabs.html'),
    focused: true,
    type: 'popup'
  };

  chrome.windows.create(opts);

  chrome.runtime.onMessage.addListener(function(_, _, response) {
    console.log(lastWindowId);
    chrome.tabs.query({windowId: lastWindowId}, function(tabs) {
      response({tabs: tabs});
    });
    return true;
  });
});
