@extends('layouts.master')

@section('content')
<!--begin::Navbar-->
@include('layouts.infoperso')
<!--end::Navbar-->
<!--begin::details View-->
<div class="card mb-5 mb-xl-10" id="kt_profile_details_view">
	<!--begin::Card header-->
	<div class="card-header cursor-pointer">
		<!--begin::Card title-->
		<div class="card-title m-0">
			<h3 class="fw-bolder m-0">Mon compte</h3>
		</div>
		<!--end::Card title-->
	</div>
	<!--begin::Card header-->
	<!--begin::Content-->
	<div id="kt_account_settings_profile_details" class="collapse show">
		<!--begin::Form-->
		<form id="kt_account_profile_details_form" class="form formField" autocomplete="off">
			<input type="hidden" id="nameController" value="usercreate">
			<input type="hidden" name="profil_id" value="{{ Session::get('idPro') }}">
			<input type="hidden" name="id" value="{{ Session::get('idUsr') }}">
			<input type="hidden" name="gender" value="{{ $query->gender }}">
			<!--begin::Card body-->
			<div class="card-body border-top p-9">
				<!--begin::Input group-->
				<div class="row mb-6">
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-12 text-center">
						<!--begin::Image input-->
						<div class="image-input image-input-outline" data-kt-image-input="true" style="background-image: url('/assets/media/avatars/{{ $query->avatar }}')">
							<!--begin::Preview existing avatar-->
							<div class="image-input-wrapper w-200px h-200px" style="background-image: url(/assets/media/avatars/{{ $query->avatar }});background-position: center;"></div>
							<!--end::Preview existing avatar-->
							<!--begin::Label-->
							<label class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-body shadow" data-kt-image-input-action="change" data-bs-toggle="tooltip" title="Changer avatar">
								<i class="bi bi-pencil-fill fs-7"></i>
								<!--begin::Inputs-->
								<input type="file" name="avatar" accept=".png, .jpg, .jpeg" />
								<!--end::Inputs-->
							</label>
							<!--end::Label-->
							<!--begin::Cancel-->
							<span class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-body shadow" data-kt-image-input-action="cancel" data-bs-toggle="tooltip" title="Supprimer avatar">
								<i class="bi bi-x fs-2"></i>
							</span>
							<!--end::Cancel-->
							<!--begin::Remove-->
							<span class="btn btn-icon btn-circle btn-active-color-primary w-25px h-25px bg-body shadow" data-kt-image-input-action="remove" data-bs-toggle="tooltip" title="Supprimer avatar">
								<i class="bi bi-x fs-2"></i>
							</span>
							<!--end::Remove-->
						</div>
						<!--end::Image input-->
						<!--begin::Hint-->
						<div class="form-text text-danger">Format accepté: png, jpg, jpeg.</div>
						<!--end::Hint-->
					</div>
					<!--end::Col-->
				</div>
				<!--begin::Input group-->
				<div class="row fv-row mt-10 mb-10">
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-6">
						<label class="form-label fw-bolder text-dark fs-6 required">Nom</label>
						<input type="text" name="lastname" value="{{ $query->lastname }}" class="form-control form-control-lg form-control-solid requiredField" />
					</div>
					<!--end::Col-->
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-6">
						<label class="form-label fw-bolder text-dark fs-6 required">Prénoms</label>
						<input type="text" name="firstname" value="{{ $query->firstname }}" class="form-control form-control-lg form-control-solid requiredField" />
					</div>
					<!--end::Col-->
				</div>
				<div class="row fv-row mb-10">
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-6">
						<label class="form-label fw-bolder text-dark fs-6 required">Téléphone</label>
						<input type="text" name="number" value="{{ $query->number }}" class="form-control form-control-lg form-control-solid requiredField number" onKeyUp="verif_num(this)" />
					</div>
					<!--end::Col-->
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-6">
						<label class="form-label fw-bolder text-dark fs-6 required">E-mail</label>
						<input type="text" name="email" value="{{ $query->email }}" class="form-control form-control-lg form-control-solid requiredField email" />
					</div>
					<!--end::Col-->
				</div>
			</div>
			<!--end::Actions-->
			<span class="msgError" style="display: none;"></span>
			<div class="card-footer text-center">
				<button type="button" class="btn btn-square btn-danger font-weight-bold resetForm">Annuler</button>
				<button type="button" class="btn btn-square btn-primary font-weight-bold submitForm">Modifier</button>
			</div>
		</form>
		<!--end::Form-->
	</div>
	<!--end::Content-->
</div>
<!--end::details View-->
@endsection