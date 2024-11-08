const imageElements = document.querySelectorAll('.configs-image');
let currentIndex = 0;
let isTransitioning = false;

function showNextImage() {
    if (isTransitioning) return;

    isTransitioning = true;
    const currentImage = imageElements[currentIndex];
    const nextIndex = (currentIndex + 1) % imageElements.length;
    const nextImage = imageElements[nextIndex];

    currentImage.classList.add('slide-out');
    currentImage.classList.remove('active');

    currentImage.addEventListener('animationend', () => {
        currentImage.style.display = 'none';
        currentImage.classList.remove('slide-out');

        nextImage.style.display = 'block';
        nextImage.classList.add('active');
        nextImage.classList.add('slide-in');

        nextImage.addEventListener('animationend', () => {
            nextImage.classList.remove('slide-in');
            isTransitioning = false;
        }, { once: true });
    }, { once: true });

    currentIndex = nextIndex;
}

imageElements[currentIndex].style.display = 'block';
imageElements[currentIndex].classList.add('active');

setInterval(showNextImage, 4000);
