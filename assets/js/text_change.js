
const textOptions = ["CONFIGS?", "SCRIPTS?", "VISUALS"];
const textOptions2 = ["CSGO", "CS2"];

const scriptHighlightElement = document.getElementById('dynamic-highlight');
const gameHighlightElement = document.getElementById('dynamic-game-highlight');

let scriptIndex = 0;
let gameIndex = 0;

function changeScriptText() {
    scriptHighlightElement.classList.add('highlight-exit-active');

    setTimeout(() => {
        scriptHighlightElement.textContent = textOptions[scriptIndex];

        scriptIndex = (scriptIndex + 1) % textOptions.length;

        scriptHighlightElement.classList.remove('highlight-exit-active');
        
        scriptHighlightElement.classList.add('highlight-enter');
        
        void scriptHighlightElement.offsetWidth;

        scriptHighlightElement.classList.add('highlight-enter-active');

    }, 500); 

    setTimeout(() => {
        scriptHighlightElement.classList.remove('highlight-enter-active');
        scriptHighlightElement.classList.remove('highlight-enter'); 
    }, 500); 
}

function changeGameText() {
    gameHighlightElement.classList.add('highlight-exit-active');

    setTimeout(() => {
        gameHighlightElement.textContent = textOptions2[gameIndex];

        gameIndex = (gameIndex + 1) % textOptions2.length;

        gameHighlightElement.classList.remove('highlight-exit-active');
        
        gameHighlightElement.classList.add('highlight-enter');

        void gameHighlightElement.offsetWidth;

        gameHighlightElement.classList.add('highlight-enter-active');

    }, 500); 

    setTimeout(() => {
        gameHighlightElement.classList.remove('highlight-enter-active');
        gameHighlightElement.classList.remove('highlight-enter'); 
    }, 500); 
}

setInterval(() => {
    changeScriptText();
    changeGameText();
}, 3000);
