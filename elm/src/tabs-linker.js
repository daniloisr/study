(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var div = document.querySelector('#container');
    var elm = Elm.embed(Elm.Tabs, div, { tabs: [] });

    chrome.runtime.sendMessage({}, function(data) {
      console.log(data);
      elm.ports.tabs.send(data.tabs);
    });
  });
})();
