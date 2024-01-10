"use strict";

// Class definition
var KTSigninGeneral = function(){
    // Elements
    var form;
    var submitButton;
    var validator;

    // Handle form
    var handleValidation = function(e){
        $('.msgError').html('');
        // Init form validation rules. For more info check the FormValidation plugin's official documentation:https://formvalidation.io/
        validator = FormValidation.formValidation(
			form, {
				fields: {
					'login': {
                        validators: {
							notEmpty: {
								message: 'Login est obligatoire'
							}
						}
					},
                    'password': {
                        validators: {
                            notEmpty: {
                                message: 'Le mot de passe est obligatoire'
                            }
                        }
                    } 
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					bootstrap: new FormValidation.plugins.Bootstrap5({
                        rowSelector: '.fv-row',
                        eleInvalidClass: '',  // comment to enable invalid state icons
                        eleValidClass: '' // comment to enable valid state icons
                    })
				}
			}
		);	
    }

    var handleSubmitAjax = function(e){
        // Handle form submit
        submitButton.addEventListener('click', function(e){
            // Prevent button default action
            e.preventDefault();
            
            // Validate form
            validator.validate().then(function(status){
                if(status == 'Valid'){
                    // Show loading indication
                    submitButton.setAttribute('data-kt-indicator', 'on');

                    // Disable button to avoid multiple click 
                    submitButton.disabled = true;
                    

                    // Simulate ajax request
                    setTimeout(function(){
                        // Hide loading indication
                        submitButton.removeAttribute('data-kt-indicator');

                        // Enable button
                        submitButton.disabled = false;
                        
                        var dataString = new FormData();
                        $('#kt_sign_in_form').find('input').each(function(){
                            dataString.append(this.name, $(this).val()); 
                        });
                        //X-CSRF-TOKEN
                        $.ajaxSetup({
                          headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                          }
                        });
                        $.ajax({
                            type: 'POST',
                            data: dataString,
                            contentType: false, 
                            processData: false,
                            url: '/login',
                            beforeSend: function(){
                              $('#kt_sign_in_submit').addClass('not-active');
                            },
                            success:function(response){
                                var splitter = response.split('|');
                                if(splitter[0] == 1){
                                    location.href = splitter[1];
                                }else{
                                    $('.msgError').html(splitter[1]);
                                    $('#kt_sign_in_submit').removeClass('not-active').addClass('btn-primary')
                                }
                            }
                        });
                    }, 2000);   						
                }else{
                    // Show error popup. For more info check the plugin's official documentation: https://sweetalert2.github.io/
                    $('.msgError').html("Service indisponible, veuillez réessayer plus tard !");
                }
            });
		});
    }

    // Public functions
    return {
        // Initialization
        init: function(){
            form = document.querySelector('#kt_sign_in_form');
            submitButton = document.querySelector('#kt_sign_in_submit');
            
            handleValidation();
            handleSubmitAjax(); // used for demo purposes only, ifyou use the below ajax version you can uncomment this one
        }
    };
}();

// On document ready
KTUtil.onDOMContentLoaded(function(){
    KTSigninGeneral.init();
});
