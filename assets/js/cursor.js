const { useState, useEffect, useRef } = window.React;
const { gsap } = window;

const CustomCursor = () => {
const [isMoving, setIsMoving] = useState(false);
const [isMouseDown, setIsMouseDown] = useState(false);
const cursorRef = useRef(null);
const trailRefs = useRef([]);
const trailLength = 10; /*!!ADJUST SIZE HERE!!*/
const mousePosition = useRef({ x: -100, y: -100 });
const movementTimeout = useRef(null);
const animationFrameId = useRef(null);

// Initialize trail segments
useEffect(() => {
const segments = Array(trailLength).
fill().
map(() => React.createRef());
trailRefs.current = segments;
return () => {
  trailRefs.current = [];
};
}, [trailLength]);

// Handle mouse movement
useEffect(() => {
const handleMouseMove = e => {
  const { clientX: x, clientY: y } = e;
  mousePosition.current = { x, y };

  gsap.to(cursorRef.current, {
    x,
    y,
    duration: 0.8,
    ease: "power2.out" });


  setIsMoving(true);
  if (movementTimeout.current) {
    clearTimeout(movementTimeout.current);
  }

  movementTimeout.current = setTimeout(() => {
    setIsMoving(false);
  }, 500);
};

window.addEventListener("mousemove", handleMouseMove);

return () => {
  window.removeEventListener("mousemove", handleMouseMove);
};
}, [setIsMoving]);

// Handle mouse down event
const handleMouseDown = () => {
setIsMouseDown(true);
gsap.to(cursorRef.current, {
  width: 50,
  height: 50,
  borderColor: "var(--green)",
  boxShadow: "0 0 25px rgba(255, 255, 255, 0.5)",
  duration: 0.2,
  ease: "power2.out" });

};

// Handle mouse up event
const handleMouseUp = () => {
setIsMouseDown(false);
gsap.to(cursorRef.current, {
  width: 25,
  height: 25,
  borderColor: "var(--white)",
  boxShadow: "none",
  duration: 0.2,
  ease: "power2.out" });

};

// Update trail segments
useEffect(() => {
const updateTrail = () => {
  trailRefs.current.forEach((ref, index) => {
    const segment = ref.current;
    const delay = (index + 1) * 0.05;

    gsap.to(segment, {
      x: mousePosition.current.x,
      y: mousePosition.current.y,
      duration: 0.3,
      delay,
      opacity: isMoving || isMouseDown ? 1 - index / trailLength : 0,
      ease: "power2.out",
      scale: 1 + index / trailLength,
      boxShadow:
      isMoving || isMouseDown ?
      `0 0 10px rgba(255, 255, 255, ${0.2 + index / trailLength})` :
      "none" });

  });
};

const animateTrail = () => {
  updateTrail();
  if (isMoving || isMouseDown) {
    animationFrameId.current = requestAnimationFrame(animateTrail);
  } else if (animationFrameId.current) {
    cancelAnimationFrame(animationFrameId.current);
  }
};

animateTrail();
return () => cancelAnimationFrame(animationFrameId.current);
}, [isMoving, isMouseDown]);

// Event listeners for mouse down and up
useEffect(() => {
window.addEventListener("mousedown", handleMouseDown);
window.addEventListener("mouseup", handleMouseUp);

return () => {
  window.removeEventListener("mousedown", handleMouseDown);
  window.removeEventListener("mouseup", handleMouseUp);
};
}, []);

return /*#__PURE__*/(
React.createElement(React.Fragment, null,
trailRefs.current.map((ref, index) => /*#__PURE__*/
React.createElement("div", { key: index, className: "trail-segment", ref: ref })), /*#__PURE__*/

React.createElement("div", { className: "custom-cursor", ref: cursorRef }, /*#__PURE__*/
React.createElement("div", { className: "cursor-dot" })), /*#__PURE__*/

React.createElement("div", { className: "display" }, /*#__PURE__*/
React.createElement("h1", null, "Animated Cursor with GSAP"), /*#__PURE__*/
React.createElement("p", null, "Move your mouse and experience the effects."))));



};

window.ReactDOM.createRoot(document.getElementById("root")).render( /*#__PURE__*/
React.createElement(CustomCursor, null));

