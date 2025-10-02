unit DAO.Pedido;

interface

uses FireDAC.Comp.Client, FireDAC.DApt, Data.DB, System.JSON, System.SysUtils,
System.StrUtils, Dataset.Serialize, DAO.Connection;

type
  TPedido = class
    private
      FConn: TFDConnection;
      FID_USUARIO: integer;
      FID_PEDIDO: integer;
      FAVALIACAO: integer;
      FID_ESTABELECIMENTO: integer;
      procedure Validate(operacao: string);
    public
      constructor Create;
      destructor Destroy; override;

      property ID_USUARIO: integer read FID_USUARIO write FID_USUARIO;
      property AVALIACAO: integer read FAVALIACAO write FAVALIACAO;
      property ID_PEDIDO: integer read FID_PEDIDO write FID_PEDIDO;
      property ID_ESTABELECIMENTO: integer read FID_ESTABELECIMENTO write FID_ESTABELECIMENTO;

      function Listar(cod_cidade: string): TJSONArray;
      procedure Avaliar;
      procedure Inserir;
  end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TPedido.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TPedido.Listar(cod_cidade: string): TJSONArray;
var
  qry: TFDQuery;
begin
  Validate('Listar');

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('select p.id_pedido, p.id_estabelecimento, e.nome, count(*) as qtd_item, ');
      SQL.Add('p.vl_total, p.dt_pedido, e.url_logo, coalesce(p.avaliacao,0) as avaliacao, ');
      SQL.Add('p.status');
      SQL.Add('from tab_pedido p');
      SQL.Add('join tab_estabelecimento e on e.id_estabelecimento = p.id_estabelecimento');
      SQL.Add('join tab_pedido_item i on i.id_pedido = p.id_pedido');
      SQL.Add('where p.id_usuario = :id_usuario');
      SQL.Add('group by p.id_pedido, p.id_estabelecimento, e.nome, ');
      SQL.Add('p.vl_total, p.dt_pedido, e.url_logo, avaliacao, p.status');
      SQL.Add('order by p.id_pedido desc');

      ParamByName('id_usuario').Value := id_usuario;

      Active := True;
    end;

    Result := qry.ToJSONArray();

  finally
    qry.Free;
  end;
end;

procedure TPedido.Avaliar;
var
  qry: TFDQuery;
begin
  Validate('Avaliar');

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('update tab_pedido set avaliacao = :avaliacao');
      SQL.Add('where id_pedido = :id_pedido');
      SQL.Add('returning id_estabelecimento');
      ParamByName('avaliacao').Value := avaliacao;
      ParamByName('id_pedido').Value := id_pedido;
      Active := True;

      ID_ESTABELECIMENTO := FieldByName('id_estabelecimento').AsInteger;

      // Atualização de estatísticas do estabelecimento
      Active := False;
      SQL.Clear;
      SQL.Add('update tab_estabelecimento set qtd_avaliacao = ');
      SQL.Add('(select count(*) from tab_pedido p where p.avaliacao > 0');
      SQL.Add('and p.id_estabelecimento = :id_estabelecimento), ');
      SQL.Add('avaliacao = (select avg(avaliacao) from tab_pedido p');
      SQL.Add('where p.avaliacao > 0 and p.id_estabelecimento = :id_estabelecimento)');
      SQL.Add('where id_estabelecimento = :id_estabelecimento');
      ParamByName('id_estabelecimento').Value := id_estabelecimento;
      ExecSQL;
    end;

  finally
    qry.Free;
  end;
end;

procedure TPedido.Inserir;
begin

end;

procedure TPedido.Validate(operacao: string);
begin
  if (ID_USUARIO <= 0) and MatchStr(operacao, ['Listar']) then
    raise Exception.Create('ID de usuário não informado!');

  if (AVALIACAO <= 0) and MatchStr(operacao, ['Validar']) then
    raise Exception.Create('Avaliação não inserida!');

  if (ID_PEDIDO <= 0) and MatchStr(operacao, ['Validar']) then
    raise Exception.Create('ID do pedido não informado!');
end;

end.
