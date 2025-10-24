unit Controller.Categoria;

interface

uses Horse,
     System.JSON,
     DAO.Categoria,
     System.SysUtils;

procedure RotaAPI;
procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RotaAPI;
begin
  THorse.Get('/v1/categorias', Listar);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cat: TCategoria;
  cod_cidade: string;
begin
  try
    cod_cidade := Req.Query['cod_cidade'];
  except
    cod_cidade := '';
  end;

  try

    try
      cat := TCategoria.Create;

      Res.Send<TJSONArray>(cat.Listar(cod_cidade));
    except on E:Exception do
      Res.Send('Erro na consulta: ' + E.Message).Status(500);
    end;

  finally
    cat.Free;
  end;
end;

end.
