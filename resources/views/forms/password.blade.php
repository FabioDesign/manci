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
			<h3 class="fw-bolder m-0">Mot de passe</h3>
		</div>
		<!--end::Card title-->
	</div>
	<!--begin::Card header-->
	<!--begin::Content-->
	<div id="kt_account_settings_profile_details" class="collapse show">
		<!--begin::Form-->
		<form id="kt_account_profile_details_form" class="form formField" autocomplete="off">
			<input type="hidden" id="nameController" value="changepass">
			<input type="hidden" name="id" value="{{ Session::get('idUsr') }}">
			<!--begin::Card body-->
			<div class="card-body border-top p-9">
				<!--begin::Input group-->
				<div class="row fv-row mt-10 mb-10">
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-4 position-relative">
						<label class="form-label fw-bolder text-dark fs-6 required">Ancien mot de passe</label>
						<input type="password" id="oldpass" name="oldpass" class="form-control form-control-lg form-control-solid requiredField oldpass password" />
						<i class="fa fa-eye-slash backPass"></i>
					</div>
					<!--end::Col-->
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-4 position-relative">
						<label class="form-label fw-bolder text-dark fs-6 required">Nouveau mot de passe</label>
						<input type="password" id="newpass" name="password" class="form-control form-control-lg form-control-solid requiredField password" />
						<i class="fa fa-eye-slash backPass"></i>
					</div>
					<!--end::Col-->
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-4 position-relative">
						<label class="form-label fw-bolder text-dark fs-6 required">Confirmer mot de passe</label>
						<input type="password" id="confirmpass" name="password_confirmation" class="form-control form-control-lg form-control-solid requiredField password" />
						<i class="fa fa-eye-slash backPass"></i>
					</div>
					<!--end::Col-->
				</div>
				<!--end::Input group-->
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