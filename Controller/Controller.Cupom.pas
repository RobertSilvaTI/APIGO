unit Controller.Cupom;

interface

uses Horse,
     Horse.JWT,
     System.JSON,
     System.SysUtils,
     DAO.Cupom,
     Controller.Comum,
     Controller.Auth;

procedure RotaAPI;
procedure Validar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RotaAPI;
begin
  THorse
    .AddCallback(HorseJWT(SECRET, THorseJWTConfig.New.SessionClass(TAuth)))
    .Get('/v1/cupons/validar', Validar);
end;

procedure Validar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cupom: TCupom;
  json: TJSONObject;
begin
  try
     try
       cupom := TCupom.Create;

       try
         cupom.COD_CUPOM := Req.Query['cod_cupom'];
       except
         cupom.COD_CUPOM := '';
       end;

       try
         cupom.ID_ESTABELECIMENTO := Req.Query['id_estabelecimento'].ToInteger;
       except
        cupom.ID_ESTABELECIMENTO := 0;
       end;

       try
         cupom.VL_PEDIDO := Req.Query['vl_pedido'].ToDouble {/ 100};
       except
         cupom.VL_PEDIDO := 0;
       end;

       json := cupom.Validar;

       if json.Size > 0 then
       begin
         Res.Send<TJSONObject>(json).Status(200);
       end
       else
       begin
         json.DisposeOf;
         Res.Send<TJSONObject>(CreateJsonObj('erro', 'Cupom inválido!')).Status(404);
       end;

     except on E:Exception do
       Res.Send<TJSONObject>(CreateJsonObj('erro', E.Message)).Status(500);
     end;
  finally
    cupom.Free;
  end;
end;

end.
