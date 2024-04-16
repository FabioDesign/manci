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
            <th>Créé par</th>
            <th class="text-center">Statut</th>
            <th class="text-center">Action</th>
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
            <td class="text-center">
              @if(in_array(6, Session::get('rights')[18]))
              <a href="/assets/media/billings/{{ 'dev-'.$data->filename }}" target="_blank" class="me-1" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Voir le devis"><i class="fa-solid fa-file-pdf fa-size text-primary"></i></a>
              @endif
              @if(((in_array(3, Session::get('rights')[18]))&&($data->status == 0))||((in_array(6, Session::get('rights')[18]))&&($data->status == 1)))
              <a href="/devisform/{{ $data->id }}" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Modifier le devis" submitbtn="Modifier le devis"><i class="fas fa-edit fa-size text-warning"></i></a>
              @else
              <a href="#"><i class="fas fa-edit fa-size text-muted"></i></a>
              @endif
              @if((in_array(5, Session::get('rights')[18]))&&($data->status == 0))
              <a href="#" class="status" data-h="{{ $data->id }}|0|18" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Transmettre le devis"><i class="fas fa-paper-plane fa-size text-success"></i></a>
              @endif
              @if((in_array(6, Session::get('rights')[18]))&&($data->status == 1))
              <a href="#" class="modalform" data-h="{{ $data->id }}|devstatus|modal-md" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Approuver/Rejeter le devis"><i class="far fa-question-circle fa-size text-danger"></i></a>
              @endif
              @if((in_array(7, Session::get('rights')[18]))&&($data->status == 2))
              <a href="#" class="modalform" data-h="{{ $data->id }}|devstatus|modal-md" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Valider/Refuser le devis"><i class="far fa-question-circle fa-size text-danger"></i></a>
              @endif
              @if((in_array(8, Session::get('rights')[18]))&&($data->status == 0))
              <a href="#" class="status" data-h="{{ $data->id.'|1|18' }}" data-bs-toggle="tooltip" data-bs-theme="tooltip-dark" data-bs-placement="top" title="Supprimer le devis"><i class="fas fa-trash-alt fa-size text-danger"></i></a>
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