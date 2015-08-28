(function() {
  var queryInfo = {
    active: true,
    currentWindow: true
  };

  document.addEventListener('DOMContentLoaded', function() {
    var div = document.querySelector('#container');
    var elm = Elm.embed(Elm.Popup, div, { tabs: [] });

    chrome.tabs.query(queryInfo, function(tabs) {
      var tab = tabs[0];
      var url = tab.url;
      elm.ports.tabs.send([url, 'foo']);
    });
  });
})();
