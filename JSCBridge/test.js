$(function() {
	JSCBridge.on('attached', function() {
		$('.js-log').text('JSCBridge attached!');
	});
});