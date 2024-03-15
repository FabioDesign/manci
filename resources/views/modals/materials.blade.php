<input type="hidden" id="nameController" value="materialcreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Nom</label>
    <input type="text" name="libelle" value="{{ $libelle }}" class="form-control form-control-lg form-control-solid requiredField" />
  </div>
  <!--end::Col-->
</div>