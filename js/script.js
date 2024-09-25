
function toggleSubscription(event, element) {
    event.preventDefault(); // Prevent the default link behavior

    const icon = element.querySelector('i');
    const isSubscribed = element.classList.contains('subscribed');

    if (isSubscribed) {
        // Change to "Subscribe"
        element.innerHTML = '<i class="fas fa-cloud"></i> Subscribe';
        element.classList.remove('subscribed');
    } else {
        // Change to "Unsubscribe"
        element.innerHTML = '<i class="fas fa-times"></i> Unsubscribe';
        element.classList.add('subscribed');
    }
}
