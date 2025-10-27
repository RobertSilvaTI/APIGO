unit Controller.Destaque;

interface

uses Horse,
     Horse.JWT,
     System.JSON,
     System.SysUtils,
     DAO.Destaque,
     Controller.Comum,
     Controller.Auth,
     UnitPrincipal;

procedure RotaAPI;
procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RotaAPI;
begin
  THorse
    .AddCallback(HorseJWT(SECRET, THorseJWTConfig.New.SessionClass(TAuth)))
    .Get('/v1/destaques', Listar);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  destaq: TDestaque;
  cod_cidade: string;
begin
  cod_cidade := Req.Query['cod_cidade'];

  if cod_cidade = '' then
  begin
    Res.Send<TJSONObject>(CreateJsonObj('erro', 'Cód de cidade não informado!')).Status(400);
    Exit;
  end;

  try
    try
      destaq := TDestaque.Create;

      Res.Send<TJSONArray>(destaq.Listar(cod_cidade)).Status(200);

    except on E:Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(500);
    end;
  finally
    destaq.Free;
  end;
end;

end.
