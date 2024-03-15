@extends('layouts.master')

@section('content')
  <!--begin::Card-->
  <div class="card card-flush">
    <!--begin::Card header-->
    <div class="card-header mt-6">
      <!--begin::Card title-->
      <div class="card-title">
        <!--begin::Search-->
        <form autocomplete="off" method="POST" action="/logs">
          @csrf
          <div class="d-flex align-items-center position-relative my-1 me-5">
            <i class="ki-duotone ki-calendar-8 fs-3 position-absolute ms-5">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
              <span class="path5"></span>
              <span class="path6"></span>
            </i>
            <input type="text" name="date" value="{{ $date }}" data-kt-permissions-table-filter="search" class="form-control form-control-solid w-200px ps-13 datepicker" readonly />
            <button type="submit" id="show" name="show" class="btn btn-square btn-primary font-weight-bold ms-5">Afficher</button>
          </div>
        </form>
        <!--end::Search-->
      </div>
      <!--end::Card title-->
    </div>
    <!--end::Card header-->
    <!--begin::Card body-->
    <div class="card-body py-4">
      <!--begin::Table-->
      <table class="table align-middle table-row-dashed fs-6 gy-5 mb-0" id="kt_permissions_table">
        <thead>
          <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
            <th class="min-w-150px w-100px">Utilisateur</th>
            <th class="min-w-100px w-50px text-center">Action</th>
            <th class="min-w-300px w-475px">Nom</th>
            <th class="min-w-100px w-150px text-center">Date</th>
          </tr>
        </thead>
        <tbody class="fw-semibold text-gray-600">
          @php $i = 1; @endphp
          @foreach($query as $data)
          <tr>
            <td class="d-flex align-items-center">
              <!--begin:: Avatar -->
              <div class="symbol symbol-circle symbol-50px overflow-hidden me-3">
                <a href="#">
                  <div class="symbol-label">
                    <img src="/assets/media/avatars/{{ $data->avatar }}" alt="{{ $data->username }}" class="w-100" />
                  </div>
                </a>
              </div>
              <!--end::Avatar-->
              <!--begin::User details-->
              <div class="d-flex flex-column">
                <a href="#" class="text-gray-800 text-hover-primary mb-1">{{ $data->username }}</a>
                <span>{{ $data->profil }}</span>
              </div>
              <!--begin::User details-->
            </td>
            <td class="text-center"><span class="badge badge-light-{{ $data->color }} fw-bold px-4 py-3">{{ $data->action }}</span></td>
            <td>{{ $data->libelle }}</td>
            <td class="text-center text-end">{{ Myhelper::formatDateFr($data->created_at) }}</td>
          </tr>
          @endforeach
        </tbody>
      </table>
      <!--end::Table-->
    </div>
    <!--end::Card body-->
  </div>
  <!--end::Card-->
@endsection

@section('scripts')
	<script src="/assets/js/custom/apps/user-management/permissions/list.js"></script>
  <script>
    $('#show').on('click', function(){
      $('#show').addClass('not-active').html('<i class="fa fa-spinner fa-pulse"></i> Patienter...');
    });
    //Date picker
    $(".datepicker").daterangepicker({
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
  </script>
@endsection