<!DOCTYPE html>
<html lang="en">
	@php 
		//Page active
		Session::put('page', $title);
	@endphp
	<!--begin::Head-->
	<head>
		<base href=""/>
		<title>{{ config('app.name') }}</title>
		<meta charset="utf-8" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<meta name="csrf-token" content="{{ csrf_token() }}">
		<link href="/assets/img/favicon.png" rel="icon" type="image/x-icon">
		<!--begin::Fonts(mandatory for all pages)-->
		<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700" />
		<!--end::Fonts-->
		<!--begin::Global Stylesheets Bundle(mandatory for all pages)-->
		<link href="/assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
		<!--end::Global Stylesheets Bundle-->
		<!--begin::Page Vendor Stylesheets(used by this page)-->
		<link href="/assets/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet" type="text/css" />
		<link href="/assets/plugins/custom/datatables/datatables.bundle.css" rel="stylesheet" type="text/css" />
		<!--end::Page Vendor Stylesheets-->
		<link href="/assets/css/skins/all.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/custom.css?v2024.07.16" rel="stylesheet" type="text/css" />
    	@yield('styles')
	</head>
	<!--end::Head-->
	<!--begin::Body-->
	<body id="kt_app_body" data-kt-app-layout="dark-sidebar" data-kt-app-header-fixed="true" data-kt-app-sidebar-enabled="true" data-kt-app-sidebar-fixed="true" data-kt-app-sidebar-hoverable="true" data-kt-app-sidebar-push-header="true" data-kt-app-sidebar-push-toolbar="true" data-kt-app-sidebar-push-footer="true" data-kt-app-toolbar-enabled="true" class="app-default" data-kt-app-page-loading-enabled="true" data-kt-app-page-loading="on">
		<!--begin::Page loading(append to body)-->
		<div class="page-loader">
			<span class="spinner-border text-primary" role="status">
				<span class="visually-hidden">Loading...</span>
			</span>
		</div>
		<!--end::Page loading-->
		<!--begin::Theme mode setup on page load-->
		<script>var defaultThemeMode = "light"; var themeMode; if ( document.documentElement ) { if ( document.documentElement.hasAttribute("data-bs-theme-mode")) { themeMode = document.documentElement.getAttribute("data-bs-theme-mode"); } else { if ( localStorage.getItem("data-bs-theme") !== null ) { themeMode = localStorage.getItem("data-bs-theme"); } else { themeMode = defaultThemeMode; } } if (themeMode === "system") { themeMode = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"; } document.documentElement.setAttribute("data-bs-theme", themeMode); }</script>
		<!--end::Theme mode setup on page load-->
		<!--begin::App-->
		<div class="d-flex flex-column flex-root app-root" id="kt_app_root">
			<!--begin::Page-->
			<div class="app-page flex-column flex-column-fluid" id="kt_app_page">
				<!--begin::Header-->
				<div id="kt_app_header" class="app-header">
					<!--begin::Header container-->
					<div class="app-container container-fluid d-flex align-items-stretch justify-content-between" id="kt_app_header_container">
						<!--begin::Sidebar mobile toggle-->
						<div class="d-flex align-items-center d-lg-none ms-n3 me-1 me-md-2" title="Show sidebar menu">
							<div class="btn btn-icon btn-active-color-primary w-35px h-35px" id="kt_app_sidebar_mobile_toggle">
								<i class="ki-duotone ki-abstract-14 fs-2 fs-md-1">
									<span class="path1"></span>
									<span class="path2"></span>
								</i>
							</div>
						</div>
						<!--end::Sidebar mobile toggle-->
						<!--begin::Mobile logo-->
						<div class="d-flex align-items-center flex-grow-1 flex-lg-grow-0">
							<a href="/{{ Session::get('page') }}" class="d-lg-none">
								<img alt="Logo" src="/assets/img/logo-manci.jpg" class="h-30px" />
							</a>
						</div>
						<!--end::Mobile logo-->
						<!--begin::Header wrapper-->
						<div class="d-flex align-items-stretch justify-content-between flex-lg-grow-1" id="kt_app_header_wrapper">
							<!--begin::Menu wrapper-->
							<div class="app-header-menu app-header-mobile-drawer align-items-stretch" data-kt-drawer="true" data-kt-drawer-name="app-header-menu" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="250px" data-kt-drawer-direction="end" data-kt-drawer-toggle="#kt_app_header_menu_toggle" data-kt-swapper="true" data-kt-swapper-mode="{default: 'append', lg: 'prepend'}" data-kt-swapper-parent="{default: '#kt_app_body', lg: '#kt_app_header_wrapper'}">
								<!--begin::Menu-->
								<div class="menu menu-rounded menu-column menu-lg-row my-5 my-lg-0 align-items-stretch fw-semibold px-2 px-lg-0" id="kt_app_header_menu" data-kt-menu="true">
									<!--begin:Menu item-->
									<div data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-placement="bottom-start" class="menu-item here show menu-here-bg menu-lg-down-accordion me-0 me-lg-2">
										<!--begin:Menu link-->
										<span class="menu-link">
											<span class="menu-title">Maintenances Navires Côte d’Ivoire</span>
										</span>
										<!--end:Menu link-->
									</div>
									<!--end:Menu item-->
								</div>
								<!--end::Menu-->
							</div>
							<!--end::Menu wrapper-->
							<!--begin::Navbar-->
							<div class="app-navbar flex-shrink-0">
							<!--begin::Theme mode-->
								<!--begin::User menu-->
								<div class="app-navbar-item ms-1 ms-md-3" id="kt_header_user_menu_toggle">
									<!--begin::Menu wrapper-->
									<div class="cursor-pointer symbol symbol-30px symbol-md-40px" data-kt-menu-trigger="{default: 'click', lg: 'hover'}" data-kt-menu-attach="parent" data-kt-menu-placement="bottom-end">
										<img src="/assets/media/avatars/{{ Session::get('avatar') }}" alt="{{ Session::get('username') }}" />
									</div>
									<!--begin::User account menu-->
									<div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-color fw-semibold py-4 fs-6 w-275px" data-kt-menu="true">
										<!--begin::Menu item-->
										<div class="menu-item px-3">
											<div class="menu-content d-flex align-items-center px-3">
												<!--begin::Avatar-->
												<div class="symbol symbol-50px me-5">
													<img src="/assets/media/avatars/{{ Session::get('avatar') }}" alt="{{ Session::get('username') }}" />
												</div>
												<!--end::Avatar-->
												<!--begin::Username-->
												<div class="d-flex flex-column">
													<div class="fw-bold d-flex align-items-center fs-5">{{ Session::get('username') }}</div>
													<a href="#" class="fw-semibold text-muted text-hover-primary fs-7">{{ Session::get('profil') }}</a>
													<a href="#" class="fw-semibold text-muted text-hover-primary fs-7">{{ Session::get('number') }}</a>
												</div>
												<!--end::Username-->
											</div>
										</div>
										<!--end::Menu item-->
										<!--begin::Menu separator-->
										<div class="separator my-2"></div>
										<!--end::Menu separator-->
										@if(isset(Session::get('rights')[1]))
										<!--begin::Menu item-->
										<div class="menu-item px-5">
											<a href="/account" class="menu-link px-5"><i class="fas fa-user-circle me-2"></i>Mon compte</a>
										</div>
										<!--end::Menu item-->
										@endif
										@if(isset(Session::get('rights')[2]))
										<!--begin::Menu item-->
										<div class="menu-item px-5">
											<a href="/password" class="menu-link px-5"><i class="fas fa-lock me-2"></i>Mot de passe</a>
										</div>
										<!--end::Menu item-->
										@endif
										<!--begin::Menu separator-->
										<div class="separator my-2"></div>
										<!--end::Menu separator-->
										<!--begin::Menu item-->
										<div class="menu-item px-5">
											<a href="/logout" class="menu-link link-danger px-5"><i class="fas fa-sign-out-alt link-danger me-2"></i>Se déconnecter</a>
										</div>
										<!--end::Menu item-->
									</div>
									<!--end::User account menu-->
									<!--end::Menu wrapper-->
								</div>
								<!--end::User menu-->
								<!--begin::Header menu toggle-->
								<div class="app-navbar-item d-lg-none ms-2 me-n2" title="Show header menu">
									<div class="btn btn-flex btn-icon btn-active-color-primary w-30px h-30px" id="kt_app_header_menu_toggle">
										<i class="ki-duotone ki-element-4 fs-1">
											<span class="path1"></span>
											<span class="path2"></span>
										</i>
									</div>
								</div>
								<!--end::Header menu toggle-->
							</div>
							<!--end::Navbar-->
						</div>
						<!--end::Header wrapper-->
					</div>
					<!--end::Header container-->
				</div>
				<!--end::Header-->
				<!--begin::Wrapper-->
				<div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
					<!--begin::Sidebar-->
					<div id="kt_app_sidebar" class="app-sidebar flex-column" data-kt-drawer="true" data-kt-drawer-name="app-sidebar" data-kt-drawer-activate="{default: true, lg: false}" data-kt-drawer-overlay="true" data-kt-drawer-width="225px" data-kt-drawer-direction="start" data-kt-drawer-toggle="#kt_app_sidebar_mobile_toggle">
						<!--begin::Logo-->
						<div class="app-sidebar-logo px-6" id="kt_app_sidebar_logo">
							<!--begin::Logo image-->
							<a href="/{{ Session::get('page') }}">
								<img alt="Logo" src="/assets/img/logo-manci.jpg" class="h-50px app-sidebar-logo-default" />
								<img alt="Logo" src="/assets/img/logo-manci.jpg" class="h-20px app-sidebar-logo-minimize" />
							</a>
							<!--end::Logo image-->
							<!--begin::Sidebar toggle-->
							<div id="kt_app_sidebar_toggle" class="app-sidebar-toggle btn btn-icon btn-shadow btn-sm btn-color-muted btn-active-color-primary body-bg h-30px w-30px position-absolute top-50 start-100 translate-middle rotate" data-kt-toggle="true" data-kt-toggle-state="active" data-kt-toggle-target="body" data-kt-toggle-name="app-sidebar-minimize">
								<i class="ki-duotone ki-double-left fs-2 rotate-180">
									<span class="path1"></span>
									<span class="path2"></span>
								</i>
							</div>
							<!--end::Sidebar toggle-->
						</div>
						<!--end::Logo-->
						<!--begin::sidebar menu-->
						<div class="app-sidebar-menu overflow-hidden flex-column-fluid">
							<!--begin::Menu wrapper-->
							<div id="kt_app_sidebar_menu_wrapper" class="app-sidebar-wrapper hover-scroll-overlay-y my-5" data-kt-scroll="true" data-kt-scroll-activate="true" data-kt-scroll-height="auto" data-kt-scroll-dependencies="#kt_app_sidebar_logo, #kt_app_sidebar_footer" data-kt-scroll-wrappers="#kt_app_sidebar_menu" data-kt-scroll-offset="5px" data-kt-scroll-save-state="true">
								<!--begin::User-->
								<div class="d-flex align-items-center flex-grow-1">
									<!--begin::Avatar-->
									<div class="symbol symbol-45px me-5">
										<img src="/assets/media/avatars/{{ Session::get('avatar') }}" alt="{{ Session::get('username') }}">
									</div>
									<!--end::Avatar-->
									<!--begin::Info-->
									<div class="d-flex flex-column">
										<div class="text-white fw-bolder d-flex align-items-center fs-7">{{ Session::get('username') }}</div>
										<a href="#" class="fw-bold text-muted text-hover-primary fs-7">{{ Session::get('number') }}</a>
										<a href="#" class="fw-bold text-muted text-hover-primary fs-7">{{ Session::get('profil') }}</a>
									</div>
									<!--end::Info-->
								</div>
								<!--end::User-->
								<!--begin::Menu-->
								<div class="menu menu-column menu-rounded menu-sub-indention px-3 my-5" id="#kt_app_sidebar_menu" data-kt-menu="true" data-kt-menu-expand="false">
									@if(isset(Session::get('rights')[6]))
									<!--begin:Menu item-->
									<div class="menu-item">
										<!--begin:Menu link-->
										<a class="menu-link @php echo $currentMenu == 'dashboard' ? 'active':'' @endphp" href="/dashboard/0">
											<span class="menu-icon">
												<i class="ki-duotone ki-element-11 fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
													<span class="path5"></span>
													<span class="path6"></span>
												</i>
											</span>
											<span class="menu-title">Tableau de bord</span>
										</a>
										<!--end:Menu link-->
									</div>
									<!--end:Menu item-->
									@endif
									@if(isset(Session::get('rights')[19]))
									<!--begin:Menu item-->
									<div class="menu-item">
										<!--begin:Menu link-->
										<a class="menu-link @php echo $currentMenu == 'billings' ? 'active':'' @endphp" href="/billings">
											<span class="menu-icon">
												<i class="ki-duotone ki-credit-cart fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
													<span class="path5"></span>
													<span class="path6"></span>
												</i>
											</span>
											<span class="menu-title">Factures</span>
										</a>
										<!--end:Menu link-->
									</div>
									<!--end:Menu item-->
									@endif
									@if(isset(Session::get('rights')[18]))
									<!--begin:Menu item-->
									<div class="menu-item">
										<!--begin:Menu link-->
										<a class="menu-link @php echo $currentMenu == 'devis' ? 'active':'' @endphp" href="/devis">
											<span class="menu-icon">
												<i class="ki-duotone ki-abstract-25 fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
													<span class="path5"></span>
													<span class="path6"></span>
												</i>
											</span>
											<span class="menu-title">Devis</span>
										</a>
										<!--end:Menu link-->
									</div>
									<!--end:Menu item-->
									@endif
									@if((isset(Session::get('rights')[7]))||(isset(Session::get('rights')[8]))||(isset(Session::get('rights')[9]))||(isset(Session::get('rights')[10])))
									<!--begin:Menu item-->
									<div data-kt-menu-trigger="click" class="menu-item @php echo $currentMenu == 'clients' ? 'here show':'' @endphp menu-accordion">
										<!--begin:Menu link-->
										<span class="menu-link">
											<span class="menu-icon">
												<i class="ki-duotone ki-bank fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
												</i>
											</span>
											<span class="menu-title">Gestion des clients</span>
											<span class="menu-arrow"></span>
										</span>
										<!--end:Menu link-->
										<!--begin:Menu sub-->
										<div class="menu-sub menu-sub-accordion">
											@if(isset(Session::get('rights')[7]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'clients' ? 'active':'' @endphp" href="/clients">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Clients</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[8]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'ships' ? 'active':'' @endphp" href="/ships">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Navires</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[9]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'inspectors' ? 'active':'' @endphp" href="/inspectors">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Inspecteurs</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[10]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'billaddr' ? 'active':'' @endphp" href="/billaddr">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Adresse Facturaction</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
										</div>
										<!--end:Menu sub-->
									</div>
									<!--end:Menu item-->
									@endif
									@if((isset(Session::get('rights')[11]))||(isset(Session::get('rights')[13]))||(isset(Session::get('rights')[15]))||(isset(Session::get('rights')[16]))||(isset(Session::get('rights')[17])))
									<!--begin:Menu item-->
									<div data-kt-menu-trigger="click" class="menu-item @php echo $currentMenu == 'settings' ? 'here show':'' @endphp menu-accordion">
										<!--begin:Menu link-->
										<span class="menu-link">
											<span class="menu-icon">
												<i class="ki-duotone ki-map fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
												</i>
											</span>
											<span class="menu-title">Paramètres</span>
											<span class="menu-arrow"></span>
										</span>
										<!--end:Menu link-->
										<!--begin:Menu sub-->
										<div class="menu-sub menu-sub-accordion">
											@if(isset(Session::get('rights')[11]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'devistyp' ? 'active':'' @endphp" href="/devistyp">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Type Devis</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[17]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'headers' ? 'active':'' @endphp" href="/headers">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Entête Facture</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[13]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'schedules' ? 'active':'' @endphp" href="/schedules">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Horaires (Travaux)</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[15]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'transport' ? 'active':'' @endphp" href="/transport">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Transports</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[16]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'quantity' ? 'active':'' @endphp" href="/quantity">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Quantités</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
										</div>
										<!--end:Menu sub-->
									</div>
									<!--end:Menu item-->
									@endif
									@if((isset(Session::get('rights')[12]))||(isset(Session::get('rights')[14]))||(isset(Session::get('rights')[20]))||(isset(Session::get('rights')[21]))||(isset(Session::get('rights')[22])))
									<!--begin:Menu item-->
									<div data-kt-menu-trigger="click" class="menu-item @php echo $currentMenu == 'supplie' ? 'here show':'' @endphp menu-accordion">
										<!--begin:Menu link-->
										<span class="menu-link">
											<span class="menu-icon">
												<i class="ki-duotone ki-call fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
													<span class="path5"></span>
													<span class="path6"></span>
													<span class="path7"></span>
													<span class="path8"></span>
												</i>
											</span>
											<span class="menu-title">Fourniture</span>
											<span class="menu-arrow"></span>
										</span>
										<!--end:Menu link-->
										<!--begin:Menu sub-->
										<div class="menu-sub menu-sub-accordion">
											@if(isset(Session::get('rights')[12]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'suppltyp' ? 'active':'' @endphp" href="/suppltyp">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Catégorie</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[14]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'suppllib' ? 'active':'' @endphp" href="/suppllib">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Nom commercial</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[20]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'materials' ? 'active':'' @endphp" href="/materials">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Matière</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[21]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'diameters' ? 'active':'' @endphp" href="/diameters">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Dimension</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[22]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'supplies' ? 'active':'' @endphp" href="/supplies">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Désignation</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
										</div>
										<!--end:Menu sub-->
									</div>
									<!--end:Menu item-->
									@endif
									@if((isset(Session::get('rights')[3]))||(isset(Session::get('rights')[4])))
									<!--begin:Menu item-->
									<div data-kt-menu-trigger="click" class="menu-item @php echo $currentMenu == 'habilitation' ? 'here show':'' @endphp menu-accordion">
										<!--begin:Menu link-->
										<span class="menu-link">
											<span class="menu-icon">
												<i class="ki-duotone ki-address-book fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
												</i>
											</span>
											<span class="menu-title">Habilitation</span>
											<span class="menu-arrow"></span>
										</span>
										<!--end:Menu link-->
										<!--begin:Menu sub-->
										<div class="menu-sub menu-sub-accordion">
											@if(isset(Session::get('rights')[3]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'users' ? 'active':'' @endphp" href="/users">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Utilisateurs</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
											@if(isset(Session::get('rights')[4]))
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'profils' ? 'active':'' @endphp" href="/profils">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Profils</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											@endif
										</div>
										<!--end:Menu sub-->
									</div>
									<!--end:Menu item-->
									@endif
									@if(isset(Session::get('rights')[5]))
									<!--begin:Menu item-->
									<div class="menu-item">
										<!--begin:Menu link-->
										<a class="menu-link @php echo $currentMenu == 'logs' ? 'active':'' @endphp" href="/logs">
											<span class="menu-icon">
												<i class="ki-duotone ki-code fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
													<span class="path5"></span>
													<span class="path6"></span>
												</i>
											</span>
											<span class="menu-title">Pistes d'audit</span>
										</a>
										<!--end:Menu link-->
									</div>
									<!--end:Menu item-->
									@endif
									<!--begin:Menu item-->
									<div data-kt-menu-trigger="click" class="menu-item @php echo $currentMenu == 'infosperso' ? 'here show':'' @endphp menu-accordion">
										<!--begin:Menu link-->
										<span class="menu-link">
											<span class="menu-icon">
												<i class="ki-duotone ki-user fs-2">
													<span class="path1"></span>
													<span class="path2"></span>
													<span class="path3"></span>
													<span class="path4"></span>
												</i>
											</span>
											<span class="menu-title">Infos perso</span>
											<span class="menu-arrow"></span>
										</span>
										<!--end:Menu link-->
										<!--begin:Menu sub-->
										<div class="menu-sub menu-sub-accordion">
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'account' ? 'active':'' @endphp" href="/account">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Mon compte</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
											<!--begin:Menu item-->
											<div class="menu-item">
												<!--begin:Menu link-->
												<a class="menu-link @php echo $currentSubMenu == 'password' ? 'active':'' @endphp" href="/password">
													<span class="menu-bullet">
														<span class="bullet bullet-dot"></span>
													</span>
													<span class="menu-title">Mot de passe</span>
												</a>
												<!--end:Menu link-->
											</div>
											<!--end:Menu item-->
										</div>
										<!--end:Menu sub-->
									</div>
									<!--end:Menu item-->
								</div>
								<!--end::Menu-->
							</div>
							<!--end::Menu wrapper-->
						</div>
						<!--end::sidebar menu-->
					</div>
					<!--end::Sidebar-->
					<!--begin::Main-->
					<div class="app-main flex-column flex-row-fluid" id="kt_app_main">
						<!--begin::Content wrapper-->
						<div class="d-flex flex-column flex-column-fluid">
							<!--begin::Toolbar-->
							<div id="kt_app_toolbar" class="app-toolbar py-3 py-lg-6">
								<!--begin::Toolbar container-->
								<div id="kt_app_toolbar_container" class="app-container container-fluid d-flex flex-stack">
									<!--begin::Page title-->
									<div class="page-title d-flex flex-column justify-content-center flex-wrap me-3">
										<!--begin::Title-->
										<h1 class="page-heading d-flex text-dark fw-bold fs-3 flex-column justify-content-center my-0">{{ $title }}</h1>
										<!--end::Title-->
										<!--begin::Breadcrumb-->
										<ul class="breadcrumb breadcrumb-separatorless fw-semibold fs-7 my-0 pt-1">
											<!--begin::Item-->
											<li class="breadcrumb-item text-muted">
												<a href="/{{ Session::get('page') }}" class="text-muted text-hover-primary">Accueil</a>
											</li>
											<!--end::Item-->
											<!--begin::Item-->
											<li class="breadcrumb-item">
												<span class="bullet bg-gray-400 w-5px h-2px"></span>
											</li>
											<!--end::Item-->
											<!--begin::Item-->
											<li class="breadcrumb-item text-muted">{{ $breadcrumb }}</li>
											<!--end::Item-->
										</ul>
										<!--end::Breadcrumb-->
									</div>
									<!--end::Page title-->
									<!--begin::Actions-->
									@if($addmodal != '')
									<div class="d-flex align-items-center gap-2 gap-lg-3">
										<!--begin::Primary button-->
										@php echo $addmodal; @endphp
										<!--end::Primary button-->
									</div>
									@endif
									<!--end::Actions-->
								</div>
								<!--end::Toolbar container-->
							</div>
							<!--end::Toolbar-->
							<!--begin::Content-->
							<div id="kt_app_content" class="app-content flex-column-fluid">
								<!--begin::Content container-->
								<div id="kt_app_content_container" class="app-container container-fluid">
									@yield('content')
								</div>
								<!--end::Content container-->
							</div>
							<!--end::Content-->
						</div>
						<!--end::Content wrapper-->
						<!--begin::Footer-->
						<div id="kt_app_footer" class="app-footer">
							<!--begin::Footer container-->
							<div class="app-container container-fluid d-flex flex-column flex-md-row flex-center flex-md-stack py-3">
								<!--begin::Copyright-->
								<div class="text-dark order-2 order-md-1">
									<span class="text-muted fw-semibold me-1">2023&copy;</span>
									<a href="#" class="text-gray-800 text-hover-primary">MANCI</a>
								</div>
								<!--end::Copyright-->
								<!--begin::Menu-->
								<ul class="menu menu-gray-600 menu-hover-primary fw-semibold order-1">
									<li class="menu-item">
										<a href="#" class="menu-link px-2">MANCI</a>
									</li>
									<li class="menu-item">
										<a href="#" class="menu-link px-2">IMN-S</a>
									</li>
									<li class="menu-item">
										<a href="#" class="menu-link px-2">SORENA-CI</a>
									</li>
								</ul>
								<!--end::Menu-->
							</div>
							<!--end::Footer container-->
						</div>
						<!--end::Footer-->
					</div>
					<!--end:::Main-->
				</div>
				<!--end::Wrapper-->
			</div>
			<!--end::Page-->
		</div>
		<!--end::App-->
		<!-- begin::Modal Status -->
		<form id="frmstatus">
			<input type="hidden" id="idStatus" name="id">
			<input type="hidden" id="valStatus" name="val">
			<input type="hidden" id="typStatus" name="typ">
		</form>
		<!--end::Modal Status -->
		<!--begin::Modal - Form-->
		<div class="modal fade" id="modalform" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
			<!--begin::Modal dialog-->
			<div class="modal-dialog modal-dialog-centered mw-650px">
				<!--begin::Modal content-->
				<div class="modal-content rounded">
					<!--begin::Modal header-->
					<div class="modal-header pb-0 border-0 justify-content-end">
						<!--begin::Close-->
						<div class="btn btn-sm btn-icon btn-active-color-primary" data-bs-dismiss="modal">
							<i class="ki-duotone ki-cross fs-1">
								<span class="path1"></span>
								<span class="path2"></span>
							</i>
						</div>
						<!--end::Close-->
					</div>
					<!--begin::Modal header-->
					<!--begin::Modal body-->
					<div class="modal-body scroll-y px-10 px-lg-15 pt-0 pb-15">
						<!--begin:Form-->
						<form class="form formField" autocomplete="off">
							<!--begin::Heading-->
							<div class="mb-13 text-center">
								<!--begin::Title-->
								<h1 id="titleForm" class="mb-3">Modal Title</h1>
								<!--end::Title-->
							</div>
							<!--end::Heading-->
							<!--begin::Input group-->
							<div id="bodyForm">Modal Body</div>
							<!--end::Input group-->
							<span class="msgError" style="display: none;"></span>
							<!--begin::Actions-->
							<div class="text-center">
								<button type="button" class="btn btn-danger me-3" data-bs-dismiss="modal">Fermer</button>
								<button type="button" class="btn btn-primary submitForm">Enregistrer</button>
							</div>
							<!--end::Actions-->
						</form>
						<!--end:Form-->
					</div>
					<!--end::Modal body-->
				</div>
				<!--end::Modal content-->
			</div>
			<!--end::Modal dialog-->
		</div>
		<!--end::Modal - Form-->
		<!--begin::Modal - Detail-->
		<div class="modal fade" id="modaldetail" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
			<!--begin::Modal dialog-->
			<div class="modal-dialog modal-dialog-centered mw-650px">
				<!--begin::Modal content-->
				<div class="modal-content rounded">
					<!--begin::Modal header-->
					<div class="modal-header pb-0 border-0 justify-content-end">
						<!--begin::Close-->
						<div class="btn btn-sm btn-icon btn-active-color-primary" data-bs-dismiss="modal">
							<i class="ki-duotone ki-cross fs-1">
								<span class="path1"></span>
								<span class="path2"></span>
							</i>
						</div>
						<!--end::Close-->
					</div>
					<!--begin::Modal header-->
					<!--begin::Modal body-->
					<div class="modal-body scroll-y px-10 px-lg-15 pt-0 pb-15">
						<!--begin:Form-->
						<form class="form formField" autocomplete="off">
							<!--begin::Heading-->
							<div class="mb-13 text-center">
								<!--begin::Title-->
								<h1 id="titleDetail" class="mb-3">Modal Title</h1>
								<!--end::Title-->
							</div>
							<!--end::Heading-->
							<!--begin::Input group-->
							<div id="bodyDetail">Modal Body</div>
							<!--end::Input group-->
						</form>
						<!--end:Form-->
					</div>
					<!--end::Modal body-->
				</div>
				<!--end::Modal content-->
			</div>
			<!--end::Modal dialog-->
		</div>
		<!--end::Modal - Detail-->
		<!--begin::Scrolltop-->
		<div id="kt_scrolltop" class="scrolltop" data-kt-scrolltop="true">
			<i class="ki-duotone ki-arrow-up">
				<span class="path1"></span>
				<span class="path2"></span>
			</i>
		</div>
		<!--end::Scrolltop-->
		<!--begin::Javascript-->
		<script>var hostUrl = "/assets/";</script>
		<!--begin::Global Javascript Bundle(mandatory for all pages)-->
		<script src="/assets/plugins/global/plugins.bundle.js"></script>
		<script src="/assets/js/scripts.bundle.js"></script>
		<!--end::Global Javascript Bundle-->
		<!--begin::Page Vendors Javascript(used by this page)-->
		<script src="/assets/plugins/custom/datatables/datatables.bundle.js"></script>
		<!--end::Page Vendors Javascript-->
		<!--begin::Custom Javascript(used for this page only)-->
		<script src="/assets/js/custom/icheck.js"></script>
		<script src="/assets/js/custom.js?v1.1.2"></script>
		<script>
			var titleLoad = "Traitement en cours!";
			var textLoad = "Veuillez patienter svp...";
			"use strict";
			//DataTable
			$("#kt_datatable").DataTable({
				responsive: true,
				language: {
					processing:     "Traitement en cours...",
					search:         "Rechercher&nbsp;:",
					lengthMenu:    "Afficher _MENU_ &eacute;l&eacute;ments",
					info:           "Affichage de l'&eacute;lement _START_ &agrave; _END_ sur _TOTAL_ &eacute;l&eacute;ments",
					infoEmpty:      "Affichage de l'&eacute;lement 0 &agrave; 0 sur 0 &eacute;l&eacute;ments",
					infoFiltered:   "(filtr&eacute; de _MAX_ &eacute;l&eacute;ments au total)",
					infoPostFix:    "",
					loadingRecords: "Chargement en cours...",
					zeroRecords:    "Aucun &eacute;l&eacute;ment &agrave; afficher",
					emptyTable:     "Aucune donnée disponible dans le tableau",
					aria: {
						sortAscending:  ": activer pour trier la colonne par ordre croissant",
						sortDescending: ": activer pour trier la colonne par ordre décroissant"
					}
				},
				"dom":
				"<'row'" +
				"<'col-sm-6 d-flex align-items-center justify-conten-start'l>" +
				"<'col-sm-6 d-flex align-items-center justify-content-end'f>" +
				">" +

				"<'table-responsive'tr>" +

				"<'row'" +
				"<'col-sm-12 col-md-5 d-flex align-items-center justify-content-center justify-content-md-start'i>" +
				"<'col-sm-12 col-md-7 d-flex align-items-center justify-content-center justify-content-md-end'p>" +
				">"
			});
		</script>
		<!--end::Custom Javascript-->
		@yield('scripts')
		<!--end::Javascript-->
	</body>
	<!--end::Body-->
</html>