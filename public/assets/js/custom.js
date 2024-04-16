//Nombre entier
function verif_num(champ){
  var chiffres = new RegExp('[0-9.]');
  for(x = 0; x < champ.value.length; x++){
    verif = chiffres.test(champ.value.charAt(x));
    if(verif == false){
      champ.value = champ.value.substr(0,x) + champ.value.substr(x+1,champ.value.length-x+1); x--;
    }
  }
}
//Tous cocher
$(document).on('ifChecked', '#checkAll', function(event){
  $(this).parents('.form-group').siblings().find('input:checkbox').each(function(){
    $(this).parent().addClass('checked').removeClass('disabled');
    $(this).attr('checked', 'checked').removeAttr('disabled');
  });
});
$(document).on('ifUnchecked', '#checkAll', function(event){
  $(this).parents('.form-group').siblings().find('input:checkbox').each(function(){
    $('.show').parent().removeClass('checked');
    $('.show').removeAttr('checked');
    $('.check').parent().addClass('disabled').removeClass('checked');
    $('.check').removeAttr('checked').attr('disabled', 'disabled');
  });
});
//Cocher afficher
$(document).on('ifChecked', '.show', function(event){
  $(this).parents('.boxcheck').siblings().find('input:checkbox').each(function(){
    $(this).parent().removeClass('disabled');
    $(this).removeAttr('disabled');
  });
});
$(document).on('ifUnchecked', '.show', function(event){
  $(this).parents('.boxcheck').siblings().find('input:checkbox').each(function(){
    $(this).parent().addClass('disabled').removeClass('checked');
    $(this).removeAttr('checked').attr('disabled', 'disabled');
    $('#checkAll').parent().removeClass('checked');
    $('#checkAll').removeAttr('checked');
  });
});
//Cocher un champ
$(document).on('ifChecked', '.check', function(event){
  $(this).attr('checked', 'checked');
});
$(document).on('ifUnchecked', '.check', function(event){
  $(this).removeAttr('checked');
  $('#checkAll').parent().removeClass('checked');
  $('#checkAll').removeAttr('checked');
});
//Checkbox
$('.iCheck').iCheck({
  checkboxClass: 'icheckbox_square-blue',
  radioClass: 'iradio_square-blue',
  increaseArea: '20%'
});
//X-CSRF-TOKEN
$.ajaxSetup({
  headers: {
    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
  }
});
//View Password
$('.viewPass, .backPass').on('click', function(){
  var password = $(this).siblings('input');
  if(password.attr('type') == 'password'){
    password.attr('type', 'text');
    $(this).removeClass('fa-eye-slash').addClass('fa-eye');
  }else{
    password.attr('type', 'password');
    $(this).removeClass('fa-eye').addClass('fa-eye-slash');
  }
});
//PDF creator
function Pdfcreator(urlpdf, id){
  var datasT = {id:id};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/'+ urlpdf,
    success: function(){}
  });
}
//Gestion des Status
function Status(id, val, typ){
  $('#idStatus').val(id);
  $('#valStatus').val(val);
  $('#typStatus').val(typ);
}
$(document).on('click', '.status', function(e){
  var datasT = $(this).attr('data-h');
  var splitter = datasT.split('|');
  var id = splitter[0];
  Status(splitter[0], splitter[1], splitter[2]);
  var title = $(this).attr('data-bs-original-title');
  Swal.fire({
    title: title,
    text: 'Veuillez confirmer votre action.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Confirmer',
    cancelButtonText: 'Annuler'
  }).then(function(result){
    if(result.value){
      var datasT = new FormData();
      $('#frmstatus').find('input').each(function(){
        datasT.append(this.name, $(this).val());
      });
      $.ajax({
        type: 'POST',
        data: datasT,
        contentType: false,
        processData: false,
        url: '/status',
        beforeSend: function(){
          Swal.fire({
            title: titleLoad,
            text: textLoad,
            timer: 50000,
            showConfirmButton: false,
          }).then(function(result){
            if(result.dismiss === "timer"){
              console.log("I was closed by the timer")
            }
          })
        },
        success:function(response){
          if(response == 'x'){
            location.href = '/';
          }else{
            $('#modalform').hide();
            $('.swal2-confirm').trigger('click');
            var splitter = response.split('|');
            if(splitter[0] == 1){
              var hasError = 'success';
              var hasTitle = 'Félicitation !';
            }else{
              var hasError = 'error';
              var hasTitle = 'Echec !';
            }
            swal.fire({
              title: hasTitle,
              text: splitter[1],
              icon: hasError,
              buttonsStyling: false,
              confirmButtonText: 'Fermer',
              customClass: {
                confirmButton: "btn btn-square font-weight-bold btn-light-success"
              }
            }).then(function(){
              location.reload();
            });
          }
        }
      });
    }
  });
});
//Modal Form
$(document).on('click', '.modalform', function(e){
  e.preventDefault();
  $('.msgError').html('');
  var datasT = $(this).attr('data-h');
  var submitbtn = $(this).attr('submitbtn');
  var splitter = datasT.split('|');
  if(splitter[0] == 0) var title = $(this).attr('title');
  else var title = $(this).attr('data-bs-original-title');
  if(splitter[2] != '') $('.modal-dialog').removeClass('mw-650px').addClass(splitter[2]);
  var datasT = {id:splitter[0]};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/'+ splitter[1],
    beforeSend: function(){
      $('#modalform').hide();
      Swal.fire({
        title: titleLoad,
        text: textLoad,
        timer: 50000,
        showConfirmButton: false,
      }).then((result) => {
        /* Read more about handling dismissals below */
        if(result.dismiss === Swal.DismissReason.timer){
          console.log('I was closed by the timer');
        }
      });
    },
    success:function(response){
      $('.swal2-confirm').trigger('click');
      if(response == 'x'){
        location.href = '/';
      }else{
        $('#titleForm').html(title);
        $('#bodyForm').html(response);
        $('.submitForm').html(submitbtn);
        $("#modalform").modal('show');
        $('.iCheck').iCheck({
          checkboxClass: 'icheckbox_square-blue',
          radioClass: 'iradio_square-blue',
          increaseArea: '20%'
        });
      }
    }
  });
});
//Modal Form
$(document).on('click', '.modaldetail', function(e){
  e.preventDefault();
  $('.msgError').html('');
  var datasT = $(this).attr('data-h');
  var splitter = datasT.split('|');
  if(splitter[0] == 0) var title = $(this).attr('title');
  else var title = $(this).attr('data-bs-original-title');
  if(splitter[2] != '') $('.modal-dialog').removeClass('mw-650px').addClass(splitter[2]);
  var datasT = {id:splitter[0]};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/'+ splitter[1],
    beforeSend: function(){
      $('#modaldetail').hide();
      Swal.fire({
        title: titleLoad,
        text: textLoad,
        timer: 50000,
        showConfirmButton: false,
      }).then((result) => {
        /* Read more about handling dismissals below */
        if(result.dismiss === Swal.DismissReason.timer){
          console.log('I was closed by the timer');
        }
      });
    },
    success:function(response){
      $('.swal2-confirm').trigger('click');
      if(response == 'x'){
        location.href = '/';
      }else{
        $('#titleDetail').html(title);
        $('#bodyDetail').html(response);
        $("#modaldetail").modal('show');
        $('.iCheck').iCheck({
          checkboxClass: 'icheckbox_square-blue',
          radioClass: 'iradio_square-blue',
          increaseArea: '20%'
        });
      }
    }
  });
});
//Form Add/Mod
$(document).on('click', '.submitForm', function(e){
  e.preventDefault();
  var iCheck = false;
  var hasError = false;
  $('.msgError').html('');
  var submitForm = $(this).html();
  $('.fieldError').removeClass('fieldError');
  var id = $('#id').val();
  var bill = $("input[name='val']:checked").val();
  var nameController = $('#nameController').val();
  var datasT = new FormData();
  $('.formField').find('input, select, textarea').each(function(){
    if($(this).is(':input:file')){
      if($(this).val() !== '') datasT.append(this.name, $(this)[0].files[0]);
    }else if($(this).is(':checkbox')){
      if($(this).is(':checked')){
        datasT.append(this.name, $(this).val());
        iCheck = true;
      }
    }else if($(this).is(':radio')){
      if($(this).is(':checked')){
        datasT.append(this.name, $(this).val());
        iCheck = true;
      }
    }else datasT.append(this.name, $(this).val());
  });
  datasT.append('btn', 'submitForm');
  $('.formField .requiredField').each(function(){
    if(jQuery.trim($(this).val()) === ''){
      $('.msgError').html("Veuillez renseigner les champs obligatoires !");
      $(this).addClass('fieldError');
      hasError = true;
    }else if((!hasError)&&($(this).hasClass('checked'))){
      if(!iCheck){
        $('.msgError').html('Veuillez cocher au moins une case.');
        $(this).addClass('fieldError');
        hasError = true;
      }
    }
  });
  $('.formField .number').each(function(){
    if(!hasError){
      var value = jQuery.trim($(this).val());
      var regex = /^[0-9\s]*$/;
      if((value != '')&&(!regex.test(value))){
        $('.msgError').html("Téléphone non valide.");
        $(this).addClass('fieldError');
        hasError = true;
      }
    }
  });
  $('.formField .email').each(function(){
    if(!hasError){
      var value = jQuery.trim($(this).val());
      var regex = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
      if((value != '')&&(!regex.test(value))){
        $(this).addClass('fieldError');
        $('.msgError').html("Adresse e-mail non valide.");
        hasError = true;
      }
    }
  });
  $('.formField .amount').each(function(){
    if(!hasError){
      var value = jQuery.trim($(this).val());
      var regex = /^[0-9\s]*$/;
      if((value != '')&&(value != 0)&&(!regex.test(value))){
        $('.msgError').html("Montant non valide.");
        $(this).addClass('fieldError');
        hasError = true;
      }
    }
  });
  $('.formField .comma').each(function(){
    if(!hasError){
      var value = jQuery.trim($(this).val());
      var regex = /^[0-9.\s]*$/;
      if((value != '')&&(!regex.test(value))){
        $('.msgError').html("Valeur non valide.");
        $(this).addClass('fieldError');
        hasError = true;
      }
    }
  });
  $('.formField .password').each(function(){
    if(!hasError){
      if($(this).val().length < 5){
        $('.msgError').html("Les mots de passe doivent être supérieur à 5 caractères");
        $(this).addClass('fieldError');
        hasError = true;
      }else if($('#newpass').val() !== $('#confirmpass').val()){
        $('.msgError').html("Les mots de passe ne sont pas identiques");
        $('#newpass, #confirmpass').addClass('fieldError');
        hasError = true;
      }
    }
  });
  if(!hasError){
    $.ajax({
      type: 'POST',
      data: datasT,
      contentType: false, 
      processData: false,
      url: '/'+ nameController,
      beforeSend: function(){
        $('.submitForm').addClass('not-active').html('<i class="fa fa-spinner fa-pulse"></i> Patienter...');
      },
      success:function(response){
        var splitter = response.split('|');
        if(splitter[0] == 'x'){
          location.href = '/';
        }else if(splitter[0] != 0){
          $('#modalform').hide();
          swal.fire({
            title: "Félicitation !",
            text: splitter[1],
            icon: 'success',
            buttonsStyling: false,
            confirmButtonText: "Fermer",
            customClass:{
              confirmButton: "btn btn-square font-weight-bold btn-light-success"
            }
          }).then(function(){
            if(bill == 4){
              Swal.fire({
                title: titleLoad,
                text: textLoad,
                timer: 50000,
                showConfirmButton: false,
              }).then((result) => {
                /* Read more about handling dismissals below */
                if(result.dismiss === Swal.DismissReason.timer){
                  console.log('I was closed by the timer');
                }
              });
              Pdfcreator('pdfbills', id);
            }
            if(splitter[0] == 1) location.reload();
            else location.href = '/';
          });
        }else{
          $('.msgError').html(splitter[1]);
          $(splitter[2]).addClass('fieldError');
          $('.submitForm').removeClass('not-active').addClass('btn-primary').html(submitForm);
        }
      }
    });
  }
});