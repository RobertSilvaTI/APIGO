unit DAO.Cupom;

interface

uses FireDAC.Comp.Client, FireDAC.DApt, Data.DB, System.JSON, System.SysUtils,
System.StrUtils, DataSet.Serialize, DAO.Connection, FireDAC.Stan.Param;

type
  TCupom = class
    private
      FConn: TFDConnection;
      FID_CUPOM: integer;
      FCOD_CUPOM: string;
      FID_ESTABELECIMENTO: integer;
      FVL_PEDIDO: double;
      procedure Validate(operacao: string);
    public
      constructor Create;
      destructor Destroy; override;

      property ID_CUPOM: integer read FID_CUPOM write FID_CUPOM;
      property ID_ESTABELECIMENTO: integer read FID_ESTABELECIMENTO write FID_ESTABELECIMENTO;
      property COD_CUPOM: string read FCOD_CUPOM write FCOD_CUPOM;
      property VL_PEDIDO: double read FVL_PEDIDO write FVL_PEDIDO;

      function Validar: TJSONObject;
end;

implementation

{ TCupom }

constructor TCupom.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TCupom.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;


function TCupom.Validar: TJSONObject;
var
  qry: TFDQuery;
  json: TJSONObject;
begin
  Validate('Validar');

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('select * from tab_cupom');
      SQL.Add('join tab_estabelecimento on tab_estabelecimento.id_cupom = tab_cupom.id_cupom');
      SQL.Add('where tab_cupom.ind_ativo = ''S''');
      SQL.Add('and tab_cupom.vl_min_pedido <= :vl_pedido');
      SQL.Add('and tab_cupom.dt_validade >= :dt_validade');
      SQL.Add('and tab_cupom.cod_cupom = :cod_cupom');
      SQL.Add('and tab_estabelecimento.id_estabelecimento = :id_estabelecimento');

      ParamByName('vl_pedido').Value := VL_PEDIDO;
      ParamByName('dt_validade').Value := FormatDateTime('yyyy-mm-dd', date);
      ParamByName('cod_cupom').Value := ID_CUPOM;
      ParamByName('id_estabelecimento').Value := ID_ESTABELECIMENTO;

      Active := True;
    end;

    Result := qry.ToJSONObject;

  finally
    FConn.Free;
  end;
end;

procedure TCupom.Validate(operacao: string);
begin
  if (COD_CUPOM.IsEmpty) and MatchStr(operacao, ['Validar'])  then
    raise Exception.Create('Cupom não informado!');
end;

end.
