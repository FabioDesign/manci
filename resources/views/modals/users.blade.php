<input type="hidden" id="nameController" value="usercreate">
<input type="hidden" name="id" value="{{ $id }}">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Genre</label>
    <select name="gender" class="form-control form-control-lg form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
      @foreach($arraySex as $key => $sex)
        <option value="{{ $key }}" @php echo $gender == $key ? 'selected':'' @endphp>{{ $sex }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Profil</label>
    <select name="profil_id" class="form-control form-control-lg form-select form-control-solid requiredField" aria-label="Select example">
      <option value="" selected disabled>Sélectionner</option>
      @foreach($sqlpro as $data)
        <option value="{{ $data->id }}" @php echo $profil_id == $data->id ? 'selected':'' @endphp>{{ $data->libelle }}</option>
      @endforeach
    </select>
  </div>
  <!--end::Col-->
</div>
<div class="row fv-row mb-7">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Nom</label>
    <input type="text" name="lastname" value="{{ $lastname }}" class="form-control form-control-lg form-control-solid requiredField" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Prénoms</label>
    <input type="text" name="firstname" value="{{ $firstname }}" class="form-control form-control-lg form-control-solid requiredField" />
  </div>
  <!--end::Col-->
</div>
<div class="row fv-row">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">E-mail</label>
    <input type="text" name="email" value="{{ $email }}" class="form-control form-control-lg form-control-solid requiredField email" />
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-6">
    <label class="form-label fw-bolder text-dark fs-6 required">Téléphone</label>
    <input type="text" name="number" value="{{ $number }}" class="form-control form-control-lg form-control-solid requiredField number" maxlength="10" onKeyUp="verif_num(this)" />
  </div>
  <!--end::Col-->
</div>