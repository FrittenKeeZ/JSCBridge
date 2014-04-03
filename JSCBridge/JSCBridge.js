;(function(w,d) {
	w.JSCBridge = new (function() {
		var messageCount = 0,
			listeners = {},
			callbacks = {};

		var triggerJS = function(event, type, msgId, data) {
			console.log('Event: ' + event + ' - Type: ' + type + ' - ID: ' + msgId, data);
		};

		var on = function(event, perform, callback) {
			listeners[event] = perform;
			if (typeof callback == 'function') {
				callbacks[event] = callback;
			}
		};

		var off = function(event) {
			delete listeners[event];
			delete callbacks[event];
		};

		var send = function(event, data, callback) {
			if (typeof data == 'function') {
				callback = data;
				data = {};
			}
		};

		this.on = on;
		this.off = off;
		this.send = send;
		this.triggerJS = triggerJS;
	})();
})(window,document);