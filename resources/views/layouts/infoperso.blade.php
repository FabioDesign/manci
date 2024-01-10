<!--begin::Navbar-->
<div class="card mb-5 mb-xl-10">
	<div class="card-body pt-9 pb-0">
		<!--begin::Details-->
		<div class="d-flex flex-wrap flex-sm-nowrap mb-3">
			<!--begin: Pic-->
			<div class="me-7 mb-4">
				<div class="symbol symbol-100px symbol-lg-160px symbol-fixed position-relative">
				<img src="/assets/media/avatars/{{ $query->avatar }}" alt="">
					<div class="position-absolute translate-middle bottom-0 start-100 mb-6 bg-success rounded-circle border border-4 border-white h-20px w-20px"></div>
				</div>
			</div>
			<!--end::Pic-->
			<!--begin::Info-->
			<div class="flex-grow-1">
				<!--begin::Title-->
				<div class="d-flex justify-content-between align-items-start flex-wrap mb-2">
					<!--begin::User-->
					<div class="d-flex flex-column">
						<!--begin::Name-->
						<div class="d-flex align-items-center mb-2">
							<a href="#" class="text-gray-900 text-hover-primary fs-2 fw-bolder me-1">{{ $query->lastname.' '.$query->firstname }}</a>
							<a href="#">
								<i class="ki-duotone ki-verify fs-1 text-primary">
									<span class="path1"></span>
									<span class="path2"></span>
								</i>
							</a>
						</div>
						<!--end::Name-->
						<!--begin::Info-->
						<div class="d-flex flex-wrap fw-semibold fs-6 mb-4 pe-2">
							<a href="#" class="d-flex align-items-center text-gray-400 text-hover-primary me-5 mb-2">
							<i class="ki-duotone ki-profile-circle fs-4 me-1">
								<span class="path1"></span>
								<span class="path2"></span>
								<span class="path3"></span>
							</i>{{ $query->libelle }}</a>
						</div>
						<!--end::Info-->
					</div>
					<!--end::User-->
				</div>
				<!--end::Title-->
				<!--begin::Stats-->
				<div class="d-flex flex-wrap flex-stack">
					<!--begin::Wrapper-->
					<div class="d-flex flex-column flex-grow-1 pe-8">
						<!--begin::Stats-->
						<div class="d-flex flex-wrap">
							<!--begin::Stat-->
							<div class="border border-gray-300 border-dashed rounded min-w-125px py-3 px-4 me-6 mb-3">
								<!--begin::Number-->
								<div class="d-flex align-items-center">
									<i class="ki-duotone ki-phone fs-3 text-success me-2">
										<span class="path1"></span>
										<span class="path2"></span>
									</i>
								</div>
								<!--end::Number-->
								<!--begin::Label-->
								<div class="fw-bold fs-6 text-gray-400 text-center">{{ $query->number }}</div>
								<!--end::Label-->
							</div>
							<!--end::Stat-->
							<!--begin::Stat-->
							<div class="border border-gray-300 border-dashed rounded min-w-125px py-3 px-4 me-6 mb-3">
								<!--begin::Number-->
								<div class="d-flex align-items-center">
									<i class="ki-duotone ki-sms fs-3 text-success me-2">
										<span class="path1"></span>
										<span class="path2"></span>
									</i>
								</div>
								<!--end::Number-->
								<!--begin::Label-->
								<div class="fw-bold fs-6 text-gray-400 text-center">{{ $query->email }}</div>
								<!--end::Label-->
							</div>
							<!--end::Stat-->
						</div>
						<!--end::Stats-->
					</div>
					<!--end::Wrapper-->
				</div>
				<!--end::Stats-->
			</div>
			<!--end::Info-->
		</div>
		<!--end::Details-->
		<!--begin::Navs-->
		<ul class="nav nav-stretch nav-line-tabs nav-line-tabs-2x border-transparent fs-5 fw-bolder">
			<!--begin::Nav item-->
			<li class="nav-item mt-2">
				<a class="nav-link text-active-primary ms-0 me-10 py-5 @php echo $currentSubMenu == 'account' ? 'active':'' @endphp" href="/account">Mon compte</a>
			</li>
			<!--end::Nav item-->
			<!--begin::Nav item-->
			<li class="nav-item mt-2">
				<a class="nav-link text-active-primary ms-0 me-10 py-5 @php echo $currentSubMenu == 'password' ? 'active':'' @endphp" href="/password">Mot de passe</a>
			</li>
			<!--end::Nav item-->
		</ul>
		<!--begin::Navs-->
	</div>
</div>
<!--end::Navbar-->