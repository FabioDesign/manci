@extends('layouts.master')

@section('content')
  <!--begin::Row-->
  <div class="row g-5 g-xl-10 mb-5 mb-xl-10">
    <!--begin::Col-->
    <div class="col-xl-2">
        <a href="/dashboard/0">
            <!--begin::Card widget 3-->
            <div class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-xl-10 bg-primary">
                <!--begin::Card body-->
                <div class="card-body align-items-end mb-3">
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-1 text-white fw-bold">Brouillon</span>
                    </div>
                    <!--end::Info-->
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-4hx text-white fw-bold" data-kt-countup="true" data-kt-countup-value="{{ $draft  }}">0</span>
                    </div>
                    <!--end::Info-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card widget 3-->
        </a>
    </div>
    <!--end::Col-->
    <!--begin::Col-->
    <div class="col-xl-2">
        <a href="/dashboard/1">
            <!--begin::Card widget 3-->
            <div class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-xl-10 bg-warning">
                <!--begin::Card body-->
                <div class="card-body align-items-end mb-3">
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-1 text-white fw-bold">Transmis</span>
                    </div>
                    <!--end::Info-->
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-4hx text-white fw-bold" data-kt-countup="true" data-kt-countup-value="{{ $pending }}">0</span>
                    </div>
                    <!--end::Info-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card widget 3-->
        </a>
    </div>
    <!--end::Col-->
    <!--begin::Col-->
    <div class="col-xl-2">
        <a href="/dashboard/2">
            <!--begin::Card widget 3-->
            <div class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-xl-10 bg-success">
                <!--begin::Card body-->
                <div class="card-body align-items-end mb-3">
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-1 text-white fw-bold">Approuvé</span>
                    </div>
                    <!--end::Info-->
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-4hx text-white fw-bold" data-kt-countup="true" data-kt-countup-value="{{ $approved }}">0</span>
                    </div>
                    <!--end::Info-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card widget 3-->
        </a>
    </div>
    <!--end::Col-->
    <!--begin::Col-->
    <div class="col-xl-2">
        <a href="/dashboard/3">
            <!--begin::Card widget 3-->
            <div class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-xl-10 bg-danger">
                <!--begin::Card body-->
                <div class="card-body align-items-end mb-3">
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-1 text-white fw-bold">Rejeté</span>
                    </div>
                    <!--end::Info-->
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-4hx text-white fw-bold" data-kt-countup="true" data-kt-countup-value="{{ $rejected }}">0</span>
                    </div>
                    <!--end::Info-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card widget 3-->
        </a>
    </div>
    <!--end::Col-->
    <!--begin::Col-->
    <div class="col-xl-2">
        <a href="/dashboard/4">
            <!--begin::Card widget 3-->
            <div class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-xl-10 bg-success">
                <!--begin::Card body-->
                <div class="card-body align-items-end mb-3">
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-1 text-white fw-bold">Validé</span>
                    </div>
                    <!--end::Info-->
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-4hx text-white fw-bold" data-kt-countup="true" data-kt-countup-value="{{ $validated }}">0</span>
                    </div>
                    <!--end::Info-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card widget 3-->
        </a>
    </div>
    <!--end::Col-->
    <!--begin::Col-->
    <div class="col-xl-2">
        <a href="/dashboard/5">
            <!--begin::Card widget 3-->
            <div class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-xl-10 bg-danger">
                <!--begin::Card body-->
                <div class="card-body align-items-end mb-3">
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-1 text-white fw-bold">Annulé</span>
                    </div>
                    <!--end::Info-->
                    <!--begin::Info-->
                    <div class="text-center">
                        <span class="fs-4hx text-white fw-bold" data-kt-countup="true" data-kt-countup-value="{{ $canceled }}">0</span>
                    </div>
                    <!--end::Info-->
                </div>
                <!--end::Card body-->
            </div>
            <!--end::Card widget 3-->
        </a>
    </div>
    <!--end::Col-->
</div>
<!--end::Row-->
<!--begin::Card-->
<div class="card">
    <!--begin::Card body-->
    <div class="card-body py-4">
      <!--begin::Table-->
      <table id="kt_datatable" class="table table-striped table-row-bordered gy-5 gs-7 border rounded">
        <thead>
          <tr class="fw-bolder fs-6 text-gray-800 px-7">
            <th>#</th>
            <th>Adresse de facturation</th>
            <th class="text-center">Réference</th>
            <th class="text-center">Total</th>
            <th class="text-center">Date</th>
            <th>Initié par</th>
            <th class="text-center">Statut</th>
          </tr>
        </thead>
        <tbody>
          @php
            $i = 1;
            foreach($query as $data):
            switch($data->status){
              case 0 : $status = 'Brouillon'; $badge = 'badge-light-primary'; break;
              case 1 : $status = 'Transmis'; $badge = 'badge-light-warning'; break;
              case 2 : $status = 'Approuvé'; $badge = 'badge-light-success'; break;
              case 3 : $status = 'Rejeté'; $badge = 'badge-light-danger'; break;
              case 4 : $status = 'Validé'; $badge = 'badge-light-success'; break;
              case 5 : $status = 'Refusé'; $badge = 'badge-light-danger'; break;
              default : $status = $badge = '';
            }
            $prenom = Str::of($data->firstname)->explode(' ');
          @endphp
          <tr>
            <td>{{ $i++ }}</td>
            <td>{{ $data->libelle }}</td>
            <td class="text-center">{{ $data->reference }}</td>
            <td class="text-center">{{ number_format($data->mt_ttc, 0, ',', '.') }}</td>
            <td class="text-center">{{ Myhelper::formatDateFr($data->date_at) }}</td>
            <td>{{ $prenom[0].' '.$data->lastname }}</td>
            <td class="text-center"><span data-kt-element="status" class="badge {{ $badge }}">{{ $status }}</span></td>
          </tr>
          @php endforeach; @endphp
        </tbody>
      </table>
      <!--end::Table-->
    </div>
    <!--end::Card body-->
  </div>
  <!--end::Card-->
@endsection