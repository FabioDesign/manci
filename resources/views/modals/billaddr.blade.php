<input type="hidden" id="nameController" value="billaddrcreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Nom</label>
    <input type="text" name="libelle" value="{{ $libelle }}" class="form-control form-control-solid requiredField" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Client</label>
    <select name="client_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
      @foreach($sqlclt as $data)
        <option value="{{ $data->id }}" @php echo $client_id == $data->id ? 'selected':'' @endphp>{{ $data->libelle }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
</div>
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Adresse de facturaction</label>
    <textarea class="form-control form-control-solid requiredField" rows="5" name="content">{{ $content }}</textarea>
  </div>
  <!--end::Col-->
</div>