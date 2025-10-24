unit DAO.Cidade;

interface

uses FireDAC.Comp.Client, FireDAC.DApt, Data.DB, System.JSON, System.SysUtils,
DataSet.Serialize, DAO.Connection;

type
  TCidade = class
    private
      FConn: TFDConnection;
    public
      constructor Create;
      destructor Destroy; override;

      function Listar(): TJSONArray;
  end;

implementation

{ TCidade }

constructor TCidade.Create;
begin
  FConn := TConnection.CreateConnection;
end;

destructor TCidade.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  inherited;
end;

function TCidade.Listar: TJSONArray;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := FConn;

    with qry do
    begin
      Active := False;
      SQL.Clear;
      SQL.Add('select * from tab_cidade order by cidade');

      Active := True;
    end;

    Result := qry.ToJSONArray();

  finally
    FConn.Free;
  end;
end;

end.
