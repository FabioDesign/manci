<input type="hidden" id="nameController" value="schedulecreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Libellé</label>
    <input type="text" name="libelle" value="{{ $libelle }}" class="form-control form-control-lg form-control-solid requiredField" />
  </div>
  <!--end::Col-->
</div>
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Montant</label>
    <input type="text" name="amount" value="{{ $amount }}" class="form-control form-control-lg form-control-solid requiredField amount" onKeyUp="verif_num(this)" />
  </div>
  <!--end::Col-->
</div>