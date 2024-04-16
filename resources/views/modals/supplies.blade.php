<input type="hidden" id="nameController" value="suppliecreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Type</label>
    <select id="suppltyp_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
      @foreach($suppltyp as $data)
        <option value="{{ $data->id }}" @php echo $suppltyp_id == $data->id ? 'selected':'' @endphp>{{ $data->libelle }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Nom</label>
    <select id="suppllib_id" name="suppllib_id" class="form-control form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
    </select>
  </div>
  <!--end::Col-->
</div>
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Matière</label>
    <select name="material_id" class="form-control form-select form-control-solid" aria-label="Select example">
      <option value="0" selected>Aucune</option>
      @foreach($material as $data)
        <option value="{{ $data->id }}" @php echo $material_id == $data->id ? 'selected':'' @endphp>{{ $data->libelle }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Qualification</label>
    <select name="diameter_id" class="form-control form-select form-control-solid" aria-label="Select example">
      <option value="0" selected>Aucune</option>
      @foreach($diameter as $data)
        <option value="{{ $data->id }}" @php echo $diameter_id == $data->id ? 'selected':'' @endphp>{{ $data->libelle }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
</div>
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Montant</label>
    <input type="text" name="amount" value="{{ $amount }}" class="form-control form-control-lg form-control-solid text-center requiredField amount" onKeyUp="verif_num(this)" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6">Unité</label>
    <input type="text" name="unit" value="{{ $unit }}" class="form-control form-control-lg form-control-solid text-center" />
  </div>
  <!--end::Col-->
</div>

<script>
  var suppltyp_id = {!! $suppltyp_id !!};
  var suppllib_id = {!! $suppllib_id !!};
  $(document).ready(function(){
    Supplliblist(suppltyp_id, suppllib_id);
  });
  //Modal Form
  $('#suppltyp_id').on('change', function(){
    var suppltyp_id = $(this).val();
    Supplliblist(suppltyp_id, suppllib_id);
  });
  //Profil form
  function Supplliblist(suppltyp_id, suppllib_id){
    var datasT = {id:suppltyp_id};
    $.ajax({
      type: 'POST',
      data: datasT,
      url: '/supplliblist',
      success: function(response){
        if(response == 'x'){
          location.href = '/';
        }else{
          var options = '<option value="" selected disabled>Sélectionner</option>';
          $.each(response, function(index, value){
            if(suppllib_id == index)
              var selected = 'selected';
            else
            var selected = '';
            options += '<option value="'+index+'" '+selected+'>'+value+'</option>';
          });
          $('#suppllib_id').html(options);
        }
      }
    });
  }
</script>