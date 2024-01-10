<input type="hidden" id="id" name="id" value="{{ $id }}">
<input type="hidden" name="typ" value="{{ $typ }}">
<input type="hidden" id="nameController" value="status">
<!--begin::Input group-->
<div class="row fv-row mb-7">
  <div class="col-sm-6 col-xl-6 text-center">
    <!--begin::Option-->
    <label class="form-check form-check-custom form-check-inline form-check-solid mx-5">
      <input class="form-check-input checked" type="radio" name="val" value="{{ $ouiVal }}" checked>
      <span class="fw-semibold ps-2 fs-6">{{ $ouiLib }}</span>
    </label>
    <!--end::Option-->
  </div>
  <!--end::Col-->
  <!--begin::Col-->
  <div class="col-sm-6 col-xl-6 text-center">
    <!--begin::Option-->
    <label class="form-check form-check-custom form-check-inline form-check-solid">
      <input class="form-check-input checked" type="radio" name="val" value="{{ $nonVal }}">
      <span class="fw-semibold ps-2 fs-6">{{ $nonLib }}</span>
    </label>
    <!--begin::Col-->
  </div>
  <!--end::Col-->
</div>
<div class="row fv-row mb-7 motif" style="display: none">
  <!--begin::Col-->
  <div class="col-sm-12 col-xl-12">
    <label class="form-label fw-bolder text-dark fs-6 required">Motif</label>
    <textarea name="motif" class="form-control refusField"></textarea>
  </div>
  <!--end::Col-->
</div>
<script>
  $('.checked').on('click', function(){
    $('.msgError').html('');
    $('.fieldError').removeClass('fieldError');
    if(($(this).val() == 2)||($(this).val() == 4)){
      $('.motif').css('display', 'none');
      $('.refusField').removeClass('requiredField');
    }else{
      $('.motif').css('display', 'flex');
      $('.refusField').addClass('requiredField');
    }
  });
</script>