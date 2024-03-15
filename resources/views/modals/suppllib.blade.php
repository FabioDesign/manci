<input type="hidden" id="nameController" value="suppllibcreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Type</label>
    <select name="suppltyp_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
      @foreach($query as $data)
        <option value="{{ $data->id }}" @php echo $suppltyp_id == $data->id ? 'selected':'' @endphp>{{ $data->libelle }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Nom</label>
    <input type="text" name="libelle" value="{{ $libelle }}" class="form-control form-control-lg form-control-solid requiredField" />
  </div>
  <!--end::Col-->
</div>