<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Client</label>
    <input type="text" value="{{ $query->client }}" class="form-control form-control-solid" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Navire</label>
    <input type="text" value="{{ $query->ships }}" class="form-control form-control-solid" />
  </div>
  <!--end::Col-->
</div>
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Nom</label>
    <input type="text" value="{{ $query->lastname }}" class="form-control form-control-solid" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Prenoms</label>
    <input type="text" value="{{ $query->firstname }}" class="form-control form-control-solid" />
  </div>
  <!--end::Col-->
</div>
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Numéro</label>
    <input type="text" value="{{ $query->number }}" class="form-control form-control-solid" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">E-mail</label>
    <input type="text" value="{{ $query->email }}" class="form-control form-control-solid" />
  </div>
  <!--end::Col-->
</div>
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6">Adresse de facturaction</label>
    <textarea class="form-control form-control-solid" rows="5">{{ $content }}</textarea>
  </div>
  <!--end::Col-->
</div>