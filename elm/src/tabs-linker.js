(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var div = document.querySelector('#container');
    var elm = Elm.embed(Elm.Tabs, div, { tabs: [] });

    chrome.runtime.sendMessage({}, function(data) {
      elm.ports.tabs.send(data.tabs);
    });

    elm.ports.changeTab.subscribe(function() {
      chrome.runtime.sendMessage({command: 'switch-tab', tabId: 240});
    })
  });
})();
