;(function(w,d) {
	w.JSCBridge = new (function() {
		var _messageCount = 0,
			_listeners = {},
			_callbacks = {},

			recvMessage = function(event, payload) {
				if (event in _listeners) {
					var handler = _listeners[event];
					handler(payload.data, function(data) {
						if (payload.has_callback) {
							var pack = {
								'id': payload.id,
								'data': data
							};
							JSCBridge.triggerOS(event, 'callback', pack);
						}
					});
				} else {
					console.log('Missing event handler:', event);
				}
			},

			recvCallback = function(event, payload) {
				var msgId = payload.id, handler;
				if (msgId in _callbacks) {
					handler = _callbacks[msgId];
					handler(payload.data);
					delete _callbacks[msgId];
				} else {
					console.log('Missing event callback:', event);
				}
			},

			recv = function(event, type, payload) {
				if (type == 'message') {
					recvMessage(event, payload);
				} else if (type == 'callback') {
					recvCallback(event, payload);
				} else {
					console.log('Unknown trigger type received');
				}
			},

			triggerJS = function(event, type, data) {
				recv(event, type, data);
			},

			on = function(event, perform) {
				_listeners[event] = perform;
			},

			off = function(event) {
				delete _listeners[event];
			},

			send = function(event, data, callback) {
				if (JSCBridge.triggerOS instanceof Function) {
					if (data instanceof Function) {
						callback = data;
						data = undefined;
					}
					var msgId = event + _messageCount, pack;
					if (callback instanceof Function) {
						_callbacks[msgId] = callback;
					}
					pack = {
						'id': msgId,
						'data': data,
						'has_callback': (callback instanceof Function)
					};

					JSCBridge.triggerOS(event, 'message', pack);

					_messageCount++;
				} else {
					console.log('JSCBridge.triggerOS not attached!');
				}
			};

		this.on = on;
		this.off = off;
		this.send = send;
		this.triggerJS = triggerJS;
	})();
})(window,document);