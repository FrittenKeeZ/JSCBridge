;(function(b,w,d) {
	$(function() {
		var $log = $('.js-log'),
			log = function(text) {
				// UI Thread needs time to update sometimes, so add delay.
				setTimeout(function() {
					$log.text(text);
				}, 10);
			};

		b.on('attached', function() {
			log('JSCBridge attached!');
		});

		// Receive tests

		b.on('send1', function() {
			log('Send event received');
		});

		b.on('send2', function(data) {
			log('iOS Version: ' + data.version);
		});

		b.on('send3', function(data, callback) {
			var arr = data.text.split('');
			arr.sort(function() {
				return .5 - Math.random();
			});
			callback({text: arr.join('')});
		});

		b.on('send4', function(data, callback) {
			callback({ua: navigator.userAgent});
		});

		// Send tests
		var send1 = function() {
				b.send('send1');
			},

			send2 = function() {
				var data = {
					version: $().jquery
				};
				b.send('send2', data);
			},

			send3 = function() {
				var data = {
					text: $('.js-input').val()
				};
				b.send('send3', data, function(data) {
					log('Uppercase: ' + data.text);
				});
			},

			send4 = function() {
				b.send('send4', function(data) {
					log('Model: ' + data.model);
				});
			};
		
		$('.js-send').on('touchend', function() {
			var event = $(this).data('event');
			switch (event) {
				case 1:
					send1();
					break;

				case 2:
					send2();
					break;

				case 3:
					send3();
					break;

				case 4:
					send4();
					break;
			}
		});
	});
})(JSCBridge,window,document);