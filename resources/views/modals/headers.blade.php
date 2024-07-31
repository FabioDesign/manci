<input type="hidden" id="nameController" value="headercreate">
<input type="hidden" name="libelle" value="{{ $libelle }}">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Pied de page</label>
    <textarea class="form-control form-control-solid requiredField" rows="5" name="footer">{{ $footer }}</textarea>
  </div>
  <!--end::Col-->
</div>