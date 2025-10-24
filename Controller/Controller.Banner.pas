unit Controller.Banner;

interface

uses
  Horse,
  Horse.JWT,
  System.JSON,
  System.SysUtils,
  DAO.Banner,
  Controller.Auth,
  Controller.Comum;

procedure RotaAPI;
procedure Consultar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RotaAPI;
begin
  THorse
    .AddCallback(HorseJWT(SECRET, THorseJWTConfig.New.SessionClass(TAuth)))
    .Get('/v1/banners', Consultar);
end;

procedure Consultar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  banner: TBanner;
  cod_cidade: string;
begin
  try
    cod_cidade := Req.Query.Items['cod_cidade'];
  except
    cod_cidade := '';
  end;

  try
    try
      banner := TBanner.Create;

      Res.Send<TJSONArray>(banner.Listar(cod_cidade)).Status(200);

    except on E:Exception do
      Res.Send<TJSONObject>(CreateJsonObj('Erro: ', E.Message)).Status(500);
    end;
  finally
    banner.Free;
  end;

end;

end.
