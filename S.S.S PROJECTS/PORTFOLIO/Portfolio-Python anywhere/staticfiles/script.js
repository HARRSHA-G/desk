// ═══════════════════════════════════════════════════════════════
// GHV PORTFOLIO - Custom JavaScript
// ═══════════════════════════════════════════════════════════════

// 1. Initialize Lenis (Smooth Scroll)
const lenis = new Lenis({
    duration: 1.5,
    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
    direction: 'vertical',
    gestureDirection: 'vertical',
    smooth: true,
    mouseMultiplier: 1,
    smoothTouch: false,
    touchMultiplier: 2,
});

function raf(time) {
    lenis.raf(time);
    requestAnimationFrame(raf);
}

requestAnimationFrame(raf);

// 2. Initialize GSAP
gsap.registerPlugin(ScrollTrigger);

// 3. Loader Animation
window.onload = () => {
    const loaderTl = gsap.timeline();

    // Animate Logo
    loaderTl.to('.loader-logo', {
        opacity: 1,
        y: 0,
        duration: 0.5,
        ease: 'power2.out'
    })
        // Animate Tagline
        .to('.loader-tagline', {
            opacity: 1,
            y: 0,
            duration: 0.4,
            ease: 'power2.out'
        }, '-=0.2')
        // Scale effect
        .to('.loader-logo', {
            scale: 1.1,
            duration: 0.5,
            ease: 'power1.inOut',
            yoyo: true,
            repeat: 1
        })
        // Slide Curtain Up
        .to('.loader', {
            yPercent: -100,
            duration: 0.8,
            ease: 'power4.inOut',
            delay: 0.2
        })
        // Start Content Animations
        .from('.hero h1', {
            y: 100,
            opacity: 0,
            duration: 1.2,
            ease: 'power4.out'
        }, '-=0.5');
};

// 4. Custom Cursor Logic (Only on Desktop)
if (window.matchMedia("(min-width: 769px)").matches) {
    const cursorDot = document.querySelector('.cursor-dot');
    const cursorRing = document.querySelector('.cursor-ring');

    gsap.set([cursorDot, cursorRing], { opacity: 0 });

    window.addEventListener('mousemove', (e) => {
        gsap.to([cursorDot, cursorRing], { opacity: 1, duration: 0.3 });
        const posX = e.clientX;
        const posY = e.clientY;
        gsap.set(cursorDot, { x: posX - 3, y: posY - 3 });
        gsap.to(cursorRing, {
            x: posX - 20,
            y: posY - 20,
            duration: 0.25,
            ease: "power2.out"
        });
    });

    // Hover effects
    const interactive = document.querySelectorAll('a, button, .glass-card, input, textarea');
    interactive.forEach(el => {
        el.addEventListener('mouseenter', () => document.body.classList.add('hovering'));
        el.addEventListener('mouseleave', () => document.body.classList.remove('hovering'));
    });
}

// 5. Improved Scroll Animations (Batching)
ScrollTrigger.batch(".glass-card, .timeline-item", {
    onEnter: batch => gsap.to(batch, {
        opacity: 1,
        y: 0,
        stagger: { each: 0.15, grid: [1, 3] },
        overwrite: true,
        duration: 1,
        ease: "power3.out"
    }),
    start: "top 90%",
});

gsap.utils.toArray('.section-title').forEach(title => {
    gsap.to(title, {
        scrollTrigger: {
            trigger: title,
            start: 'top 85%',
        },
        y: 0,
        opacity: 1,
        duration: 1,
        ease: 'power3.out'
    });
});

// Staggered Skills Animation
ScrollTrigger.batch(".skill-card", {
    onEnter: batch => gsap.to(batch, {
        opacity: 1,
        y: 0,
        stagger: { each: 0.1, grid: [1, 4] },
        overwrite: true,
        duration: 0.8,
        ease: "back.out(1.7)"
    }),
    start: "top 85%",
});

