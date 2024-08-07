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
            <th rowspan="2" class="align-middle">#</th>
            <th rowspan="2" class="align-middle">Catégorie</th>
            <th colspan="3" class="text-center bg-dark text-white">DESIGNATION</th>
            <th rowspan="2" class="align-middle text-center">Prix achat</th>
            <th rowspan="2" class="align-middle text-center">P.U.</th>
            <th rowspan="2" class="align-middle text-center">Unité de mesure</th>
            <th rowspan="2" class="align-middle text-center">Date</th>
            <th rowspan="2" class="align-middle text-center">Action</th>
          </tr>
          <tr class="fw-bolder text-gray-800 px-7">
            <th>Nom commercial</th>
            <th class="text-center">Matière</th>
            <th class="text-center">Dimension</th>
          </tr>
        </thead>
        <tbody>
          @php $i = 1; @endphp
          @foreach($query as $data)
          <tr>
            <td>{{ $i++ }}</td>
            <td>{{ $data->type }}</td>
            <td>{{ $data->suppllib }}</td>
            <td class="text-center">{{ $data->material }}</td>
            <td class="text-center">{{ $data->diameter }}</td>
            <td class="text-center">{{ number_format($data->cost, 0, '', '.') }}</td>
            <td class="text-center">{{ number_format($data->amount, 0, '', '.') }}</td>
            <td class="text-center">{{ $data->unit }}</td>
            <td class="text-center">{{ Myhelper::formatDateFr($data->created_at) }}</td>
            <td class="text-center">
              @if(in_array(3, Session::get('rights')[22]))
              <a href="#" class="modalform" data-h="{{ $data->id }}|supplieform|" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Modifier la Désignation" submitbtn="Modifier"><i class="fas fa-edit fa-size text-warning"></i></a>
              @else
              <a href="#"><i class="fas fa-edit fa-size text-muted"></i></a>
              @endif
              @if((in_array(8, Session::get('rights')[22]))&&(Myhelper::searchDevtyp($data->id, 2) == 0))
              <a href="#" class="status" data-h="{{ $data->id.'|2|22' }}" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Supprimer la Désignation"><i class="fas fa-trash-alt fa-size text-danger"></i></a>
              @else
              <a href="#"><i class="fas fa-trash-alt fa-size text-muted"></i></a>
              @endif
            </td>
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