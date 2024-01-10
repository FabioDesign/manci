<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Facture</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
    <style>
      @page {
        size: A4;
        margin: 0;
      }
      @media print {
        html, body {
          width: 210mm;
          height: 297mm;
        }
      }
      body {
        font-size: 9pt;
        font-family: "Times New Roman", Times, serif;
        padding-top: 140px;
        padding-left: 40px;
        padding-right: 50px;
        padding-bottom: 70px;
        /* background-image: url({{ $bills->logo }});
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center center; */
      }
      .mytable>thead>tr>th {
        padding: 0 3px;
        border-spacing: 0px;
        border: 1px solid #000;
      }
      .mytable>tbody>tr>td, .mytable>tfoot>tr>td {
        padding: 0 3px;
        border-spacing: 0px;
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
    <table class="table table-bordered mytable">
      <thead>
        <tr>
          <td colspan="5">
            <table class="table noborder">
              <tbody>
                <tr>
                  <td width="310px">&nbsp;</td>
                  <td width="285px">
                    <strong>{{ $bills->bill_addr }}</strong><br>
                    {!! nl2br($bills->content) !!}
                  </td>
                  <td width="100px">&nbsp;</td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
        <tr>
          <th width="67%" class="text-center">DESIGNATION</th>
          <th width="5%" class="text-center">QTE</th>
          <th width="5%" class="text-center">UoM</th>
          <th width="9%" class="text-center">PU</th>
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
        @if(($bills->mt_rem != 0)||($bills->sum_tva != 0))
        @php $border = ""; @endphp
        <tr>
          <td class="fw-bold border-top">
            TOTAL</td>
          <td colspan="4" class="text-end fw-bold border-top">{{ number_format($bills->mt_ht, 0, ',', '.') }}</td>
        </tr>
        @endif
        @php
          if($bills->see_rem == 1){
            $totalrem = $bills->mt_ht - $bills->mt_rem;
        @endphp
        <tr>
          <td class="fw-bold">REMISE ({{ $bills->sum_rem }}%)</td>
          <td colspan="4" class="text-end fw-bold">{{ number_format($bills->mt_rem, 0, ',', '.') }}</td>
        </tr>
        <tr>
          <td class="fw-bold">TOTAL - REMISE</td>
          <td colspan="4" class="text-end fw-bold">{{ number_format($totalrem, 0, ',', '.') }}</td>
        </tr>
        @php } @endphp
        @if($bills->see_tva == 1)
        <tr>
          <td class="fw-bold">TVA ({{ $bills->sum_tva }}%)</td>
          <td colspan="4" class="text-end fw-bold">{{ number_format($bills->mt_tva, 0, ',', '.') }}</td>
        </tr>
        @endif
        <tr>
          <td class="fw-bold {{ $border }}">NET A PAYER</td>
          <td colspan="4" class="text-end fw-bold {{ $border }}">
            {{ number_format($bills->mt_ttc, 0, ',', '.') }} FCFA
            @if($bills->see_euro == 1)
            - {{ Myhelper::formatEuro($bills->mt_euro) }} €
            @endif
          </td>
        </tr>
        <tr><td colspan="5" class="border-top"></td></tr>
      </tfoot>
    </table>
    <table class="table" style="margin-top: -15px;">
      <tbody>
        <tr>
          <td>
            Arrêté la présent facture à la somme de : <strong>{{ $int2string }}</strong></br>
            @if($bills->see_euro == 1)
            <strong>1- Euro = {{ Session::get('euro') }}€</strong>
            @endif
          </td>
        </tr>
      </tbody>
    </table>
  </body>
</html>