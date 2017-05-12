chrome.commands.onCommand.addListener(function(command) {
  if (command != 'show-tabs-list') return;

  chrome.windows.create({
    width: 400,
    height: 200,
    left: 200,
    top: 200,
    url: chrome.runtime.getURL('tabs.html'),
    focused: true,
    type: 'popup'
  });

  chrome.runtime.onMessage.addListener(function(msg, _, response) {
    switch(msg.command) {
      case 'switch-tab':
        chrome.tabs.update(msg.tabId, { active: true });
        break;
      default:
        chrome.tabs.query({}, function(tabs) {
          response({ tabs: tabs });
        });
    }

    return true;
  });
});
