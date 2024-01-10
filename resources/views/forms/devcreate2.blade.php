@extends('layouts.master')

@section('content')
<!--begin::Card-->
<div class="card">
	<!--begin::Card body-->
	<div class="card-body p-12">
		<!--begin::Form-->
		<form id="kt_invoice_form" class="formField" autocomplete="off">
			<input type="hidden" id="nameController" value="deviscreate">
			<input type="hidden" id="old_rem" name="old_rem" value="0">
			<input type="hidden" id="old_tva" name="old_tva" value="0">
			<input type="hidden" id="devttr_id" name="devttr_id">
			<input type="hidden" id="id" name="id">
			<!--begin::Input group-->
			<div class="row g-9 mb-8">
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-2">
					<label class="form-label fw-bolder text-dark fs-6 required">Référence</label>
					<input type="text" name="reference" value="{{ $reference }}" class="form-control form-control-solid requiredField text-center" />
				</div>
				<!--end::Col-->
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-2">
					<label class="form-label fw-bolder text-dark fs-6 required">Date</label>
					<!--begin::Input-->
					<div class="position-relative d-flex align-items-center">
						<!--begin::Icon-->
						<i class="ki-duotone ki-calendar fs-2 position-absolute mx-4">
							<span class="path1"></span>
							<span class="path2"></span>
							<span class="path3"></span>
							<span class="path4"></span>
							<span class="path5"></span>
							<span class="path6"></span>
						</i>
						<!--end::Icon-->
						<!--begin::Datepicker-->
						<input id="date_at" name="date_at" class="form-control form-control-solid requiredField ps-12" readonly />
						<!--end::Datepicker-->
					</div>
					<!--end::Input-->
				</div>
				<!--end::Col-->
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-3">
					<label class="form-label fw-bolder text-dark fs-6 required">Client</label>
					<select id="client_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
						<option value="" selected disabled>Sélectionner</option>
						@foreach($client as $data)
							<option value="{{ $data->id }}">{{ $data->libelle }}</option>
						@endforeach
					</select>
				</div>
				<!--end::Col-->
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-3">
					<label class="form-label fw-bolder text-dark fs-6 required">Adresse de facturation</label>
					<select id="billaddr_id" name="billaddr_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
						<option value="" selected disabled>Sélectionner</option>
					</select>
				</div>
				<!--end::Col-->
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-2">
					<label class="form-label fw-bolder text-dark fs-6 required">Entête</label>
					<select name="header_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
						<option value="" selected disabled>Sélectionner</option>
						@foreach($header as $data)
							<option value="{{ $data->id }}">{{ $data->libelle }}</option>
						@endforeach
					</select>
				</div>
				<!--end::Col-->
			</div>
			<!--end::Input group-->
			<!--begin::Separator-->
			<div class="separator separator-dashed my-10"></div>
			<!--end::Separator-->
			<!--begin::Row-->
			<div class="row gx-10 mb-5">
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-8">
					<label class="form-label fw-bolder text-dark fs-6 required">Titre</label>
					<!--begin::Option-->
					<label class="form-check form-check-custom form-check-inline form-check-solid mx-5">
						<input class="form-check-input" type="radio" name="devttr" value="1" checked>
						<span class="fw-semibold ps-2 fs-6">Ajouter</span>
					</label>
					<!--end::Option-->
					<!--begin::Option-->
					<label class="form-check form-check-custom form-check-inline form-check-solid">
						<input class="form-check-input devttr" type="radio" name="devttr" value="2" disabled>
						<span class="fw-semibold ps-2 fs-6">Modifier</span>
					</label>
					<!--end::Option-->
					<input type="text" id="title" name="title" class="form-control form-control-solid requiredField" />
				</div>
				<!--end::Col-->
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-4">
					<label class="form-label fw-bolder text-dark fs-6 required">Type devis</label>
					<select id="devtyp_id" name="devtyp_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
						<option value="" selected disabled>Sélectionner</option>
						@foreach($devistyp as $data)
							<option value="{{ $data->id }}">{{ $data->libelle }}</option>
						@endforeach
					</select>
				</div>
				<!--end::Col-->
			</div>
			<div class="row gx-10 mb-5">
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-4">
					<label class="form-label fw-bolder text-dark fs-6">Total type</label>
					<!--begin::Input group-->
					<input type="text" id="solde" name="solde" value="0" class="form-control form-control-solid text-center" readonly />
					<!--end::Input group-->
					<label class="form-label fw-bolder text-dark fs-6 my-3">Remise %</label>
					<!--begin::Input group-->
					<div class="mb-5">
						<label class="form-check form-switch form-check-custom form-check-solid flex-stack mb-5 remtyp">
							<input class="form-check-input w-70px h-40px me-5" id="seeremtyp" name="seeremtyp" type="checkbox">
							<input type="text" id="mtremtyp" name="mtremtyp" value="0" class="form-control form-control-solid text-center amount" onKeyUp="verif_num(this)" />
						</label>
					</div>
					<!--end::Input group-->
				</div>
				<!--end::Col-->
				<!--begin::Col-->
				<div class="col-sm-12 col-xl-8">
					<label class="form-label fw-bolder text-dark fs-6">Description</label>
					<!--begin::Input group-->
					<div class="mb-5">
						<textarea class="form-control form-control-solid" rows="5" id="content" name="content"></textarea>
					</div>
					<!--end::Input group-->
				</div>
				<!--end::Col-->
			</div>
			<!--end::Row-->
			<!--begin::Separator-->
			<div class="separator separator-dashed my-10"></div>
			<!--end::Separator-->
			<div class="form-command">
				<datalist id="qte"></datalist>
				<div class="row mb-5 devistype">
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-4 position-relative">
						<label class="form-check form-check-custom form-check-solid position-absolute top-50 formcheck">
							<input type="checkbox" name="display[]" class="form-check-input h-20px w-20px display">
						</label>
						<label class="form-label fw-bolder text-dark fs-6 required">Designation</label>
						<select name="item_id[]" class="form-control form-select form-control-solid item_id" aria-label="Select example">
							<option value="" selected disabled>Sélectionner</option>
						</select>
					</div>
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-2">
						<label class="form-label fw-bolder text-dark fs-6 required">Prix unitaire</label>
						<input type="text" name="price[]" placeholder="0" class="form-control form-control-solid text-center amount price" onKeyUp="verif_num(this)" readonly />
					</div>
					<!--end::Col-->
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-2">
						<label class="form-label fw-bolder text-dark fs-6 required">Qté</label>
						<input type="text" name="qte[]" list="qte" placeholder="0" class="form-control form-control-solid text-center qte space" readonly />
					</div>
					<!--end::Col-->
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-2">
						<label class="form-label fw-bolder text-dark fs-6">Unité</label>
						<input type="text" name="unit[]" class="form-control form-control-solid text-center unit space" readonly />
					</div>
					<!--end::Col-->
					<!--begin::Col-->
					<div class="col-sm-12 col-xl-2 position-relative">
						<label class="form-label fw-bolder text-dark fs-6 required">Total</label>
						<input type="text" value="0" class="form-control form-control-solid text-center w-85 total" readonly />
						<!--begin::Delete-->
						<a href="#" class="btn btn-icon position-absolute bottom-0 end-0 pe-none">
							<i class="ki-duotone ki-trash text-dark fs-1">
								<span class="path1"></span>
								<span class="path2"></span>
								<span class="path3"></span>
								<span class="path4"></span>
								<span class="path5"></span>
							</i>
						</a>
						<!--end::Delete-->
					</div>
					<!--end::Col-->
				</div>
			</div>
			<!--begin::Actions-->
			<div class="row justify-content-center mb-5">
				<div class="col-sm-12 col-xl-4"></div>
				<div class="col-sm-12 col-xl-4">
					<button type="button" class="btn btn-square btn-primary font-weight-bold w-100 addDev not-active">
						<i class="ki-duotone ki-plus-square fs-2">
							<span class="path1"></span>
							<span class="path2"></span>
							<span class="path3"></span>
						</i>Ajouter
					</button>
				</div>
				<div class="col-sm-12 col-xl-4"></div>
			</div>
			<!--end::Actions-->
			<!--begin::Table-->
			<div class="table-responsive border-bottom mb-9">
				<table class="table mb-3">
					<thead>
						<tr class="border-bottom fs-6 fw-bold text-muted">
							<th class="min-w-100px text-center pb-2">Total devis</th>
							<th class="min-w-100px text-center pb-2" style="width: 200px">Remise %</th>
							<th class="min-w-100px text-center pb-2" style="width: 200px">TVA %</th>
							<th class="min-w-100px text-center pb-2">Total FCFA</th>
							<th class="min-w-100px text-center pb-2" style="width: 200px">Total EURO</th>
						</tr>
					</thead>
					<tbody>
						<tr class="fw-bold text-gray-700 fs-5 text-end">
							<td class="text-center pt-6 mt_ht">0</td>
							<td class="pt-6">
								<div class="row">
									<div class="col-sm-12 col-xl-4">
										<label class="form-check form-switch form-check-custom form-check-solid flex-stack">
											<input class="form-check-input h-30px w-50px" name="see_rem" type="checkbox">
										</label>
									</div>
									<div class="col-sm-12 col-xl-8">
										<input type="text" name="sum_rem" placeholder="0" class="form-control form-control-solid text-center h-30px" />
									</div>
								</div>
							</td>
							<td class="pt-6">
								<div class="row">
									<div class="col-sm-12 col-xl-4">
										<label class="form-check form-switch form-check-custom form-check-solid flex-stack">
											<input class="form-check-input h-30px w-50px" name="see_tva" type="checkbox">
										</label>
									</div>
									<div class="col-sm-12 col-xl-8">
										<input type="text" name="sum_tva" placeholder="0" class="form-control form-control-solid text-center h-30px" />
									</div>
								</div>
							</td>
							<td class="text-center pt-6 mt_ttc">0</td>
							<td class="pt-6">
								<div class="row">
									<div class="col-sm-12 col-xl-4">
										<label class="form-check form-switch form-check-custom form-check-solid flex-stack">
											<input class="form-check-input h-30px w-50px" name="see_euro" type="checkbox">
										</label>
									</div>
									<div class="col-sm-12 col-xl-8">
										<input type="text" id="mt_euro" placeholder="0" class="form-control form-control-solid text-center h-30px" readonly />
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!--begin::Actions-->
			<div class="row justify-content-center">
				<div class="col-sm-12 col-xl-3"></div>
				<div class="col-sm-12 col-xl-3">
					<a href="/devis" class="btn btn-square btn-danger font-weight-bold w-100">
						<i class="ki-duotone ki-send fs-1">
							<span class="path1"></span>
							<span class="path2"></span>
						</i>Retour
					</a>
				</div>
				<div class="col-sm-12 col-xl-3">
					<button type="button" class="btn btn-square btn-success font-weight-bold w-100 submitDev">
						<i class="ki-duotone ki-triangle fs-2">
							<span class="path1"></span>
							<span class="path2"></span>
							<span class="path3"></span>
						</i>Valider
					</button>
				</div>
				<div class="col-sm-12 col-xl-3"></div>
				<div class="col-sm-12 col-xl-12 text-center"><span class="msgError"></span></div>
			</div>
			<!--end::Actions-->
			<!--begin::Separator-->
			<div class="separator separator-dashed my-10"></div>
			<!--end::Separator-->
			<!--begin::Table wrapper-->
			<div class="table-responsive mb-10">
				<!--begin::Table-->
				<table class="table align-middle table-row-dashed fs-6 gy-5 mb-0">
					<!--begin::Table head-->
					<thead>
						<tr class="border-bottom fs-6 fw-bold text-gray-700 text-uppercase">
							<th class="min-w-300px w-475px text-center">Designation</th>
							<th class="min-w-100px w-100px text-center">PU</th>
							<th class="min-w-100px w-100px text-center">Qté</th>
							<th class="min-w-100px w-100px text-center">Total</th>
						</tr>
					</thead>
					<!--end::Table head-->
					<!--begin::Table body-->
					<tbody class="fw-semibold text-gray-600 datadevis"></tbody>
					<!--end::Table body-->
				</table>
			</div>
			<!--end::Table-->
		</form>
		<!--end::Form-->
	</div>
	<!--end::Card body-->
</div>
<!--end::Card-->
@endsection

@section('scripts')
	<script src="/assets/js/devis.js?v1.1.3"></script>
	<script>
    	var countApp = 100;
		var remtyp = '<input class="form-check-input w-70px h-40px me-5" id="seeremtyp" name="seeremtyp" type="checkbox"><input type="text" id="mtremtyp" name="mtremtyp" value="0" class="form-control form-control-solid text-center amount" onKeyUp="verif_num(this)" />';
		$(document).ready(function(){
			Billaddrlist(0, 0);
		});
	</script>
@endsection