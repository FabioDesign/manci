<input type="hidden" id="nameController" value="shipcreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Libelle</label>
    <input type="text" name="libelle" value="{{ $libelle }}" class="form-control form-control-solid requiredField" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Client</label>
    <select id="client_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
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
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Inspecteur</label>
    <select name="inspector_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
      @foreach($sqlinsp as $data)
        <option value="{{ $data->id }}" @php echo $inspector_id == $data->id ? 'selected':'' @endphp>{{ $data->lastname.' '.$data->firstname }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Adresse facturation</label>
    <select id="billaddr_id" name="billaddr_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
    </select>
  </div>
  <!--end::Col-->
</div>

<script>
  var client_id = {!! $client_id !!};
  var billaddr_id = {!! $billaddr_id !!};
  $(document).ready(function(){
    Billaddrlist(client_id, billaddr_id);
  });
  //Modal Form
  $('#client_id').on('change', function(){
    var client_id = $(this).val();
    Billaddrlist(client_id, billaddr_id);
  });
</script>