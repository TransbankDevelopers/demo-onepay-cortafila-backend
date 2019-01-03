if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
    .then(function(reg) {
      console.log('[Companion]', 'Service worker registered!');
      reg.pushManager.getSubscription().then(function(sub) {
        if (sub === null) {
          // Update UI to ask user to register for Push
          console.log('Not subscribed to push service!');
          subscribeUser();
        } else {
          // We have a subscription, update the database
          console.log('Subscription object: ', sub);
        }
      });
    });
}

function subscribeUser() {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.ready.then(function(reg) {

      reg.pushManager.subscribe({
        userVisibleOnly: true
      }).then(function(sub) {
        console.log('Endpoint URL: ', sub.endpoint);
      }).catch(function(e) {
        if (Notification.permission === 'denied') {
          alert("La solicitud para notificaciones push fue rechazada. La aplicación no podrá funcionar.");
          console.warn('Permission for notifications was denied');
        } else {
          alert("No fue posible realizar la subscripción para notificaciones push.");
          console.error('Unable to subscribe to push', e);
        }
      });
    })
  }
}