// 6. Form Submission (With Custom Popup)
const form = document.querySelector('form');
const popup = document.getElementById('success-popup');

if (form) {
    form.addEventListener('submit', function (e) {
        e.preventDefault();
        const formData = new FormData(form);
        const btn = form.querySelector('button');
        const originalText = btn.innerHTML;

        // Loading State
        btn.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i> Sending...';
        btn.style.opacity = '0.7';

        fetch('https://api.web3forms.com/submit', {
            method: 'POST',
            body: formData
        })
            .then(async (response) => {
                let json = await response.json();
                if (response.status == 200) {
                    // Success State
                    btn.innerHTML = originalText;
                    btn.style.opacity = '1';
                    form.reset();

                    // Show Custom Popup
                    popup.classList.add('active');

                    // Hide after 3 seconds
                    setTimeout(() => {
                        popup.classList.remove('active');
                    }, 3000);

                } else {
                    console.log(response);
                    alert(json.message || "Something went wrong!");
                    btn.innerHTML = originalText;
                }
            })
            .catch(error => {
                console.log(error);
                alert("Something went wrong!");
                btn.innerHTML = originalText;
            });
    });
}

// 7. Skills "See More" Logic (Responsive)
function initSkillsToggle() {
    const grid = document.getElementById('technical-arsenal');
    if (!grid) return;

    const cards = Array.from(grid.children);
    const toggleContainer = document.getElementById('skills-toggle-btn');
    const toggleBtn = document.getElementById('toggle-skills');

    let isExpanded = false;

    function updateVisibility() {
        let limit = cards.length;

        if (window.innerWidth < 768) {
            limit = 6;
        } else if (window.innerWidth < 1024) {
            limit = 12;
        }

        if (cards.length > limit) {
            toggleContainer.classList.remove('hidden');

            cards.forEach((card, index) => {
                if (index >= limit) {
                    if (isExpanded) {
                        card.style.display = 'flex';
                        card.classList.add('skill-card');
                        gsap.fromTo(card,
                            { opacity: 0, y: 30 },
                            { opacity: 1, y: 0, duration: 0.4, delay: (index - limit) * 0.05 }
                        );
                    } else {
                        card.style.display = 'none';
                    }
                } else {
                    card.style.display = 'flex';
                    card.classList.add('skill-card');
                }
            });
        } else {
            toggleContainer.classList.add('hidden');
            cards.forEach(card => {
                card.style.display = 'flex';
                card.classList.add('skill-card');
            });
        }
    }

    if (toggleBtn) {
        toggleBtn.addEventListener('click', () => {
            isExpanded = !isExpanded;
            updateVisibility();

            if (isExpanded) {
                toggleBtn.innerHTML = 'See Less <i class="fas fa-chevron-up ml-2"></i>';
                ScrollTrigger.refresh();
            } else {
                toggleBtn.innerHTML = 'See More <i class="fas fa-chevron-down ml-2"></i>';
                ScrollTrigger.refresh();
                toggleContainer.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });
    }

    updateVisibility();
    window.addEventListener('resize', () => {
        isExpanded = false;
        if (toggleBtn) toggleBtn.innerHTML = 'See More <i class="fas fa-chevron-down ml-2"></i>';
        updateVisibility();
    });
}

document.addEventListener('DOMContentLoaded', initSkillsToggle);

// 8. Mobile Menu Logic (With hamburger animation)
const hamburger = document.querySelector('.hamburger');
const offCanvas = document.querySelector('.off-canvas-menu');
const overlay = document.querySelector('.overlay-menu');
const mobileLinks = document.querySelectorAll('.mobile-nav-link');

if (hamburger) {
    hamburger.addEventListener('click', () => {
        hamburger.classList.toggle('active');
        offCanvas.classList.toggle('active');
        overlay.classList.toggle('active');
    });
}

const closeMenu = () => {
    if (hamburger) hamburger.classList.remove('active');
    if (offCanvas) offCanvas.classList.remove('active');
    if (overlay) overlay.classList.remove('active');
};

if (overlay) overlay.addEventListener('click', closeMenu);
mobileLinks.forEach(link => link.addEventListener('click', closeMenu));

// 9. Back to Top Button Logic
const backToTop = document.getElementById('back-to-top');

if (backToTop) {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 200) {
            backToTop.classList.add('visible');
        } else {
            backToTop.classList.remove('visible');
        }
    });

    backToTop.addEventListener('click', () => {
        lenis.scrollTo(0, { duration: 1.5 });
    });
}

