window.onload = function() {
    // Add fade-out class to initiate opacity transition
    document.querySelector('.loader-container').classList.add('fade-out');
    
    // Wait for the fade-out transition to complete (0.5s) before hiding the loader
    setTimeout(function() {
        document.querySelector('.loader-container').classList.add('hidden');
        
        // Remove blur effect from .page-content by adding .page-loaded class to body
        document.body.classList.add('page-loaded');
    }, 500); // 500 milliseconds for fade-out transition
};
