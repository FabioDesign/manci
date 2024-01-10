@extends('layouts.master')

@section('content')
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
            <th>Validé par</th>
            <th class="text-center">Voir</th>
          </tr>
        </thead>
        <tbody>
          @php $i = 1; @endphp
          @foreach($query as $data)
          @php $prenom = Str::of($data->firstname)->explode(' '); @endphp
          <tr>
            <td>{{ $i++ }}</td>
            <td>{{ $data->libelle }}</td>
            <td class="text-center">{{ $data->reference }}</td>
            <td class="text-center">{{ number_format($data->mt_ttc, 0, ',', '.') }}</td>
            <td class="text-center">{{ Myhelper::formatDateFr($data->validated_at) }}</td>
            <td>{{ $prenom[0].' '.$data->lastname }}</td>
            <td class="text-center">
              <a href="/assets/media/billings/{{ 'bill-'.$data->filename }}" target="_blank" class="me-1" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Voir le devis"><i class="fa-solid fa-file-pdf fa-size text-primary"></i></a>
            </td>
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