// 10. Navbar Scroll Effect
const navbar = document.getElementById('navbar');
if (navbar) {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
}

// 11. Projects Toggle Logic
function initProjectsToggle() {
    const projectGrid = document.getElementById('project-grid');
    const projectToggleBtn = document.getElementById('project-toggle-btn');
    const projectToggleContainer = document.getElementById('project-toggle-container');

    if (!projectGrid || !projectToggleBtn) return;

    const cards = projectGrid.querySelectorAll('.glass-card');
    let isExpanded = false;

    function updateVisibility() {
        let limit = cards.length;

        if (window.innerWidth < 768) {
            limit = 3;
        } else if (window.innerWidth < 1024) {
            limit = 4;
        }

        if (cards.length > limit) {
            projectToggleContainer.classList.remove('hidden');

            cards.forEach((card, index) => {
                if (index >= limit) {
                    if (isExpanded) {
                        card.style.display = 'block';
                        gsap.fromTo(card,
                            { opacity: 0, y: 30 },
                            { opacity: 1, y: 0, duration: 0.4, delay: (index - limit) * 0.1 }
                        );
                    } else {
                        card.style.display = 'none';
                    }
                } else {
                    card.style.display = 'block';
                }
            });
        } else {
            projectToggleContainer.classList.add('hidden');
            cards.forEach(card => {
                card.style.display = 'block';
            });
        }
    }

    projectToggleBtn.addEventListener('click', () => {
        isExpanded = !isExpanded;
        updateVisibility();

        if (isExpanded) {
            projectToggleBtn.innerHTML = 'See Less <i class="fas fa-chevron-up ml-2"></i>';
            ScrollTrigger.refresh();
        } else {
            projectToggleBtn.innerHTML = 'See More <i class="fas fa-chevron-down ml-2"></i>';
            ScrollTrigger.refresh();
            projectGrid.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });

    updateVisibility();
    window.addEventListener('resize', () => {
        isExpanded = false;
        projectToggleBtn.innerHTML = 'See More <i class="fas fa-chevron-down ml-2"></i>';
        updateVisibility();
    });
}

document.addEventListener('DOMContentLoaded', initProjectsToggle);

// ═══════════════════════════════════════════════════════════════
// 12. CODE PROTECTION SYSTEM (Anti-Copy/Paste/Screenshot)
// ═══════════════════════════════════════════════════════════════

// Disable Right Click
document.addEventListener('contextmenu', (e) => {
    e.preventDefault();
    return false;
});

// Disable Keyboard Shortcuts


// Disable Copy/Cut/Paste
document.addEventListener('copy', (e) => {
    e.preventDefault();
});

// Restore Strict Content Hiding (The "Blackout" Method)
const protectContent = () => {
    document.documentElement.style.visibility = 'hidden';
    document.title = 'Protected Content';
};

const showContent = () => {
    // Only show if we actually have focus
    if (document.hasFocus()) {
        document.documentElement.style.visibility = 'visible';
        document.title = 'Harsha Vardhan Gadde | Full Stack Developer Portfolio';
    }
};

// 1. Event Loop Heartbeat (The Failsafe)
// Constantly checks if the window is focused. If not, HIDE EVERYTHING.
// This catches "side-by-side" apps that might not trigger a blur event instantly.
setInterval(() => {
    if (!document.hasFocus()) {
        protectContent();
    }
}, 50); // Checks 20 times per second

// 2. Hide immediately on generic triggers
window.addEventListener('blur', protectContent);
window.addEventListener('focus', showContent);
document.addEventListener('mouseleave', protectContent);
document.addEventListener('mouseenter', showContent);

// 3. Detect DevTools docking/undocking
window.addEventListener('resize', () => {
    // If resize mimics a snap layout or devtools, hide briefly to be safe
    if (!document.hasFocus()) {
        protectContent();
    }
});


// ═══════════════════════════════════════════════════════════════
// PARANOID MODE: Block OS Shortcuts (Win+Shift+S)
// ═══════════════════════════════════════════════════════════════

document.addEventListener('keydown', (e) => {
    // 1. Windows Key (Meta), Alt, or Control
    // Hiding content *immediately* on these keys is the only way to beat Win+Shift+S
    if (e.key === 'Meta' || e.key === 'Alt' || e.key === 'Control') {
        protectContent();
    }

    // 2. PrintScreen
    if (e.key === 'PrintScreen') {
        protectContent();
        e.preventDefault();
        alert('Screenshots disabled');
        // Restore after a delay
        setTimeout(showContent, 1000);
    }

    // 3. Command/Ctrl Shortcuts
    const isCmd = e.ctrlKey || e.metaKey;

    // Block F12, DevTools shortcuts, and Save/Print shortcuts
    if (e.key === 'F12' ||
        (isCmd && e.shiftKey && ['I', 'i', 'J', 'j', 'C', 'c', '3', '4', '5'].includes(e.key)) ||
        (isCmd && ['u', 'U', 's', 'S', 'p', 'P', 'a', 'A', 'c', 'C', 'v', 'V', 'x', 'X'].includes(e.key))) {
        e.preventDefault();
        protectContent();
        return false;
    }
});

// Restore content when keys are released
document.addEventListener('keyup', (e) => {
    if (e.key === 'Meta' || e.key === 'Alt' || e.key === 'Control') {
        // Slight delay to ensure Screenshot tool isn't active
        setTimeout(showContent, 500);
    }
});



// Disable Dragging (Backup to CSS)
window.ondragstart = function () { return false; };




// ═══════════════════════════════════════════════════════════════
// 13. CONSOLE BAN (The "Red Warning")
// ═══════════════════════════════════════════════════════════════
// If they effectively hack open the console, give them a warning.
// AND lag their browser slightly to discourage inspection.

const consoleWarning = () => {
    const term = [
        "%c⛔ STOP!",
        "%cThis is a protected area.",
        "%cAccess to the source code is restricted. Your IP address and actions may be monitored.",
    ];

    const styles = [
        "color: red; font-size: 60px; font-weight: bold; text-shadow: 2px 2px 0px black;",
        "color: white; font-size: 20px; font-weight: bold; background: red; padding: 5px 10px; border-radius: 5px;",
        "color: #aaa; font-size: 14px; margin-top: 10px;"
    ];

    console.clear();
    console.log(term[0], styles[0]);
    console.log(term[1], styles[1]);
    console.log(term[2], styles[2]);

    // Debugger Trap: Pauses execution if DevTools is open
    // This makes inspecting the code extremely annoying
    setInterval(() => {
        // This 'debugger' statement only works if DevTools is open.
        // It will constantly pause the script, making inspection impossible.
        debugger;
    }, 1000);
};

// Run immediately
consoleWarning();

// Detect DevTools by Window Resize (Common method)
window.addEventListener('resize', () => {
    // If the window inner size changes drastically without outer size changing, it's likely DevTools docking
    const widthDiff = window.outerWidth - window.innerWidth;
    const heightDiff = window.outerHeight - window.innerHeight;

    if (widthDiff > 160 || heightDiff > 160) {
        protectContent(); // Hide site
        // alert("Developer Tools Detected. Content Hidden."); // Optional: Alert user
    }
});


