/* Buttons, Headings, Backgrounds for Export.gov */ 


/* image */
img {
	max-width: 90%;
	height: auto;
}

.logo img {
    padding-top: 0px;
    margin-top: -8px;
}

@media (max-width:1200px) {
img#logo{
	margin-top:-2px;
}
}

@media (max-width:767px) {
img#logo{
	margin-top:6px;
}
}
@media (max-width:480px) {
img#logo{
	margin-top:6px;
}
}



@media (min-width:767px) {
.logo img {
width: 250px;
}
}


@media (max-width: 1200px) {
.headtop {
margin-top:-36px;
margin-right:30px;
}
}
@media (max-width: 992px) {
.headtop {
margin-top:-36px;
margin-right:30px;
}
.logo img, .header-small .logo img {
margin-top:0;
}
}

@media (max-width: 767px) {
.headtop {
margin-top:-36px;
margin-right:30px;
}
}
@media (max-width: 480px) {
.headtop {
margin-top:-36px;
margin-right:30px;
}
.navbar-brand img {
width:150px;
}
.header .header-top-dropdown .dropdown>button {
font-size:12px;
}

}

@media (max-width: 380px) {
.headtop {
margin-top:-36px;
margin-right:30px;
}
.navbar-brand img {
width:120px;
}
.header .header-top-dropdown .dropdown>button {
font-size:10px;
}

}



/* default, primary, secondary backgrounds, buttons and titles
----------------------------------*/

/* Start backgrounds */


.primary-bg-ita {
    color:#fff;
    background-color:#1e3357; /* Dark Blue */
}

/* End backgrounds */



/* Start Custom Global.css settings */

.fixed-header-on .header .logo {

	margin: -10px 0 -4px 0;
}

@media (max-width:991px) {
	.logo img,
	.header-small .logo img {
		margin: 0 auto;
		margin-top: 10px;
    	margin-left: 0;
		width: 150px;
		display: block;
	}
}

/* End Custom Global.css settings */




.site-slogan {
	color: #cd3c2e;
    font-size: 14px;
   /* text-indent: 18px; */
   margin-top: 30px;
   position: absolute;
   float: left;

}

/* 6 Navigations
----------------------------------------------------------------------------- */
/* first level menu items */
.navbar-default .navbar-nav > li > a {
	color: #003366;
}
/* first level active menu items on hover/focus */
.navbar-default .navbar-nav > .active > a,
.navbar-default .navbar-nav > .active > a:focus {
	color: #3c4542;
	background-color: transparent;
}

/* second level menu items on focus/hover and when opened */
.dropdown-menu > li > a:hover,
.dropdown-menu > li > a:focus,
.nav .open > a,
.nav .open > a:hover,
.nav .open > a:focus,
.dropdown-menu > .active > a,
.dropdown-menu > .active > a:hover,
.dropdown-menu > .active > a:focus,
.dropdown-menu .menu > .active > a,
.dropdown-menu .menu > .active > a:hover,
.dropdown-menu .menu > .active > a:focus {
	background-color: #ffffff;
	color: #3c4542;
	border-color: #f1f1f1;
}
/* mega menu menu items on focus/hover and when opened */
.mega-menu .menu > li > a:hover,
.mega-menu .menu > li > a:focus {
	background-color: #ffffff;
	color: #3c4542;
	border-color: #f1f1f1;
	text-decoration: none;
}

/* arrows for parent menu items */
.navbar-default .navbar-nav > .active.dropdown > a:before {
	color: #3c4542;
}
.dropdown .dropdown.open>a:before,
.transparent.header:not(.dark) .dropdown .dropdown.open>a:before {
	color: #3c4542;
}

/* mobile menu toggle button on hover/focus */
.navbar-default .navbar-toggle:hover,
.navbar-default .navbar-toggle:focus {
	background-color: #fff;
	border-color: #fff;
}
.navbar-default .navbar-toggle .icon-bar {
	background-color: #003366;
}
.navbar-default .navbar-toggle:hover .icon-bar,
.navbar-default .navbar-toggle:focus .icon-bar {
	background-color: #004d99;
}
/* Small devices (tablets, phones less than 767px) */
@media (max-width:1200px) {
	/* Mobile menu
	------------------------------ */
	/* active items */
	.navbar-default .navbar-nav .open .dropdown-menu > .active > a,
	.navbar-default .navbar-nav .open .dropdown-menu > .active > a:hover,
	.navbar-default .navbar-nav .open .dropdown-menu > .active > a:focus {
		color: #3c4542;
		background-color: transparent;
	}
	/* first level items */
		.navbar-default .navbar-nav > li > a {

		border-bottom: 1px solid #f1f1f1;
	}
		/* first level items hover and focus states */
	.navbar-default .navbar-nav > li > a:hover,
	.navbar-default .navbar-nav > li > a:focus,
	.navbar-default .navbar-nav > .active > a:hover,
	.navbar-default .navbar-nav > .active > a:focus {
		color: #3c4542;
		background-color: #fff;
	}
		/* second level items on hover/focus */
	.navbar-default .navbar-nav .open .dropdown-menu > li > a:hover,
	.navbar-default .navbar-nav .open .dropdown-menu > li > a:focus {
		color: #3c4542;
	}
}

@media (max-width:1200px) {
.navbar-default .navbar-nav > .open > a, .navbar-default .navbar-nav > .open > a:hover, .navbar-default .navbar-nav > .open > a:focus {
background:#fff;
}
}

/* Offcanvas navigation
---------------------------------- */

#offcanvas .nav .open > a,
#offcanvas .nav .open > a:hover,
#offcanvas .nav .open > a:focus,
#offcanvas .nav > li > a:hover,
#offcanvas .nav > li > a:focus,
#offcanvas .navbar-nav > li.active > a {
	color: #3c4542;
	background-color: #ffffff;
}

/* Subfooter navigation
---------------------------------- */

.subfooter .navbar-default .nav > li > a {
	padding: 10px 10px;
	text-transform: none;
	line-height: 1;
	font-size: 14px;
	font-weight: 400;
}
.subfooter .navbar-default .nav > li > a:hover,
.subfooter .navbar-default .nav > .active > a:hover,
.subfooter .navbar-default .nav > .active > a:focus {
	background-color: transparent;
	text-decoration: underline;
	color: #3c4542;
}