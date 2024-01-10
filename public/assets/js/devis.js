//Saisi quantité
$(document).on('keyup', '.qte', function(){
  var current = $(this).parent('.col-sm-12').siblings();
  var qte = $(this).val() == '' ? 0:$(this).val();
  var price = current.find('.price').val() == '' ? 0:current.find('.price').val();
  if((qte != 0)&&(price != 0)){
    Totalamount(qte, price, current)
  }
});
//Saisi prix
$(document).on('keyup', '.price', function(){
  var current = $(this).parent('.col-sm-12').siblings();
  var price = $(this).val() == '' ? 0:$(this).val();
  var qte = current.find('.qte').val() == '' ? 0:current.find('.qte').val();
  if((qte != 0)&&(price != 0)){
    Totalamount(qte, price, current)
  }
});
//Calcul Total
function Totalamount(qte, price, current){
  var datasT = {qte:qte};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/qtevalue',
    success: function(response){
      var total = response * price;
      current.find('.total').val(total);
      TotalTyp();
    }
  });
}
//Modal Form
$(document).on('change', '.type_id', function(){
  var current = $(this);
  var id = $(this).val();
  var datasT = {id:id};
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
          options += '<option value="'+index+'">'+value+'</option>';
        });
        current.parent('.col-sm-12').siblings().find('.item_id').html(options);
      }
    }
  });
});
//Désignation
$(document).on('change', '.item_id', function(){
  var id = $(this).val();
  var type = $('#devtyp_id').val();
  $(this).siblings().find('.display').val(id);
  var current = $(this).parent('.col-sm-12').siblings();
  var mat = current.find('.material_id').val();
  var dia = current.find('.diameter_id').val();
  if((type != 2)||((type == 2)&&((mat != null)||(mat != undefined))&&((dia != null)||(dia != undefined)))) Priceamount(id, mat, dia, type, current);
});
//Désignation
$(document).on('change', '.material_id', function(){
  var mat = $(this).val();
  var current = $(this).parent('.col-sm-12').siblings();
  var id = current.find('.item_id').val();
  var dia = current.find('.diameter_id').val();
  if((id != null)&&(dia != null)) Priceamount(id, mat, dia, 2, current);
});
//Désignation
$(document).on('change', '.diameter_id', function(){
  var dia = $(this).val();
  var current = $(this).parent('.col-sm-12').siblings();
  var id = current.find('.item_id').val();
  var mat = current.find('.material_id').val();
  if((id != null)&&(mat != null)) Priceamount(id, mat, dia, 2, current);
});
//Calcul Price
function Priceamount(id, mat, dia, type, current){
  var qte = current.find('.qte').val();
  var valqte = qte == '' ? 0:qte;
  var datasT = {id:id, mat:mat, dia:dia, type:type};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/devprice',
    success: function(response){
      if(response == 'x'){
        location.href = '/';
      }else{
        var splitter = response.split('|');
        current.find('.unit').val(splitter[1]);
        current.find('.price').val(splitter[0]);
        var total = splitter[0] * valqte;
        current.find('.total').val(total);
        $('.qte, .unit, .price').removeAttr('readonly');
      }
    }
  });
}
//Modal Form
$('#client_id').on('change', function(){
  var client_id = $(this).val();
  Billaddrlist(client_id, billaddr_id);
});
//Profil form
function Billaddrlist(client_id, billaddr_id){
  var datasT = {id:client_id};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/billaddrlist',
    success: function(response){
      if(response == 'x'){
        location.href = '/';
      }else{
        var options = '<option value="" selected disabled>Sélectionner</option>';
        $.each(response, function(index, value){
          if(billaddr_id == index)
            var selected = 'selected';
          else
          var selected = '';
          options += '<option value="'+index+'" '+selected+'>'+value+'</option>';
        });
        $('#billaddr_id').html(options);
      }
    }
  });
}
//Modal Form
$(document).on('change', '#devtyp_id', function(){
  $('#solde').val(0);
  $('#content').val('');
  $('.remtyp').html(remtyp);
  var id = $(this).val();
  settinglist(id, 0);
  $('.addDev').removeClass('not-active').addClass('btn-primary');
});
//Add Line 
$(document).on('click', '.addDev', function(){
  var id = $('#devtyp_id').val();
  settinglist(id, 1);
});
//Designation Liste
function settinglist(id, type){
  var hasError = false;
  if(type == 1){
    $('.msgError').html('');
    $('.requiredField').removeClass('fieldError');
    $('.form-command .requiredField').each(function(){
      if(jQuery.trim($(this).val()) === ''){
        $('.msgError').html('Veuillez renseigner les champs obligatoires !');
        $(this).addClass('fieldError');
        hasError = true;
      }
    });
  }
  if(!hasError){
    var datasT = {id:id};
    $.ajax({
      type: 'POST',
      data: datasT,
      url: '/settinglist',
      success: function(response){
        if(response == 'x'){
          location.href = '/';
        }else{
          var splitter = response.split('|');
          if(id == 2){
            if(type == 0){
              var contentApp = '<datalist id="qte"></datalist><div class="row mb-5"><div class="col-sm-12 col-xl-2 position-relative"><label class="form-check form-check-custom form-check-solid position-absolute top-50 formcheck"><input class="form-check-input h-20px w-20px display" type="checkbox" name="display[]"></label><label class="form-label fw-bolder text-dark fs-6 required">Type</label><select class="form-control form-select form-control-solid type_id" aria-label="Select example">'+splitter[0]+'</select></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Libellé</label><select name="item_id[]" class="form-control form-select form-control-solid item_id requiredField" aria-label="Select example"><option value="" selected disabled>Sélectionner</option></select></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Matière</label><select name="material_id[]" class="form-control form-select form-control-solid material_id requiredField" aria-label="Select example">'+splitter[1]+'</select></div><div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6 required">Diamètre</label><select name="diameter_id[]" class="form-control form-select form-control-solid diameter_id space requiredField" aria-label="Select example">'+splitter[2]+'</select></div><div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6 required">PU</label><input type="text" name="price[]" placeholder="0" class="form-control form-control-solid space text-center requiredField amount price" readonly /></div><div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6 required">Qté</label><input type="text" name="qte[]" list="qte" placeholder="0" class="form-control form-control-solid space text-center requiredField qte" readonly /></div><div class="col-sm-12 col-xl-1"><label class="form-label fw-bolder text-dark fs-6">Unité</label><input type="text" name="unit[]" class="form-control form-control-solid space text-center unit" readonly /></div><div class="col-sm-12 col-xl-2 position-relative"><label class="form-label fw-bolder text-dark fs-6 required">Total</label><input type="text" value="0" class="form-control form-control-solid requiredField text-center w-85 total" readonly /><a href="#" class="btn btn-icon position-absolute bottom-0 end-0 pe-none"><i class="ki-duotone ki-trash text-dark fs-1"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span><span class="path5"></span></i></a></div></div>';
              $('.form-command').html(contentApp);
            }else{
              var contentApp = '<div class="row mb-5"><div class="col-sm-12 col-xl-2 position-relative"><label class="form-check form-check-custom form-check-solid position-absolute formcheck"><input class="form-check-input h-20px w-20px display" type="checkbox" name="display[]"></label><select class="form-control form-select form-control-solid type_id" aria-label="Select example">'+splitter[0]+'</select></div><div class="col-sm-12 col-xl-2"><select name="item_id[]" class="form-control form-select form-control-solid item_id requiredField" aria-label="Select example"><option value="" selected disabled>Sélectionner</option></select></div><div class="col-sm-12 col-xl-2"><select name="material_id[]" class="form-control form-select form-control-solid material_id requiredField" aria-label="Select example">'+splitter[1]+'</select></div><div class="col-sm-12 col-xl-1"><select name="diameter_id[]" class="form-control form-select form-control-solid diameter_id space requiredField" aria-label="Select example">'+splitter[2]+'</select></div><div class="col-sm-12 col-xl-1"><input type="text" name="price[]" placeholder="0" class="form-control form-control-solid space text-center requiredField amount price" readonly /></div><div class="col-sm-12 col-xl-1"><input type="text" name="qte[]" list="qte" placeholder="0" class="form-control form-control-solid space text-center requiredField qte" readonly /></div><div class="col-sm-12 col-xl-1"><input type="text" name="unit[]" class="form-control form-control-solid space text-center unit" readonly /></div><div class="col-sm-12 col-xl-2 position-relative"><input type="text" value="0" class="form-control form-control-solid requiredField text-center w-85 total" readonly /><a href="#" class="btn btn-icon btn-flex btn-active-light-danger position-absolute bottom-0 end-0 delDev" data-bs-toggle="tooltip" aria-label="Supprimer" data-bs-original-title="Supprimer" data-kt-initialized="1"><i class="ki-duotone ki-trash text-danger fs-1"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span><span class="path5"></span></i></a></div></div>';
              $('.form-command').append(contentApp);
              ++countApp;
              TotalTyp();
            }
          }else{
            if(type == 0){
              var contentApp = '<datalist id="qte"></datalist><div class="row mb-5"><div class="col-sm-12 col-xl-4 position-relative"><label class="form-check form-check-custom form-check-solid position-absolute top-50 formcheck"><input class="form-check-input h-20px w-20px display" type="checkbox" name="display[]"></label><label class="form-label fw-bolder text-dark fs-6 required">Designation</label><select name="item_id[]" class="form-control form-select form-control-solid requiredField item_id" aria-label="Select example">'+splitter[0]+'</select></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Prix unitaire</label><input type="text" name="price[]" placeholder="0" class="form-control form-control-solid requiredField text-center amount price" onKeyUp="verif_num(this)" readonly /></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Qté</label><input type="text" name="qte[]" list="qte" placeholder="0" class="form-control form-control-solid requiredField text-center qte space" readonly /></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6">Unité</label><input type="text" name="unit[]" class="form-control form-control-solid text-center unit space" readonly /></div><div class="col-sm-12 col-xl-2 position-relative"><label class="form-label fw-bolder text-dark fs-6 required">Total</label><input type="text" value="0" class="form-control form-control-solid requiredField text-center w-85 total" readonly /><a href="#" class="btn btn-icon position-absolute bottom-0 end-0 pe-none"><i class="ki-duotone ki-trash text-dark fs-1"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span><span class="path5"></span></i></a></div></div>';
              $('.form-command').html(contentApp);
            }else{
              var contentApp = '<div class="row mb-5"><div class="col-sm-12 col-xl-4 position-relative"><label class="form-check form-check-custom form-check-solid position-absolute formcheck"><input class="form-check-input h-20px w-20px display" type="checkbox" name="display[]"></label><select name="item_id[]" class="form-control form-select form-control-solid requiredField item_id" aria-label="Select example">'+splitter[0]+'</select></div><div class="col-sm-12 col-xl-2"><input type="text" name="price[]" placeholder="0" class="form-control form-control-solid text-center requiredField amount price" readonly /></div><div class="col-sm-12 col-xl-2"><input type="text" name="qte[]" list="qte" placeholder="0" class="form-control form-control-solid text-center requiredField qte space" readonly /></div><div class="col-sm-12 col-xl-2"><input type="text" name="unit[]" class="form-control form-control-solid text-center unit space" readonly /></div><div class="col-sm-12 col-xl-2 position-relative"><input type="text" value="0" class="form-control form-control-solid requiredField text-center w-85 total" readonly /><a href="#" class="btn btn-icon btn-flex btn-active-light-danger position-absolute bottom-0 end-0 delDev" data-bs-toggle="tooltip" aria-label="Supprimer" data-bs-original-title="Supprimer" data-kt-initialized="1"><i class="ki-duotone ki-trash text-danger fs-1"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span><span class="path5"></span></i></a></div></div>';
              $('.form-command').append(contentApp);
              ++countApp;
              TotalTyp();
            }
          }
          if(type == 0){
            $.ajax({
              type: 'GET',
              url: '/quantitylist',
              success: function(response){
                var options = '';
                $.each(response, function(value){
                  options += '<option value="'+value+'">';
                });
                $('#qte').html(options);
              }
            });
          }
        }
      }
    });
  }
}
//Supprimer la ligne d'Appareil
$(document).on('click', '.delDev', function(e){
  e.preventDefault();
  $('#msgError').html('');
  $(this).parents('.row').remove();
  $('.submitDev').removeClass('not-active').addClass('btn-success').html('<i class="ki-duotone ki-triangle fs-2"><span class="path1"></span><span class="path2"></span><span class="path3"></span></i>Valider');
  --countApp;
  TotalTyp();
});
//Saisi Remise
$(document).on('keyup', '#mtremtyp', function(){
  TotalTyp();
});
//Total cmd
function TotalTyp(){
  var total = 0;
  $('.form-command .total').each(function(){
    if(jQuery.trim($(this).val()) !== 0){
      total += ($(this).val() * 1);
    }
  });
  var amount = $('#mtremtyp').val();
  var mtrem = amount == '' ? 0:amount;
  var remise = (total * mtrem) / 100;
  var solde = total - remise;
  $('#solde').val(solde);
}
//Ligne devis
function Devismod(id){
  var datasT = {id:id};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/devismod',
    beforeSend: function(){
      $('.datadevis').html('<tr><td colspan="4" class="text-center"><i class="fa fa-spinner fa-pulse text-primary fa-5x"></i></td></tr>');
    },
    success: function(response){
      $('.datadevis').html(response);
    }
  });
}
//Modif des lignes
$(document).on('click', '.devlinemod', function(e){
  e.preventDefault();
  var devttr = $(this).attr('devttr');
  $('#devttr_id').val(devttr);
  var devtyp = $(this).attr('devtyp');
  var datasT = {devttr_id:devttr, devtyp_id:devtyp};
  $.ajax({
    type: 'POST',
    data: datasT,
    url: '/devlinemod',
    beforeSend: function(){
      $('.addDev').addClass('not-active');
      $('.submitDev').addClass('not-active').html('<i class="fa fa-spinner fa-pulse"></i> Patienter...');
    },
    success:function(response){
      var splitter = response.split('|');
      $('#title').val(splitter[0]);
      $('#devtyp_id').html('<option value="'+devtyp+'">'+splitter[1]+'</option>');
      $('#content').html(splitter[2]);
      $('#solde').val(splitter[3]);
      $('#mtremtyp').val(splitter[4]);
      if(splitter[5] == 1) $('#seeremtyp').attr('checked', 'checked');
      if(splitter[6] != '') $('.form-command').html(splitter[6]);
      $('.devttr').attr('checked', 'checked').removeAttr('disabled');
      $('.addDev').removeClass('not-active').addClass('btn-primary');
      $('.submitDev').removeClass('not-active').addClass('btn-success').html('<i class="ki-duotone ki-triangle fs-2"><span class="path1"></span><span class="path2"></span><span class="path3"></span></i>Valider');
      $('.scrolltop').trigger('click');
    }
  });
  $.ajax({
    type: 'GET',
    url: '/quantitylist',
    success: function(response){
      var options = '';
      $.each(response, function(value){
        options += '<option value="'+value+'">';
      });
      $('#qte').html(options);
    }
  });
});
//Form Ligne Devis
$(document).on('click', '.submitDev', function(e){
  e.preventDefault();
  var hasError = false;
  $('.msgError').removeAttr('style').html('');
  var submitDev = $(this).html();
  $('.fieldError').removeClass('fieldError');
  var datasT = new FormData();
  $('.formField').find('input, select, textarea').each(function(){
    if($(this).is(':checkbox')){
      if($(this).is(':checked')){
        datasT.append(this.name, $(this).val());
      }
    }else if($(this).is(':radio')){
      if($(this).is(':checked')){
        datasT.append(this.name, $(this).val());
      }
    }else datasT.append(this.name, $(this).val());
  });
  $('.formField .requiredField').each(function(){
    if(jQuery.trim($(this).val()) === ''){
      $('.msgError').html("Veuillez renseigner les champs obligatoires !");
      $(this).addClass('fieldError');
      hasError = true;
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
  if(!hasError){
    $.ajax({
      type: 'POST',
      data: datasT,
      contentType: false, 
      processData: false,
      url: '/deviscreate',
      beforeSend: function(){
        $('.addDev').addClass('not-active');
        $('.submitDev').addClass('not-active').html('<i class="fa fa-spinner fa-pulse"></i> Patienter...');
      },
      success:function(response){
        var splitter = response.split('|');
        if(splitter[0] == 'x'){
          location.href = '/';
        }else if(splitter[0] != 0){
          $('#solde').val(0);
          $('#content').val('');
          $('.remtyp').html(remtyp);
          $('#id').val(splitter[2]);
          $('.mt_ht').html(splitter[3]);
          $('.mt_ttc').html(splitter[4]);
          $('#old_rem').val(splitter[7]);
          $('#old_tva').val(splitter[8]);
          $('#mt_euro').val(splitter[5]);
          $('#devttr_id').val(splitter[6]);
          Pdfcreator('pdfdevis', splitter[2]);
          $('.msgError').css('color', '#47BE7D').html(splitter[1]);
          $('.devttr').attr('checked', 'checked').removeAttr('disabled');
          $('#devtyp_id').html('<option value="" selected="" disabled="">Sélectionner</option><option value="1">TRAVAUX</option><option value="2">FOURNITURES</option><option value="3">TRANSPORT</option>');
          var contentApp = '<datalist id="qte"></datalist><div class="row mb-5 devistype"><div class="col-sm-12 col-xl-4 position-relative"><label class="form-check form-check-custom form-check-solid position-absolute top-50 formcheck"><input class="form-check-input h-20px w-20px display" type="checkbox" name="display[]"></label><label class="form-label fw-bolder text-dark fs-6 required">Designation</label><select name="item_id[]" class="form-control form-select form-control-solid item_id" aria-label="Select example">Sélectionner</select></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Prix unitaire</label><input type="text" name="price[]" placeholder="0" class="form-control form-control-solid text-center amount price" onKeyUp="verif_num(this)" readonly /></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6 required">Qté</label><input type="text" name="qte[]" list="qte" placeholder="0" class="form-control form-control-solid text-center qte space" readonly /></div><div class="col-sm-12 col-xl-2"><label class="form-label fw-bolder text-dark fs-6">Unité</label><input type="text" name="unit[]" class="form-control form-control-solid text-center unit space" readonly /></div><div class="col-sm-12 col-xl-2 position-relative"><label class="form-label fw-bolder text-dark fs-6 required">Total</label><input type="text" value="0" class="form-control form-control-solid text-center w-85 total" readonly /><a href="#" class="btn btn-icon position-absolute bottom-0 end-0 pe-none"><i class="ki-duotone ki-trash text-dark fs-1"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span><span class="path5"></span></i></a></div></div>';
          $('.form-command').html(contentApp);
          //Ligne devis
          Devismod(splitter[2]);
        }else{
          $('.msgError').html(splitter[1]);
        }
        $('.submitDev').removeClass('not-active').addClass('btn-success').html(submitDev);
      }
    });
  }
});
//Date picker
$('#date_at').daterangepicker({
  singleDatePicker: true,
  showDropdowns: true,
  minYear: 2023,
  maxDate: moment(),
  autoApply:true,
  "locale": {
    "format": "DD-MM-YYYY",
    "separator": "-",
    "daysOfWeek": [
        "Dim",
        "Lun",
        "Mar",
        "Mer",
        "Jeu",
        "Ven",
        "Sam"
    ],
    "monthNames": [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Jullet",
      "Août",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre"
    ],
  }
});