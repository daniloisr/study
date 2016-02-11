Elm.Native.JsonDecoder = {};
Elm.Native.JsonDecoder.make = function(localRuntime) {
	localRuntime.Native = localRuntime.Native || {};
	localRuntime.Native.JsonDecoder = localRuntime.Native.JsonDecoder || {};
	if (localRuntime.Native.JsonDecoder.values)
	{
		return localRuntime.Native.JsonDecoder.values;
	}

	var Task = Elm.Native.Task.make(localRuntime);
	var Utils = Elm.Native.Utils.make(localRuntime);

  var getArray = Task.asyncFunction(function(callback) {
    return callback(Task.succeed(['foo', 'bar']));
  });

	return localRuntime.Native.JsonDecoder.values = {
		getArray: getArray
	};
};
