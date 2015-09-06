(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var div = document.querySelector('#container');
    var elm = Elm.embed(Elm.Tabs, div, { tabs: [] });

    chrome.runtime.sendMessage({}, function(data) {
      chrome.tabs.getCurrent(function(tab) {
        currentTab = tab;

        var tabs = data.tabs.filter(function(tab) {
          return tab.id !== currentTab.id
        });

        elm.ports.tabs.send(tabs);
      });
    });

    elm.ports.changeTab.subscribe(function(id) {
      chrome.runtime.sendMessage({command: 'switch-tab', tabId: id});
    })
  });
})();
