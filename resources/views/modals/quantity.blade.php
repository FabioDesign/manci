<input type="hidden" id="nameController" value="quantitycreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Nom</label>
    <input type="text" name="libelle" value="{{ $libelle }}" class="form-control form-control-lg form-control-solid requiredField" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Valeur</label>
    <input type="text" name="valeur" value="{{ $valeur }}" class="form-control form-control-lg form-control-solid requiredField comma" onKeyUp="verif_num(this)" />
  </div>
  <!--end::Col-->
</div>