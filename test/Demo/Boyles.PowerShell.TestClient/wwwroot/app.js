// Close the main menu once a menu item is chosen.
//
// The navbar dropdowns use data-bs-auto-close="outside" so the hover flyout submenus stay usable, which means Bootstrap
// never closes a dropdown on a click inside it. Blazor's enhanced navigation also swaps the page without a reload, so
// nothing else resets the menu. This delegated handler closes every open dropdown (and the collapsed mobile navbar)
// whenever a real menu link - anything but a submenu toggle - is clicked.
document.addEventListener('click', function (event) {
    var link = event.target.closest('#navbar-menu .dropdown-menu a.dropdown-item:not(.dropdown-toggle)');
    if (!link) {
        return;
    }

    var bs = window.bootstrap;

    document.querySelectorAll('#navbar-menu [data-bs-toggle="dropdown"].show').forEach(function (toggle) {
        var dropdown = bs && bs.Dropdown ? bs.Dropdown.getInstance(toggle) : null;
        if (dropdown) {
            dropdown.hide();
            return;
        }

        toggle.classList.remove('show');
        toggle.setAttribute('aria-expanded', 'false');
        var menu = toggle.parentElement.querySelector(':scope > .dropdown-menu');
        if (menu) {
            menu.classList.remove('show');
        }
    });

    var navbar = document.getElementById('navbar-menu');
    if (navbar && navbar.classList.contains('show')) {
        var collapse = bs && bs.Collapse ? bs.Collapse.getInstance(navbar) : null;
        if (collapse) {
            collapse.hide();
        } else {
            navbar.classList.remove('show');
        }
    }
});
