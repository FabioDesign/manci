@extends('layouts.master')

@section('content')
<!--begin::Card-->
<div class="card">
  <!--begin::Card body-->
  <div class="card-body py-4">
    <!--begin::Table-->
    <form class="formField">
      <input type="hidden" id="nameController" value="profilcreate">
      <input type="hidden" name="id" value="{{ $id }}">
      <div class="profilform"></div>
    </form>
    <!--end::Table-->
  </div>
  <!--end::Card body-->
</div>
<!--end::Card-->
@endsection

@section('scripts')
<script>
  var id = {!! $id !!};
  $(document).ready(function(){
    Profilform(id);
  });
  //Profil form
  function Profilform(id){
    var datasT = {id:id};
    $.ajax({
      type: 'POST',
      data: datasT,
      url: '/profilform',
      beforeSend: function(){
        $('.profilform').addClass('text-center').html('<i class="fa fa-spinner fa-pulse fa-5x link-primary"></i>');
      },
      success: function(response){
        if(response == 'x'){
          location.href = '/';
        }else{
          $('.profilform').removeClass('text-center').html(response);
          $('.iCheck').iCheck({
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%'
          });
        }
      }
    });
  }
</script>
@endsection