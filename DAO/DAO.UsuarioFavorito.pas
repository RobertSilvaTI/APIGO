unit DAO.UsuarioFavorito;

interface

uses FireDAC.Comp.Client, FireDAC.DApt, Data.DB, FireDAC.Stan.Param, System.JSON, System.SysUtils,
System.StrUtils, DataSet.Serialize, DAO.Connection;

type TUsuarioFavorito = class
  private
    FConn: TFDConnection;
    FID_FAVORITO: integer;
    FID_ESTABELECIMENTO: integer;
    FID_USUARIO: integer;

    procedure Validate(operacao: string);
  public
    constructor Create;
    destructor Destroy; override;

    property ID_FAVORITO: integer read FID_FAVORITO write FID_FAVORITO;
    property ID_USUARIO: integer read FID_USUARIO write FID_USUARIO;
    property ID_ESTABELECIMENTO: integer read FID_ESTABELECIMENTO write FID_ESTABELECIMENTO;

    function Listar: TJSONArray;
    procedure Inserir;
    procedure Excluir;
end;

implementation

{ TUsuarioFavorito }

constructor TUsuarioFavorito.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TUsuarioFavorito.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TUsuarioFavorito.Listar: TJSONArray;
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
      SQL.Add('select f.id_favorito, e.id_estabelecimento, e.nome, e.url_logo, e.avaliacao,');
      SQL.Add('c.categoria, e.endereco, e.complemento, e.bairro, e.cidade, e.uf, e.cod_cidade');
      SQL.Add('from tab_usuario_favorito f');
      SQL.Add('join tab_estabelecimento e on e.id_estabelecimento = f.id_estabelecimento');
      SQL.Add('join tab_categoria c on c.id_categoria = e.id_categoria');
      SQL.Add('where f.id_usuario = :id_usuario');
      SQL.Add('order by e.nome');

      ParamByName('id_usuario').Value := ID_USUARIO;

      Active := True;
    end;

    Result := qry.ToJSONArray();

  finally
    qry.Free;
  end;
end;

procedure TUsuarioFavorito.Inserir;
var
  qry: TFDQuery;
begin
  Validate('Inserir');

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('insert into tab_usuario_favorito(id_usuario, id_estabelecimento)');
      SQL.Add('values(:id_usuario, :id_estabelecimento)');
      SQL.Add('returning id_favorito');

      ParamByName('id_usuario').Value := ID_USUARIO;
      ParamByName('id_estabelecimento').Value := ID_ESTABELECIMENTO;
      Active := True;

      ID_FAVORITO := FieldByName('id_favorito').AsInteger;
    end;
  finally
    qry.Free;
  end;
end;

procedure TUsuarioFavorito.Excluir;
var
  qry: TFDQuery;
begin
  Validate('Excluir');

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('delete tab_usuario_favorito');
      SQL.Add('where id_favorito = :id_favorito and id_usuario = :id_usuario');

      ParamByName('id_favorito').Value := ID_FAVORITO;
      ParamByName('id_usuario').Value := ID_USUARIO;

      ExecSQL;
    end;

  finally
    qry.Free;
  end;
end;

procedure TUsuarioFavorito.Validate(operacao: string);
begin
  if (ID_USUARIO <= 0) and MatchStr(operacao, ['Listar', 'Inserir', 'Excluir']) then
    raise Exception.Create('ID de Usuário não informado!');

  if (ID_ESTABELECIMENTO <= 0) and MatchStr(operacao, ['Inserir']) then
    raise Exception.Create('ID do estabelecimento não informada!');

  if (ID_FAVORITO <= 0) and MatchStr(operacao, ['Excluir']) then
    raise Exception.Create('ID favorito não informado!');

end;

end.
