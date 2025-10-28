/* Small javascript for displaying page load time */

window.addEventListener('load', () => {
    const loadTime = performance.now();
    document.querySelector('.ping').innerHTML = `[${loadTime.toFixed(0)}ms]`;
});
