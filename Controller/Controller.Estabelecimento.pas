unit Controller.Estabelecimento;

interface

uses Horse,
     Horse.JWT,
     System.JSON,
     System.SysUtils,
     DAO.Estabelecimento,
     Controller.Comum,
     Controller.Auth;

procedure RotaAPI;
procedure Consultar(Req: THorseRequest; Res: THorseResponse; Nexdt: TProc);
procedure ConsultarID(Req: THorseRequest; Res: THorseResponse; Nexdt: TProc);

implementation

procedure RotaAPI;
begin
  THorse
    .AddCallback(HorseJWT(SECRET, THorseJWTConfig.New.SessionClass(TAuth)))
    .Get('/v1/estabelecimentos', Consultar);
  THorse
    .AddCallback(HorseJWT(SECRET, THorseJWTConfig.New.SessionClass(TAuth)))
    .Get('/v1/estabelecimentos/:id_estabelecimento', ConsultarID);
end;

procedure Consultar(Req: THorseRequest; Res: THorseResponse; Nexdt: TProc);
var
  estab: TEstabelecimento;
  pagina: Integer;
begin
  try
    try
      estab := TEstabelecimento.Create;
      estab.ID_USUARIO := GetUserRequest(Req);

      try
        pagina := Req.Query['pagina'].ToInteger;
      except
        pagina := 0;
      end;

      try
        estab.ID_CATEGORIA := Req.Query['id_categoria'].ToInteger;
      except
        estab.ID_CATEGORIA := 0;
      end;

      try
        estab.NOME := Req.Query['nome'];
      except
        estab.NOME := '';
      end;

      try
        estab.COD_CIDADE := Req.Query['cod_cidade'];
      except
        estab.COD_CIDADE := '';
      end;

      try
        estab.ID_BANNER := Req.Query['id_banner'].ToInteger;
      except
        estab.ID_BANNER := 0;
      end;

      Res.Send<TJSONArray>(estab.Listar(pagina)).Status(200);

    except on E:Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(500);
    end;
  finally
    estab.Free;
  end;
end;

procedure ConsultarID(Req: THorseRequest; Res: THorseResponse; Nexdt: TProc);
var
  estab: TEstabelecimento;
  json: TJSONArray;
begin
  try
    try
      estab := TEstabelecimento.Create;
      estab.ID_USUARIO := GetUserRequest(Req);
      estab.ID_ESTABELECIMENTO := Req.Params['id_estabelecimento'].ToInteger;

      json := estab.Listar(0);

      if json.Size > 0 then
      begin
        Res.Send<TJSONArray>(json).Status(200);
      end
      else
      begin
        Res.Send<TJSONArray>(json).Status(204);
      end;

    except on E:Exception do
      Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(500);
    end;
  finally
    estab.Free;
  end;
end;

end.
