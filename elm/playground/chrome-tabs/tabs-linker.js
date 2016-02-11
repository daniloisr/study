(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var div = document.querySelector('#container');

    chrome.runtime.sendMessage({}, function(data) {
      chrome.tabs.getCurrent(function(tab) {
        currentTab = tab;

        var tabs = data.tabs.filter(function(tab) {
          return tab.id !== currentTab.id
        });

        var elm = Elm.embed(Elm.Tabs, div, { getTabs: tabs });

        elm.ports.changeTab.subscribe(function(model) {
          var selected = model.tabs.filter(function(t) { return t.active })[0];
          chrome.runtime.sendMessage({command: 'switch-tab', tabId: selected.id});
        });
      });
    });
  });
})();
