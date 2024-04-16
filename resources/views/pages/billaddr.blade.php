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
            <th>Client</th>
            <th>Titre</th>
            <th class="text-center">Date</th>
            <th class="text-center">Statut</th>
            <th class="text-center">Action</th>
          </tr>
        </thead>
        <tbody>
          @php
            $i = 1;
            foreach($query as $data):
            if($data->status == 1){
              $icone = 'ban';
              $status = 'Activé';
              $titre = 'Désactivation';
              $color = 'link-danger';
              $badge = 'badge-light-success';
            }else{
              $icone = 'check';
              $status = 'Désactivé';
              $titre = 'Activation';
              $color = 'link-success';
              $badge = 'badge-light-danger';
            }
          @endphp
          <tr>
            <td>{{ $i++ }}</td>
            <td>{{ $data->client }}</td>
            <td>{{ $data->libelle }}</td>
            <td class="text-center">{{ Myhelper::formatDateFr($data->created_at) }}</td>
            <td class="text-center"><span data-kt-element="status" class="badge {{ $badge }}">{{ $status }}</span></td>
            <td class="text-center">
              <a href="#" class="modaldetail" data-h="{{ $data->id }}|billaddrform|" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Détail Adresse Facturaction"><i class="fab fa-wpforms fa-size text-primary"></i></a>&nbsp;
              @if(in_array(3, Session::get('rights')[10]))
              <a href="#" class="modalform" data-h="{{ $data->id }}|billaddrform|" data-bs-toggle="tooltip" data-bs-theme="dark" data-bs-placement="top" title="Modifier Adresse Facturaction" submitbtn="Modifier"><i class="fas fa-edit fa-size text-warning"></i></a>
              @else
              <a href="#"><i class="fas fa-edit fa-size text-muted"></i></a>
              @endif
              @if(in_array(4, Session::get('rights')[10]))
              <a href="#" class="status" data-h="{{ $data->id.'|'.$data->status.'|10' }}" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="{{ $titre }} Adresse Facturaction"><i class="fas fa-{{ $icone }} fa-size {{ $color }}"></i></a>
              @else
              <a href="#"><i class="fas fa-{{ $icone }} fa-size text-muted"></i></a>
              @endif
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