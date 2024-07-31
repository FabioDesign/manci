<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Devis</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <style>
      @page {
        margin: 100px 25px 80px;
      }
      body {
        font-size: 9pt;
        font-family: "Times New Roman", Times, serif;
      }
      header {
        position: fixed;
        top: -100px;
        left: 0px;
        right: 0px;
        height: 100px;
        text-align: center;
        background-image: url({{ $devis->header }});
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center center;
      }
      footer {
        position: fixed;
        bottom: -80px;
        left: 0px;
        right: 0px;
        height: 80px;
        text-align: center;
        border-top: 1px solid #D4891D !important;
      }
      .content {
        margin-top: 10px;
        margin-bottom: 10px;
      }
      table.devTable {
        border: 1px solid #000;
        border-collapse: collapse;
      }
      table.devTable th {
        padding: 3px 2px;
        border-spacing: 0;
        border: 1px solid #000;
      }
      table.devTable td {
        padding: 3px 2px;
        border-spacing: 0;
        border-left: 1px solid #000;
        border-right: 1px solid #000;
      }
      .noborder td, .noborder th {
        border: none !important;
      }
      .border-top {
        border-top: 1px solid #000 !important;
      }
      .border-bottom {
        border-bottom: 1px solid #000 !important;
      }
    </style>
  </head>
  <body>
    <header></header>
    <footer>{!! nl2br($devis->footer) !!}</footer>
    <div class="content">
      <table class="table noborder">
        <tbody>
          <tr>
            <td width="50%">
              @if($devis->libship != '')
                NAVIRE<br><strong>{{ $devis->libship }}</strong>
              @else
                <strong>{{ $devis->bill_addr }}</strong><br>
                {!! nl2br($devis->content) !!}
              @endif
            </td>
            <td width="50%" class="text-end">
              Date : {{ Myhelper::datejour($devis->date_at) }}<br><br>
              Devis N° {{ $devis->reference }}
            </td>
          </tr>
        </tbody>
      </table>
      <table class="table devTable">
        <thead>
          <tr>
            <th width="67%" class="text-center">DESIGNATION</th>
            <th width="5%" class="text-center">QTE</th>
            <th width="5%" class="text-center">UoM</th>
            <th width="9%" class="text-center">P.U.</th>
            <th width="14%" class="text-center">MONTANT</th>
          </tr>
        </thead>
        <tbody>
          @foreach($query as $data)
            {!! $data !!}
          @endforeach
        </tbody>
        <tfoot>
          @php $border = "border-top"; @endphp
          @if(($devis->mt_rem != 0)||($devis->sum_tva != 0))
          @php $border = ""; @endphp
          <tr>
            <td class="fw-bold border-top">TOTAL</td>
            <td colspan="4" class="text-end fw-bold border-top">{{ number_format($devis->mt_ht, 0, ',', '.') }}&nbsp;</td>
          </tr>
          @endif
          @php
            if($devis->see_rem == 1){
              $totalrem = $devis->mt_ht - $devis->mt_rem;
          @endphp
          <tr>
            <td class="fw-bold">REMISE ({{ $devis->sum_rem }}%)</td>
            <td colspan="4" class="text-end fw-bold">{{ number_format($devis->mt_rem, 0, ',', '.') }}&nbsp;</td>
          </tr>
          <tr>
            <td class="fw-bold">TOTAL - REMISE</td>
            <td colspan="4" class="text-end fw-bold">{{ number_format($totalrem, 0, ',', '.') }}&nbsp;</td>
          </tr>
          @php } @endphp
          @if($devis->see_tva == 1)
          <tr>
            <td class="fw-bold">TVA ({{ $devis->sum_tva }}%)</td>
            <td colspan="4" class="text-end fw-bold">{{ number_format($devis->mt_tva, 0, ',', '.') }}&nbsp;</td>
          </tr>
          @endif
          <tr>
            <td class="fw-bold {{ $border }}">NET A PAYER</td>
            <td colspan="4" class="text-end fw-bold {{ $border }}">
              {{ number_format($devis->mt_ttc, 0, ',', '.') }} FCFA
              @if($devis->see_euro == 1)
              - {{ Myhelper::formatEuro($devis->mt_euro) }} €
              @endif
              &nbsp;
            </td>
          </tr>
        </tfoot>
      </table>
      <table class="table" style="margin-top: -15px;">
        <tbody>
          <tr>
            <td>
              Arrêté le présent devis à la somme de : <strong>{{ $int2string }}</strong></br>
              @if($devis->see_euro == 1)
              <strong>1- Euro = {{ Session::get('euro') }}€</strong>
              @endif
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </body>
</html>