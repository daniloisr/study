Elm.Native.Popup = {};
Elm.Native.Popup.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.Popup = localRuntime.Native.Popup || {};
	if (localRuntime.Native.Popup.values)
	{
		return localRuntime.Native.Popup.values;
	}

	var Task = Elm.Native.Task.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);


  var getCurrentTabUrl = Task.asyncFunction(function(callback) {
    var queryInfo = {
      active: true,
      currentWindow: true
    };

    chrome.tabs.query(queryInfo, function(tabs) {
      var tab = tabs[0];
      var url = tab.url;
      return callback(Task.succeed([url]));
    });
  });

	return localRuntime.Native.Popup.values = {
		getCurrentTabUrl: getCurrentTabUrl
	};
};
